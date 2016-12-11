// init
$(function(){
	$("#login").bind("click",onLogin); 
});

// ログイン
function onLogin() { 
	
	var username = $("#userName").val();
	var userpass = $("#userPassword").val();
	
	var BasicAuthorizationCode = function(username, password){
		var safeStr = unescape(encodeURIComponent(username + ':' + password));
		var btoaCode = btoa(safeStr);
		return 'Basic ' + btoaCode;
	};
	var json_data={"enterprise_id":"MAE0001"};
	$.ajax({
		url: "http://54.199.240.10/api/MAS0000010",
		type: 'post',
		contentType: "application/json; charset=utf-8",
		beforeSend: function (xhr) {
			xhr.setRequestHeader ('Authorization', BasicAuthorizationCode(username, userpass));
		},
		data:JSON.stringify(json_data),
		success: function(data){
		},
		complete: function(xhr, ts){
			var data=eval("("+xhr.responseText+")");
			var result=data["result_code"];
			var token=data["token"];
			if(result=="0"){
				$.cookie('token',token);
				window.location.href = "punch.html";
			}else{
				alert("ユーザー名とパスワードを確認してください");
			}
		},
		error: function(data, textStatus, errorThrown){
			 alert(data + textStatus + errorThrown);
	  }
	});
}