//
//  PunchListTableViewCell.h
//  Signinout
//
//  Created by yaochenxu on 2016/08/06.
//  Copyright © 2016年 Yaochenxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PunchListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *punchDate;
@property (weak, nonatomic) IBOutlet UILabel *punchCheckinTime;
@property (weak, nonatomic) IBOutlet UILabel *punchCheckoutTime;
@property (weak, nonatomic) IBOutlet UILabel *punchExceptTime;
@property (weak, nonatomic) IBOutlet UILabel *punchTotalTime;


@end
