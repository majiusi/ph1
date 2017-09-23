# -*- coding: utf-8 -*-
# !/usr/bin/env python
###################################
#description: 勤務表出力_Excel
#author: Kyoku
#date: 2016/11/14
###################################

#from __future__ import division 

import logging
import xlrd
import datetime
#import time
import os
from xlutils.copy import copy
from flask import Flask, jsonify, g
from DBTransactionBatch import DBSession

# initialization
app = Flask(__name__)
#app.config.from_object('config')
logger = logging.getLogger('MaiaService.Batch.MakeWorkbook')

# 派遣ID -> global
_dispatchId = ''

###################################
#WorksheetToExcel:勤務表出力
#parameter
#    enterpriseId(必須):企業ID
#    dispatchId(必須):派遣ID
#    customerId:社員ID
#    _year(必須):年
#    _month(必須):月
###################################
def WorksheetToExcel(enterpriseId, dispatchId, customerId, _year_, _month_):
    logger.info('logger output start........')
    
    global _dispatchId
    global inPath
    global exPath
    global smaillist

    # 入力引数チェック
    if(len(str(enterpriseId)) <= 0 
       or len(str(dispatchId)) <= 0 
       or len(str(_year_)) <= 0 
       or len(str(_month_)) <= 0):
        print u'入力引数の設定にエラーが発生しました。'
        print u'企業ID:' + enterpriseId
        print u'派遣ID:' + dispatchId
        print u'勤務年:' + _year_
        print u'勤務月:' + _month_
        return
    
    _dispatchId = dispatchId
    
    if(len(customerId) > 0):
        print u'勤務情報出力開始_社員_' + customerId + u':' + str(datetime.datetime.now())
    
    # 勤務年の設定
    iYear = str(_year_)
    # 勤務月の設定
    iMonth = "%02d" % int(_month_)
    
    # セッション作成
    dbSession = DBSession()
        
    try:
        dbSession.session_open()
    except Exception:
        dbSession.session_close()
        print u'データベース接続に失敗しました。'
    
    # 社員情報取得
    lines = dbSession.getEmployeesInfo(customerId)
    #print (u'社员情报取得件数:' + str(len(lines)), str(customerId))

    for line in lines:
        # 派遣情報取得
        # 1レコードのみ取得想定
        ## line[1] : 社員ID（employee_id）
        dspclines = dbSession.getAttendancesInfo(enterpriseId, dispatchId, line[1], iYear + iMonth)
        #print u'派遣信息取得件数:' + str(len(dspclines))
        #if(len(dspclines) <= 0):
            #print u'パラメータ：'+enterpriseId+u'-'+dispatchId+u'-'+line[1]+u'-'+iYear+u'-'+iMonth
        
        if(len(dspclines) > 0):
            # Excel出力処理呼出
            # 内部勤務表出力
            # line[5] : 社員名（name_jp）
            inPath = _internal_creat_excel(dspclines, int(iYear), int(iMonth), line[5])

            # 外部勤務表出力
            # line[5] : 社員名（name_jp）
            exPath = _external_creat_excel(dspclines, int(iYear), int(iMonth), line[5])

    #セッションクローズ
    dbSession.session_close()

    if(len(customerId) > 0):
        print u'勤務情報出力終了_社員_' + customerId + ':' + str(datetime.datetime.now())

