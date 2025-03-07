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
    button.style = 'top:0; right:0; position: absolute; z-index:9999;'
    const buttonName = '复制数据';
    button.innerHTML = buttonName;
    document.body.appendChild(button);

    button.addEventListener('click', () => {
        const hostname = window.location.hostname;
        const pathname = window.location.pathname;
        const shHost = 'www.sse.com.cn';
        const szHost = 'www.szse.cn'
        const bjHost = 'www.bseinfo.net'
        const exchange = hostname === shHost ? 'sh' : hostname === szHost ? 'sz' : hostname === bjHost ? 'bj' : '';
        if (exchange === 'sh') {
            const trList = document.querySelectorAll('tr');
            const e1 = Array.from(trList).find(e => e.firstChild.textContent == '市价总值(亿元)');
            const e2 = Array.from(trList).find(e => e.firstChild.textContent == '流通市值(亿元)');
            const v1 = e1.children[1].textContent;
            const v2 = e2.children[1].textContent;
            navigator.clipboard.writeText(v1 + '\t' + v2);
        } else if (exchange === 'sz') {
            const tbody = document.querySelectorAll('tbody')[3];
            const v1 = tbody.children[7].children[1].textContent;
            const v2 = tbody.children[8].children[1].textContent;
            navigator.clipboard.writeText(v1 + '\t' + v2);
        } else if (exchange === 'bj') {
            const tbody = document.querySelector('#dailyReport');
            const v1 = tbody.children[3].children[1].textContent;
            const v2 = tbody.children[3].children[3].textContent;
            navigator.clipboard.writeText(v1 + '\t' + v2);
        }
    });
}

createButton();