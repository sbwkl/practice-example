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
// @grant       GM_listValues
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
            { expr1: 'aum - gold * USDCNH / 31.1034768',  price: 'N/A', ratio: 'N/A', action: '', p95: '￥(-13, 12)/g', expr2: 'aum / (gold * USDCNH / 31.1034768)'},
            {
              price: 'N/A', ratio: 'N/A', action: '', p95: '￥(-122, 630)/kg',
              expr1: 'agm - silver * USDCNH * 1000 / 31.1034768',
              expr2: 'agm / (silver * USDCNH * 1000 / 31.1034768)',
              expr3: 'Math.exp(0.1311) * (silver * USDCNH * 1000 / 31.1034768)'
            },
            { expr1: 'ptm - platinum * USDCNH / 31.1034768',  price: 'N/A', ratio: 'N/A', action: '', p95: ', 100' , expr2: 'ptm / (platinum * USDCNH / 31.1034768)'},
            { expr1: 'gold - xau_usd', price: 'N/A', ratio: 'N/A', action: '', p95: '$(0, 54)/oz' , expr2: 'gold / xau_usd'},
            { expr1: 'silver - xag_usd', price: 'N/A', ratio: 'N/A', action: '', p95: '$(-0.4, 0.8)/oz' , expr2: 'silver / xag_usd'},
            { expr1: 'tgold / USDJPY - xau_usd / 31.1034768', price: 'N/A', ratio: 'N/A', action: '', p95: '$(-1.1, 2.23)/g' , expr2: '(tgold / USDJPY) / (xau_usd / 31.1034768)'}
          ]);

          const cache = new Map();

          function evalExpr(expr, ctx) {
            if (!cache.has(expr)) {
              cache.set(
                expr,
                new Function("ctx", `
                  ${Object.keys(ctx).map(k => `const ${k} = ctx.${k};`).join('\n')}
                  return ${expr};
                `)
              );
            }
            return cache.get(expr)(ctx);
          }

          GM_addValueChangeListener('dataSource', (name, oldVal, newVal, remote) => {

            const ctx = {};
            GM_listValues().filter(k => k !== '').forEach(k => {
              let _k = k.replace(/[^a-zA-Z0-9]/g, '_');
              _k = _k.replace(/^var$/g, '_var');
              ctx[_k] = Number(GM_getValue(k).replace(/,/g, ''));
            });

            // console.log('change...', ctx);

            for (const row of rows.value) {
              row.price = evalExpr(row.expr1, ctx).toFixed(2);
              row.ratio = Math.log(evalExpr(row.expr2, ctx)).toFixed(4);

              if (row.expr3) {
                row.action = evalExpr(row.expr3, ctx).toFixed(2);
              }

            }

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
                  <el-table-column prop="price" label="a-b" width="70" />
                  <el-table-column prop="ratio" label="a/b" width="70" />
                  <el-table-column prop="action" label="action" width="80" />
                  <el-table-column prop="p95" label="95%" width="150"/>
                  <el-table-column prop="expr1" label="a-b expr" width="300" >
                    <template #default="{ row }">
                      <el-input
                        v-model="row.expr1"
                        size="small"
                      />
                    </template>
                  </el-table-column>
                  <el-table-column prop="expr2" label="a/b expr" width="300" >
                    <template #default="{ row }">
                      <el-input
                        v-model="row.expr2"
                        size="small"
                      />
                    </template>
                  </el-table-column>
                  <el-table-column prop="expr3" label="expr3" width="300" >
                    <template #default="{ row }">
                      <el-input
                        v-model="row.expr3"
                        size="small"
                      />
                    </template>
                  </el-table-column>
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