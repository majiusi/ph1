//
//  DateUtils.h
//  Signinout
//
//  Created by yaochenxu on 2017/6/30.
//  Copyright © 2017年 maiasoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtils : NSObject
+ (id)sharedDateUtilsByGCD;

-(NSDate*) ConvertToHoursAndMinutesWithTotalMinutes:(int)TotalMinutes  withStartYmd:(NSString *)startYmd withFormat:(NSString *)formatString;

- (NSDate*) ConvertToHoursAndMinutesWithStringOfHHmm:(NSString*)HHmmString withStartYmd:(NSString *)startYmd withFormat:(NSString *)formatString;
@end
