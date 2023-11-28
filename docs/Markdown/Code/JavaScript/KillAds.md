去除网页广告的简单案例，可以自行添加网站

```javascript
// ==UserScript==
// @name         去除网站广告
// @namespace    http://tampermonkey.net/
// @version      1.0.0
// @description  去除网站广告，现已支持【gitee】
// @author       bolishitoumingde
// @match        gitee.com/*
// @grant        unsafeWindow
// @grant        GM_addStyle
// @grant        GM_log
// @require      https://cdn.bootcss.com/jquery/3.4.1/jquery.min.js
// ==/UserScript==

const giteeSelectorArr = [
  `body > div.gitee-stars-main-widget.pendan-widget`
]

function blockGitee () {
  if ($(document).ready()) {
    giteeSelectorArr.forEach((selector, index) => {
      giteeSelectorArr[index] = `${selector} {display:none!important}`
    })
    var sec = giteeSelectorArr.join(` `);
    var style = document.createElement(`style`);
    (document.querySelector(`head`) || document.querySelector(`body`)).appendChild(style);
    style.appendChild(document.createTextNode(sec));
  }
}


(function () {
  'use strict';

  var webList = []
  webList.push('gitee.com')

  var url = window.location.href;
  var index = webList.findIndex(item => url.match(item))

  // 当前网站不在去除广告的列表内
  if (index == -1) {
    return
  }

  switch (index) {
    case 0: blockGitee(); return;
  }
})();
```