# 外部Excel出力
def _external_creat_excel(lines, iYear, iMonth, user_name):
    print 'externalCreatExcel() - start'
    print '    --output user:' + user_name
    
    #global
    global fileName

    #excel open
    inWorkbook = xlrd.open_workbook(_get_template_file_path(1), formatting_info=True);
    
    #copy inWorkbook to outWorkbook
    outWorkbook = copy(inWorkbook);
    
    outSheet = outWorkbook.get_sheet(0)
    
    #################
    #平常勤務
    #################
    #開始時[K1(10,0)]
    _set_out_cell(outSheet, 10, 0, lines[0][0][0:2])
    #開始分[M1(12,0)]
    _set_out_cell(outSheet, 12, 0, lines[0][0][3:5])
    #終了時[P1:(15,0)]
    _set_out_cell(outSheet, 15, 0, lines[0][1][0:2])
    #終了分[R1:(17,0)]
    _set_out_cell(outSheet, 17, 0, lines[0][1][3:5])
    #休憩[K2:(10,1)]
    _set_out_cell(outSheet, 10, 1, lines[0][2])
    #所属会社[C6:(2,5)]
    _set_out_cell(outSheet, 2, 5, lines[0][3])
    #チーム名[C7:(2,6)]
    _set_out_cell(outSheet, 2, 6, lines[0][4])
    #氏名[I7:(8,6)]
    _set_out_cell(outSheet, 8, 6, user_name)
    #合計設定用
    totalMinutes = 0.0
    #################
    #作業明細表の各項目の設定
    #################
    #日数取得
    days = _get_days(iYear, iMonth)
    #days = int(lines[len(lines)-1][14])
    #開始行[B11:(10,41)]
    row = 10
    lineRow = 0
    for idayline in range(days):
        #################
        #レポート提出情報
        #################
        if(len(lines) > lineRow and lines[lineRow][14] == "%02d" % (idayline + 1)):
            #勤務月[A11:(0,10)～A41:(0,40)]
            _set_out_cell(outSheet, 0, row, iMonth)
            #作業時間の日設定[B11:(1,10)～B41:(1,40)]
            _set_out_cell(outSheet, 1, row, idayline + 1)
            #作業時間の曜日設定[C11:(2,10)～C41:(2,40)]
            strr = _get_week(iYear, iMonth, idayline + 1)
            _set_out_cell(outSheet, 2, row, strr)
            #作業開始時間設定[D11:(3,10)～D41:(3,40)]
            if lines[lineRow][5] is not None:
                _set_out_cell(outSheet, 3, row, lines[lineRow][5].strftime("%H:%M"))
            #作業終了時間設定[F11:(5,10)～F41:(5,40)]
            if lines[lineRow][6] is not None:
                _set_out_cell(outSheet, 5, row, lines[lineRow][6].strftime("%H:%M"))
            #休憩時間設定[H11:(7,10)～H41:(7,40)]
            _set_out_cell(outSheet, 7, row, lines[lineRow][11])
            #合計設定[J11:(9,10)～J41:(9,40)]
            if lines[lineRow][12] is not None:
                #totalMinutes += float("%.2f" % (lines[lineRow][12] / 60.0)) 
                totalMinutes += float(lines[lineRow][12])
                _set_out_cell(outSheet, 9, row, "%.2f" % (lines[lineRow][12] / 60.0))
            #備考設定[M8:(12,10)～M41:(12,40)]
            _set_out_cell(outSheet, 12, row, lines[lineRow][13])
            #line 次の行へ 
            lineRow = lineRow + 1
        else:
            #勤務月[A11:(0,10)～A41:(0,40)]
            _set_out_cell(outSheet, 0, row, iMonth)
            #作業時間の日設定[B11:(1,10)～B41:(1,40)]
            _set_out_cell(outSheet, 1, row, idayline + 1)
            #作業時間の曜日設定[C11:(2,10)～C41:(2,40)]
            strr = _get_week(iYear, iMonth, idayline + 1)
            _set_out_cell(outSheet, 2, row, strr)
        #次の行へ
        row = row + 1
        
    #合計設定[J42:(9,41)]
    total = "%.2f" % (totalMinutes / 60.0)
    totalNum = (totalMinutes - totalMinutes % 30) / 60.0
    _set_out_cell(outSheet, 9, 41, u"%s／%.2f" % (total, totalNum))
    #出力ファイルパス取得
    fileName = _get_file_path(user_name, _dispatchId, str(iYear) + str("%02d" % iMonth), 1)
    outWorkbook.save(fileName)
    return fileName
    
    print 'externalCreatExcel() - end'

