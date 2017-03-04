//
//  HttpResponseErrorCode.m
//  Signinout
//
//  Created by yaochenxu on 2016/12/25.
//  Copyright © 2016年 Yaochenxu. All rights reserved.
//

#import "HttpResponseErrorCode.h"

/**
 Get statusCode form AFNetworking's (NSURLSessionDataTask *task), be used at WebServiceAPI.m

 @param task <#task description#>
 @return <#return value description#>
 */
NSInteger getErrorStatusCode (NSURLSessionDataTask *task){
    NSHTTPURLResponse *httpRespone = (NSHTTPURLResponse *)task.response;
    return (NSInteger)httpRespone.statusCode;
}

/**
 Get errorCode form AFNetworking's (NSError * error), be used at WebServiceAPI.m

 @param error <#error description#>
 @return <#return value description#>
 */
NSInteger getErrorCode (NSError *error){
    if(error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] != nil){
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:0 error:nil ];
        
        NSString *errorCode = responseDict[@"errorCode"];
        
        return [errorCode intValue];
    }else return 901;
}

/**
 Get errorCode form AFNetworking's (NSError * error) by Dictionary type, be used at WebServiceAPI.m

 @param error <#error description#>
 @return <#return value description#>
 */
NSDictionary* getError (NSError *error){
    if(error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] != nil){
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:0 error:nil ];
        
        return responseDict;
    }else return nil;
}
