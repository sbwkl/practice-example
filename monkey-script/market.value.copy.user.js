// ==UserScript==
// @name        复制数据
// @namespace   https://sbwkl.github.io/
// @match       https://www.sse.com.cn/market/stockdata/overview/day/
// @match       https://www.sse.com.cn/market/stockdata/overview/day/index_his.shtml
// @match       https://www.szse.cn/market/stock/indicator/index.html
// @match       https://www.bseinfo.net/static/statisticdata.html
// @grant       none
// @version     1.0
// @author      wayne
// @downloadURL https://raw.githubusercontent.com/sbwkl/practice-example/refs/heads/master/monkey-script/market.value.copy.user.js
// @require     https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js
// @description 2/17/2023, 10:37:49 AM
// ==/UserScript==


function createButton() {
    const button = document.createElement('Button');
    button.style = 'top:0; right:0; position: fixed; z-index:9999;'
    const buttonName = '复制数据';
    button.innerHTML = buttonName;
    document.body.appendChild(button);

    button.addEventListener('click', () => {
        button.innerHTML = '正在复制';
        const hostname = window.location.hostname;
        const shHost = 'www.sse.com.cn';
        const szHost = 'www.szse.cn'
        const bjHost = 'www.bseinfo.net'
        const exchange = hostname === shHost ? 'sh' : hostname === szHost ? 'sz' : hostname === bjHost ? 'bj' : '';
        if (exchange === 'sh') {
            const trList = document.querySelectorAll('tr');
            const e1 = Array.from(trList).find(e => e.firstChild.textContent == '市价总值(亿元)');
            const e2 = Array.from(trList).find(e => e.firstChild.textContent == '流通市值(亿元)');
            var v1 = e1.children[1].textContent;
            var v2 = e2.children[1].textContent;
            if (v1 == '-') {
                v1 = parseFloat(e1.children[2].textContent) + parseFloat(e1.children[3].textContent);
            }
            if (v2 == '-') {
                v2 = parseFloat(e2.children[2].textContent) + parseFloat(e2.children[3].textContent);
            }
            navigator.clipboard.writeText(v1 + '\t' + v2);
        } else if (exchange === 'sz') {
            const trList = document.querySelectorAll('tr');
            const e1 = Array.from(trList).find(e => e.firstChild.textContent == '股票总市值（亿元）');
            const e2 = Array.from(trList).find(e => e.firstChild.textContent == '股票流通市值（亿元）');
            const v1 = e1.children[1].textContent;
            const v2 = e2.children[1].textContent;
            navigator.clipboard.writeText(v1 + '\t' + v2);
        } else if (exchange === 'bj') {
            const tbody = document.querySelector('#dailyReport');
            const v1 = tbody.children[3].children[1].textContent;
            const v2 = tbody.children[3].children[3].textContent;
            navigator.clipboard.writeText(v1 + '\t' + v2);
        } else {
            navigator.clipboard.writeText('没有内容');
        }
        setTimeout(() => {
            button.innerHTML = buttonName;
        }, 3000);
    });
}

createButton();