// ==UserScript==
// @name        复制数据
// @namespace   https://sbwkl.github.io/
// @match       https://www.sse.com.cn/market/stockdata/overview/day/
// @grant       none
// @version     1.0
// @author      wayne
// @downloadURL http://ai.beisheng.com:8080/douhot.enhance.user.js
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
        console.log(window.location.hostname);
        console.log(window.location.pathname);
        const tbody = document.querySelector('tbody');
        const v1 = tbody.children[1].children[1].textContent;
        const v2 = tbody.children[2].children[1].textContent;
        console.log(v1);
        navigator.clipboard.writeText(v1 + '\t' + v2);
    });
}

createButton();