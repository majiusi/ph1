function getInfo() {
    var ajax = new Ajax('GET', 'bin/get_info.php', {loading : gettingInfo, complete : showInfo});
    ajax.sendReq();
}

function gettingInfo() {
    $i('msg').innerHTML = '正在获取用户信息……';
}

function showInfo() {
    var res = this.req.responseText;
    if (/<error>/.test(res)) {
        res = this.req.responseXML.documentElement;
        $i('info').innerHTML = $tns(res, 'info');
        $i('msg').innerHTML = $tns(res, 'error');
        if ($tns(res, 'info') == '请重新登录') {
            $i('divContent').innerHTML = '<a href="index.php" class="link">登录</a>';
        }
    } else {
        $i('divContent').innerHTML = res;
        $i('msg').innerHTML = '';
    }
}

function modItem(oElem, item) {
    var oDiv = $i('divMod');
    oDiv.className = 'div_mod_show';
    oDiv.style.left = (findPosX(oElem) + 20) + 'px';
    oDiv.style.top = (findPosY(oElem) + 20) + 'px';
    var name = oElem.parentNode.firstChild.firstChild.firstChild.nodeValue;
    var val = oElem.firstChild.firstChild ? oElem.firstChild.firstChild.nodeValue : '';
    var value = htmlStr(val);
    
    var modItemHtml = {
        id_no : function() {
            return '<input type="text" id="txtMod" name="itemMod" onfocus="applyStyle(this, ' + "'normal'" + ');" class="text_mod_normal" value="' + value + '" />';
        },
        name : function() {
            return '<input type="text" id="txtMod" name="itemMod" onfocus="applyStyle(this, ' + "'normal'" + ');" class="text_mod_normal" value="' + value + '" />';
        },
        sex : function() {
            return '<div class="mod_sex">' +
                '<input type="radio" id="rdoMale" name="itemMod" value="男"' + (value == '男' ? ' checked="checked"' : '') + ' />男' +
                '<input type="radio" id="rdoFemale" name="itemMod" value="女"' + (value == '男' ? '' : ' checked="checked"') + ' />女' +
                '</div>';
        },
        birthday : function() {
            var d = value.split('-');
            return '<div class="mod_birthday">' +
                '<input type="text" id="txtModYear" name="itemMod" onfocus="applyStyle(this, ' + "'normal'" + ');" class="text_mod_year_normal" value="' + d[0] + '" />年' +
                '<input type="text" id="txtModMonth" name="itemMod" onfocus="applyStyle(this, ' + "'normal'" + ');" class="text_mod_month_normal" value="' + d[1] + '" />月' +
                '<input type="text" id="txtModDate" name="itemMod" onfocus="applyStyle(this, ' + "'normal'" + ');" class="text_mod_date_normal" value="' + d[2] + '" />日' +
                '</div>';
        },
        tel : function() {
            return '<input type="text" id="txtMod" name="itemMod" onfocus="applyStyle(this, ' + "'normal'" + ');" class="text_mod_normal" value="' + value + '" />';
        },
        mobile : function() {
            return '<input type="text" id="txtMod" name="itemMod" onfocus="applyStyle(this, ' + "'normal'" + ');" class="text_mod_normal" value="' + value + '" />';
        },
        email : function() {
            return '<input type="text" id="txtMod" name="itemMod" onfocus="applyStyle(this, ' + "'normal'" + ');" class="text_mod_normal" value="' + value + '" />';
        },
        addr : function() {
            return '<textarea id="txaMod" name="itemMod" onfocus="applyStyle(this, ' + "'normal'" + ');" class="textarea_mod_normal">' + value + '</textarea>';
        }
    };
    
    var modHtml = '<div id="divModTitle" class="div_mod_title"><label>修改' + name + '</label>';
    modHtml += '<img src="img/close.gif" onclick="modCancel();"></img></div>';
    modHtml += '<div id="divModItem" class="div_mod_item">';
    modHtml += modItemHtml[item]();
    modHtml += '</div>';
    modHtml += '<div id="divModSubmit" class="div_mod_submit">';
    modHtml += '<label id="lblMod" class="mod_error"></label>';
    modHtml += '<input type="button" id="btnModOK" value="确定" onclick="modOK(' + "'" + item + "', '" + value + "'" + ');" />';
    modHtml += '<input type="button" id="btnModCancel" value="取消" onclick="modCancel();" />';
    modHtml += '</div>';
    
    oDiv.innerHTML = modHtml;
    if (item != 'birthday') {
        $n('itemMod', 0).value = val;
    }
    $n('itemMod', 0).select();
}

