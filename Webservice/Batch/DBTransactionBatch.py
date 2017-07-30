# -*- coding: utf-8 -*-
# !/usr/bin/env python
###################################
# description: 连接DB
# author: Kyoku
# date: 2017/1/8
###################################

import MySQLdb
import datetime

class DBSession:
    #数据库连接字符串
    conn = None
    #游标指针（cursor）
    cur = None
    
    # 连接DB
    def session_open(self):
        #创建MySQL数据库连接字符串
        self.conn = MySQLdb.connect(
                           host="localhost",
                           user="dbuser",
                           passwd="Admin001",
                           db="maiaDB",
                           port=3306,
                           charset="utf8")
    
    # 关闭DB连接
    def session_close(self):
        # 关闭数据库连接
        self.conn.close()
        
    # 员工信息取得
    def getEmployeesInfo(self, name):
        #创建cursor(游标指针)
        cur = self.conn.cursor()
        # 社員情報取得
        sql = " select "
        sql += " enterprise_id, "             #0
        sql += " employee_id, "               #1
        sql += " IFNULL(name_in_law,'0'), "   #2
        sql += " IFNULL(name_cn,'0'), "       #3
        sql += " IFNULL(name_en,'0'), "       #4
        sql += " IFNULL(name_jp,'0'), "       #5
        sql += " IFNULL(name_kana,'0'), "     #6
        sql += " resident_spot_id, "          #7
        sql += " mobile, "                    #8
        sql += " mobile_cn, "                 #9
        sql += " valid, "                     #10
        sql += " create_by, "                 #11
        sql += " create_at, "                 #12
        sql += " update_by, "                 #13
        sql += " update_at, "                 #14
        sql += " update_cnt, "                #15
        sql += " mail_addr "                  #16
        sql += " from employees "
        if len(name) > 0:
            sql += " where employee_id = '"
            sql += name
            sql += "'"
        sql += " ; "
        
        #print sql
        cur.execute(sql)
        lines = cur.fetchall()
        
        return lines
        
    # 派遣信息取得
    ## enterpriseId : 企業ID
    ## dispatchId : 派遣ID
    ## employeeId : 社員ID
    ## dateYm : 勤務年月
    def getDispatchesInfo(self, enterpriseId, dispatchId, employeeId, dateYm):
        #cursor
        cur = self.conn.cursor()
        
        # 派遣情報取得
        sql = " select "
        sql += " dsp.work_start_time, "                #0
        sql += " dsp.work_end_time, "                  #1
        sql += " dsp.day_break_minutes, "              #2
        sql += " '', "                                 #3
        sql += " '', "                                 #4
        sql += " att.report_start_time, "              #5
        sql += " att.report_end_time, "                #6
        sql += " att.start_time, "                     #7
        sql += " att.end_time, "                       #8
        sql += " att.start_spot_name, "                #9
        sql += " att.end_spot_name, "                  #10
        sql += " att.exclusive_minutes, "              #11
        sql += " att.total_minutes, "                  #12
        sql += " '', "                                 #13
        sql += " DATE_FORMAT(att.date, '%d') "         #14
        sql += " from dispatches dsp, attendances att "
        sql += " where "
        sql += " dsp.enterprise_id = att.enterprise_id "
        sql += " and "
        sql += " dsp.dispatch_id = att.dispatch_id "
        sql += " and "
        sql += " dsp.employee_id = att.employee_id "
        sql += " and "
        sql += " att.enterprise_id = '"
        sql += enterpriseId
        sql += "'"
        sql += " and "
        sql += " att.dispatch_id = '"
        sql += dispatchId
        sql += "'"
        sql += " and "
        sql += " att.employee_id = '"
        sql += employeeId
        sql += "'"
        sql += " and "
        sql += " DATE_FORMAT(att.date, '%Y%m') = '"
        sql += dateYm
        sql += "'"
        #print sql
        cur.execute(sql)
        
        return cur.fetchall()
        
    # バッチ実行パラメータ取得
    def getBatchParamet(self):
        #cursor
        cur = self.conn.cursor()
        
        # 派遣情報取得
        sql = " select distinct "
        sql += " enterprise_id, "                #0
        sql += " dispatch_id "                   #1
        sql += " from dispatches "
        #print sql
        cur.execute(sql)
        
        return cur.fetchall()
    
#     def ins(self):
#         #插入数据(测试用)
#         intCnt = self.cur.execute("insert into test (id,name) values (%s,%s)",("test2","文字测试1"))
#         #result = self.cur.execute("insert into test (id,name) values (%s,%s)",(("test2","123456"),("test3","123456")))
#         print intCnt
#         if intCnt == 1:
#             self.conn.commit()

if(__name__=="__main__"):
    # セッション作成
    dbSession = DBSession()
    
    try:
        dbSession.session_open()
    except Exception:
        dbSession.session_close()
        print u'データベース接続に失敗しました。'
        
    # バッチ実行パラメータ取得
    prmtLines = dbSession.getBatchParamet()
    
    # 勤務年の設定
    iYear = str(datetime.datetime.now().year)
    # 勤務月の設定
    iMonth = "%02d" % int(datetime.datetime.now().month)
    
    # 社員ID
    customerId = ''#'ENP0000001'
    
    for prmtline in prmtLines:
        #print u'◆バッチ実行パラメータ取得結果'
        #print prmtline
        # 企業ID
        enterpriseId = prmtline[0]
        # 派遣ID
        dispatchId = prmtline[1]
        # 社員情報取得
        epyLines = dbSession.getEmployeesInfo(customerId)
    
        for epyLine in epyLines:
            #print u'1.社員情報取得結果'
            #print epyLine
            dspclines = dbSession.getDispatchesInfo(enterpriseId, dispatchId, epyLine[1], iYear + iMonth)
    
            #for dspcline in dspclines:
                #print u'2.派遣信息取得結果'
                #print dspcline
    
    #セッションクローズ
    dbSession.session_close()


