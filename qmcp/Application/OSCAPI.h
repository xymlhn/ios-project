//
//  OSCAPI.h
//  iosapp
//
//  Created by chenhaoxiang on 14-10-16.
//  Copyright (c) 2014年 oschina. All rights reserved.
//

#ifndef iosapp_OSCAPI_h
#define iosapp_OSCAPI_h

//#define OSCAPI_ADDRESS             @"http://192.168.13.25:8080/"
//#define OSCAPI_ADDRESS             @"http://inforshare.vicp.cc:8000/"
#define OSCAPI_ADDRESS                  @"http://www.efw365.com/"
#define OSCAPI_LOGIN                    @"api/login"
#define OSCAPI_LOGOUT                   @"api/logout"
#define OSCAPI_SERVER_TIME              @"a/api/servertime"
#define OSCAPI_WORKORDER                @"i/a/api/workorder/"
#define OSCAPI_ALL_WORKORDER            @"i/a/api/workorder?lastUpdateTime="
#define OSCAPI_POSTWORKORDERSTEP        @"i/a/api/workorder/"
#define OSCAPI_PUSHID                   @"i/a/api/push/id/"
#define OSCAPI_NICKNAME                 @"i/a/api/user/nickname"
#define OSCAPI_TIMESTAMP                @"i/a/api/workorder/timestamp/"
#define OSCAPI_ATTACHMENT               @"i/a/api/attachment/"
#define OSCAPI_PICKUPITEM               @"i/a/api/salesorder/item/"
#define OSCAPI_PICKUPSIGNATURE          @"i/a/api/salesorder/item/"
#define OSCAPI_SALESORDERBIND           @"i/a/api/salesorder/bind?lastUpdateTime="
#define OSCAPI_SALESORDERCONFIRM        @"i/a/api/salesorder/confirm?lastUpdateTime="
#define OSCAPI_SALESORDERGRAB           @"i/a/api/salesorder/confirm/"
#define OSCAPI_MANUAL                   @"api/appoperationmanual"
#define OSCAPI_COMMODITYITEM            @"i/a/api/commodity/item?lastUpdateTime="
#define OSCAPI_COMODITYPROPERTY         @"i/a/api/commodity/property?lastUpdateTime="
#define OSCAPI_GETWORKORDERBYITEMCODE   @"i/a/api/workorder/item/"
#define OSCAPI_ALL_CAMERA               @"i/a/api/camera/"
#define OSCAPI_CURRENT_CAMERA           @"i/a/api/camera/"
#define OSCAPI_CAMERA_SWITCH            @"i/a/api/camera/switch/"
#define OSCAPI_FORMTEMPLATE             @"i/a/api/salesorder/form/template?salesOrderCode="
#define OSCAPI_FORMDATA                 @"i/a/api/salesorder/form/data?salesOrderCode="
#define OSCAPI_SAVE_FORMDATA            @"i/a/api/salesorder/form/data"
#define OSCAPI_DELETE_FORMDATA          @"i/a/api/salesorder/form/data/"
#define OSCAPI_ITEM_COMPLETE            @"i/a/api/salesorder/itemcomplete/"

#endif
