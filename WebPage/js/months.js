// 画面初期化時
$(function(){
	var SEARCH_YEAR;
	var SEARCH_MONTH;
	TOKEN=$.cookie('token');
	getSysdate();
	getMonths();
	
	$("#pre_date").on("click",function(){
		preDate();
	});
	
	$("#next_date").on("click",function(){
		nextDate();
	});
});

// 先月の勤務時間
function preDate(){
	if(SEARCH_MONTH==1){
		SEARCH_MONTH=12;
		SEARCH_YEAR=SEARCH_YEAR-1;
	}else{
		SEARCH_MONTH=SEARCH_MONTH-1;
	}
	$("#my-ajax-table tr:not(:first)").remove(); 
	getMonths();
}

// 来月の勤務時間
function nextDate(){
	if(SEARCH_MONTH==12){
		SEARCH_MONTH=1;
		SEARCH_YEAR=SEARCH_YEAR+1;
	}else{
		SEARCH_MONTH=SEARCH_MONTH+1;
	}
	$("#my-ajax-table tr:not(:first)").remove(); 
	getMonths();
}

// システムデート取得
function getSysdate(){
	var dateObj = new Date();
	SEARCH_YEAR = dateObj.getFullYear();
	SEARCH_MONTH = dateObj.getMonth() + 1;
}

function BasicAuthorizationCode(username, password){
	var safeStr = unescape(encodeURIComponent(username + ':' + password));
	var btoaCode = btoa(safeStr);
	return 'Basic ' + btoaCode;
};

// 勤務時間取得
function getMonths(){
	$("#now_date").text(SEARCH_YEAR + "年" + SEARCH_MONTH + "月"); 
	var json_data={"enterprise_id":"MAE0001","search_year":SEARCH_YEAR,"search_month":SEARCH_MONTH};
	$.ajax({
		url: "http://54.199.240.10/api/MAS0000040",
		type: 'post',
		contentType: "application/json; charset=utf-8",
		beforeSend: function (xhr) {
			xhr.setRequestHeader ('Authorization', BasicAuthorizationCode(TOKEN, ''));
		},
		data:JSON.stringify(json_data),
		success: function(data){
			if(data["result_code"]=="0"){
				$.each(data["monthly_work_time_list"],function(index,item){
					var dataTr = "<tr><td>"+item["work_date"]+"</td><td>"+item["which_day"]+"</td><td>"+item["report_start_time"]+"</td><td>"+item["report_end_time"]+"</td><td>"+item["report_exclusive_minutes"]+"</td><td>"+item["report_total_minutes"]+"</td></tr>"; 
					$("#my-ajax-table").append(dataTr);
				});
				$("#total_hours").text("合計 " + data["total_hours"]);
			}
		},
		complete: function(xhr, ts){
		},
		error: function(data, textStatus, errorThrown){
			 alert(data + textStatus + errorThrown);
		}
	});
}

