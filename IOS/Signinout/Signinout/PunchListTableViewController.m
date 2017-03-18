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

@interface PunchListTableViewController ()
- (IBAction)nextMonth:(UIBarButtonItem *)sender;
- (IBAction)beforeMonth:(UIBarButtonItem *)sender;

// list data
@property (nonatomic,strong) NSMutableArray* objects;
@property (nonatomic,strong) NSString* totalHoursByMinutesUnit;
@property (nonatomic, retain) NSDateComponents* comp;

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
    label.text = @"日付                  開始          終了        控除         出勤時間";
    
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 25.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    static NSString *footSectionID = @"footSectionID";
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footSectionID];
    UILabel *label;
   
    footerView = nil;
    footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:footSectionID];
    label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 450, 20)];
    label.font = [UIFont systemFontOfSize:13];
    [footerView addSubview:label];
    
    
    double minuteToHours = [self.totalHoursByMinutesUnit doubleValue] / 60.0f;
    
    label.text = [NSString stringWithFormat:@"                                                                 合計：%.2f", minuteToHours];
    
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"punchListCell";
    
    PunchListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSMutableDictionary*  dict = self.objects[indexPath.row];
    
    // set cell content
    cell.punchDate.text = [NSString stringWithFormat:@"%@(%@)", [dict objectForKey:@"work_date"],[dict objectForKey:@"which_day"]];
    
    if([[dict objectForKey:@"report_start_time"] integerValue] == 0)
        cell.punchCheckinTime.text = @"0";
    else
        cell.punchCheckinTime.text = [[dict objectForKey:@"report_start_time"] substringToIndex:5];
    
    if([[dict objectForKey:@"report_end_time"] integerValue] == 0)
        cell.punchCheckoutTime.text = @"0";
    else
        cell.punchCheckoutTime.text = [[dict objectForKey:@"report_end_time"] substringToIndex:5];
    
    cell.punchExceptTime.text = [NSString stringWithFormat:@"%@(分)",[dict objectForKey:@"report_exclusive_minutes"]];
    double minutesToHours = [[dict objectForKey:@"report_total_minutes"] doubleValue] / 60.0f;
    cell.punchTotalTime.text = [NSString stringWithFormat:@"%3.2f(時間)", minutesToHours];
    
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
    
    return cell;
}

-(void)startRequest:(NSString *)searchYear withSearchMonth:(NSString *)searchMonth
{
    NSUserDefaults  *userDefault = [NSUserDefaults standardUserDefaults];
    // show monthly attendances infomation
    [[WebServiceAPI requestWithFinishBlock:^(id object) {
        NSNumber *resultCodeObj = [object objectForKey:@"result_code"];
        if ([resultCodeObj integerValue] < 0)
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
            //            self.ErrorMessage.text = @"企業ID、ユーザID、パスワード不正";
        } else {
            [self reloadView:object];
        }
    } failBlock:^(int statusCode, int errorCode) {
        //        self.ErrorMessage.text = @"企業ID、ユーザID、パスワード不正";
        [self.navigationController popToRootViewControllerAnimated:YES];
        
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
 Do nothing when table first row be touched.
 
 */
//-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
//{
//    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//    if(indexPath.row == 0)
//    {
//        return NO;
//    }
//    return YES;
//}

/**
 Set parameter and show edit window when row be touched.

 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if([segue.identifier isEqualToString:@"EditMonthlyDataIdentifier"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        NSMutableDictionary *dict = self.objects[indexPath.row - 1];
        NSMutableDictionary *dict = self.objects[indexPath.row];
        
        EditMonthlyDataViewController *editMonthlyData = segue.destinationViewController;
        editMonthlyData.workDate = [NSString stringWithFormat:@"%@",[dict objectForKey:@"work_date"]];
        editMonthlyData.strStartTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"report_start_time"]];
        editMonthlyData.strEndTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"report_end_time"]];
        editMonthlyData.strExceptTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"report_exclusive_minutes"]];
        editMonthlyData.strTotalMinute = [NSString stringWithFormat:@"%@",[dict objectForKey:@"report_total_minutes"]];
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
