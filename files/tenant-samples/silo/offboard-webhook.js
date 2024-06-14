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
        type: 1,
        data: {
          status: Number(`${process.env.CODEBUILD_BUILD_SUCCEEDING}`),
          resources: [],
          appPlaneUrl: "",
          tier:process.env.TENANT_TIER
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
    await makeCall(process.env.API_ENDPOINT, payload(), "webhook");
  }
  if (require.main === module) {
    callWebhook().catch((e) => console.log(e));
  }
  module.exports = { callWebhook };