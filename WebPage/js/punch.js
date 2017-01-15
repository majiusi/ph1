// 画面初期化時
$(function(){
	TOKEN=$.cookie('token');
	getPageFlag();
	getNameJP();
	getWorkTime();
	getSysDate();
	getLoaction();

	// bindClick
	$("#startWork").click(startWork());
	$("#endWork").click(endWork());
});

function initPage(pageFlag){
	switch(pageFlag)
	{
		case 1:
		  $("#punch3").show();
		  break;
		case 2:
		  $("#punch2").show();
		  break;
		case 3:
		  $("#punch3").show();
		  break;
		case 4:
		  $("#punch4").show();
		  break;
		default:
		  alert(pageFlag);
	}
}

function BasicAuthorizationCode(username, password){
	var safeStr = unescape(encodeURIComponent(username + ':' + password));
	var btoaCode = btoa(safeStr);
	return 'Basic ' + btoaCode;
};

// 日付表示
function getSysDate(){
		var seperator1 = "-";
		var seperator2 = ":";
		var seperator3 = " ";
		// Dateオブジェクトを作成
		var dateObj = new Date();
		var year = dateObj.getFullYear();
		var mouth = dateObj.getMonth() + 1;
		var date = dateObj.getDate();

		// 曜日の表記
		var weekDayList = [ "日", "月", "火", "水", "木", "金", "土" ];
		var day = weekDayList[dateObj.getDay()] + "曜日" ;

		//日付の表記
		var currentDate = year + seperator1 + mouth + seperator1 + date;
		$("#sysDate").text( day + seperator3 + currentDate);

		// 時間の表記
		var hours=dateObj.getHours();
		var minutes=dateObj.getMinutes();
		var dn="AM";
		if (hours>12){
			dn="PM";
			hours=hours-12;
		}
		if (hours==0)
			hours=12;
		if (minutes<=9)
			minutes="0"+minutes;
		var ctime=dn + seperator3 + hours + seperator2 + minutes;
		$("#sysTime").text(ctime);

}

// 初期状態
function getPageFlag(){
	var json_data={"enterprise_id":"MAE0001"};
	$.ajax({
		url: "http://54.199.240.10/api/MAS0000020",
		type: 'post',
		contentType: "application/json; charset=utf-8",
		beforeSend: function (xhr) {
			xhr.setRequestHeader ('Authorization', BasicAuthorizationCode(TOKEN, ''));
		},
		data:JSON.stringify(json_data),
		success: function(data){
		},
		complete: function(xhr, ts){
			var data=eval("("+xhr.responseText+")");
			var pageFlag=data["page_flag"];
			initPage(pageFlag);
		},
		error: function(data, textStatus, errorThrown){
			 alert(data + textStatus + errorThrown);
	  }
	});
}

// 名前表示
function getNameJP(){
	var json_data={"enterprise_id":"MAE0001"};
	$.ajax({
		url: "http://54.199.240.10/api/MAS0000030",
		type: 'post',
		contentType: "application/json; charset=utf-8",
		beforeSend: function (xhr) {
			xhr.setRequestHeader ('Authorization', BasicAuthorizationCode(TOKEN, ''));
		},
		data:JSON.stringify(json_data),
		success: function(data){
		},
		complete: function(xhr, ts){
			var data=eval("("+xhr.responseText+")");
			$("#userName").text(data["name_jp"]);
		},
		error: function(data, textStatus, errorThrown){
			 alert(data + textStatus + errorThrown);
	  }
	});
}

// 出勤時間表示
function getWorkTime(){
	var json_data={"enterprise_id":"MAE0001"};
	$.ajax({
		url: "http://54.199.240.10/api/MAS0000040",
		type: 'post',
		contentType: "application/json; charset=utf-8",
		beforeSend: function (xhr) {
			xhr.setRequestHeader ('Authorization', BasicAuthorizationCode(TOKEN, ''));
		},
		data:JSON.stringify(json_data),
		success: function(data){
		},
		complete: function(xhr, ts){
			var data=eval("("+xhr.responseText+")");
			$("#totalDays").text(data["total_days"] + "日");
			$("#totalHours").text(data["total_hours"]　+ "時間");

		},
		error: function(data, textStatus, errorThrown){
			 alert(data + textStatus + errorThrown);
	  }
	});
}

