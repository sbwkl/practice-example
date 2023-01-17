// ==UserScript==
// @name        hello
// @namespace   https://github.com/sbwkl/practice-example/tree/master/monkey-script
// @match       https://www.baidu.com/
// @run-at      document-idle
// @version     1.0
// @description none
// ==/UserScript==


var button = document.createElement('button');
button.innerHTML = '点我搜杭州';
button.style = 'top: 0; right: 0; position: absolute; z-index: 9999';
document.body.appendChild(button);

button.addEventListener('click', function () {
    const kw = document.getElementById('kw');
    const su = document.getElementById('su');
    kw.value = '杭州';
    su.click();
})