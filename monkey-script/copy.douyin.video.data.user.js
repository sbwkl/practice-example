// ==UserScript==
// @name        复制抖音视频数据
// @namespace   https://sbwkl.github.io/
// @match       https://creator.douyin.com/creator-micro/content/manage
// @grant       none
// @version     1.0
// @author      -
// @description 2/10/2023, 11:37:21 AM
// ==/UserScript==


function createButton() {
    const btnText = '复制视频数据';
    var btn = document.createElement('Button');
    btn.style = 'top:0; right:0; position:absolute; z-index:9999';
    btn.innerHTML = btnText;
    document.body.appendChild(btn);
    btn.addEventListener('click', function () {
        const micro = document.getElementById('micro');
        const root = micro.firstElementChild.firstElementChild.children[1].firstElementChild
        const videoElementList = root.firstElementChild.firstElementChild.children[2].children[1].firstElementChild;
        let content = 'videoTitle\tvideoLength';
        for (let e of videoElementList.children) {
            const videoTitle = e.children[1].firstElementChild.firstElementChild.innerHTML;
            const videoLength = e.children[0].children[3].innerHTML;
            content += `\n${videoTitle}\t${videoLength}`;
        }
        navigator.clipboard.writeText(content);
        btn.innerHTML = '已复制';
        setTimeout(() => btn.innerHTML = btnText, 3000);
    })
}

createButton();