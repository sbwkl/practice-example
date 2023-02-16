// ==UserScript==
// @name        复制热点宝数据
// @namespace   https://sbwkl.github.io/
// @match       https://douhot.douyin.com/creator/detail
// @grant       none
// @version     1.0
// @author      -
// @description 2/16/2023, 10:00:55 AM
// @require     https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js
// @require     https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.4/moment.min.js
// ==/UserScript==


function createProductAnalysisButton() {
    const button = document.createElement('Button');
    button.style = 'top:0; right:0; position: absolute; z-index:9999;'
    const buttonName = '复制达人数据';
    button.innerHTML = buttonName;
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

        const ironPromise = axios.get(`https://douhot.douyin.com/douhot/v1/author_analysis/user_portrait?sec_uid=${userId}&option=13`).then(r => {
            const portrait = JSON.stringify(r.data.data);
            return `INSERT INTO rebate_douyin_account_report (user_id, fans_iron_portrait) VALUES('${userId}', '${portrait}') ON DUPLICATE KEY UPDATE fans_iron_portrait='${portrait}';`
        });

        const activePromise = axios.get(`https://douhot.douyin.com/douhot/v1/author_analysis/user_portrait?sec_uid=${userId}&option=12`).then(r => {
            const portrait = JSON.stringify(r.data.data);
            return `INSERT INTO rebate_douyin_account_report (user_id, fans_active_portrait) VALUES('${userId}', '${portrait}') ON DUPLICATE KEY UPDATE fans_active_portrait='${portrait}';`
        });

        const activeTimePromise = axios.get(`https://douhot.douyin.com/douhot/v1/author_analysis/user_portrait?sec_uid=${userId}&option=11`).then(r => {
            const portrait = JSON.stringify(r.data.data);
            return `INSERT INTO rebate_douyin_account_report (user_id, fans_active_time) VALUES('${userId}', '${portrait}') ON DUPLICATE KEY UPDATE fans_active_time='${portrait}';`
        });

        const genderPromise = axios.get(`https://douhot.douyin.com/douhot/v1/author_analysis/user_portrait?sec_uid=${userId}&option=2`).then((r) => {
            const portrait = JSON.stringify(r.data.data);
            return `INSERT INTO rebate_douyin_account_report (user_id, fans_gender_portrait) VALUES('${userId}', '${portrait}') ON DUPLICATE KEY UPDATE fans_gender_portrait='${portrait}';`
        });
        
        const agePromise = axios.get(`https://douhot.douyin.com/douhot/v1/author_analysis/user_portrait?sec_uid=${userId}&option=3`).then((r) => {
            const portrait = JSON.stringify(r.data.data);
            return `INSERT INTO rebate_douyin_account_report (user_id, fans_age_portrait) VALUES('${userId}', '${portrait}') ON DUPLICATE KEY UPDATE fans_age_portrait='${portrait}';`
        });

        const regionPromise = axios.get(`https://douhot.douyin.com/douhot/v1/author_analysis/user_portrait?sec_uid=${userId}&option=4`).then(r => {
            const portrait = JSON.stringify(r.data.data);
            return `INSERT INTO rebate_douyin_account_report (user_id, fans_region_portrait) VALUES('${userId}', '${portrait}') ON DUPLICATE KEY UPDATE fans_region_portrait='${portrait}';`
        });

        const today = moment().subtract(1, 'd').format('YYYYMMDD')
        const hotEventPromise = axios.get(`https://douhot.douyin.com/douhot/v1/billboard/total?type=range&start_date=${today}&end_date=${today}&page=1&page_size=10`).then(r => {
            const rankingData = JSON.stringify(r.data.data);
            return `INSERT INTO rebate_douyin_common_ranking (ranking_type, ranking_data) VALUES('HOT_EVENT', '${rankingData}') ON DUPLICATE KEY UPDATE ranking_data='${rankingData}';`
        });

        const hotTopicPromise = axios.post('https://douhot.douyin.com/douhot/v1/material/challenge_billboard', {
            "page":1,"page_size":10,"date_window":24,"sub_type":2001
        }).then(r => {
            const rankingData = JSON.stringify(r.data.data);
            return `INSERT INTO rebate_douyin_common_ranking (ranking_type, ranking_data) VALUES('HOT_TOPIC', '${rankingData}') ON DUPLICATE KEY UPDATE ranking_data='${rankingData}';`
        })
        button.innerHTML = '正在复制...';
        Promise.all([baseInfoPromise, recentInfoPromise, 
            ironPromise, activePromise, activeTimePromise, genderPromise, agePromise, regionPromise, 
            hotEventPromise, hotTopicPromise]).then((values) => {
            navigator.clipboard.writeText(values.join('\n'));
        }).then(() => {
            button.innerHTML = '已复制';
        }).then(() => {
            setTimeout(() => {
                button.innerHTML = buttonName;
            }, 3000);
        })
        ;
    })
}

createProductAnalysisButton();