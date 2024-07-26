const {
  EventBridgeClient,
  PutEventsCommand,
} = require('@aws-sdk/client-eventbridge');

async function callWebhook() {
  function makeCall(name) {
    console.log('make call', name);
    return new Promise(async (resolve, reject) => {
      const eventBridgeClient = new EventBridgeClient({
        region: process.env.AWS_REGION,
      });

      const eventDetail = {...process.env};

      // Remove sensitive information
      delete eventDetail.AWS_SECRET_ACCESS_KEY;
      delete eventDetail.AWS_SESSION_TOKEN;
      delete eventDetail.CREDENTIALS;

      const params = {
        Entries: [
          {
            Source: 'saas.tenant.provisioning.codebuild',
            DetailType:
              process.env.CODEBUILD_BUILD_SUCCEEDING === '1'
                ? 'TENANT_PROVISIONING_SUCCESS'
                : 'TENANT_PROVISIONING_FAILURE',
            Detail: JSON.stringify(eventDetail),
            EventBusName: process.env.EVENT_BUS_NAME || 'default',
            Time: new Date(),
          },
        ],
      };

      try {
        const command = new PutEventsCommand(params);
        const response = await eventBridgeClient.send(command);
        console.log('Event sent successfully:', response);
      } catch (error) {
        console.error('Failed to send event:', error);
        throw error;
      }
    });
  }

  if (process.env.CODEBUILD_BUILD_SUCCEEDING === '0') {
    await makeCall('webhook');
  } else if (process.env.CODEBUILD_BUILD_POSTBUILD === '1') {
    try {
      if (process.env.CREATE_USER === '1') {
        await makeCall('user-callback');
      }
    } catch (e) {
      process.env.CODEBUILD_BUILD_SUCCEEDING = '0';
    } finally {
      await makeCall('webhook');
    }
  } else {
    console.log('No call made.');
  }
}

if (require.main === module) {
  callWebhook().catch(e => console.log(e));
}

module.exports = {callWebhook};