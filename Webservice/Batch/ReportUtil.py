# -*- coding: utf-8 -*-
# !/usr/bin/env python
###################################
#description: レポート情報処理
#author: Kyoku
#date: 2017/7/23
###################################

import os
import datetime

###################################
#getFilePath:出力ファイルパスの取得
#parameter
#    name      :ユーザー名
#    dispatchId:派遣ID
#    years     :年月(yyyyMM)
#    status    :ステータス(0:社内用／1:社外用)
###################################
def getReportPath(name, dispatchId, years, status):
    if(status == 0):
        path = u'/home/maiasoft/maiaReport/internal/' + str(years)
    else:
        path = u'/home/maiasoft/maiaReport/external/' + str(years)
    path=path.strip()
    path=path.rstrip("/")
    isExists=os.path.exists(path)
    if not isExists:
        os.makedirs(path)
    path = path + u'/' + dispatchId + u'_' + name + u'_' + str(years) + u'.xls'
    return path

###################################
#description:前月の年月(yyyyMM)・前月を返す
#parameter
#    years:前月の年月(yyyyMM)
#return
#    lastonth:月前月
###################################
def getLastmonth(years):
    date = datetime.datetime.now()
    # 前月取得
    lastmonth = date.month - 1
    # 前月取得
    years = date.year + "%02d" % int(lastmonth) 
    # 戻り値
    return years, lastmonth