const path = require('path');
const { remote } = require('webdriverio');

const apkPath = process.env.APK_PATH
  || path.resolve(__dirname, '../../mobile/app/build/outputs/apk/debug/app-debug.apk');
const reviewUrl = process.env.MOBILE_REVIEW_URL || 'http://10.0.2.2:8000/mobile/';

const options = {
  hostname: process.env.APPIUM_HOST || '127.0.0.1',
  port: Number(process.env.APPIUM_PORT || 4723),
  path: '/',
  logLevel: 'warn',
  capabilities: {
    platformName: 'Android',
    'appium:deviceName': process.env.APPIUM_DEVICE || 'Android Emulator',
    'appium:automationName': 'UiAutomator2',
    'appium:app': apkPath,
    'appium:autoGrantPermissions': true,
    'appium:newCommandTimeout': 120
  }
};

async function run() {
  const driver = await remote(options);
  try {
    const urlInput = await driver.$('id:com.codex.mobile:id/url_input');
    await urlInput.setValue(reviewUrl);

    const loadButton = await driver.$('id:com.codex.mobile:id/load_button');
    await loadButton.click();

    const webView = await driver.$('id:com.codex.mobile:id/web_view');
    await webView.waitForDisplayed({ timeout: 10000 });
  } finally {
    await driver.deleteSession();
  }
}

run().catch((error) => {
  console.error(error);
  process.exit(1);
});
