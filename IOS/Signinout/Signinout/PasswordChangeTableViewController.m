//
//  PasswordChangeTableViewController.m
//  Signinout
//
//  Created by yaochenxu on 2017/3/21.
//  Copyright © 2017年 maiasoft. All rights reserved.
//

#import "PasswordChangeTableViewController.h"
#import "WebServiceAPI.h"

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
    
    NSUserDefaults  *userDefault = [NSUserDefaults standardUserDefaults];
    
    [[WebServiceAPI requestWithFinishBlock:^(id object) {
        NSNumber *resultCodeObj = [object objectForKey:@"result_code"];
        if ([resultCodeObj integerValue] < 0)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"パスワードの変更に失敗しました。" message:@"入力値を確認してください。" preferredStyle: UIAlertControllerStyleActionSheet];
            [alert addAction:[UIAlertAction actionWithTitle:@"閉じる" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                // return to before window
                [self.navigationController popToRootViewControllerAnimated:YES];
            }]];
            //show dialog box
            [self presentViewController:alert animated:true completion:nil];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"パスワード変更しました。" preferredStyle: UIAlertControllerStyleActionSheet];
            [alert addAction:[UIAlertAction actionWithTitle:@"閉じる" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // return to before window
                [self.navigationController popToRootViewControllerAnimated:YES];
            }]];
            //show dialog box
            [self presentViewController:alert animated:true completion:nil];
        }
    } failBlock:^(int statusCode, int errorCode) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"サービスの利用ができません。" preferredStyle: UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"閉じる" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            // return to before window
            [self.navigationController popToRootViewControllerAnimated:YES];
        }]];
        //show dialog box
        [self presentViewController:alert animated:true completion:nil];
        
    }] changePasswordWithEnterpriseId:[userDefault stringForKey:@"enterpriseId"]  withUserName:[userDefault stringForKey:@"userName"] withPassword:self.oldPassword.text withPassword1:self.password1.text withPassword2:self.password2.text ];
}
@end
