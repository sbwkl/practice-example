// ==UserScript==
// @name        crawl relation keyword
// @namespace   https://sbwkl.github.io/
// @match       https://trendinsight.oceanengine.com/arithmetic-index/analysis
// @grant       none
// @version     1.0
// @author      -
// @description 2/9/2023, 4:45:30 PM
// ==/UserScript==

/**
 * 尚未写完，似乎实现不了，太蛋疼了
 */
function createCrawlButton() {
  const buttonText = '开始爬取';
  var button = document.createElement('Button');
  button.innerHTML = buttonText;
  button.style = "top:0;right:0;position:absolute;z-index: 9999; font-size: 16px;background-color: #e7e7e7;2px solid black;"
  document.body.appendChild(button);
  button.addEventListener("click", function() {
    // const keywordInput = document.getElementsByClassName('byted-select-value')[0];

    visitKeyword();

    let sqlContent = '';
    navigator.clipboard.writeText(sqlContent);
    button.innerHTML = '已复制';
    setTimeout(() => button.innerHTML = buttonText, 1000);
  })
}

function visitKeyword() {
  deep++;
  const relationAnalysis = root.children[1].children[1].firstElementChild.firstElementChild.children[2].firstElementChild.firstElementChild.firstElementChild.firstElementChild.firstElementChild.firstElementChild.firstElementChild.children[1];
  relationAnalysis.click();
  setTimeout(() => {
    printRelationKeyword();
    if (deep > 3) {
      return;
    }
    while(true) {
      // iterate relation word
      const relationRank = getRelationRankFromWindow();
      const idx = indexTracer[deep] || 0;
      if (idx >= relationRank.children.length) {
          break;
      }
      e = relationRank.children[idx];
      e.firstElementChild.click();
      setTimeout(() => {
          indexTracer[deep] = idx + 1;
          visitKeyword();
      }, 1000);
    }
    deep--;
  }, 1000);
}

function printRelationKeyword() {
    const relationRank = getRelationRankFromWindow();
    for (let e of relationRank.children) {
      const keyword = e.firstElementChild.firstElementChild.children[1].innerHTML;
      console.log(keyword);
    }
    return relationRank;
}

function getRelationRankFromWindow() {
    const root = document.getElementById('root');
    const relationRank = root.children[1].children[1].firstElementChild.firstElementChild.children[2].children[2].firstElementChild.firstElementChild.children[2].firstElementChild.firstElementChild.children[1];
    return relationRank;
}

let keywordStack = [];
let indexTracer = {};
let deep = 0;
createCrawlButton();