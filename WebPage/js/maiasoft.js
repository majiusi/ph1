// »­Ãæ³õÆÚ»¯•r
$(function(){
	$("#login").bind("click",onLogin); 
});

functionBasicAuthorizationCode(username, password){
	var safeStr = unescape(encodeURIComponent(username + ':' + password));
	var btoaCode = btoa(safeStr);
	return 'Basic ' + btoaCode;
};


function onLogin() { 
	var username = $("#userName").text;
	var password = $("#userPassword").text;
	
	var json_data={"enterprise_id":"MAE0001"};
	$.ajax({
		url: "http://54.199.240.10/api/MAS0000010",
		type: 'post',
		contentType: "application/json; charset=utf-8",
		beforeSend: function (xhr) {
			xhr.setRequestHeader ('Authorization', BasicAuthorizationCode(username, password));
		},
		data:JSON.stringify(json_data),
		success: function(data){
			alert("data:" + data);
		},
		complete: function(xhr, ts){
			alert(xhr.status);
			alert(xhr.responseText);
		},
		error: function(data, textStatus, errorThrown){
			 alert(data + textStatus + errorThrown);
	  }
	});
}