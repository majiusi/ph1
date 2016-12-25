//
//  HttpResponseErrorCode.m
//  Signinout
//
//  Created by yaochenxu on 2016/12/25.
//  Copyright © 2016年 maiasoft. All rights reserved.
//

#import "HttpResponseErrorCode.h"

NSInteger getErrorStatusCode (NSURLSessionDataTask *task){
    NSHTTPURLResponse *httpRespone = (NSHTTPURLResponse *)task.response;
    return (NSInteger)httpRespone.statusCode;
}


NSInteger getErrorCode (NSError *error){
    if(error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] != nil){
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:0 error:nil ];
        
        NSString *errorCode = responseDict[@"errorCode"];
        
        return [errorCode intValue];
    }else return 901;
}
NSDictionary* getError (NSError *error){
    if(error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] != nil){
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:0 error:nil ];
        
        return responseDict;
    }else return nil;
}
