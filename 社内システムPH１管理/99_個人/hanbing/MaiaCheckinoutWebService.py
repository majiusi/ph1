# -*- coding: utf-8 -*-
<<<<<<< HEAD
#!/usr/bin/env python
from flask import Flask, abort, request, jsonify, g, url_for, make_response
=======
# !/usr/bin/env python
from flask import Flask, jsonify, make_response
>>>>>>> origin/master
from flask_httpauth import HTTPBasicAuth
from Utility import *
from BL import *

# initialization
app = Flask(__name__)
app.config.from_object('config')

# extensions
auth = HTTPBasicAuth()

# authentication callback method
@auth.verify_password
def verify_password(username_or_token, password):
    isPassed = UserAuth.LonginAuth.verify_password(username_or_token, password)
    return isPassed

@auth.error_handler
def unauthorized():
    return make_response(jsonify({'result_code':-1 }), 403)

####################################################################
# WebService　URI声明（BL ロジック呼出し開始）
####################################################################

########################################################
# 社員用 Service
################

# ログイン認証を行い、トーケンを戻す
@app.route('/api/MAS0000010')
@auth.login_required
def get_auth_token():
    # トーケン有効期間ディフォルト一年
    token = UserAuth.LonginAuth.generate_auth_token()
    return jsonify({'result_code':0, 'token': token.decode('ascii'), 'duration': 60*60*24*365})

# 画面表示フラグ取得
@app.route('/api/MAS0000020')
@auth.login_required
def get_next_page_flag():
    return GetNextPageFlag.get_next_page_flag()

# 社員＆勤務基本情報取得
@app.route('/api/MAS0000030')
@auth.login_required
def get_employee_info():
    return GetEmployeeInfo.get_employee_info()

# 月間勤務情報取得
@app.route('/api/MAS0000040')
@auth.login_required
def get_attendance_info_by_year_month():
    return GetAttendanceInfo.get_attendance_info_by_year_month()

# パンチ開始情報submit
@app.route('/api/MAS0000050', methods=['POST'])
@auth.login_required
def insert_attendance_work_start_info():
    return ModifyAttendanceInfo.insert_attendance_work_start_info()

# パンチ終了情報submit
@app.route('/api/MAS0000060', methods=['POST'])
@auth.login_required
def update_attendance_work_end_info():
    return ModifyAttendanceInfo.update_attendance_work_end_info()

# レポート出勤情報submit
@app.route('/api/MAS0000070', methods=['POST'])
@auth.login_required
def update_attendance_report_info():
    return ModifyAttendanceInfo.update_attendance_report_info()

<<<<<<< HEAD
=======

# レポート出勤情報更新
@app.route('/api/MAS0000071', methods=['POST'])
@auth.login_required
def update_attendance_report_info_by_date():
    return ModifyAttendanceInfo.update_attendance_report_info_by_date()


>>>>>>> origin/master
# パスワード更新(社員用)
@app.route('/api/MAS0000080', methods=['POST'])
@auth.login_required
def change_password_for_employee():
    return ChangeUserPwd.change_password_for_employee()


########################################################
# 管理者用 Service
################
# パスワード更新(管理者用)
@app.route('/api/MAS1000010', methods=['POST'])
@auth.login_required
def change_password_for_manager():
    return ChangeUserPwd.change_password_for_manager()


# ユーザー新規登録
@app.route('/api/MAS1000020', methods=['POST'])
@auth.login_required
def new_user():
    return CreateUser.create_user()


# ユーザー勤務一覧取得
@app.route('/api/MAS1000030', methods=['GET'])
@auth.login_required
def get_attendance_list():
    return GetUserListInfo.get_user_list_info_by_section_month_state()


####################################################################
# WebService　URI声明（BL ロジック呼出し終了）
####################################################################

########################################test############################

if __name__ == '__main__':
    app.run()

    #app.run(host='0.0.0.0',port=8008)
    #app.run(host='0.0.0.0',port=808,debug=True)

