//
//  PunchNavigationController.m
//  Signinout
//
//  Created by yaochenxu on 2016/12/4.
//  Copyright © 2016年 Yaochenxu. All rights reserved.
//

#import "PunchNavigationController.h"

@interface PunchNavigationController ()

@end

@implementation PunchNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
       // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewDidAppear:(BOOL)animated{
    
//    NSUserDefaults  * userDefault = [NSUserDefaults standardUserDefaults];
//    
//    NSLog(@"nextPage:%ld",(long)[userDefault integerForKey:@"nextPage"]);
//    
//    if ([userDefault integerForKey:@"nextPage"] == 1)
//    {
//        [self performSegueWithIdentifier:@"id1" sender:self];
//    }
//    else if ([userDefault integerForKey:@"nextPage"] == 2)
//    {
//        [self performSegueWithIdentifier:@"id2" sender:self];
//    }
    
//    if ([userDefault integerForKey:@"nextPage"] == 1)
//    {
//        UIViewController * viewControl = [self.storyboard instantiateViewControllerWithIdentifier:@"PunchPage1"];
//
//        [self.navigationController pushViewController:viewControl animated:YES];
//    }
//    else if ([userDefault integerForKey:@"nextPage"] == 2)
//    {
//        UIViewController * viewControl = [self.storyboard instantiateViewControllerWithIdentifier:@"PunchPage2"];
//        [self.navigationController pushViewController:viewControl animated:YES];
//    }
    
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
