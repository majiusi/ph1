# _*_ coding: utf-8 _*_
#!/usr/bin/env python
from flask import Flask, abort, request, jsonify, g, url_for, make_response
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
    token = UserAuth.LonginAuth.generate_auth_token(600)
    return jsonify({'result_code':0, 'token': token.decode('ascii'), 'duration': 600})

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

# パスワード更新(社員用)
@app.route('/api/MAS0000080', methods=['POST'])
@auth.login_required
def change_password_for_employee():
    return ChangeUserPwd.change_password_for_employee()


########################################################
# 管理者用 Service
################
# パスワード更新()
@app.route('/api/MAS1000010', methods=['POST'])
@auth.login_required
def change_password_for_Manager():
    return ChangeUserPwd.change_password_for_Manager()
    

@app.route('/api/users/<int:id>')
def get_user(id):
    user = User.query.get(id)
    if not user:
        abort(400)
    return jsonify({'username': user.username})

@app.route('/api/persional_labor_time_list')
def get_persional_labour_time_list():
    return GetUserLaborList.get_persional_labour_time_list()


@app.route('/api/resource')
@auth.login_required
def get_resource():
    return jsonify({'data': 'Hello, %s!' % g.user.username})

# ユーザー新規登録
@app.route('/api/create_user', methods=['POST'])
@auth.login_required
def new_user():
    return CreateUser.create_user()
####################################################################
# WebService　URI声明（BL ロジック呼出し終了）
####################################################################

########################################test############################

if __name__ == '__main__':
    app.run()

    #app.run(host='0.0.0.0',port=8008)
    #app.run(host='0.0.0.0',port=808,debug=True)

