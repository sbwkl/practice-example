// ==UserScript==
// @name        Basis Monitor
// @namespace   https://sbwkl.github.io/
// @match       https://quote.eastmoney.com/*/*.html
// @match       https://www.investing.com/*/*
// @match       https://quote.eastmoney.com/
// @exclude     https://quote.eastmoney.com/newstatic/html/profitchart_new.html*
// @grant       GM_setValue
// @grant       GM_getValue
// @grant       GM_addValueChangeListener
// @version     1.0
// @author      sbwkl
// @downloadURL https://raw.githubusercontent.com/sbwkl/practice-example/refs/heads/master/monkey-script/basis.monitor.user.js
// @description 12/15/2025, 4:26:43 PM
// ==/UserScript==

(function() {
    'use strict';

    var currentUrl = window.location.href;

    if (currentUrl == 'https://quote.eastmoney.com/') {
        startMonitor();
    } else if (currentUrl.startsWith('https://quote.eastmoney.com/')) {
        var parts = currentUrl.split('/');
        var symbol = parts[parts.length - 1].replace('.html', '');
        const targetNode = document.querySelector('.zxj');
        startUploadData(targetNode, symbol);
    } else if (currentUrl.startsWith('https://www.investing.com/')) {
        setTimeout(() => {
            var parts = currentUrl.split('/');
            var symbol = parts[parts.length - 1];
            const targetNode = document.querySelector('.text-5xl\\/9');;
            startUploadData(targetNode, symbol);
        }, 10000);
    }

    // 聚合计算
    function startMonitor() {
        let lastNotify = 0;

        GM_addValueChangeListener('dataSource', (name, oldVal, newVal, remote) => {
            const usdcnh = GM_getValue('USDCNH');
            const gc = Number(GM_getValue('gold').replace(/,/g, ''));
            const au = GM_getValue('aum');
            const si = GM_getValue('silver');
            const ag = GM_getValue('agm');
            const f518850 = (Math.exp(Math.log(gc) + Math.log(usdcnh) - 8.1)).toFixed(3);
            
            let b1 = (au - gc * usdcnh / 31.1034768).toFixed(2);
            let b2 = (ag - si * usdcnh * 1000 / 31.1034768).toFixed(2);

            console.log(`黄金基差: ${b1}, 518850 < ${f518850}`);
            console.log('白银基差: ', b2);

            let title = '';
            let text = '';
            let notify = false;

            if (b1 < -13.98) {
                title += `黄金基差：${b1} `;
                text += '518850 多 1OZ 空 ';
                notify = true;
            }

            if (b2 < 138 || b2 > 610) {
                title += `白银基差：${b2} `;
                text += `AU ${b2 < 138 ? '多' : '空'} SI ${b2 < 138 ? '多' : '空'}`;
                notify = true;
            }

            const now = Date.now();

            if (now - lastNotify > 5 * 60 * 1000 && notify) {
                lastNotify = now;
                GM_notification({
                    title: '基差大于 ' + basis,
                    text: '518850 多 1OZ 空',
                    image: '',
                    timeout: 5000,
                    onclick: null
                });
            }
        });

        console.log('开始监控...');
    }

    function startUploadData(targetNode, symbol) {

        if (!targetNode) {
            console.log('未找到目标元素，等待加载或检查选择器。');
            return;
        }

        // 先保存一份数据
        GM_setValue(symbol, targetNode.innerText || targetNode.textContent);

        // 2. 配置观察选项（要监听哪些变化）
        const config = {
            childList: true,     // 监听直接子节点的变化
            subtree: true,       // 监听整个子树下的所有后代节点变化
            characterData: true, // 监听节点文本内容的变化
            attributes: true    // 监听属性变化（如果需要）
        };

        // 3. 创建一个变化时的回调函数
        const callback = function(mutationsList) {
            for (let mutation of mutationsList) {
                // 处理不同类型的变动
                if (mutation.type === 'childList') {
                    // 获取最新的值，例如目标元素内部的文本
                    handleValueChange(targetNode, symbol);
                } else if (mutation.type === 'characterData') {
                    handleValueChange(targetNode, symbol);
                }
                // 可以根据需要添加对属性变化的处理 (mutation.type === 'attributes')
            }
        };

        // 4. 创建观察者实例并开始观察
        const observer = new MutationObserver(callback);
        observer.observe(targetNode, config);
        console.log('已开始监控目标元素的变动。');
    }

    // 处理值变化的函数
    function handleValueChange(targetNode, symbol) {
        // 获取当前值（根据你的实际需求调整选择器）
        const currentValue = targetNode.innerText || targetNode.textContent;
        console.log('当前值变为:', currentValue);

        GM_setValue(symbol, currentValue);
        GM_setValue('dataSource', symbol);
    }
})();