# 内部Excel出力
def _internal_creat_excel(lines, iYear, iMonth, user_name):
    print 'internalCreatExcel() - start'
    print '    --output user:' + user_name

    #global
    global fileName

    #excel open
    inWorkbook = xlrd.open_workbook(_get_template_file_path(0), formatting_info=True);
    
    #copy inWorkbook to outWorkbook
    outWorkbook = copy(inWorkbook);
    
    outSheet = outWorkbook.get_sheet(0)
    
    #################
    #平常勤務
    #################
    #開始時[Y1(24,0)]
    _set_out_cell(outSheet, 24, 0, lines[0][0][0:2])
    #開始分[AA1(26,0)]
    _set_out_cell(outSheet, 26, 0, lines[0][0][3:5])
    #終了時[AD1:(29,0)]
    _set_out_cell(outSheet, 29, 0, lines[0][1][0:2])
    #終了分[AD1:(29,0)]
    _set_out_cell(outSheet, 31, 0, lines[0][1][3:5])
    #休憩[AA2:(26,1)]
    _set_out_cell(outSheet, 26, 1, lines[0][2])
    #所属会社[D6:(3,5)]
    _set_out_cell(outSheet, 3, 5, lines[0][3])
    #チーム名[D7:(3,6)]
    _set_out_cell(outSheet, 3, 6, lines[0][4])
    #氏名[M7:(12,6)]
    _set_out_cell(outSheet, 12, 6, user_name)
    #合計設定用(8.50)
    totalMinutes = 0.0
    #################
    #作業明細表の各項目の設定
    #################
    #日数取得
    days = _get_days(iYear, iMonth)
    #days = int(lines[len(lines)-1][14])
    #開始行[B11:(10,41)]
    row = 10
    lineRow = 0
    for idayline in range(days):
        #################
        #レポート提出情報
        #################
        if(len(lines) > lineRow and lines[lineRow][14] == "%02d" % (idayline + 1)):
            #勤務月[A11:(0,10)～A41:(0,40)]
            _set_out_cell(outSheet, 0, row, iMonth)
            #作業時間の日設定[B11:(1,10)～B41:(1,40)]
            _set_out_cell(outSheet, 1, row, idayline + 1)
            #作業時間の曜日設定[C11:(2,10)～C41:(2,40)]
            strr = _get_week(iYear, iMonth, idayline + 1)
            _set_out_cell(outSheet, 2, row, strr)
            #作業開始時間設定[D11:(3,10)～D41:(3,40)]
            if lines[lineRow][5] is not None:
                _set_out_cell(outSheet, 3, row, lines[lineRow][5].strftime("%H:%M"))
            #作業終了時間設定[F11:(5,10)～F41:(5,40)]
            if lines[lineRow][6] is not None:
                _set_out_cell(outSheet, 5, row, lines[lineRow][6].strftime("%H:%M"))
            #休憩時間設定[H11:(7,10)～H41:(7,40)]
            _set_out_cell(outSheet, 7, row, lines[lineRow][11])
            #合計設定[J11:(9,10)～J41:(9,40)]
            if lines[lineRow][12] is not None:
                #total
                totalMinutes += float(lines[lineRow][12])
                #output
                s1 = lines[lineRow][12] // 60
                s2 = lines[lineRow][12] % 60
                _set_out_cell(outSheet, 9, row, "%02d:%02d" % (s1, s2))
            #備考設定[AA11:(26,10)～AA41:(26,40)]
            _set_out_cell(outSheet, 26, row, lines[lineRow][13])
            #################
            #コレクション情報
            #################
            #コレクション開始時間設定[M11:(12,10)～M41:(12,40)]
            if lines[lineRow][7] is not None:
                _set_out_cell(outSheet, 12, row, lines[lineRow][7].strftime("%H:%M"))
            #コレクション開始場所設定[O11:(14,10)～O41:(14,40)]
            _set_out_cell(outSheet, 14, row, lines[lineRow][9])
            #コレクション終了時間設定[S11:(18,10)～S41:(18,40)]
            if lines[lineRow][8] is not None:
                _set_out_cell(outSheet, 18, row, lines[lineRow][8].strftime("%H:%M"))
            #コレクション終了場所設定[U11:(20,10)～U41:(20,40)]
            _set_out_cell(outSheet, 20, row, lines[lineRow][10])
            #line 次の行へ 
            lineRow = lineRow + 1
        else:
            #勤務月[A11:(0,10)～A41:(0,40)]
            _set_out_cell(outSheet, 0, row, iMonth)
            #作業時間の日設定[B11:(1,10)～B41:(1,40)]
            _set_out_cell(outSheet, 1, row, idayline + 1)
            #作業時間の曜日設定[C11:(2,10)～C41:(2,40)]
            strr = _get_week(iYear, iMonth, idayline + 1)
            _set_out_cell(outSheet, 2, row, strr)
        #次の行へ
        row = row + 1
        
    #合計時間設定[J42:(9,41)]
    #disply time (8:30)
    s1 = "%d:%d" % (totalMinutes // 60, totalMinutes % 60)
    #disply time (8.50)
    s2 = totalMinutes / 60.0
    _set_out_cell(outSheet, 9, 41, u"%s／%.2f" % (s1, s2))
    #出力ファイルパス取得
    fileName = _get_file_path(user_name, _dispatchId, str(iYear) + str("%02d" % iMonth), 0)
    outWorkbook.save(fileName)
    return fileName
    
    print 'internalCreatExcel() - end'

###################################
#description:該当年月日の曜日を返す
#parameter
#    year:年
#    month:月
#    day:月
###################################
def _get_week(year, month, day):
    week = datetime.date(year, month, day).weekday()
    if week == 0:
        strWeek = u'月'
    elif(week == 1):
        strWeek = u'火'
    elif week == 2:
        strWeek = u'水'
    elif week == 3:
        strWeek = u'木'
    elif week == 4:
        strWeek = u'金'
    elif week == 5:
        strWeek = u'土'
    elif week == 6:
        strWeek = u'日'
    else:
        strWeek = '-1'
    return strWeek


###################################
#description:当月の日数を返す
#parameter
#    year:年
#    month:月
###################################
def _get_days(year, month):
    #勤務日数取得
    last = datetime.date(year, month + 1, 1) - datetime.timedelta(1)
    return last.day

###################################
#description:指定の位置でデータを設定する。
#parameter
#    outSheet:シート
#    col:列(A=0,Z=25)
#    row:行(0から)
#    value:値
###################################
def _set_out_cell(outSheet, col, row, value):
    """ Change cell value without changing formatting. """
    def _getOutCell(outSheet, colIndex, rowIndex):
        """ HACK: Extract the internal xlwt cell representation. """
        row = outSheet._Worksheet__rows.get(rowIndex)
        if not row: return None
 
        cell = row._Row__cells.get(colIndex)
        return cell
 
    # HACK to retain cell style.
    previousCell = _getOutCell(outSheet, col, row)
    # END HACK, PART I

    outSheet.write(row, col, value)
 
    # HACK, PART II
    if previousCell:
        newCell = _getOutCell(outSheet, col, row)
        if newCell:
            newCell.xf_idx = previousCell.xf_idx
    # END HACK

###################################
#getFilePath:出力ファイルパスの取得
#parameter
#    name      :ユーザ名
#    dispatchId:派遣ID
#    years     :年月(yyyyMM)
#    status    :区分(0:社内    1:社外)
###################################
def _get_file_path(name, dispatchId, years, status):
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
#getTemplateFilePath:テンプレートファイルパスの取得
#parameter
#    status:区分(0:社内    1:社外)
###################################
def _get_template_file_path(status):
    if(status == 0):
        path = u'/home/maiasoft/maiaTemplate/勤務表_社内用.xls'
    else:
        path = u'/home/maiasoft/maiaTemplate/勤務表_社外用.xls'
    return path

###################################
#outputAll:全員情報を取得し、レポートを作成する。
###################################
def outputAll():
    # セッション作成
    dbSession = DBSession()
     
    try:
        dbSession.session_open()
    except Exception:
        dbSession.session_close()
        print u'データベース接続に失敗しました。'
        
    # バッチ実行パラメータ取得
    lines = dbSession.getBatchParamet()
    
    #セッションクローズ
    dbSession.session_close()
    
    # 勤務年
    iYear = datetime.datetime.now().year
    # 勤務月
    iMonth = datetime.datetime.now().month - 1
    # 社員ID
    customerId = ''#'ENP0000001'
    
    print u'勤務情報出力Statr_全員:' + str(datetime.datetime.now())    
    
    for line in lines:
        # 企業ID
        enterpriseId = line[0]
        # 派遣ID
        dispatchId = line[1]
        # main()処理実行：パラメータ出力
        print('main:バッチ処理実行、一括出力start(企業ID-派遣ID-社員ID-勤務年月)')
        print('     enterprise_id:' + enterpriseId)
        print('     dispatch_id:' + dispatchId)
        print('     customer_id:' + customerId)
        print('     years:' + str(iYear)+str(iMonth))
        # 勤務表出力
        ## iMonth
        WorksheetToExcel(enterpriseId, dispatchId, customerId, iYear, iMonth)
        print(enterpriseId, dispatchId, customerId, iYear, iMonth) 
    print u'勤務情報出力END_全員:' + str(datetime.datetime.now())

if(__name__=="__main__"):
    outputAll()
