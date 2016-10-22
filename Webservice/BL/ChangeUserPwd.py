# _*_ coding: utf-8 _*_
#!/usr/bin/env python
###################################
#description: パスワード更新
#author: Yaochenxu
#date: 2016/10/22
###################################
import logging, datetime
from Entity import Users
from flask import Flask, request, jsonify, g

# initialization
app = Flask(__name__)
app.config.from_object('config')
logger = logging.getLogger('MaiaService.BL.ChangeUserPwd')

###################################
#-description: 社員用パスワード更新
#-author: Yaochenxu
#-date: 2016/10/22
###################################
def change_password_for_employee():
    logger.info('change_user_password() start.')
    try:
        # 入力値取得
        new_pwd1 = request.json.get('new_pwd1')
        new_pwd2 = request.json.get('new_pwd2')

        # 入力値検証
        if new_pwd1 is None or new_pwd2 is None:
            logger.error('入力検証エラー')
            return (jsonify({'result_code':-1}))

        user = Users.User.query.filter_by(name=g.user.name).first()
        if user is None:
            logger.error('ユーザ存在しない')
            return  (jsonify({'result_code':-1}))

        # パスワード更新
        user.hash_password(new_pwd1)
        user.update_by = g.user.name
        user.update_at = datetime.datetime.now()
        user.update_user()

        logger.info('change_user_password() end.')
        return (jsonify({'result_code':0 }))
    except Exception, e:
        logger.error(e)
        return (jsonify({'result_code':-1 }))

###################################
#-description: 管理者用パスワード更新
#-author: Yaochenxu
#-date: 2016/10/22
###################################
def change_password_for_Manager():
    logger.info('change_password_for_Manager() start.')
    try:
        # 入力値取得
        user_name_for_changed = request.json.get('user_name_for_changed')
        new_pwd1 = request.json.get('new_pwd1')
        new_pwd2 = request.json.get('new_pwd2')

        # 入力値検証
        if new_pwd1 is None or new_pwd2 is None:
            logger.error('入力検証エラー')
            return (jsonify({'result_code':-1}))

        user = Users.User.query.filter_by(name=user_name_for_changed).first()
        if user is None:
            logger.error('ユーザ存在しない')
            return  (jsonify({'result_code':-1}))

        
        # !! 権限決めてから修正要、################
        if g.user.auth_id != '2' and g.user.auth_id != '3':
            logger.error('権限たりない')
            return  (jsonify({'result_code':-1}))

        # パスワード更新
        user.hash_password(new_pwd1)
        user.update_by = g.user.name
        user.update_at = datetime.datetime.now()
        user.update_cnt = user.update_cnt + 1
        user.update_user()

        logger.info('change_password_for_Manager() end.')
        return (jsonify({'result_code':0 }))
    except Exception, e:
        logger.error(e)
        return (jsonify({'result_code':-1 }))

