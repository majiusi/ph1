//
//  PunchViewController.m
//  Signinout
//
//  Created by yaochenxu on 2016/08/02.
//  Copyright © 2016年 maiasoft. All rights reserved.
//

#import "PunchViewController.h"

@interface PunchViewController ()




- (IBAction)setStartTime:(UIButton *)sender;

- (IBAction)submitPage1:(UIButton *)sender;
- (IBAction)submitPage2:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UILabel *positionInfo;
@property (weak, nonatomic) IBOutlet UIButton *submitPage1Btn;
@property (weak, nonatomic) IBOutlet UIButton *submitPage2Btn;
@property (weak, nonatomic) IBOutlet UIStackView *page3Stack;
@property (weak, nonatomic) IBOutlet UIButton *startTimeBtn;

@end

@implementation PunchViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults  * userDefault = [NSUserDefaults standardUserDefaults];
    NSLog(@"token:%@",[userDefault stringForKey:@"token"]);
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewDidAppear:(BOOL)animated{
    
    self.positionInfo.hidden = YES;
    self.submitPage1Btn.hidden = YES;
    self.submitPage1Btn.hidden = YES;
    self.page3Stack.hidden = YES;
    
    NSUserDefaults  * userDefault = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"nextPage:%ld",(long)[userDefault integerForKey:@"nextPage"]);
    
    if ([userDefault integerForKey:@"nextPage"] == 1)
    {
        //[self performSegueWithIdentifier:@"id1" sender:self];
        self.positionInfo.hidden = NO;
        self.submitPage1Btn.hidden = NO;
    }
    else if ([userDefault integerForKey:@"nextPage"] == 2)
    {
        //[self performSegueWithIdentifier:@"id2" sender:self];
        self.positionInfo.hidden = NO;
        self.submitPage2Btn.hidden = NO;
    }
    else if ([userDefault integerForKey:@"nextPage"] == 3)
    {
        //[self performSegueWithIdentifier:@"id2" sender:self];
        self.page3Stack.hidden = NO;
    }
}

//- (IBAction)SubmitPage1:(id)sender {
    
    

    //UINavigationController * navControl = [self.storyboard instantiateViewControllerWithIdentifier:@"PunchPageReDirect"];
    //self.navigationController.viewControllers = @[navControl ];
    
//    [self.navigationController popViewControllerAnimated:YES];
//    UINavigationController * navControl = [self.storyboard instantiateViewControllerWithIdentifier:@"PunchPageReDirect"];
//    [navControl viewDidLoad];
    

//}


- (IBAction)submitPage1:(UIButton *)sender {
    NSUserDefaults  * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setInteger:2 forKey:@"nextPage"];
    self.submitPage1Btn.hidden = YES;
    self.submitPage2Btn.hidden = NO;
}

- (IBAction)submitPage2:(UIButton *)sender {
    NSUserDefaults  * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setInteger:3 forKey:@"nextPage"];
    self.submitPage1Btn.hidden = YES;
    self.submitPage2Btn.hidden = YES;
    self.positionInfo.hidden = YES;
    self.page3Stack.hidden = NO;
}

- (IBAction)setStartTime:(UIButton *)sender {
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeTime;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert.view addSubview:datePicker];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        //实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"HH:SS"];//设定时间格式
        NSString *dateString = [dateFormat stringFromDate:datePicker.date];
        //求出当天的时间字符串
        self.startTimeBtn.titleLabel.text = dateString;
        NSLog(@"%@",dateString);
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:^{ }];
}


@end
