中国电信网上大学解除 切屏 & 复制限制 的油猴脚本

```javascript
// ==UserScript==
// @name         中国电信网上大学知识中心 题目复制 & 搜索
// @namespace    http://tampermonkey.net/
// @version      1.0.1
// @description  给中国电信网上大学知识中心增加 复制 & 搜索 按钮，当考试页面 "我要交卷" 上方出现 “已允许切屏/复制” 时表示脚本已启用
// @author       bolishitoumingde
// @match        kc.zhixueyun.com
// @match        wenku.baidu.com
// @match        *://*/*
// @run-at       document-end
// @grant        GM_getValue
// @grant        GM_setValue
// @grant        GM_deleteValue
// @grant        GM_setClipboard
// @grant        GM_info
// @grant        GM_xmlhttpRequest
// @grant        GM_addStyle
// @grant        GM_getResourceText
// @grant        GM_registerMenuCommand
// @grant        unsafeWindow
// @resource   vantcss   https://unpkg.com/vant@2.12/lib/index.css
// @require      https://cdn.bootcss.com/jquery/3.4.1/jquery.min.js
// @require      https://cdn.bootcdn.net/ajax/libs/clipboard.js/2.0.11/clipboard.min.js
//
// @connect      https://www.kaoshibao.com/
// @license      GPLv3
// @connect      *
// @downloadURL
// @updateURL
// ==/UserScript==

// @match        *://*/*

var $ = unsafeWindow.jQuery || window.jQuery;
var Clipboard = window.ClipboardJS;

var getSelectedText = function () {
  if (window.getSelection) {
    return window.getSelection().toString();
  }
  if (document.getSelection) {
    return document.getSelection().toString();
  }
  if (document.selection) {
    return document.selection.createRange().text;
  }
  return "";
};

var bindClipboardEvent = function (clipboard) {
  clipboard.on("success", function (e) {
    $("#_copy").html("复制成功");
    setTimeout(function () { return $("#_copy").fadeOut(1000); }, 1000);
    e.clearSelection();
  });
  clipboard.on("error", function (e) {
    $("#_copy").html("复制失败");
    setTimeout(function () { return $("#_copy").fadeOut(1000); }, 1000);
    e.clearSelection();
  });
};

// 加载UI
async function loadUi (copyText) {
  const ui = document.createElement("iframe");
  ui.id = "ui";
  ui.style.position = 'fixed';
  ui.style.top = '0'
  ui.style.height = '50%'
  ui.style.width = '100%'
  ui.style.backgroundColor = 'white';
  ui.style.zIndex = "10000"
  ui.src = "https://so.kaoshibao.com/search/question?keyword=" + copyText

  document.body.appendChild(ui)
}

function initEvent () {
  var event = setInterval(() => {
    if (document.body) {
      clearInterval(event);

      document.addEventListener("mouseup", function (e) {
        // 在于判断是否点击了复制按钮和搜索按钮，如果点击则不弹出按钮
        if ($(e) == $("#_copy") || $(e) == $("#_search")) {
          return;
        }
        var ui = document.getElementById('ui')
        if (ui) {
          document.body.removeChild(ui)
        }
        $("#_copy").remove()
        $("#_search").remove()
        var copyText = getSelectedText()
        if (!copyText) {
          return "";
        }
        // 复制按钮
        var copyTemplate = "<div id=\"_copy\"\n style=\"cursor:pointer;border-radius:5px;padding: 5px 10px;color: #FFF;background: green;position: absolute; z-index:1000;left:".concat(e.pageX + 5, "px;top:").concat(e.pageY - 15, "px;\"\n data-clipboard-text=\"").concat(copyText.replace(/"/g, "&quot;"), "\">复制</div>");
        $("body").append(copyTemplate);
        $("#_copy").on("mousedown", function (event) { return event.stopPropagation() })
        $("#_copy").on("mouseup", function (event) { return event.stopPropagation() })
        var clipboard = new Clipboard("#_copy")
        bindClipboardEvent(clipboard)


        var url = window.location.hash;
        var urlStr = url.toString();
        if (urlStr.match("/exam/exam/answer-paper/")) {
          // 搜索按钮
          var searchTemplate = "<div id=\"_search\"\n style=\"cursor:pointer;border-radius:5px;padding: 5px 10px;color: #FFF;background: red;position: absolute; z-index:1000;left:".concat(e.pageX + 85, "px;top:").concat(e.pageY - 15, "px;\"\n data-clipboard-text=\"").concat(copyText.replace(/"/g, "&quot;"), "\">搜索</div>");
          $("body").append(searchTemplate);
          $("#_search").on("mousedown", function (event) { return event.stopPropagation() })
          $("#_search").on("mouseup", function (event) { return event.stopPropagation() })
          $("#_search").on("click", function (event) {
            // 搜索按钮的点击事件
            loadUi(copyText)
          })
        }
      })
    }
  }, 100)
}

function initExam () {
  if (window.location.hash.toString.match("/exam/exam/answer-paper/")) {
    var allowSwitchAndCopyButton = `<a id="allowSwitchAndCopy" class="btn block w-half m-top">允许切屏/复制</a>`
    // 添加允许切屏和复制的按钮
    var event = setInterval(() => {
      if (document.body) {
        clearInterval(event)
        $(".side-main #D165submit").parent().prepend(allowSwitchAndCopyButton)
        $(".side-main #allowSwitchAndCopy").click(allowSwitchAndCopy)
      }
    }, 100);

    function allowSwitchAndCopy () {
      allowSwitch()
      allowCopy()
    }

    // 允许切屏
    function allowSwitch () {
      unsafeWindow.onblur = null;
      Object.defineProperty(unsafeWindow, 'onblur', {
        set: function (v) {
          console.log('onblur', v)
        }
      });
    }

    // 允许复制
    function allowCopy () {
      var previewContent = document.querySelector('.preview-content')
      previewContent.oncontextmenu = null
      previewContent.oncopy = null
      previewContent.oncut = null
      previewContent.onpaste = null
    }
  }
}

(function () {
  var url = window.location.hash;
  var urlStr = url.toString();

  // 判断是否在考试页面
  // if (urlStr.match("/exam/exam/answer-paper/")) {
  //   unsafeWindow.onblur = null;
  //   document.body.onblur = null;
  //   Object.defineProperty(unsafeWindow, 'onblur', {
  //     set: function (v) {
  //       console.log('unsafeWindow onblur', v)
  //     }
  //   });
  //   Object.defineProperty(document.body, 'onblur', {
  //     set: function (v) {
  //       console.log('body onblur', v)
  //     }
  //   });
  //   initEvent();
  // }
  unsafeWindow.onblur = null;
  document.body.onblur = null;
  Object.defineProperty(unsafeWindow, 'onblur', {
    set: function (v) {
      console.log('unsafeWindow onblur', v)
    }
  });
  Object.defineProperty(document.body, 'onblur', {
    set: function (v) {
      console.log('body onblur', v)
    }
  });
  initEvent();
  // 添加允许切屏和复制的按钮
  setTimeout(() => {
    var allowSwitchAndCopyButton = `<a id="allowSwitchAndCopy" class="btn block w-half m-top">已允许切屏/复制</a>`
    $(".side-main #D165submit").parent().prepend(allowSwitchAndCopyButton)
    // $(".side-main #allowSwitchAndCopy").click(allowSwitchAndCopy)
  }, 1000)
  // initExam()
})();
```

