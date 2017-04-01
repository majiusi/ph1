# -*- coding: utf-8 -*-
#!/usr/bin/python
###################################
#description: 勤務表出力_Excel
#author: Kyoku
#date: 2016/11/14
###################################

from DBTransactionBatch import DBSession 

import logging
import xlrd
import datetime
from xlutils.copy import copy

# initialization
logger = logging.getLogger('MaiaService.Batch.DBSession')

# 勤務表出力
def WorksheetToExcel():
    logger.info('DBSession open.')
    print 'WorksheetToExcel() - start'
    # パラメータ取得
    # 企業ID
    enterprise_id = 'ENT0000001'
    # 派遣ID
    dispatch_id = 'DIS0000001'
    # 社員ID
    customer_id = '999'#ENP0000001
    # 勤務年
    iYear = 2017
    # 勤務月
    iMonth = 10
    
    # セッション作成
    dbSession = DBSession()
    # ユーザ名作成
    user_name = ""
        
    try:
        dbSession.session_open()
    except Exception:
        dbSession.session_close()
        print 'ErrorMessage:セッションオープンが失敗しました。'
    
    # 社員情報取得
    lines = None
    if customer_id == '999':
        lines = dbSession.getEmployeesInfo(customer_id)
    else:
        lines = dbSession.getEmployeesInfo(customer_id)
    print '社员情报取得件数：' + str(len(lines))
    
    #取得結果チェック
    if len(lines) <= 0: 
        print 'ErrorMessage:該当社員不存在、処理終了'
        return
    for line in lines:
        # 派遣情報取得
        # 1レコードのみ取得想定
        ## line[1] : 社員ID（employee_id）
        dspclines = dbSession.getDispatchesInfo(enterprise_id, dispatch_id, line[1], iYear+iMonth)
        print '派遣信息取得件数：' + str(len(dspclines))
         
        # Excel出力呼出
        # 内部勤務表出力
        ## line[5] : 社員名（name_jp）
        internalCreatExcel(dspclines, iYear, iMonth, line[5])
        # 外部勤務表出力
        ## line[5] : 社員名（name_jp）
        externalCreatExcel(dspclines, iYear, iMonth, line[5])

    #セッションクローズ
    dbSession.session_close()

    print 'WorksheetToExcel() - end'

# 外部Excel出力
def externalCreatExcel(lines, iYear, iMonth, user_name):
    print 'externalCreatExcel() - start'
    #excel open
    inWorkbook = xlrd.open_workbook(u'file\\勤務表_社外_(名前).xls', formatting_info=True);
    
    #copy inWorkbook to outWorkbook
    outWorkbook = copy(inWorkbook);
    
    outSheet = outWorkbook.get_sheet(0)
    
    #################
    #平常勤務
    #################
    #開始時[K1(10,0)]
    setOutCell(outSheet, 10, 0, lines[0][0][0:2])
    #開始分[M1(12,0)]
    setOutCell(outSheet, 12, 0, lines[0][0][3:5])
    #終了時[P1:(15,0)]
    setOutCell(outSheet, 15, 0, lines[0][1][0:2])
    #終了分[R1:(17,0)]
    setOutCell(outSheet, 17, 0, lines[0][1][3:5])
    #休憩[K2:(10,1)]
    setOutCell(outSheet, 10, 1, lines[0][2])
    #所属会社[C6:(2,5)]
    setOutCell(outSheet, 2, 5, lines[0][3])
    #チーム名[C7:(2,6)]
    setOutCell(outSheet, 2, 6, lines[0][4])
    #氏名[I7:(8,6)]
    setOutCell(outSheet, 8, 6, user_name)
    #勤務月[A11:(0,10)]
    setOutCell(outSheet, 0, 10, iMonth)
    #合計設定用
    totalMinutes = 0
    #################
    #作業明細表の各項目の設定
    #################
    #日数取得
    days = getDays(iYear, iMonth)
    #開始行[B11:(10,41)]
    row = 10
    for idayline in range(days):
        #作業日付以外の場合、出力終了
        if (idayline >= len(lines)):
            break
        #################
        #レポート提出情報
        #################
        #作業時間の日設定[B11:(1,10)～B41:(1,40)]
        setOutCell(outSheet, 1, row, idayline + 1)
        #作業時間の曜日設定[C11:(2,10)～C41:(2,40)]
        strr = getWeek(iYear, iMonth, idayline + 1)
        setOutCell(outSheet, 2, row, strr)
        #作業開始時間設定[D11:(3,10)～D41:(3,40)]
        setOutCell(outSheet, 3, row, lines[idayline][5].strftime("%H:%M"))
        #作業終了時間設定[F11:(5,10)～F41:(5,40)]
        setOutCell(outSheet, 5, row, lines[idayline][6].strftime("%H:%M"))
        #休憩時間設定[H11:(7,10)～H41:(7,40)]
        setOutCell(outSheet, 7, row, lines[idayline][11])
        #合計設定[J11:(9,10)～J41:(9,40)]
        totalMinutes += float("%.2f" % (lines[idayline][12] / 60))
        setOutCell(outSheet, 9, row, "%.2f" % (lines[idayline][12] / 60))
        #備考設定[M8:(12,10)～M41:(12,40)]
        setOutCell(outSheet, 12, row, lines[idayline][13])
        #次の行へ
        row = row + 1
        
    #合計設定[J42:(9,41)]
    setOutCell(outSheet, 9, 41, "%.2f" % totalMinutes)
    
    outWorkbook.save(u'file\\勤務表_社外_(キョクハ).xls');
    
    print 'externalCreatExcel() - end'

