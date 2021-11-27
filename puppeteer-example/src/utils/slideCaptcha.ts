import { imageDetector } from 'utils/imageDetector';
import fetch from 'node-fetch';
import * as fs from 'fs';

class SlideCaptcha {

    async unlock(page): Promise<Object> {
        const resp:any = {};
        try {
            const frame = page.frames().find(frame => frame.name() == 'tcaptcha_iframe')
            const filepath = await this.saveCaptchaImage(frame);
            const offset = await this.getSlideOffset(frame, filepath);
            const coord = await this.getStartCoord(frame);

            await page.mouse.move(coord.x, coord.y);
            await page.mouse.down();
            await page.waitForTimeout(500);
            for (let i = 1; i <= offset; i++) {
                await page.mouse.move(coord.x + i, coord.y);
                await page.waitForTimeout(10);
            }
            await page.waitForTimeout(500);
            await page.mouse.up();
            await page.waitForTimeout(3000);
            resp.filepath = filepath;
        } catch(e) {
            console.log(e);
            resp.error = e;
        }
        return resp;
    }

    async saveCaptchaImage(frame): Promise<string> {
        const imageUrl = await frame.$eval('#slideBg', el => el.getAttribute('src'));
        const filepath = '/tmp/scrapy/login/catpchaBg.jpg';
        const response = await fetch(imageUrl);
        const dest = fs.createWriteStream(filepath);
        await response.body.pipe(dest)
        return filepath;
    }

    async getSlideOffset(frame, filepath): Promise<number> {
        const retArray = await imageDetector.detectEdge(filepath);
        const ret = JSON.parse(retArray[0]);
        const drag_bar = await frame.$('#slide');
        const bar_position = await drag_bar.boundingBox();
        const width = bar_position.width;
        const offset = width * (parseInt(ret['dx']) - 23) / parseInt(ret['width']) - 26;
        return offset;
    }

    async getStartCoord(frame) {
        const drag_btn = await frame.$('#tcaptcha_drag_thumb');
        const position = await drag_btn.boundingBox();
        return {
            'x': position.x, 
            'y': position.y + position.height / 2
        };
    }
}

export const slideCaptcha = new SlideCaptcha();