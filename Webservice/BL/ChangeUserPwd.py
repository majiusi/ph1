# -*- coding: utf-8 -*-
# !/usr/bin/env python
###################################
# description: パスワード更新
# author: Yaochenxu
# date: 2016/10/22
###################################
import logging, datetime
from flask import Flask, request, jsonify, g

# initialization
app = Flask(__name__)
app.config.from_object('config')
logger = logging.getLogger('MaiaService.BL.ChangeUserPwd')


###################################
# -description: 社員用パスワード更新
# -author: Yaochenxu
# -date: 2016/10/22
###################################
def change_password_for_employee():
    from Entity import DBTransaction, Users
    logger.info('change_user_password() start.')
    try:
        # 入力値取得
        new_pwd1 = request.json.get('new_pwd1')
        new_pwd2 = request.json.get('new_pwd2')

        # 入力値検証
        if new_pwd1 is None or new_pwd2 is None or new_pwd1 != new_pwd2:
            logger.error('入力検証エラー')
            return jsonify({'result_code': -1})

        user = Users.User.query.filter_by(
            enterprise_id=g.user.enterprise_id, name=g.user.name).first()
        if user is None:
            logger.error('ユーザ存在しない')
            return jsonify({'result_code': -2})

        # パスワード更新
        user.hash_password(new_pwd1)
        user.update_by = g.user.name
        user.update_at = datetime.datetime.now()
        user.update_cnt += 1
        # 新パスワードのコミット
        DBTransaction.session_commit()

        logger.info('change_user_password() end.')
        return jsonify({'result_code': 0})
    except Exception, e:
        logger.error(e)
        return jsonify({'result_code': -9})
    finally:
        DBTransaction.session_close()


###################################
# -description: 管理者用パスワード更新
# -author: Yaochenxu
# -date: 2016/10/22
###################################
def change_password_for_Manager():
    from Entity import DBTransaction, Users
    logger.info('change_password_for_Manager() start.')
    try:
        # 入力値取得
        user_name_for_changed = request.json.get('user_name_for_changed')
        new_pwd1 = request.json.get('new_pwd1')
        new_pwd2 = request.json.get('new_pwd2')

        # 入力値検証
        if new_pwd1 is None or new_pwd2 is None or new_pwd1 != new_pwd2:
            logger.error('入力検証エラー')
            return jsonify({'result_code': -1})

        user = Users.User.query.filter_by(
            enterprise_id=g.user.enterprise_id, name=user_name_for_changed).first()
        if user is None:
            logger.error('ユーザ存在しない')
            return jsonify({'result_code': -2})

        # !! 権限決めてから修正要、################
        if g.user.auth_id != '2' and g.user.auth_id != '3':
            logger.error('権限たりない')
            return jsonify({'result_code': -3})

        # パスワード更新
        user.hash_password(new_pwd1)
        user.update_by = g.user.name
        user.update_at = datetime.datetime.now()
        user.update_cnt += 1
        # 新パスワードのコミット
        DBTransaction.session_commit()

        logger.info('change_password_for_Manager() end.')
        return jsonify({'result_code': 0})
    except Exception, e:
        logger.error(e)
        return jsonify({'result_code': -9})
    finally:
        DBTransaction.session_close()