# 内部Excel出力
def internalCreatExcel(lines, iYear, iMonth, user_name):
    print 'internalCreatExcel() - start'
    #excel open
    inWorkbook = xlrd.open_workbook(u'file\\勤務表_社内_(名前).xls', formatting_info=True);
    
    #copy inWorkbook to outWorkbook
    outWorkbook = copy(inWorkbook);
    
    outSheet = outWorkbook.get_sheet(0)
    
    #################
    #平常勤務
    #################
    #開始時[Y1(24,0)]
    setOutCell(outSheet, 24, 0, lines[0][0][0:2])
    #開始分[AA1(26,0)]
    setOutCell(outSheet, 26, 0, lines[0][0][3:5])
    #終了時[AD1:(29,0)]
    setOutCell(outSheet, 29, 0, lines[0][1][0:2])
    #終了分[AD1:(29,0)]
    setOutCell(outSheet, 31, 0, lines[0][1][3:5])
    #休憩[AA2:(26,1)]
    setOutCell(outSheet, 26, 1, lines[0][2])
    #所属会社[D6:(3,5)]
    setOutCell(outSheet, 3, 5, lines[0][3])
    #チーム名[D7:(3,6)]
    setOutCell(outSheet, 3, 6, lines[0][4])
    #氏名[M7:(12,6)]
    setOutCell(outSheet, 12, 6, user_name)
    #勤務月[A11:(0,10)]
    setOutCell(outSheet, 0, 10, iMonth)
    #合計設定用
    totalMinutes = 0
    #################
    #作業明細表の各項目の設定
    #################
    #日数取得
    days = getDays(iYear, iMonth)
    #開始行[B11:(10,41)]
    row = 10
    for idayline in range(days):
        #作業日付以外の場合、出力終了
        if (idayline >= len(lines)):
            break
        #################
        #レポート提出情報
        #################
        #作業時間の日設定[B11:(1,10)～B41:(1,40)]
        setOutCell(outSheet, 1, row, idayline + 1)
        #作業時間の曜日設定[C11:(2,10)～C41:(2,40)]
        strr = getWeek(iYear, iMonth, idayline + 1)
        setOutCell(outSheet, 2, row, strr)
        #作業開始時間設定[D11:(3,10)～D41:(3,40)]
        setOutCell(outSheet, 3, row, lines[idayline][5].strftime("%H:%M"))
        #作業終了時間設定[F11:(5,10)～F41:(5,40)]
        setOutCell(outSheet, 5, row, lines[idayline][6].strftime("%H:%M"))
        #休憩時間設定[H11:(7,10)～H41:(7,40)]
        setOutCell(outSheet, 7, row, lines[idayline][11])
        #合計設定[J11:(9,10)～J41:(9,40)]
        totalMinutes += float("%.2f" % (lines[idayline][12] / 60))
        setOutCell(outSheet, 9, row, "%.2f" % (lines[idayline][12] / 60))
        #備考設定[AA11:(26,10)～AA41:(26,40)]
        setOutCell(outSheet, 26, row, lines[idayline][13])
        #################
        #コレクション情報
        #################
        #コレクション開始時間設定[M11:(12,10)～M41:(12,40)]
        setOutCell(outSheet, 12, row, lines[idayline][7].strftime("%H:%M"))
        #コレクション開始場所設定[O11:(14,10)～O41:(14,40)]
        setOutCell(outSheet, 14, row, lines[idayline][9])
        #コレクション終了時間設定[S11:(18,10)～S41:(18,40)]
        setOutCell(outSheet, 18, row, lines[idayline][8].strftime("%H:%M"))
        #コレクション終了場所設定[U11:(20,10)～U41:(20,40)]
        setOutCell(outSheet, 20, row, lines[idayline][10])
        #次の行へ
        row = row + 1
        
    #合計設定[J42:(9,41)]
    setOutCell(outSheet, 9, 41, "%.2f" % totalMinutes)
    
    outWorkbook.save(u'file\\勤務表_社内_(キョクハ).xls');
    
    print 'internalCreatExcel() - end'

###################################
#description:該当年月日の曜日を返す
#parameter
#    year:年
#    month:月
#    day:月
###################################
def getWeek(year, month, day):
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
#description:該当月の日数を返す
#parameter
#    year:年
#    month:月
###################################
def getDays(year, month):
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
def setOutCell(outSheet, col, row, value):
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

if(__name__=="__main__"):
    WorksheetToExcel()