function modOK(item, oldValue) {
    var newValue = $n('itemMod', 1) ? ($n('itemMod', 0).value + '-' + $n('itemMod', 1).value + '-' + $n('itemMod', 2).value) : ($n('itemMod', 0).type == 'radio' ? ($n('itemMod', 0).checked ? '男' : '女') : $n('itemMod', 0).value);
    if (newValue == oldValue) {
        $i('btnModOK').style.visibility = 'hidden';
        hideMod();
        $i('msg').innerHTML = '您未做修改';
        return;
    }
    
    switch (item) {
        case 'id_no' :
            if (!checkItem({elem : $i('txtMod'), msgArea : $i('lblMod')}, ['blankString', 'invalidIdNo'], null, {invalidIdNo : '身份证号无效'})) return;
            break;
        case 'name' :
            if (!checkItem({elem : $i('txtMod'), msgArea : $i('lblMod')}, ['blankString', 'invalidString', 'tooShort', 'tooLong'], {reg : /^[^&]*$/, minLen : 2, maxLen : 100}, {tooShort : '姓名过短', tooLong : '姓名超长'})) return;
            break;
        case 'birthday' :
            if (!checkItem({elem : [$i('txtModYear'), $i('txtModMonth'), $i('txtModDate')], msgArea : $i('lblMod')}, ['invalidDate', 'dateOver'], null, {dateOver : '今日之后'})) return;
            break;
        case 'tel' :
            if (!checkItem({elem : $i('txtMod'), msgArea : $i('lblMod')}, ['blankString', 'invalidTel'], null, {invalidTel : '电话号码无效'})) return;
            break;
        case 'mobile' :
            if (!checkItem({elem : $i('txtMod'), msgArea : $i('lblMod')}, ['blankString', 'invalidString'], {reg : /^1(3|5|8)\d{9}$/}, {invalidString : '手机号码无效'})) return;
            break;
        case 'email' :
            if (!checkItem({elem : $i('txtMod'), msgArea : $i('lblMod')}, ['blankString', 'invalidEmail', 'tooLong'], {maxLen : 40}, {invalidEmail : '邮件地址无效', tooLong : '邮件地址超长'})) return;
            break;
        case 'addr' :
            if (!checkItem({elem : $i('txaMod'), msgArea : $i('lblMod')}, ['blankString', 'invalidString', 'tooLong'], {reg : /^[^&]*$/, maxLen : 500}, {tooLong : '地址超长'})) return;
            break;
    }
    
    if (item == 'birthday') {
        var d = newValue.split('-');
        d[1] = d[1].length == 1 ? ('0' + d[1]) : d[1];
        d[2] = d[2].length == 1 ? ('0' + d[2]) : d[2];
        newValue = d.join('-');
    }
    $i('btnModOK').style.visibility = 'hidden';
    hideMod();
    var ajax = new Ajax('POST', 'bin/update_info.php', {loading : modifying, complete : modRes}, 'field=' + item + '&value=' + newValue);
    ajax.sendReq();
}

function modifying() {
    $i('msg').innerHTML = '正在为您修改……';
}

function modRes() {
    var res = this.req.responseXML.documentElement;
    if ($tns(res, 'error')) {
        $i('msg').innerHTML = $tns(res, 'error');
        if ($tns(res, 'info') == '请重新登录') {
            $i('divContent').innerHTML = '<a href="index.php" class="link">登录</a>';
        }
    } else {
        $i('msg').innerHTML = $tns(res, 'msg');
        $i($tns(res, 'field')).innerHTML = $tns(res, 'value') ? (/</.test($tns(res, 'value')) ? $tns(res, 'value').replace(/</g, '&#60;') : $tns(res, 'value')) : '';
    }
}

function modCancel() {
    $i('btnModCancel').style.visibility = 'hidden';
    hideMod();
    $i('msg').innerHTML = '';
}

function hideMod() {
    $i('divMod').className = 'div_mod_init';
}