// パンチ開始
function startWork(){
	var json_data={"enterprise_id":"MAE0001","start_longitude":gpsLat,"start_latitude":gpsLng,"start_spot_name":"TmpLocationName"};
	$.ajax({
		url: "http://54.199.240.10/api/MAS0000050",
		type: 'post',
		contentType: "application/json; charset=utf-8",
		beforeSend: function (xhr) {
			xhr.setRequestHeader ('Authorization', BasicAuthorizationCode(TOKEN, ''));
		},
		data:JSON.stringify(json_data),
		success: function(data){
		},
		complete: function(xhr, ts){
			var data=eval("("+xhr.responseText+")");
			var resultCode=data["result_code"];
			alert("result_code:"+resultCode);
		},
		error: function(data, textStatus, errorThrown){
			 alert(data + textStatus + errorThrown);
	  }
	});
}

// パンチ終了
function endWork(){
	var json_data={"enterprise_id":"MAE0001","end_longitude":gpsLat,"end_latitude":gpsLng,"end_spot_name":"TmpLocationName"};
	$.ajax({
		url: "http://54.199.240.10/api/MAS0000060",
		type: 'post',
		contentType: "application/json; charset=utf-8",
		beforeSend: function (xhr) {
			xhr.setRequestHeader ('Authorization', BasicAuthorizationCode(TOKEN, ''));
		},
		data:JSON.stringify(json_data),
		success: function(data){
		},
		complete: function(xhr, ts){
			var data=eval("("+xhr.responseText+")");
			var resultCode=data["result_code"];
			alert("result_code:"+resultCode);
		},
		error: function(data, textStatus, errorThrown){
			 alert(data + textStatus + errorThrown);
	  }
	});
}

// 地域情報表示
function getLoaction(){
	// ユーザーの端末がGeoLocation APIに対応しているかの判定

	// 対応している場合
	if( navigator.geolocation )
	{
		// 現在地を取得
		navigator.geolocation.getCurrentPosition(

			// [第1引数] 取得に成功した場合の関数
			function( position )
			{
				gpsLat = position.coords.latitude;
				gpsLng = position.coords.longitude;
				gmap_init(gpsLat,gpsLng);
			},

			// [第2引数] 取得に失敗した場合の関数
			function( error )
			{
				// エラーコード(error.code)の番号
				// 0:UNKNOWN_ERROR				原因不明のエラー
				// 1:PERMISSION_DENIED			利用者が位置情報の取得を許可しなかった
				// 2:POSITION_UNAVAILABLE		電波状況などで位置情報が取得できなかった
				// 3:TIMEOUT					位置情報の取得に時間がかかり過ぎた…

				// エラー番号に対応したメッセージ
				var errorInfo = [
					"原因不明のエラーが発生しました…。" ,
					"位置情報の取得が許可されませんでした…。" ,
					"電波状況などで位置情報が取得できませんでした…。" ,
					"位置情報の取得に時間がかかり過ぎてタイムアウトしました…。"
				] ;

				// エラー番号
				var errorNo = error.code ;

				// エラーメッセージ
				var errorMessage = "[エラー番号: " + errorNo + "]\n" + errorInfo[ errorNo ] ;

				// アラート表示
				alert( errorMessage ) ;
			}
		) ;
	}
	// 対応していない場合
	else
	{
		// エラーメッセージ
		var errorMessage = "お使いの端末は、GeoLacation APIに対応していません。" ;

		// アラート表示
		alert( errorMessage ) ;
	}
}

// googlemap init
function gmap_init(gpsLat,gpsLng) {
	geocoder = new google.maps.Geocoder();
	var latlng = new google.maps.LatLng(gpsLat,gpsLng);

	geocoder.geocode({'latLng':latlng},function(results,status){
		if (status == google.maps.GeocoderStatus.OK) {
			console.log(results[1].address);
			$("#location").text(results[2].formatted_address);
		} else {
			console.log(status);
		}
	});
}
