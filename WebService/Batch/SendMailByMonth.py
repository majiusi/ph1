# -*- coding: utf-8 -*-
# !/usr/bin/env python
###################################
#description: メール送信処理（月次実行）
#             毎月の月初ごとに一度実行し、
#             前月分の勤務レポートを送信する。
#author: Kyoku
#date: 2017/07/30
###################################

import datetime
#from Utility.MailUtil import mail
#from Utility import MailUtil
import MailUtil

from DBTransactionBatch import DBSession

###################################
#description:送信処理
###################################
def sendMail():
    # 勤務年
    year = datetime.datetime.now().year
    # 前月の勤務月
    month = datetime.datetime.now().month - 1
    
    # セッション作成
    dbSession = DBSession()
    try:
        dbSession.session_open()
    except Exception:
        print u'データベース接続に失敗しました。'
        return
    
    # メールサーバー接続
    sendMail = MailUtil.mail()
    try:
        sendMail.smtpOpen()
    except Exception:
        print u'メールサーバ接続に失敗しました。'
        return
    
    # メール宛先情報取得
    lines = dbSession.getDispatchesInfo()  #(employeeId = 'MA00011')#test save
    for line in lines:
        try:
            # メール送信を行う
            msg = sendMail.getMsgAttach(line[1], line[2], line[3], year, month)
            sendMail.sendMail(msg)
        except Exception as ex:
            print('Failed to send -> %s : {0}' % line[1])
            print('exception -> sendMail : {0}'.format(ex))
    
    # メールサーバー停止
    try:
        sendMail.smtpClose()
    except Exception:
        print u'メールサーバ停止に失敗しました。'
        
###################################
#description:__main__
###################################
if(__name__=="__main__"):
    sendMail()

