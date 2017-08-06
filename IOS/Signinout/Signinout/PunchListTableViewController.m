//
//  PunchListTableViewController.m
//  Signinout
//
//  Created by yaochenxu on 2016/08/06.
//  Copyright © 2016年 Yaochenxu. All rights reserved.
//

#import "PunchListTableViewController.h"
#import "PunchListTableViewCell.h"
#import "EditMonthlyDataViewController.h"
#import "WebServiceAPI.h"
#import "Constant.h"

@interface PunchListTableViewController ()
- (IBAction)nextMonth:(UIBarButtonItem *)sender;
- (IBAction)beforeMonth:(UIBarButtonItem *)sender;

// list data
@property (nonatomic,strong) NSMutableArray* objects;
@property (nonatomic,strong) NSString* totalHoursByMinutesUnit;
@property (nonatomic, retain) NSDateComponents* comp;

@property (nonatomic, strong) NSString *strDefaultStartTime;
@property (nonatomic, strong) NSString *strDefaultEndTime;
@property (nonatomic, strong) NSString *strDefaultExceptTime;

@end

@implementation PunchListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // get NSCalendar object
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // get system date
    NSDate* dt = [NSDate date];
    // define flags to get system year and month
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth;
    self.comp = [gregorian components: unitFlags fromDate:dt];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    NSString *searchYear = [NSString stringWithFormat:@"%ld",(long)self.comp.year];
    NSString *searchMonth = [NSString stringWithFormat:@"%ld",(long)self.comp.month];
    
    [self startRequest:searchYear withSearchMonth:searchMonth];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.objects.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerSectionID = @"headerSectionID";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerSectionID];
    UILabel *label;
    
    if (headerView == nil) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerSectionID];
        label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 450, 20)];
        [headerView addSubview:label];
    }
    label.font = [UIFont systemFontOfSize:13];

    // show table title
    label.text = @"日付                   開始           終了        控除      出勤時間";
    
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 25.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    // [value stored to 'footerView' during its initialization is never read] in Analyze. But,
    // in order to show the [total work time] in real time, this code required.
    static NSString *footSectionID = @"footSectionID";
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footSectionID];
    UILabel *label;
   
    footerView = nil;
    footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:footSectionID];
    label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 450, 20)];
    label.font = [UIFont systemFontOfSize:13];
    [footerView addSubview:label];
    
    
    double minuteToHours = [self.totalHoursByMinutesUnit doubleValue] / 60.0f;
    int hour = [self.totalHoursByMinutesUnit intValue] / 60;
    int minute = [self.totalHoursByMinutesUnit intValue] % 60;
    
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"合計：%02d:%02d (%.2f)",hour, minute, minuteToHours];
    
    return footerView;
}

- (int)isLocalSystemDate:(NSString *)dateString
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    NSDate *localDate = [formatter dateFromString:dateTime];
    
    NSDate *inputDate = [formatter dateFromString:dateString];
    
    NSComparisonResult result = [localDate compare:inputDate];
    
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"punchListCell";
    
    PunchListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSMutableDictionary*  dict = self.objects[indexPath.row];
    
    // set cell content
    cell.punchDate.text = [NSString stringWithFormat:@"%@(%@)", [dict objectForKey:@"work_date"],[dict objectForKey:@"which_day"]];
    
    NSString *strReportStartTime = [dict objectForKey:@"report_start_time"] ;
    NSString *strReportEndTime = [dict objectForKey:@"report_end_time"] ;
    
    cell.punchCheckinTime.text = @"00:00";
    if( strReportStartTime != nil && ![strReportStartTime isEqualToString:@"00:00:00"] && [strReportStartTime length] > 0)
        cell.punchCheckinTime.text = [strReportStartTime substringToIndex:5];
    
    cell.punchCheckoutTime.text = @"00:00";
    if( strReportEndTime != nil && ![strReportEndTime isEqualToString:@"00:00:00"] && [strReportEndTime length] > 0)
        cell.punchCheckoutTime.text = [strReportEndTime substringToIndex:5];

    cell.punchExceptTime.text = [NSString stringWithFormat:@"%0d(分)",[[dict objectForKey:@"report_exclusive_minutes"] intValue]];
    //double minutesToHours = [[dict objectForKey:@"report_total_minutes"] doubleValue] / 60.0f;
    int hour = [[dict objectForKey:@"report_total_minutes"] intValue] / 60;
    int minute = [[dict objectForKey:@"report_total_minutes"] intValue]  % 60;
    cell.punchTotalTime.text = [NSString stringWithFormat:@"%02d:%02d", hour, minute];
    
    // set text font color
    cell.punchDate.textColor = [UIColor grayColor];
    cell.punchCheckinTime.textColor = [UIColor grayColor];
    cell.punchCheckoutTime.textColor = [UIColor grayColor];
    cell.punchExceptTime.textColor = [UIColor grayColor];
    cell.punchTotalTime.textColor = [UIColor grayColor];
    NSString *witchDay = [NSString stringWithFormat:@"%@",[dict objectForKey:@"which_day"]];
    if([witchDay isEqualToString:@"土"] || [witchDay isEqualToString:@"日"] || [witchDay isEqualToString:@"祝"])
    {
        cell.punchDate.textColor = [UIColor redColor];
    }
    UIColor *currentDateColour = [UIColor colorWithRed:30.f/255.f green:144.f/255.f blue:255.f/255.f alpha:1.0];
    if( [self isLocalSystemDate:[dict objectForKey:@"work_date"]] == 0)
    {
        cell.punchCheckinTime.textColor = currentDateColour;
        cell.punchCheckoutTime.textColor = currentDateColour;
        cell.punchExceptTime.textColor = currentDateColour;
        cell.punchTotalTime.textColor = currentDateColour;
    
    }
    
    return cell;
}

