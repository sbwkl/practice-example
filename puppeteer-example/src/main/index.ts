import * as puppeteer from 'puppeteer';
import { slideCaptcha } from 'utils/slideCaptcha';

class Index {

    async main() {
        const browser = await puppeteer.launch({ 
            headless: false,
            args: ['--no-sandbox', '--disable-setuid-sandbox']
        });
        try {
            const page = await browser.newPage();
            // await page.goto('https://console.authing.cn/login');
            // await page.waitForSelector('button[type="button"]', {
            //     timeout: 5000
            // })
            // await page.click('div.styles_authing-tabs-inner__KEW7v div');
            // await page.waitForSelector('#identity', {
            //     timeout: 3000
            // })
            // await page.type('#identity', 'zhangsan');
            // await page.type('#password', 'password');
            // await page.click('button[type="button"]');
            
            // await page.waitForTimeout(5000);

            await page.goto('https://007.qq.com/online.html');
            await page.waitForSelector('#code');
            await page.waitForTimeout(1000);

            await page.hover('#code');
            await page.click('#code');
            await page.waitForSelector('#tcaptcha_iframe');
            await page.waitForTimeout(5000);
            await slideCaptcha.unlock(page);

        } finally {
            await browser.close();
        }
    }
}

(async () => {
    const index = new Index();
    await index.main();
})()