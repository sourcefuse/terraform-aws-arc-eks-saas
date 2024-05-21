async function callWebhook() {
  const crypto = require("crypto");
  const http =
    process.env.API_ENDPOINT?.split("://")[0] === "https"
      ? require("https")
      : require("http");

  const timestamp = Date.now();
  const secret = process.env.SECRET;
  const context = process.env.CODEBUILD_BUILD_ID;
  const payload = () =>
    JSON.stringify({
      initiatorId: process.env.TENANT_ID,
      type: 0,
      data: {
        status: Number(`${process.env.CODEBUILD_BUILD_SUCCEEDING}`),
        resources: [
          {
            type: "s3",
            metadata: {
              bucket: process.env.TF_STATE_BUCKET,
              path: process.env.TF_KEY,
            },
          },
        ],
      },
    });

  const tenantData = JSON.parse(process.env.TENANT_DATA);
  const tenantPayload = JSON.stringify({
    email: tenantData.contact?.email,
    phone: tenantData.contact?.phone,
    username: tenantData.contact?.username,
    tenantName: tenantData.name,
    tenantKey: tenantData.key,
    firstName: tenantData.contact?.firstName,
    lastName: tenantData?.lastName,
    middleName: tenantData?.middleName,
    cognitoAuthId: process.env.COGNITO_AUTH_ID,
    authClient: {
      clientId: process.env.CLIENT_ID,
      clientSecret: process.env.CLIENT_SECRET,
      redirectUrl: process.env.APP_PLANE_REDIRECT_URL,
      secret: process.env.RANDOM_SECRET,
      accessTokenExpiration: Number(process.env.ACCESS_TOKEN_EXPIRATION),
      refreshTokenExpiration: Number(process.env.REFRESH_TOKEN_EXPIRATION),
      authCodeExpiration: Number(process.env.AUTH_CODE_EXPIRATION),
    },
    address: {
      address: tenantData.address?.address,
      city: tenantData.address?.city,
      state: tenantData.address?.state,
      zip: tenantData.address?.zip,
      country: tenantData.address?.country,
    },
  });

  function makeCall(endPoint, payload, name) {
    return new Promise((resolve, reject) => {
      let str = "";
      if (name === "user-callback") {
        str = `${payload}${timestamp}`;
      } else {
        str = `${payload}${context}${timestamp}`;
      }
      const signature = crypto
        .createHmac("sha256", secret)
        .update(str)
        .digest("hex");
      const options = {
        method: "POST",
        headers: {
          "content-type": "application/json",
          "x-timestamp": timestamp,
          "x-signature": signature,
          "bypass-tunnel-reminder":true,
        },
      };

      const req = http.request(endPoint, options, (res) => {
        console.log("statusCode:", res.statusCode);
        if (res.statusCode !== 204) {
          reject(`Call failed for ${name}`);
          return;
        }
        resolve(`Call succeeded for ${name}`);
      });

      req.on("error", (e) => {
        console.error(e);
        throw e;
      });

      req.write(payload);
      req.end();
    });
  }

  if (process.env.CODEBUILD_BUILD_SUCCEEDING === "0") {
    await makeCall(process.env.API_ENDPOINT, payload(), "webhook");
  } else if (process.env.CODEBUILD_BUILD_POSTBUILD === "1") {
    try {
      if (process.env.CREATE_USER === "1") {
        await makeCall(
          process.env.USER_CALLBACK_ENDPOINT,
          tenantPayload,
          "user-callback"
        );
      }
    } catch (e) {
      process.env.CODEBUILD_BUILD_SUCCEEDING = "0";
    } finally {
      await makeCall(process.env.API_ENDPOINT, payload(), "webhook");
    }
  } else {
    console.log("No call made");
  }
}

if (require.main === module) {
  callWebhook().catch((e) => console.log(e));
}

module.exports = { callWebhook };