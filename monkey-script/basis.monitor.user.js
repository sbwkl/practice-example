// ==UserScript==
// @name        Basis Monitor
// @namespace   https://sbwkl.github.io/
// @match       https://quote.eastmoney.com/*/*.html
// @match       https://www.investing.com/*/*
// @match       https://fu.minkabu.jp/*/*
// @match       https://www.google.com/
// @exclude     https://quote.eastmoney.com/newstatic/html/profitchart_new.html*
// @grant       GM_setValue
// @grant       GM_getValue
// @grant       GM_addValueChangeListener
// @version     1.0
// @author      sbwkl
// @downloadURL https://raw.githubusercontent.com/sbwkl/practice-example/refs/heads/master/monkey-script/basis.monitor.user.js
// @description 12/15/2025, 4:26:43 PM
// ==/UserScript==

(function () {
  'use strict';

  var currentUrl = window.location.href;

  if (currentUrl == 'https://www.google.com/') {
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
  } else if (currentUrl.startsWith("https://fu.minkabu.jp/")) {
      var parts = currentUrl.split('/');
      var symbol = parts[parts.length - 1];
      const targetNode = document.querySelector('.text-4xl');;
      startUploadData(targetNode, symbol);
  } else {
    console.log('unknow page.');
  }

  // 聚合计算
  function startMonitor() {
    const host = document.createElement('div');
    host.style.position = 'fixed';
    host.style.top = '10px';
    host.style.left = '10px';
    host.style.zIndex = '999999';
    document.body.appendChild(host);

    const shadow = host.attachShadow({ mode: 'open' });

    const appRoot = document.createElement('div');
    shadow.appendChild(appRoot);

    const style = document.createElement('style');
    style.textContent = `
        .panel {
          width: 500px;
          background: #fff;
          border-radius: 8px;
          box-shadow: 0 6px 16px rgba(0,0,0,.15);
          padding: 8px;
          font-family: system-ui, -apple-system, BlinkMacSystemFont;
        }
      `;
    shadow.appendChild(style);

    function loadScript(src) {
      return new Promise((resolve) => {
        const s = document.createElement('script');
        s.src = src;
        s.onload = resolve;
        document.head.appendChild(s);
      });
    }

    function loadCSS(href) {
      const l = document.createElement('link');
      l.rel = 'stylesheet';
      l.href = href;
      shadow.appendChild(l);
    }

    loadCSS('https://unpkg.com/element-plus/dist/index.css');

    Promise.all([
      loadScript('https://unpkg.com/vue@3/dist/vue.global.prod.js'),
      loadScript('https://unpkg.com/element-plus/dist/index.full.min.js')
    ]).then(initVue);

    function initVue() {


      const { createApp, ref } = unsafeWindow.Vue;

      const App = {
        setup() {
          const rows = ref([
            { symbol: 'AU - GC', price: 'N/A', action: '', p95: '-13, 11' },
            { symbol: 'AG - SI', price: 'N/A', action: '', p95: '-122, 630' },
            { symbol: 'PT - PL', price: 'N/A', action: '', p95: ', 100' },
            { symbol: 'AU - XAU', price: 'N/A', action: '', p95: '0, 54' },
            { symbol: 'AG - XAG', price: 'N/A', action: '', p95: '-0.4, 0.8' },
            { symbol: 'OSE - GC', price: 'N/A', action: '', p95: '-34, 70' }
          ]);

          GM_addValueChangeListener('dataSource', (name, oldVal, newVal, remote) => {
            const usdcnh = GM_getValue('USDCNH');
            const usdjpy = GM_getValue('USDJPY');
            const gc = Number(GM_getValue('gold').replace(/,/g, ''));
            const au = GM_getValue('aum');
            const si = GM_getValue('silver');
            const ag = GM_getValue('agm');
            const f518850 = (Math.exp(Math.log(gc) + Math.log(usdcnh) - 8.1)).toFixed(3);
            const pt = GM_getValue('ptm');
            const PL = Number(GM_getValue('platinum').replace(/,/g, ''));
            const xau = Number(GM_getValue('xau-usd').replace(/,/g, ''));
            const xag = GM_getValue('xag-usd');
            const tgold = Number(GM_getValue('tgold').replace(/,/g, ''));

            let b1 = (au - gc * usdcnh / 31.1034768).toFixed(2);
            let b2 = (ag - si * usdcnh * 1000 / 31.1034768).toFixed(2);
            let b3 = (pt - PL * usdcnh / 31.1034768).toFixed(2);
            let b4 = (gc - xau).toFixed(2);
            let b5 = (si - xag).toFixed(2);
            let b6 = (tgold / usdjpy * 31.1034768 - xau).toFixed(2);

            rows.value[0].price = b1;
            rows.value[0].action = `518850 < ${f518850}`

            rows.value[1].price = b2;
            rows.value[2].price = b3;
            rows.value[3].price = b4;
            rows.value[4].price = b5;
            rows.value[5].price = b6;
          });

          return { rows };
        },
        template: `
              <div class="panel">
                <el-table
                  :data="rows"
                  size="small"
                  height="260"
                  border
                  row-key="symbol"
                >
                  <el-table-column prop="price" label="Basis" width="70" />
                  <el-table-column prop="symbol" label="Symbol" width="100" />
                  <el-table-column prop="action" label="Action" width="150" />
                  <el-table-column prop="p95" label="95%" />
                </el-table>
              </div>
            `
      };
      const app = createApp(App);
      app.use(ElementPlus);
      app.mount(appRoot);
    }
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
    const callback = function (mutationsList) {
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