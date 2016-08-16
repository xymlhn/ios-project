//
//  RestApiHelper.m
//  qmcp
//
//  Created by 谢永明 on 16/3/9.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "HttpUtil.h"
#import "AFHTTPSessionManager.h"
#import "AppManager.h"
@implementation HttpUtil

+(void)post:(NSString *)urlpath param:(id)dict finish:(CompletionHandler)completion
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    urlpath = [urlpath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    DebugLog(@"\n===========request===========\n%@\n%@:\n%@", @"post", urlpath, dict);
    [manager POST:urlpath parameters:dict progress:nil success:^(NSURLSessionDataTask * session, id responseObject){
       [self handleSuccessWithResponseObject:responseObject task:session urlPath:urlpath finish:completion];
        
    }failure:^(NSURLSessionDataTask * task, NSError * error){
        
        [self handleFailureWithError:error task:task urlPath:urlpath finish:completion];
       
    }];
}

+(void)get:(NSString *)urlpath param:(id)dict finish:(CompletionHandler)completion
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    urlpath = [urlpath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    DebugLog(@"\n===========request===========\n%@\n%@:\n%@", @"get", urlpath, dict);
    [manager GET:urlpath parameters:dict progress:nil success:^(NSURLSessionDataTask * session, id responseObject){
       [self handleSuccessWithResponseObject:responseObject task:session urlPath:urlpath finish:completion];
        
    }failure:^(NSURLSessionDataTask * task, NSError * error){
        [self handleFailureWithError:error task:task urlPath:urlpath finish:completion];
    }];
}

+(void)postFile:(NSString *)urlpath file:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName param:(NSDictionary *)dict finish:(CompletionHandler)completion
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    urlpath = [urlpath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    DebugLog(@"\n===========request===========\n%@\n%@:\n%@", @"post", urlpath, dict);
    [manager POST:urlpath parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:data name:name fileName:fileName  mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       [self handleSuccessWithResponseObject:responseObject task:task urlPath:urlpath finish:completion];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleFailureWithError:error task:task urlPath:urlpath finish:completion];
    }];
}

+(void)postFormData:(NSString *)urlpath param:(NSDictionary *)dict finish:(CompletionHandler)completion
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    urlpath = [urlpath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    DebugLog(@"\n===========request===========\n%@\n%@:\n%@", @"post", urlpath, dict);
    [manager POST:urlpath parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData){
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self handleSuccessWithResponseObject:responseObject task:task urlPath:urlpath finish:completion];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleFailureWithError:error task:task urlPath:urlpath finish:completion];
    }];
}

/**
 *  处理请求失败
 *
 *  @param error      错误
 *  @param task       任务
 *  @param urlpath    地址
 *  @param completion 回调
 */
+(void)handleFailureWithError:(NSError *)error
                         task:(NSURLSessionDataTask *)task
                      urlPath:(NSString *)urlpath
                       finish:(CompletionHandler)completion{
    
    [[AppManager getInstance] handleHeader:task];
    DebugLog(@"\n===========response===========\n%@:\n%@", urlpath, error);
    NSString *description = error.userInfo[@"NSLocalizedDescription"];
    NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
    
    if(data != nil){
        NSDictionary *content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString *message = [content valueForKey:@"message"];
        if (message == nil) {
            message = @"服务器发生未知错误!";
        }
        
        completion(nil ,message);
    }else{
        completion(nil,description);
    }
}

+(void)handleSuccessWithResponseObject:(id)responseObject
                                  task:(NSURLSessionDataTask *)task
                               urlPath:(NSString *)urlpath
                                finish:(CompletionHandler)completion{
    NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    DebugLog(@"\n===========response===========\n%@:\n%@", urlpath, obj);
    if(![[AppManager getInstance] handleHeader:task]){
        completion(obj ,nil);
    }else{
        completion(obj,@"错误");
    }
    
}

@end
