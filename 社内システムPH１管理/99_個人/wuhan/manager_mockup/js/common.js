function $i() {
    return document.getElementById(arguments[0]);
}

function $n() {
    var oa = document.getElementsByName(arguments[0]);
    return arguments[1] == null ? oa : oa[arguments[1]];
}

function $tn() {
    var oa = document.getElementsByTagName(arguments[0]);
    return arguments[1] == null ? oa : oa[arguments[1]];
}

function $tns() {
    var o = arguments[0].getElementsByTagName(arguments[1])[0];
    return o ? o.childNodes.length > 1 ? o.childNodes[1].nodeValue : (o.firstChild ? o.firstChild.nodeValue : null) : null;
}

function htmlStr(str) {
    return str.replace(/&/g, '&#38;').replace(/\"/g, '&#34;').replace(/</g, '&#60;').replace(/>/g, '&#62;').replace(/[\"\'\\]/g, '\\$&');
}

function isArray(o) {
    return Object.prototype.toString.apply(o) === '[object Array]';
}

function applyStyle(oElem, style) {
    //设置背景色
    oElem.className = oElem.className.replace(/_[a-zA-Z0-9]+$/, '_' + style);
}

function addChild(oElem, type, text, value) {
    //添加子元素
    var oChild = document.createElement(type);
    oChild.innerHTML = text;
    oChild.value = value;
    oElem.appendChild(oChild);
}

function findPosX(oElem) {
    var posX = 0;
    if (oElem.offsetParent) {
        while (oElem.offsetParent) {
            posX += oElem.offsetLeft;
            oElem = oElem.offsetParent;
        }
    } else if (oElem.x) {
        posX += oElem.x;
    }
    return posX;
}

function findPosY(oElem) {
    var posY = 0;
    if (oElem.offsetParent) {
        while (oElem.offsetParent) {
            posY += oElem.offsetTop;
            oElem = oElem.offsetParent;
        }
    } else if (oElem.y) {
        posY += oElem.y;
    }
    return posY;
}

function initSel(oSel, text) {
    //初始化SELECT
    for (var i = oSel.childNodes.length - 1; i >= 0; i--) {
        oSel.removeChild(oSel.childNodes[i]);
    }
    if (text) {
        addChild(oSel, 'option', text, 0);
    }
}

function isLeap(y) {
    //return y % 4 == 0 && y % 100 != 0 || y % 400 == 0;
    return (new Date(y, 2, 0).getDate() == 29);
}

function formatDate(date, isFull, delimeter) {
    if (typeof date === 'string') {
        var d = date.split(/\D+/);
        var date = new Date(d[0], d[1] - 1, d[2]);
    } else if (new Date(date) == null) {
        return null;
    }
    var delimeter = delimeter || '-';
    return (isFull ? date.getFullYear() : date.getYear()) + delimeter +
        (isFull ? (date.getMonth() < 9 ? '0' + (date.getMonth() + 1) : (date.getMonth() + 1)) : (date.getMonth() + 1)) + delimeter +
        (isFull ? (date.getDate() < 10 ? '0' + date.getDate() : date.getDate()) : (date.getDate()));
}

function check(str, con) {
    var checks = {
        blankString : function() {
            return str ? false : true;
        },
        invalidString : function() {
            return (con['reg'] || /^[A-Za-z0-9_\-]+$/).test(str) ? false : true;
        },
        tooShort : function() {
            return str.length != 0 && str.length < (con['minLen'] || 3);
        },
        tooLong : function() {
            return str.length > (con['maxLen'] || 10);
        },
        notSame : function() {
            return con['id'] ? ($i(con['id']) ? (($i(con['id'])).value ? (str != ($i(con['id'])).value) : false) : false) : false;
        },
        invalidDate : function() {
            try {
                if (!/^\d{4}-\d{1,2}-\d{1,2}$/.test(str)) throw new Exception();
                var d = str.split('-');
                if (d[0] < (con['llYear'] || 1900) || d[0] > (con['ulYear'] || 2100)) throw new Exception();
                if (d[1] < 1 || d[1] > 12) throw new Exception();
                var tab = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
                tab[1] = isLeap(d[0]) ? 29 : tab[1];
                if (d[2] < 1 || d[2] > tab[d[1] - 1]) throw new Exception();
            } catch (e) {
                return true;
            }
            return false;
        },
        dateOver : function() {
            return formatDate(str, true) > formatDate(con['date'] || new Date(), true);
        },
        invalidIdNo : function() {
            return /^[1-8]\d{5}((18)|(19)|(20))?\d{2}[0-1]\d[0-3]\d{4}[\dXx]?$/.test(str) ? false : true;
        },
        invalidTel : function() {
            return /^((\(0[1-9]\d{1,3}\))|(0[1-9]\d{1,3})|(0[1-9]\d{1,3}\-?))[2-9]\d{2,3}\-?\d{4}$/.test(str) ? false : true;
        },
        invalidEmail : function() {
            return /^[a-z_](([a-z0-9_\-]*)|(([a-z0-9_\-]*)?([\.\+][a-z0-9_\-]+)*))@[a-z0-9]+\.(com|net|org|edu|biz|co)(\.[a-z][a-z])?$/i.test(str) ? false : true;
        }
    };
    
    return checks[con['type']]();
}

function checkItem(obj, types, con, msgs) {
    var elem = obj['elem'];
    var str = '';
    if (isArray(elem)) {
        for (i in elem) {
            str += elem[i].value + '-';
        }
        str = str.slice(0, str.length - 1);
    } else {
        str = elem.value;
    }
    var name = obj['name'] || null;
    var msgs = {
        blankString : msgs && msgs['blankString'] || (name || '项目') + '为空',
        invalidString : msgs && msgs['invalidString'] || (name || '') + '包含无效字符',
        tooShort : msgs && msgs['tooShort'] || (name || '') + '不足最小长度',
        tooLong : msgs && msgs['tooLong'] || (name || '') + '超过最大长度',
        notSame : msgs && msgs['notSame'] || (name || '两次输入') + '不一致',
        invalidDate : msgs && msgs['invalidDate'] || '无效日期',
        dateOver : msgs && msgs['dateOver'] || (con && con['date'] || '今天') + '之后的日期',
        invalidIdNo : msgs && msgs['invalidIdNo'] || '无效的身份证号',
        invalidTel : msgs && msgs['invalidTel'] || '无效的电话号码',
        invalidEmail : msgs && msgs['invalidEmail'] || '无效的邮件地址'
    };
    
    for (i in types) {
        if (check(str, {type : types[i], reg : con && con['reg'], maxLen : con && con['maxLen'], minLen : con && con['minLen'], date : con && con['date']})) {
            if (isArray(elem)) {
                for (j in elem) {
                    applyStyle(elem[j], 'error');
                }
            } else {
                applyStyle(elem, 'error');
            }
            obj['msgArea'].innerHTML = msgs[types[i]];
            return false;
        }
    }
    
    if (isArray(elem)) {
        for (i in elem) {
            applyStyle(elem[i], 'normal');
        }
    } else {
        applyStyle(elem, 'normal');
    }
    obj['msgArea'].innerHTML = '';
    return true;
}

function sleep(numberMillis) {
    //等待numberMillis毫秒
    var dialogScript = "window.setTimeout(" + " function(){window.close();}," + numberMillis + ");";
    var result = window.showModalDialog("javascript:document.writeln(" + "'<script>" + dialogScript + "<" + "/script>')");
}

function redirect(url) {
    window.location.href = url;
    window.nevigate(url);
}

Ajax = function(method, url, callbacks, data, async) {
    //Ajax核心类
    this.req = null;
    this.method = method || 'GET';
    this.url = url;
    this.onUninit = callbacks['uninitialized'] || null;
    this.onLoading = callbacks['loading'] || null;
    this.onLoaded = callbacks['loaded'] || null;
    this.onInter = callbacks['interactive'] || null;
    this.onComplete = callbacks['complete'];
    this.data = data;
    this.async = async || true;
}

Ajax.prototype = {
    sendReq : function() {
        try {
            this.req = new ActiveXObject('Msxml2.XMLHTTP');
        } catch (e) {
            try {
                this.req = new ActiveXObject('Microsoft.XMLHTTP');
            } catch (e) {
                try {
                    this.req = new XMLHttpRequest();
                } catch (e) {}
            }
        }
        this.req.open(this.method, this.url, this.async);
        if (this.method == 'POST') {
            this.req.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
            this.req.setRequestHeader('Contend-length', this.data.length);
        }
        var self = this;
        this.req.onreadystatechange = function() {
            self.onReady.call(self);
        };
        this.req.send(this.method == 'POST' ? this.data : null);
    },
    
    onReady : function() {
        switch (this.req.readyState) {
            case 0 : {
                if (this.onUninit) {
                    this.onUninit.call(this);
                }
                break;
            }
            case 1 : {
                if (this.onLoading) {
                    this.onLoading.call(this);
                }
                break;
            }
            case 2 : {
                if (this.onLoaded) {
                    this.onLoaded.call(this);
                }
                break;
            }
            case 3 : {
                if (this.onInter) {
                    this.onInter.call(this);
                }
                break;
            }
            case 4 : {
                if (this.onComplete) {
                    this.onComplete.call(this);
                }
            }
        }
    }
}
