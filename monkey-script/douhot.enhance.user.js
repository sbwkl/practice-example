// ==UserScript==
// @name        复制热点宝数据
// @namespace   https://sbwkl.github.io/
// @match       https://douhot.douyin.com/creator/detail
// @grant       none
// @version     1.0
// @author      -
// @description 2/16/2023, 10:00:55 AM
// @require     https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js
// ==/UserScript==


function createProductAnalysisButton() {
    const button = document.createElement('Button');
    button.style = 'top:0; right:0; position: absolute; z-index:9999;'
    button.innerHTML = '复制 30 天作品数据';
    document.body.appendChild(button);

    button.addEventListener('click', () => {
        const userId = new URLSearchParams(window.location.href).get('creator_id');
        const baseInfoPromise = axios.get(`https://douhot.douyin.com/douhot/v1/author_analysis/author_info?sec_uid=${userId}`).then((r) => {
            const nickname = r.data.data.nickname.replace(/([\uE000-\uF8FF]|\uD83C[\uDF00-\uDFFF]|\uD83D[\uDC00-\uDDFF])/g, '');
            const avatarUrl = r.data.data.avatar_url;
            const followerCount = r.data.data.follower_count;
            return `INSERT INTO rebate_douyin_account_report (user_id, nickname, avatar_url, follower_count) VALUES('${userId}', '${nickname}', '${avatarUrl}', '${followerCount}') ON DUPLICATE KEY UPDATE nickname='${nickname}', avatar_url='${avatarUrl}', follower_count='${followerCount}';`;
        });

        const recentInfoPromise = axios.get(`https://douhot.douyin.com/douhot/v1/author_analysis/product_analysis/product_data?sec_uid=${userId}&day=30`).then((r) => {
            const recentInfo = JSON.stringify(r.data.data);
            return `INSERT INTO rebate_douyin_account_report (user_id, recent_info) VALUES('${userId}', '${recentInfo}') ON DUPLICATE KEY UPDATE recent_info='${recentInfo}';`
        });

        const genderPromise = axios.get(`https://douhot.douyin.com/douhot/v1/author_analysis/user_portrait?sec_uid=${userId}&option=2`).then((r) => {
            const portrait = JSON.stringify(r.data.data);
            return `INSERT INTO rebate_douyin_account_report (user_id, fans_gender_portrait) VALUES('${userId}', '${portrait}') ON DUPLICATE KEY UPDATE fans_gender_portrait='${portrait}';`
        })
        
        const agePromise = axios.get(`https://douhot.douyin.com/douhot/v1/author_analysis/user_portrait?sec_uid=${userId}&option=3`).then((r) => {
            const portrait = JSON.stringify(r.data.data);
            return `INSERT INTO rebate_douyin_account_report (user_id, fans_age_portrait) VALUES('${userId}', '${portrait}') ON DUPLICATE KEY UPDATE fans_age_portrait='${portrait}';`
        })

        const regionPromise = axios.get(`https://douhot.douyin.com/douhot/v1/author_analysis/user_portrait?sec_uid=${userId}&option=4`).then(r => {
            const portrait = JSON.stringify(r.data.data);
            return `INSERT INTO rebate_douyin_account_report (user_id, fans_region_portrait) VALUES('${userId}', '${portrait}') ON DUPLICATE KEY UPDATE fans_region_portrait='${portrait}';`
        })

        Promise.all([baseInfoPromise, recentInfoPromise, genderPromise, agePromise, regionPromise]).then((values) => {
            navigator.clipboard.writeText(values.join('\n'));
        });
    })
}

createProductAnalysisButton();