//
//  LoginViewController.m
//  Signinout
//
//  Created by yaochenxu on 2016/11/26.
//  Copyright © 2016年 maiasoft. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
- (IBAction)LoginButton:(UIButton *)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (IBAction)LoginButton:(UIButton *)sender {
    UITabBarController *tabControl = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginAfter"];
    [self.navigationController pushViewController:tabControl animated:YES];
    
}
@end
