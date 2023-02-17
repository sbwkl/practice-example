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


const userId = new URLSearchParams(window.location.href).get('creator_id');

function createProductAnalysisButton() {
    const button = document.createElement('Button');
    button.style = 'top:0; right:0; position: absolute; z-index:9999;'
    const buttonName = '复制达人数据';
    button.innerHTML = buttonName;
    document.body.appendChild(button);

    button.addEventListener('click', () => {
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

function createCheckboxButton() {
    const button = document.createElement('Button');
    button.style = 'top:50px; right:0; position: absolute; z-index:9999;'
    const buttonName = '显示复选框';
    button.innerHTML = buttonName;
    document.body.appendChild(button);
    button.addEventListener('click', () => {
        const tableList = document.getElementsByTagName('table');
        const exportButton = document.createElement('Button');
        exportButton.innerHTML = '正在生成...';
        const div = tableList[0].children[1].firstElementChild.firstElementChild.firstElementChild
        div.replaceChild(exportButton, div.firstElementChild);
        exportButton.addEventListener('click', () => {
            const checkboxList = document.getElementsByClassName('account-ref');
            const accountList = [];
            for (let cb of checkboxList) {
                if (cb.checked) {
                    const key = cb.getAttribute('data-key')
                    accountList.push({
                        'avatar_url': dataset[key]['avatar_url'],
                        'nickname': dataset[key]['nick_name'],
                        'user_id': dataset[key]['user_id']
                    });
                }
            }
            const accountRef = JSON.stringify(accountList);
            navigator.clipboard.writeText(`INSERT INTO rebate_douyin_account_report (user_id, account_ref) VALUES('${userId}', '${accountRef}') ON DUPLICATE KEY UPDATE account_ref='${accountRef}';`);
        });

        axios.get(`https://douhot.douyin.com/douhot/v1/author_analysis/fans_interest/similar_author?sec_uid=${userId}`)
        .then(r => {
            for (let u of r.data.data) {
                const nickname = u['nick_name'];
                dataset[nickname] = u;
            }
            const trList = tableList[1].children[1].children;
            for (let tr of trList) {
                const td = tr.firstElementChild;
                // const div = document.createElement('div');
                // div.innerHTML = '<input type="checkbox"></input>';
                // td.insertBefore(div, td.firstElementChild);
                
                // const avatar = tr.children[1].getElementsByTagName('img')[0].src;
                const iframe = tr.children[1].getElementsByTagName('iframe')[0]
                const nickname = iframe.parentElement.children[1].innerText;
                td.firstElementChild.innerHTML = `<input type="checkbox" class="account-ref" data-key="${nickname}"></input>`;
            }
        }).then(() => {
            exportButton.innerHTML = '导出 SQL';
        });
    });
}

const dataset = {}
createProductAnalysisButton();
createCheckboxButton();