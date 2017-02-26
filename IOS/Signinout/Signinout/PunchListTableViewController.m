//
//  PunchListTableViewController.m
//  Signinout
//
//  Created by yaochenxu on 2016/08/06.
//  Copyright © 2016年 maiasoft. All rights reserved.
//

#import "PunchListTableViewController.h"
#import "PunchListTableViewCell.h"
#import "EditMonthlyDataViewController.h"
#import "WebServiceAPI.h"

@interface PunchListTableViewController ()

// list data
@property (nonatomic,strong) NSMutableArray* objects;

@end

@implementation PunchListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewDidAppear:(BOOL)animated
{
    [self startRequest];
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

    return self.objects.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"punchListCell";
    
    PunchListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.punchDate.text = @"日付";
        cell.punchCheckinTime.text = @"開始";
        cell.punchCheckoutTime.text = @"終了";
        cell.punchExceptTime.text = @"控除";
        cell.punchTotalTime.text = @"出勤時間";
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    } else {
        NSMutableDictionary*  dict = self.objects[indexPath.row - 1];
        cell.punchDate.text = [NSString stringWithFormat:@"%@(%@)", [dict objectForKey:@"work_date"],[dict objectForKey:@"which_day"]];
        cell.punchCheckinTime.text = [[dict objectForKey:@"report_start_time"] substringToIndex:5];
        cell.punchCheckoutTime.text = [[dict objectForKey:@"report_end_time"] substringToIndex:5];
        cell.punchExceptTime.text = [NSString stringWithFormat:@"%@(分)",[dict objectForKey:@"report_exclusive_minutes"]];
        
        double minutesToHours = [[dict objectForKey:@"report_total_minutes"] doubleValue] / 60.0f;
        cell.punchTotalTime.text = [NSString stringWithFormat:@"%3.2f(時間)", minutesToHours];
        
        cell.punchDate.textColor = [UIColor grayColor];
        cell.punchCheckinTime.textColor = [UIColor grayColor];
        cell.punchCheckoutTime.textColor = [UIColor grayColor];
        cell.punchExceptTime.textColor = [UIColor grayColor];
        cell.punchTotalTime.textColor = [UIColor grayColor];
    }
    
    return cell;
}

-(void)startRequest
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
        
    }] getEmployeeMonthlyInfoWithEnterpriseId:[userDefault stringForKey:@"enterpriseId"]  withUserName:[userDefault stringForKey:@"token"] withPassword:@"" ];
    
}

-(void)reloadView:(NSDictionary*)res
{
    NSNumber *resultCodeObj = [res objectForKey:@"result_code"];
    if ([resultCodeObj integerValue] >=0)
    {
        self.objects = [res objectForKey:@"monthly_work_time_list"];
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
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if(indexPath.row == 0)
    {
        return NO;
    }
    return YES;
}

/**
 Set parameter and show edit window when row be touched.

 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if([segue.identifier isEqualToString:@"EditMonthlyDataIdentifier"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSMutableDictionary *dict = self.objects[indexPath.row - 1];
        
        EditMonthlyDataViewController *editMonthlyData = segue.destinationViewController;
        editMonthlyData.workDate = [dict objectForKey:@"work_date"];
        editMonthlyData.strStartTime = [dict objectForKey:@"report_start_time"];
        editMonthlyData.strEndTime = [dict objectForKey:@"report_end_time"];
        editMonthlyData.strExceptTime = [dict objectForKey:@"report_exclusive_minutes"];
        editMonthlyData.strTotalMinute = [dict objectForKey:@"report_total_minutes"];
    }
}

@end
