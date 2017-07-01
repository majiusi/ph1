//
//  DateUtils.m
//  Signinout
//
//  Created by yaochenxu on 2017/6/30.
//  Copyright © 2017年 maiasoft. All rights reserved.
//

#import "DateUtils.h"

@implementation DateUtils

static DateUtils * _dateUtilsByGCD = nil;

/**
 Singlegon for DateUtils

 @return Singlegon DateUtils object
 */
+(id)sharedDateUtilsByGCD{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateUtilsByGCD = [[DateUtils alloc] init];
    });
    return _dateUtilsByGCD;
}

/**
 Convert total minutes to hours:minutes And join yyyyMMDD

 @param TotalMinutes TotalMinutes
 @param withStartYmd ex: "1970/01/01"
 @param formatString ex: "yyyy/mm/dd HH:mm"  -> It's so terrible, it must be HH by 24h.
 @return formated NSDate object
 */
- (NSDate*) ConvertToHoursAndMinutesWithTotalMinutes:(int)TotalMinutes withStartYmd:(NSString *)startYmd withFormat:(NSString *)formatString{

    int exceptSeconds = TotalMinutes * 60;
    int minutes = (exceptSeconds / 60) % 60;  // int seconds = exceptSeconds % 60;
    int hours = exceptSeconds / 3600;
    NSString *stringDate = [NSString stringWithFormat:@"%@ %d:%d",startYmd,hours,minutes];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:formatString];
    NSDate *dateByFormated = [dateFormatter dateFromString:stringDate];
    
    return dateByFormated;
}


/**
 Convert fixed time(15:10) to NSDate

 @param HHmmString ex: "15:10"
 @param startYmd ex: "1970/01/01"
 @param formatString formatString ex: "yyyy/mm/dd HH:mm"  -> It's so terrible, it must be HH by 24h.
 @return NSDate object
 */
- (NSDate*) ConvertToHoursAndMinutesWithStringOfHHmm:(NSString*)HHmmString withStartYmd:(NSString *)startYmd withFormat:(NSString *)formatString{
    
    NSString *stringDate = [NSString stringWithFormat:@"%@ %@",startYmd,HHmmString];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:formatString];
    NSDate *dateByFormated = [dateFormatter dateFromString:stringDate];
    
    return dateByFormated;
}

@end
