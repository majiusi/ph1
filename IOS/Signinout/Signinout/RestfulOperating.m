//
//  RestfulOperating.m
//  Signinout
//
//  Created by yaochenxu on 2016/08/06.
//  Copyright © 2016年 maiasoft. All rights reserved.
//

#import "RestfulOperating.h"

@interface RestfulOperating()
// save data for userPunchListData from webservice
@property (nonatomic,strong) NSDictionary* punchListData;
@end



@implementation RestfulOperating


-(NSDictionary*)getUserPunchListData{
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:@"192.168.0.6" customHeaderFields:nil];
    MKNetworkOperation *op = [engine operationWithPath:@"api/labourTimeList" params:nil httpMethod:@"GET" ssl:NO];

    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        
        NSLog(@"responseData : %@", [operation responseString]);
        NSData *data  = [operation responseData];
        self.punchListData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        //[self reloadView:resDict];
        
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        NSLog(@"MKNetwork请求错误 : %@", [err localizedDescription]);
    }];
    [engine enqueueOperation:op];
    
    return self.punchListData;

}

@end