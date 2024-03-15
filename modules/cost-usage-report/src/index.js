const AWS = require('aws-sdk');

exports.handler = function(event, context, callback) {
    const glue = new AWS.Glue();
    
    glue.startCrawler({ Name: process.env.CRAWLER_NAME }, function(err, data) {
        if (err) {
            // Check if Crawler is already running
            const response = JSON.parse(this.httpResponse.body);
            if (response['__type'] == 'CrawlerRunningException') {
                console.log('Crawler already running; ignoring trigger.');

                callback(null, response.Message);
            }
        }
        else {
            console.log("Successfully triggered crawler");
        }
    });
}