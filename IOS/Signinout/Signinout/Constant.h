//
//  Constant.h
//  Signinout
//
//  Created by yaochenxu on 2017/3/23.
//  Copyright © 2017年 Yaochenxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "UICustomActionSheet.h"

/** サービスの利用ができません。 */
static NSString* const CONST_SERVICE_NOT_AVAILABLE = @"サービスの利用ができません。";
/** チームID、ユーザID、パスワード不正 */
static NSString* const CONST_LOGIN_FAIL_MSG = @"入力された情報が不正です。";

/** パスワードの変更に失敗しました。 */
static NSString* const CONST_PASSWORD_UPDATE_ERROR_TITLE = @"パスワードの変更に失敗しました。";
/** 入力値を確認してください。 */
static NSString* const CONST_PASSWORD_UPDATE_ERROR_MSG = @"入力値を確認してください。";
/** 【ユーザ存在しない】：ユーザ情報異常、再ログインしてください。 */
static NSString* const CONST_PASSWORD_UPDATE_USER_NOT_EXSIST_MSG = @"ユーザ情報異常、再ログインしてください。";
/** パスワードの変更は異常になりました */
static NSString* const CONST_USER_NOT_EXSIST_MSG = @"パスワードの変更は異常になりました。";
/** パスワードが変更されました。 */
static NSString* const CONST_PASSWORD_UPDATE_SUCCESSED_MSG = @"パスワードが変更されました。";
/** 合計負数　提出不可 */
static NSString* const CONST_REPORT_CANNOT_UPDATE_MSG = @"合計負数(提出不可)";
/** 更新 */
static NSString* const CONST_REPORT_UPDATE_BTN = @"更新";
/** 提出 */
static NSString* const CONST_REPORT_SUBMIT_BTN = @"提出";
/** 閉じる */
static NSString* const CONST_CLOSE_BTN = @"閉じる";
/** 削除 */
static NSString* const CONST_DELETE_BTN = @"削除";
/** 出勤情報が更新されました。 */
static NSString* const CONST_REPORT_UPDATED_MSG = @"出勤情報が更新されました。 ";
/** 出勤情報が削除されました。 */
static NSString* const CONST_REPORT_DELETE_MSG = @"出勤情報が削除されました。 ";

/////////////////////////////////////PunchViewController

/** 位置情報の取得に失敗しました。 */
static NSString* const CONST_LOCATION_INTELLIGENCE_FAILURE = @"位置情報の取得に失敗しました。";
/** 社員基本情報の取得に失敗しました。 */
static NSString* const CONST_GET_EMPLOYEE_BASEINFO_ERROR = @"社員基本情報の取得に失敗しました。";
/** 社員月間情報の取得に失敗しました。 */
static NSString* const CONST_GET_EMPLOYEE_MONTHLY_INFO_ERROR = @"社員月間情報の取得に失敗しました。";
/** 表示画面の取得に失敗しました。 */
static NSString* const CONST_GET_PAGE_FLAG_ERROR = @"表示画面の取得に失敗しました。";
/** 出勤開始時間の提出に失敗しました。 */
static NSString* const CONST_SUBMIT_WORKSTART_INFO_ERROR = @"出勤開始時間の提出に失敗しました。";
/** 出勤終了時間の提出に失敗しました。 */
static NSString* const CONST_SUBMIT_WORKEND_INFO_ERROR = @"出勤終了時間の提出に失敗しました。";
/** 勤務レポートの提出に失敗しました。 */
static NSString* const CONST_SUBMIT_REPORT_INFO_ERROR = @"勤務レポートの提出に失敗しました。";
/** ＜      開始：%@      ＞ */
static NSString* const CONST_START_FORMAT = @"＜      開始：%@      ＞";
/** ＜      終了：%@      ＞ */
static NSString* const CONST_END_FORMAT = @"＜      終了：%@      ＞";
/** ＜      控除：%@(分)      ＞ */
static NSString* const CONST_EXCEPT_FORMAT = @"＜      控除：%@(分)      ＞";
/** ＜      控除：%@      ＞ */
static NSString* const CONST_EXCEPT_FORMAT_2 = @"＜      控除：%@      ＞";
/** ＜      控除：%02d:%02d      ＞ */
static NSString* const CONST_EXCEPT_FORMAT_3 = @"＜      控除：%02d:%02d      ＞";
/** ＜      合計：%.1f(時間)      ＞ */
static NSString* const CONST_TOTAL_TIME_FORMAT = @"＜      合計：%.2f(時間)      ＞";
/** 合計：%02d：%02d */
static NSString* const CONST_TOTAL_TIME_FORMAT_2 = @"合計：%02d：%02d";
/** 名前%@　　出勤合計：%.2f時間 */
static NSString* const CONST_NAME_AND_TOTAL_WORK_TIME_FORMAT = @"%@　　出勤合計：%.2f時間";
/** 位置情報取得中・・・ */
static NSString* const CONST_POSITION_INFO_MSG = @"提出不可（位置情報なし）";
/** 変更の出勤日：%@ */
static NSString* const CONST_WORK_INFO_EDIT_DATE_FORMAT = @"          変更の出勤日：%@";

