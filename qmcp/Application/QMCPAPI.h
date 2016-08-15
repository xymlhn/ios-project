//
//  QMCPAPI.h
//  iosapp
//
//  Created by chenhaoxiang on 14-10-16.
//  Copyright (c) 2014年 QMCPhina. All rights reserved.
//

#ifndef iosapp_QMCPAPI_h
#define iosapp_QMCPAPI_h

//#define QMCPAPI_ADDRESS             @"http://192.168.13.60:8080/"
//#define QMCPAPI_ADDRESS             @"http://inforshare.vicp.cc:8000/"
#define QMCPAPI_ADDRESS                  @"http://www.efw365.com/"
#define QMCPAPI_LOGIN                    @"api/login"
#define QMCPAPI_LOGOUT                   @"api/logout"
#define QMCPAPI_SERVER_TIME              @"a/api/servertime"
#define QMCPAPI_WORKORDER                @"i/a/api/workorder/"
#define QMCPAPI_ALL_WORKORDER            @"i/a/api/workorder?lastUpdateTime="
#define QMCPAPI_POSTWORKORDERSTEP        @"i/a/api/workorder/"
#define QMCPAPI_POSTWORKORDERINVENTORY   @"i/a/api/salesorder/item/"
#define QMCPAPI_PUSHID                   @"i/a/api/push/id/"
#define QMCPAPI_NICKNAME                 @"i/a/api/user/nickname"
#define QMCPAPI_TIMESTAMP                @"i/a/api/workorder/timestamp/"
#define QMCPAPI_ATTACHMENT               @"i/a/api/attachment/"
#define QMCPAPI_PICKUPITEM               @"i/a/api/salesorder/item/"
#define QMCPAPI_PICKUPSIGNATURE          @"i/a/api/salesorder/item/"
#define QMCPAPI_SALESORDERBIND           @"i/a/api/salesorder/bind?lastUpdateTime="
#define QMCPAPI_SALESORDERCONFIRM        @"i/a/api/salesorder/confirm?lastUpdateTime="
#define QMCPAPI_SALESORDERGRAB           @"i/a/api/salesorder/confirm/"
#define QMCPAPI_MANUAL                   @"api/appoperationmanual"
#define QMCPAPI_COMMODITYITEM            @"i/a/api/commodity/item?lastUpdateTime="
#define QMCPAPI_COMODITYPROPERTY         @"i/a/api/commodity/property?lastUpdateTime="
#define QMCPAPI_GETWORKORDERBYITEMCODE   @"i/a/api/workorder/item/"
#define QMCPAPI_ALL_CAMERA               @"i/a/api/camera/"
#define QMCPAPI_CURRENT_CAMERA           @"i/a/api/camera/"
#define QMCPAPI_CAMERA_SWITCH            @"i/a/api/camera/switch/"
#define QMCPAPI_FORMTEMPLATE             @"i/a/api/salesorder/form/template?salesOrderCode="
#define QMCPAPI_FORMDATA                 @"i/a/api/salesorder/form/data?salesOrderCode="
#define QMCPAPI_SAVE_FORMDATA            @"i/a/api/salesorder/form/data"
#define QMCPAPI_DELETE_FORMDATA          @"i/a/api/salesorder/form/data/"
#define QMCPAPI_ITEM_COMPLETE            @"i/a/api/salesorder/itemcomplete/"
#define QMCPAPI_SEARCH                   @"i/a/api/workorder/search"
#define QMCPAPI_IMAGEURL                 @"i/a/api/attachment/get"
#define QMCPAPI_USERICONURL              @"i/a/api/user/info/portrait/"
#endif
