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
#import "Config.h"
#import "Utils.h"
#import "EnumUtil.h"
#import "PchHeader.h"
@implementation HttpUtil

+(void)post:(NSString *)urlpath
      param:(id)dict
     finish:(CompletionHandler)completion{
    
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

+(void)get:(NSString *)urlpath
     param:(id)dict
    finish:(CompletionHandler)completion{
    
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

+(void)postFile:(NSString *)urlpath
           file:(NSData *)data
           name:(NSString *)name
       fileName:(NSString *)fileName
          param:(NSDictionary *)dict
         finish:(CompletionHandler)completion{
    
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

+(void)postFormData:(NSString *)urlpath
              param:(NSDictionary *)dict
             finish:(CompletionHandler)completion{
    
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
 *  处理失败的请求
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
    
    [self handleHeader:task];
    DebugLog(@"\n===========response===========\n%@:\n%@", urlpath, error);
    NSString *description = error.userInfo[@"NSLocalizedDescription"];
    NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
    
    if(data != nil){
        NSDictionary *content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString *message = [content valueForKey:@"message"];
        if (message == nil || [message isKindOfClass:[NSNull class]]) {
            message = @"服务器发生未知错误!";
        }
        
        completion(nil ,message);
    }else{
        completion(nil,description);
    }
}

/**
 *  处理成功的请求
 *
 *  @param responseObject 响应对象
 *  @param task           任务
 *  @param urlpath        地址
 *  @param completion     回调
 */
+(void)handleSuccessWithResponseObject:(id)responseObject
                                  task:(NSURLSessionDataTask *)task
                               urlPath:(NSString *)urlpath
                                finish:(CompletionHandler)completion{
    NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    if (obj == nil) {
        obj = @{@"success":[[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding]};
    }
    DebugLog(@"\n===========response===========\n%@:\n%@", urlpath, obj);
    if(![self handleHeader:task]){
        completion(obj ,nil);
    }else{
        completion(obj,@"错误");
    }
    
}

/**
 *  处理响应头
 *
 *  @param session 任务
 *
 *  @return bool
 */
+(BOOL)handleHeader:(NSURLSessionDataTask *) session{
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)session.response;
    NSDictionary *dic = response.allHeaderFields;
    
    id failure = [dic valueForKey:@"failure"];
    if(failure){
        int type = [[dic valueForKey:@"exceptionType"] intValue];
        NSLog(@"\n=============header==================\n%@\n",[EnumUtil exceptionTypeString:type] );
        if (type == (int)ExceptionTypeNotLogin)  {
            NSArray *accountAndPassword = [Config getUserNameAndPassword];
            NSString *name = accountAndPassword? accountAndPassword[0] : @"";
            NSString *password = accountAndPassword? accountAndPassword[1] : @"";
            [[AppManager getInstance] reLoginWithUserName:name andPassword:password finishBlock:^(id data, NSString *error) {
                if(error){
                    [Utils showHudTipStr:@"重登陆失败，请手动登录！"];
                }
            }];
        }
    }
    return failure;
}

@end
