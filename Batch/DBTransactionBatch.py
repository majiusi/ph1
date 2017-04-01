# -*- coding: utf-8 -*-
# !/usr/bin/env python
###################################
# description: 连接DB
# author: Kyoku
# date: 2017/1/8
###################################

import MySQLdb

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
                           user="root",
                           passwd="Password123",
                           db="maiadb",
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
        #注意文字前缀u
        #msg1 = u"MySQLに繋がりました。"
        #print msg1
        #print msg1.encode("utf-8")
        #print msg1.decode("utf-8")
        
        # 社員情報取得
        sql = " select "
        sql += " enterprise_id, "
        sql += " employee_id, "
        sql += " name_in_law, "
        sql += " name_cn, "
        sql += " name_en, "
        sql += " name_jp, "
        sql += " name_kana, "
        sql += " resident_spot_id, "
        sql += " mobile, "
        sql += " mobile_cn, "
        sql += " valid, "
        sql += " create_by, "
        sql += " create_at, "
        sql += " update_by, "
        sql += " update_at, "
        sql += " update_cnt " 
        sql += " from employees "
        if name != '999':
            sql += " where "
            sql += " employee_id = '"
            sql += name
            sql += "'"
        sql += " ; "
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
        sql += " '（仮）所属会社', "                       #3
        sql += " '（仮）プロジェクト名', "                  #4
        sql += " att.report_start_time, "              #5
        sql += " att.report_end_time, "                #6
        sql += " att.start_time, "                     #7
        sql += " att.end_time, "                       #8
        sql += " att.start_spot_name, "                #9
        sql += " att.end_spot_name, "                  #10
        sql += " att.exclusive_minutes, "              #11
        sql += " att.total_minutes, "                  #12
        sql += " '（仮）備考', "                          #13
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
    
#     def ins(self):
#         #插入数据(测试用)
#         intCnt = self.cur.execute("insert into test (id,name) values (%s,%s)",("test2","文字测试1"))
#         #result = self.cur.execute("insert into test (id,name) values (%s,%s)",(("test2","123456"),("test3","123456")))
#         print intCnt
#         if intCnt == 1:
#             self.conn.commit()
#         
#         #查询数据(测试用)
#         self.cur.execute("select id,name from test")
#         lines = self.cur.fetchall()
#         if lines is not None:
#             print 1
#         for line in lines:
#             print line[0],line[1]
        
if(__name__=="__main__"):
    DB = DBSession();
    lines = DB.getEmployeesInfo('999')#ENP0000001
    for line in lines:
        print line[0]