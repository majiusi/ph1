//
//  CALayer+LayerColor.m
//  Signinout
//
//  Created by yaochenxu on 2016/12/4.
//  Copyright © 2016年 maiasoft. All rights reserved.
//

#import "CALayer+LayerColor.h"

@implementation CALayer (LayerColor)
- (void) setBorderColorFromUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}
@end
