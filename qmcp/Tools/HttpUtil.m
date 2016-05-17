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

+(void)post:(NSString *)urlpath param:(id)dict finish:(void (^)(NSDictionary *, NSError *))cb
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    urlpath = [urlpath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [manager POST:urlpath parameters:dict progress:nil success:^(NSURLSessionDataTask * session, id responseObject){
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if(![[AppManager getInstance] handleHeader:session]){
            
            cb(obj ,nil);
        }else{
           
            NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:obj];
            cb(obj,error);
        }
        
    }failure:^(NSURLSessionDataTask * task, NSError * error){
        [[AppManager getInstance] handleHeader:task];
        cb(nil ,error);
    }];
}

+(void)get:(NSString *)urlpath param:(id)dict finish:(void (^)(NSDictionary *, NSError *))cb
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    urlpath = [urlpath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [manager GET:urlpath parameters:dict progress:nil success:^(NSURLSessionDataTask * session, id responseObject){
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if(![[AppManager getInstance] handleHeader:session]){
            cb(obj ,nil);
        }else{
            NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:obj];
            cb(nil,error);
        }
        
    }failure:^(NSURLSessionDataTask * task, NSError * error){
        [[AppManager getInstance] handleHeader:task];
        cb(nil ,error);
    }];
}

+(void)postFile:(NSString *)urlpath file:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName param:(NSDictionary *)dict finish:(void (^)(NSDictionary *, NSError *))cb
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
            cb(obj ,nil);
        }else{
            NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:obj];
            cb(nil,error);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[AppManager getInstance] handleHeader:task];
        cb(nil ,error);
    }];
}


@end