-(void)startRequest:(NSString *)searchYear withSearchMonth:(NSString *)searchMonth
{
    NSUserDefaults  *userDefault = [NSUserDefaults standardUserDefaults];
    
    // Get employee base info, and show name of JP, show defalut work start/end/except time.
    [[WebServiceAPI requestWithFinishBlock:^(id object) {
        NSNumber *resultCodeObj = [object objectForKey:@"result_code"];
        if ([resultCodeObj integerValue] < 0)
        {
            // get EmployeeBaseInfo error
            //SHOW_MSG(@"", CONST_GET_EMPLOYEE_BASEINFO_ERROR, self);
            SHOW_MSG_STYLE(CONST_GET_EMPLOYEE_BASEINFO_ERROR, @" ")
        } else {
            self.strDefaultStartTime = [object objectForKey:@"default_work_start_time"];
            self.strDefaultEndTime = [object objectForKey:@"default_work_end_time"];
            self.strDefaultExceptTime = [NSString stringWithFormat:@"%@",[object objectForKey:@"default_except_minutes"]];
        }
    } failBlock:^(int statusCode, int errorCode) {
        // web service not available
        //SHOW_MSG(@"", CONST_SERVICE_NOT_AVAILABLE, self);
        SHOW_MSG_STYLE(CONST_SERVICE_NOT_AVAILABLE, @" ")
        
    }] getEmployeeBaseInfoWithEnterpriseId:[userDefault stringForKey:@"enterpriseId"]  withUserName:[userDefault stringForKey:@"token"] withPassword:@"" ];

    SHOW_PROGRESS(self.navigationController.view);
    // show monthly attendances infomation
    [[WebServiceAPI requestWithFinishBlock:^(id object) {
        NSNumber *resultCodeObj = [object objectForKey:@"result_code"];
        if ([resultCodeObj integerValue] < 0)
        {
            // get EmployeeMonthlyInfo error
            //SHOW_MSG(@"", CONST_GET_EMPLOYEE_MONTHLY_INFO_ERROR, self);
            SHOW_MSG_STYLE(CONST_GET_EMPLOYEE_MONTHLY_INFO_ERROR, @" ")
        } else {
            [self reloadView:object];
        }
        HIDE_PROGRESS
    } failBlock:^(int statusCode, int errorCode) {
        // web service not available
        HIDE_PROGRESS
        //SHOW_MSG(@"", CONST_SERVICE_NOT_AVAILABLE, self);
        SHOW_MSG_STYLE(CONST_SERVICE_NOT_AVAILABLE, @" ")
        
    }] getEmployeeMonthlyInfoWithEnterpriseId:[userDefault stringForKey:@"enterpriseId"]  withUserName:[userDefault stringForKey:@"token"] withPassword:@"" withSearchYear:searchYear withSearchMonth:searchMonth ];
    
}

-(void)reloadView:(NSDictionary*)res
{
    NSNumber *resultCodeObj = [res objectForKey:@"result_code"];
    if ([resultCodeObj integerValue] >=0)
    {
        self.objects = [res objectForKey:@"monthly_work_time_list"];
        self.totalHoursByMinutesUnit = [res objectForKey:@"total_hours"];
        [self.tableView reloadData];
    } else {
        NSString *errorStr = [@"return code:" stringByAppendingString:[resultCodeObj stringValue]];

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Not data" message:errorStr preferredStyle:UIAlertControllerStyleAlert ];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Close"
                                    style:UIAlertActionStyleCancel
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                    }];
        
        [alert addAction:yesButton];

        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - Navigation

/**
 Set parameter and show edit window when row be touched.

 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if([segue.identifier isEqualToString:@"EditMonthlyDataIdentifier"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSMutableDictionary *dict = self.objects[indexPath.row];
        
        EditMonthlyDataViewController *editMonthlyData = segue.destinationViewController;
        editMonthlyData.workDate = [NSString stringWithFormat:@"%@",[dict objectForKey:@"work_date"]];
        editMonthlyData.strStartTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"report_start_time"]];
        editMonthlyData.strEndTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"report_end_time"]];
        editMonthlyData.strExceptTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"report_exclusive_minutes"]];
        editMonthlyData.strTotalMinute = [NSString stringWithFormat:@"%@",[dict objectForKey:@"report_total_minutes"]];
        editMonthlyData.strDefaultStartTime = self.strDefaultStartTime;
        editMonthlyData.strDefaultEndTime = self.strDefaultEndTime;
        editMonthlyData.strDefaultExceptTime = self.strDefaultExceptTime;
        
    }
}



- (IBAction)nextMonth:(UIBarButtonItem *)sender {
    // get next month
    [self.comp setMonth:[self.comp month] + 1 ];
    if([self.comp month] > 12)
    {
        [self.comp setYear:[self.comp year] + 1 ];
        [self.comp setMonth:1 ];
    }
    NSString *searchYear = [NSString stringWithFormat:@"%ld",(long)self.comp.year];
    NSString *searchMonth = [NSString stringWithFormat:@"%ld",(long)self.comp.month];
    
    [self startRequest:searchYear withSearchMonth:searchMonth];
}

- (IBAction)beforeMonth:(UIBarButtonItem *)sender {
    // get before month
    [self.comp setMonth:[self.comp month] - 1 ];
    if([self.comp month] < 1)
    {
        [self.comp setYear:[self.comp year] - 1 ];
        [self.comp setMonth:12 ];
    }
    NSString *searchYear = [NSString stringWithFormat:@"%ld",(long)self.comp.year];
    NSString *searchMonth = [NSString stringWithFormat:@"%ld",(long)self.comp.month];
    
    [self startRequest:searchYear withSearchMonth:searchMonth];
}
@end
