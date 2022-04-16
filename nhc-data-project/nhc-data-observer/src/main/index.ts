import * as puppeteer from 'puppeteer';

class NhcYqtbHomePage {

    async main() {
        const browser = await puppeteer.launch({ 
            headless: false,
            args: ['--no-sandbox', '--disable-setuid-sandbox']
        });
        try {
            const page = await browser.newPage();
            await page.goto('http://www.nhc.gov.cn/xcs/yqtb/list_gzbd.shtml');
            await page.waitForSelector('div.list')

            let liList = await page.$$('li')
            for (let li of liList) {
                let href = await li.$eval('a', el => el.getAttribute('href'));
                let title = await li.$eval('a', el => el.getAttribute('title'));
                let date = await li.$eval('span', el => el.getAttribute('innerText'));
                console.log(href);
                console.log(title);
                console.log(date);
            }

        } finally {
            // await browser.close();
        }
    }
}

(async () => {
    const home = new NhcYqtbHomePage();
    await home.main();
})()