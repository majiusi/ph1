//
//  PasswordChangeTableViewController.m
//  Signinout
//
//  Created by yaochenxu on 2017/3/21.
//  Copyright © 2017年 Yaochenxu. All rights reserved.
//

#import "PasswordChangeTableViewController.h"
#import "WebServiceAPI.h"
#import "Constant.h"

@interface PasswordChangeTableViewController ()
- (IBAction)cancle:(UIButton *)sender;
- (IBAction)changePassword:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *oldPassword;
@property (weak, nonatomic) IBOutlet UITextField *password1;
@property (weak, nonatomic) IBOutlet UITextField *password2;

@end

@implementation PasswordChangeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancle:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)changePassword:(UIButton *)sender {
    SHOW_PROGRESS(self.navigationController.view);
    
    NSUserDefaults  *userDefault = [NSUserDefaults standardUserDefaults];
    
    [[WebServiceAPI requestWithFinishBlock:^(id object) {
        NSNumber *resultCodeObj = [object objectForKey:@"result_code"];
        HIDE_PROGRESS
        if ([resultCodeObj integerValue] < 0)
        {
            // password update error
            SHOW_MSG(CONST_PASSWORD_UPDATE_ERROR_TITLE, CONST_PASSWORD_UPDATE_ERROR_MSG, self);
        } else {
            // password update successed
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:CONST_PASSWORD_UPDATE_SUCCESSED_MSG preferredStyle: UIAlertControllerStyleActionSheet];
            [alert addAction:[UIAlertAction actionWithTitle:@"閉じる" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // clear old token
                [userDefault removeObjectForKey:@"token"];
                
                // return to before window
                [self.navigationController popToRootViewControllerAnimated:YES];
            }]];
            // show dialog box
            [self presentViewController:alert animated:true completion:nil];
        }
    } failBlock:^(int statusCode, int errorCode) {
        // web service not available
        HIDE_PROGRESS
        SHOW_MSG(@"", CONST_SERVICE_NOT_AVAILABLE, self);
        
    }] changePasswordWithEnterpriseId:[userDefault stringForKey:@"enterpriseId"]  withUserName:[userDefault stringForKey:@"userName"] withPassword:self.oldPassword.text withPassword1:self.password1.text withPassword2:self.password2.text ];
}
@end
