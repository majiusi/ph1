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

@interface PunchListTableViewController ()

// list data
@property (nonatomic,strong) NSMutableArray* objects;

@end

@implementation PunchListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startRequest];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
        cell.punchTotalTime.text = @"総時間";
    } else {
        NSMutableDictionary*  dict = self.objects[indexPath.row - 1];
        cell.punchDate.text = [dict objectForKey:@"work_date"];
        cell.punchCheckinTime.text = [dict objectForKey:@"report_start_time"];
        cell.punchCheckoutTime.text = [dict objectForKey:@"report_end_time"];
        cell.punchTotalTime.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"report_total_minutes"]];
        
    }
    
    return cell;
}

-(void)startRequest
{
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:@"MAE0001" forKey:@"enterprise_id"];
    [param setValue:@"2016" forKey:@"search_year"];
    [param setValue:@"11" forKey:@"search_month"];
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:@"127.0.0.1:5000" customHeaderFields:nil];
    MKNetworkOperation *op = [engine operationWithPath:@"api/MAS0000040" params:param httpMethod:@"POST" ssl:NO];
    [op setUsername:@"yaochenxu" password:@"mapw001" basicAuth:YES];
    [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    
    
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        
        NSLog(@"responseData : %@", [operation responseString]);
        NSData *data  = [operation responseData];
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        [self reloadView:resDict];
        
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        NSLog(@"MKNetwork request error : %@", [err localizedDescription]);
    }];
    [engine enqueueOperation:op];
    
}

-(void)reloadView:(NSDictionary*)res
{
    NSNumber *resultCodeObj = [res objectForKey:@"result_code"];
    if ([resultCodeObj integerValue] >=0)
    {
        self.objects = [res objectForKey:@"monthly_work_time_list"];
        [self.tableView reloadData];
    } else {
        NSString *errorStr = [@"Return code:" stringByAppendingString:[resultCodeObj stringValue]];

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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"EditMonthlyDataIdentifier"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSMutableDictionary *dict = self.objects[indexPath.row - 1];
        
        EditMonthlyDataViewController *editMonthlyData = segue.destinationViewController;
        editMonthlyData.workDate = [dict objectForKey:@"work_date"];
    }
}


@end