/** 更新失敗 */
static NSString* const CONST_CHANGE_WORK_REPORT_FAIL_TITLE = @"更新失敗";
/** 出勤情報の更新に失敗しました。 */
static NSString* const CONST_CHANGE_WORK_REPORT_FAIL_MSG = @"出勤情報の更新に失敗しました。";
/** 未来日の更新ができません。 */
static NSString* const CONST_CHANGE_FUTURE_DATE_MSG = @"未来日の更新ができません。";
/** 利用者は当月しか更新できません。 */
static NSString* const CONST_CHANGE_NOT_CURRENT_MONTH_MSG = @"利用者は当月しか更新できません。";

/** 削除失敗 */
static NSString* const CONST_DELETE_WORK_REPORT_FAIL_TITLE = @"削除失敗";
/** 出勤情報の削除に失敗しました。 */
static NSString* const CONST_DELETE_WORK_REPORT_FAIL_MSG = @"出勤情報の削除に失敗しました。";
/** 未来日の削除ができません。 */
static NSString* const CONST_DELETE_FUTURE_DATE_MSG = @"未来日の削除ができません。";
/** 利用者は当月しか削除できません。 */
static NSString* const CONST_DELETE_NOT_CURRENT_MONTH_MSG = @"利用者は当月しか削除できません。";

/** メール送信機能がサポートされていません。 */
static NSString* const CONST_MAIL_SEND_UNSUPPORTED_MSG = @"メール送信機能がサポートされていません。";
/** メールアカウントが設定されていません。 */
static NSString* const CONST_MAIL_ACCOUNT_NULL_MSG = @"メールアカウントが設定されていません。";
/** メールタイトル */
static NSString* const CONST_MAIL_TITLE = @"【パスワード初期化申し込み】";
/** メール本文 */
static NSString* const CONST_MAIL_CONTEXT = @"ご担当者様\n\n \
チームID：xxxxxxx\n \
ユーザID：xxxxxxxxx\n \
社員氏名：○○　○○のパスワードのリセットをお願いします。\n\n \
以上\n \
※パスワードが登録のメールに送信されます。";


/** メッセージ表示ダイアログ */
#define SHOW_MSG_OLD(TITLE, MESSAGE, QUVC) UIAlertController *alert = [UIAlertController alertControllerWithTitle:TITLE message:MESSAGE preferredStyle: UIAlertControllerStyleActionSheet]; \
    [alert addAction:[UIAlertAction actionWithTitle:@"閉じる" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) { }]]; \
    [QUVC presentViewController:alert animated:true completion:nil];


#define SHOW_MSG_STYLE(TITLE, MESSAGE) UICustomActionSheet* actionSheet = [[UICustomActionSheet alloc] initWithTitle:TITLE delegate:nil buttonTitles:@[CONST_CLOSE_BTN]];  \
    [actionSheet setSubtitle:MESSAGE]; \
    [actionSheet setExclusiveTouch:YES]; \
    [actionSheet setButtonColors:@[[UIColor redColor]]]; \
    [actionSheet setBackgroundColor:[UIColor clearColor]]; \
    [actionSheet setSubtitleColor:[UIColor whiteColor]]; \
    [actionSheet showInView:self.view ];


/** プロセスダイアログの表示 */
#define SHOW_PROGRESS(QUVC) MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:QUVC animated:YES]; \
    /* Set the label text. */  \
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title"); 
    /* You can also adjust other label properties if needed. */
    /* hud.label.font = [UIFont italicSystemFontOfSize:16.f]; */
/*    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{ \
         Simulate by just waiting. \
        sleep(3.); \
        dispatch_async(dispatch_get_main_queue(), ^{ \
            [hud hideAnimated:YES]; \
        });  \
    });
*/

/** プロセスダイアログの表示非表示 */
#define HIDE_PROGRESS [hud hideAnimated:YES];
#define RESHOW_PROGRESS [hud showAnimated:YES];
