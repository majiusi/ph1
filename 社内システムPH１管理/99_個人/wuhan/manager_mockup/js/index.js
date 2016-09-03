function checkUId(blank) {
    var types = blank ? ['blankString'] : [];
    types.push('invalidString');
    types.push('tooShort');
    types.push('tooLong');
    return checkItem({elem : $i('txtUId'), name : '登陆名', msgArea : $i('lblUId')}, types);
}

function checkUPwd(blank) {
    var types = blank ? ['blankString'] : [];
    types.push('tooShort');
    types.push('tooLong');
    return checkItem({elem : $i('txtUPwd'), name : '密码', msgArea : $i('lblUPwd')}, types);
}

function getAuth(uid) {
    if (uid.length < 3) {
        initSel($i('selUAuth'), '游客');
        return;
    }
    var ajax = new Ajax('GET', 'bin/get_auth.php?id=' + uid + '&sid=' + Math.random(), {loading : loadingAuth, complete : setAuth});
    ajax.sendReq();
}

function loadingAuth() {
    $i('lblUAuth').innerHTML = '<img src="img/loading.gif"></img>';
}

function setAuth() {
    var res = this.req.responseXML.documentElement;
    var auth = res.getElementsByTagName('auth');
    if (auth) {
        var oSel = $i('selUAuth');
        initSel(oSel, '游客');
        for (var i = 0; i < auth.length; i++) {
            addChild(oSel, 'option', auth[i].firstChild.nodeValue, i + 1);
        }
    } else {
        var oSel = $i('selUAuth');
        initSel(oSel, '游客');
    }
    $i('lblUAuth').innerHTML = '';
}

function login() {
    if (!(checkUId(true) & checkUPwd(true))) {
        return false;
    }
    var data = 'id=' + $i('txtUId').value + '&pwd=' + $i('txtUPwd').value + '&auth=' + $i('selUAuth').value;
    var ajax = new Ajax('POST', 'bin/verify_user.php', {loading : logining, complete : loginRes}, data);
    ajax.sendReq();
}

function logining() {
    $i('msg').innerHTML = '正在为您登录……';
}

function loginRes() {
    var res = this.req.responseXML.documentElement;
    var error = $tns(res, 'error');
    
    if (error) {
        $i('msg').innerHTML = error;
        $i('txtUPwd').value = '';
    } else {
        $i('info').innerHTML = $tns(res, 'info');
        $i('msg').innerHTML = $tns(res, 'msg');
        genLink($tns(res, 'auth'));
    }
}

function genForm() {
    $i('divContent').innerHTML =
        '<form id="frmLogin">' +
            '<table id="tblLogin">' +
            '<tr>' +
                '<td class="field">' +
                    '<label id="lblUIdName">' +
                        '<em>*</em>登录名：' +
                    '</label>' +
                '</td>' +
                '<td id="tdUId">' +
                    '<input type="text" id="txtUId" title="登录名" onfocus="applyStyle(this, ' +
                    "'focus'" +
                    ');" onblur="checkUId();" onkeyup="getAuth(this.value);" class="text_login_normal" />' +
                '</td>' +
                '<td>' +
                    '<label id="lblUId" class="errormsg">' +
                    '</label>' +
                '</td>' +
            '</tr>' +
            '<tr>' +
                '<td class="field">' +
                    '<label id="lblUPwdName">' +
                        '<em>*</em>密码：' +
                    '</label>' +
                '</td>' +
                '<td id="tdUPwd">' +
                    '<input type="password" id="txtUPwd" title="密码" onfocus="applyStyle(this, ' +
                    "'focus'" +
                    ');" onblur="checkUPwd();" class="text_login_normal" />' +
                '</td>' +
                '<td>' +
                    '<label id="lblUPwd" class="errormsg">' +
                    '</label>' +
                '</td>' +
            '</tr>' +
            '<tr>' +
                '<td class="field">' +
                    '<label id="lblUAuthName">' +
                        '权限：' +
                    '</label>' +
                '</td>' +
                '<td id="tdUAuth">' +
                    '<select id="selUAuth" title="权限" class="select_auth_normal">' +
                        '<option selected="selected" value="0">游客</option>' +
                    '</select>' +
                '</td>' +
                '<td>' +
                    '<label id="lblUAuth" class="errormsg">' +
                    '</label>' +
                '</td>' +
            '</tr>' +
            '</table>' +
            '<table id="tblSubmit">' +
            '<tr>' +
                '<td>' +
                    '<input type="button" id="btnLogin" value="登录" title="登录" onclick="login();" class="button" />' +
                '</td>' +
                '<td>' +
                    '<input type="button" id="btnReg" value="注册" title="注册" onclick="location.href(' +
                    "'reg.php'" +
                    ');" class="button" />' +
                '</td>' +
            '</tr>' +
            '</table>' +
        '</form>';
    $i('txtUId').title = '3~10位的字母、数字、下划线(_)或连字号(-)';
    $i('txtUPwd').title = '3~10位';
}

function genLink(auth) {
    $i('divContent').innerHTML = '';
    if (auth >= 1) {
        $i('divContent').innerHTML +=
            '<div id="divAInfo" class="navi">' +
                '<a href="detail.php">我的信息</a>' +
            '</div>';
    }
    if (auth >= 2) {
        $i('divContent').innerHTML +=
            '<br />' +
            '<div id="tdAMng" class="navi">' +
                '<a href="manage.php">用户管理</a>' +
            '</div>';
    }
    $i('divContent').innerHTML +=
        '<table id="tblSubmit">' +
        '<tr>' +
            '<td>' +
                '<input type="button" id="btnLogout" value="退出" title="退出" onclick="logout();" class="button" />' +
            '</td>' +
        '</tr>' +
        '</table>';
}

function logout() {
    var ajax = new Ajax('GET', 'bin/logout.php', {loading : logouting, complete : logoutRes});
    ajax.sendReq();
}

function logouting() {
    $i('msg').innerHTML = '正在为您退出……';
}

function logoutRes() {
    var res = this.req.responseXML.documentElement;
    var error = $tns(res, 'error');
    
    if (error) {
        $i('info').innerHTML = $tns(res, 'info');
        $i('msg').innerHTML = error;
    } else {
        $i('info').innerHTML = $tns(res, 'info');
        $i('msg').innerHTML = $tns(res, 'msg');
    }
    genForm();
}

function getLoginInfo() {
    var ajax = new Ajax('GET', 'bin/get_login_info.php', {loading : gettingLoginInfo, complete : loginInfo});
    ajax.sendReq();
}

function gettingLoginInfo() {
    $i('msg').innerHTML = '正在为您跳转……';
}

function loginInfo() {
    var res = this.req.responseXML.documentElement;
    
    $i('info').innerHTML = $tns(res, 'info');
    $i('msg').innerHTML = $tns(res, 'msg');
    genLink($tns(res, 'auth'));
}
