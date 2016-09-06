//
//  RestApiHelper.h
//  qmcp
//
//  Created by 谢永明 on 16/3/9.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PchHeader.h"

@interface HttpUtil : NSObject

/**
 *  post请求
 *
 *  @param urlpath 地址
 *  @param dict    字典参数
 *  @param block      回调
 */
+(void) post:(NSString *)urlpath
       param:(id)dict
      finish:(CompletionHandler)completion;


/**
 *  get请求
 *
 *  @param urlpath 地址
 *  @param dict    参数
 *  @param block      回调
 */
+(void) get:(NSString *)urlpath
      param:(id)dict
     finish:(CompletionHandler)completion;


/**
 *  上传文件
 *
 *  @param urlpath  地址
 *  @param data     文件参数
 *  @param name     接口名
 *  @param fileName 文件名
 *  @param dict     字典参数
 *  @param block       回调
 */
+(void)postFile:(NSString *)urlpath
           file:(NSData *)data
           name:(NSString *)name
       fileName:(NSString *)fileName
          param:(NSDictionary *)dict finish:(CompletionHandler)completion;

/**
 *  post FormData类型
 *
 *  @param urlpath    地址
 *  @param dict       参数
 *  @param completion 回调
 */
+(void)postFormData:(NSString *)urlpath
              param:(NSDictionary *)dict
             finish:(CompletionHandler)completion;
@end
