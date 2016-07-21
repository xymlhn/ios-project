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
    [manager POST:urlpath parameters:dict progress:nil success:^(NSURLSessionDataTask * session, id responseObject){
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if(![[AppManager getInstance] handleHeader:session]){
            completion(obj ,nil);
        }else{
            completion(obj,@"错误");
        }
        
    }failure:^(NSURLSessionDataTask * task, NSError * error){
        [[AppManager getInstance] handleHeader:task];
        NSString *description = error.userInfo[@"NSLocalizedDescription"];
        NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];

        if(data != nil){
            NSDictionary *content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString *message = [content valueForKey:@"message"];
            completion(nil ,message);
        }else{
            completion(nil,description);
        }
       
    }];
}

+(void)get:(NSString *)urlpath param:(id)dict finish:(CompletionHandler)completion
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    urlpath = [urlpath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [manager GET:urlpath parameters:dict progress:nil success:^(NSURLSessionDataTask * session, id responseObject){
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if(![[AppManager getInstance] handleHeader:session]){
            completion(obj ,nil);
        }else{
            completion(obj,@"错误");
        }
        
    }failure:^(NSURLSessionDataTask * task, NSError * error){
        [[AppManager getInstance] handleHeader:task];
        NSString *description = error.userInfo[@"NSLocalizedDescription"];
        NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        
        if(data != nil){
            NSDictionary *content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString *message = [content valueForKey:@"message"];
            completion(nil ,message);
        }else{
            completion(nil,description);
        }
    }];
}

+(void)postFile:(NSString *)urlpath file:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName param:(NSDictionary *)dict finish:(CompletionHandler)completion
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    urlpath = [urlpath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [manager POST:urlpath parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:data name:name fileName:fileName  mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if(![[AppManager getInstance] handleHeader:task]){
            completion(obj ,nil);
        }else
        {
            completion(obj,@"错误");
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        [[AppManager getInstance] handleHeader:task];
        NSString *description = error.userInfo[@"NSLocalizedDescription"];
        NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        
        if(data != nil){
            NSDictionary *content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString *message = [content valueForKey:@"message"];
            completion(nil ,message);
        }else{
            completion(nil,description);
        }
    }];
}

+(void)postFormData:(NSString *)urlpath param:(NSDictionary *)dict finish:(CompletionHandler)completion
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    urlpath = [urlpath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [manager POST:urlpath parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData){
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if(![[AppManager getInstance] handleHeader:task]){
            completion(obj ,nil);
        }else{
            completion(obj,@"错误");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[AppManager getInstance] handleHeader:task];
        NSString *description = error.userInfo[@"NSLocalizedDescription"];
        NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        
        if(data != nil){
            NSDictionary *content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString *message = [content valueForKey:@"message"];
            completion(nil ,message);
        }else{
            completion(nil,description);
        }
    }];
}

@end
