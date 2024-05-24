const {URL} = require('url');
const synthetics = require('Synthetics');
const log = require('SyntheticsLogger');
const syntheticsConfiguration = synthetics.getConfiguration();
const syntheticsLogHelper = require('SyntheticsLogHelper');

const loadBlueprint = async function () {

    const urls = ['${api_hostname}${api_path}'];

    // Set screenshot option
    const takeScreenshot = ${take_screenshot};

    /* Disabling default step screen shots taken during Synthetics.executeStep() calls
    * Step will be used to publish metrics on time taken to load dom content but
    * Screenshots will be taken outside the executeStep to allow for page to completely load with domcontentloaded
    * You can change it to load, networkidle0, networkidle2 depending on what works best for you.
    */
    syntheticsConfiguration.disableStepScreenshots();
    syntheticsConfiguration.setConfig({
        continueOnStepFailure: true,
        includeRequestHeaders: true, // Enable if headers should be displayed in HAR
        includeResponseHeaders: true, // Enable if headers should be displayed in HAR
        restrictedHeaders: [], // Value of these headers will be redacted from logs and reports
        restrictedUrlParameters: [] // Values of these url parameters will be redacted from logs and reports

    });

    let page = await synthetics.getPage();

    for (const url of urls) {
        await loadUrl(page, url, takeScreenshot);
    }
};

// Reset the page in-between
const resetPage = async function (page) {
    try {
        await page.goto('about:blank', {waitUntil: ['load', 'networkidle0'], timeout: 30000});
    } catch (ex) {
        synthetics.addExecutionError('Unable to open a blank page ', ex);
    }
}

const loadUrl = async function (page, url, takeScreenshot) {
    let stepName = null;
    let domcontentloaded = false;

    try {
        stepName = new URL(url).hostname;
    } catch (error) {
        const errorString = `Error parsing url: $${url}.  $${error}`;
        log.error(errorString);
        /* If we fail to parse the URL, don't emit a metric with a stepName based on it.
        It may not be a legit CloudWatch metric dimension name and we may not have an alarms
        setup on the malformed URL stepName.  Instead, fail this step which will
        show up in the logs and will fail the overall canary and alarm on the overall canary
        success rate.
        */
        throw error;
    }

    await synthetics.executeStep(stepName, async function () {
        const sanitizedUrl = syntheticsLogHelper.getSanitizedUrl(url);

        /* You can customize the wait condition here. For instance, using 'networkidle2' or 'networkidle0' to load page completely.
        networkidle0: Navigation is successful when the page has had no network requests for half a second. This might never happen if page is constantly loading multiple resources.
        networkidle2: Navigation is successful when the page has no more then 2 network requests for half a second.
        domcontentloaded: It's fired as soon as the page DOM has been loaded, without waiting for resources to finish loading. Can be used and then add explicit await page.waitFor(timeInMs)
        */
        const response = await page.goto(url, {waitUntil: ['domcontentloaded'], timeout: 30000});
        if (response) {
            domcontentloaded = true;
            const status = response.status();
            const statusText = response.statusText();

            logResponseString = `Response from url: $${sanitizedUrl}  Status: $${status}  Status Text: $${statusText}`;

        //If the response status code is not a 2xx success code
            if (response.status() < 200 || response.status() > 299) {
                throw `Failed to load url: $${sanitizedUrl} $${response.status()} $${response.statusText()}`;
            }
        } else {
            const logNoResponseString = `No response returned for url: $${sanitizedUrl}`;
            log.error(logNoResponseString);
            throw new Error(logNoResponseString);
        }
    });

// Wait for 15 seconds to let page load fully before taking screenshot.
    if (domcontentloaded && takeScreenshot) {
        await page.waitFor(15000);
        await synthetics.takeScreenshot(stepName, 'loaded');
        await resetPage(page);
    }
};

const urls = [];

exports.handler = async () => {
    return await loadBlueprint();
};