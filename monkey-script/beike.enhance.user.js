// ==UserScript==
// @name        复制贝壳房子数据
// @namespace   https://sbwkl.github.io/
// @match       https://hz.fang.ke.com/loupan/
// @grant       none
// @version     1.0
// @author      -
// @require     https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js
// @description 2/17/2023, 10:37:49 AM
// ==/UserScript==


function createButton() {
    const button = document.createElement('Button');
    button.style = 'top:0; right:0; position: absolute; z-index:9999;'
    const buttonName = '复制数据';
    button.innerHTML = buttonName;
    document.body.appendChild(button);

    button.addEventListener('click', () => {
        button.innerHTML = '开始复制...';
        const promiseList = [];
        for (let idx = 1; i < 121; i++) {
            const promise = axios.get(`https://hz.fang.ke.com/loupan/pg${idx}/?_t=1`).then(r => {
                return {
                    'page': idx,
                    'data': r.data
                }
            });
            promiseList.push(promise)
        }
        Promise.all(promiseList).then(values => {
            dataList = [];
            for (let v of values) {
                dataList.push(v);
            }
            navigator.clipboard.writeText(JSON.stringify(dataList));
        }).then(() => {
            button.innerHTML = '已复制';
        }).then(() => {
            setTimeout(() => {
                button.innerHTML = buttonName;
            }, 3000)
        })
    });
}

createButton();