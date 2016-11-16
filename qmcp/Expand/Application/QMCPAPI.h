//
//  QMCPAPI.h
//  iosapp
//
//  Created by 谢永明 on 16/3/4.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#ifndef iosapp_QMCPAPI_h
#define iosapp_QMCPAPI_h

//#define QMCPAPI_ADDRESS             @"http://192.168.13.63:8080/"
//#define QMCPAPI_ADDRESS             @"http://inforshare.vicp.cc:8000/"
#define QMCPAPI_ADDRESS                  @"http://www.efw365.com/"

#define QMCPAPI_LOGIN                    @"api/login"
#define QMCPAPI_LOGOUT                   @"api/logout"
#define QMCPAPI_SERVER_TIME              @"a/api/servertime"
#define QMCPAPI_NICKNAME                 @"i/a/api/user/nickname"
#define QMCPAPI_PUSHID                   @"i/a/api/push/id/"
#define QMCPAPI_ATTACHMENT               @"i/a/api/attachment/"
#define QMCPAPI_ISONWORK                 @"i/a/api/isonwork"
#define QMCPAPI_LOCATION                 @"/i/a/api/gis/location/"
#define QMCPAPI_IMAGEURL                 @"i/a/api/attachment/get"
#define QMCPAPI_USERICONURL              @"i/a/api/user/info/portrait/"
#define QMCPAPI_MANUAL                   @"api/appoperationmanual"

#define QMCPAPI_COMMODITYITEM            @"i/a/api/commodity/item?lastUpdateTime="
#define QMCPAPI_COMMODITYSNAPSHOT        @"i/a/api/commodity/baseinfo?lastUpdateTime="
#define QMCPAPI_COMODITYPROPERTY         @"i/a/api/commodity/property?lastUpdateTime="

//*********************工单接口*******************//
//根据code获取工单
#define QMCPAPI_WORKORDER                @"i/a/api/workorder/"
//获取所有工单
#define QMCPAPI_ALL_WORKORDER            @"i/a/api/workorder?lastUpdateTime="
//提交工单步骤数据
#define QMCPAPI_POSTWORKORDERSTEP        @"i/a/api/workorder/"
//工单时间戳
#define QMCPAPI_TIMESTAMP                @"i/a/api/workorder/timestamp/"
//根据物品code获取工单
#define QMCPAPI_GETWORKORDERBYITEMCODE   @"i/a/api/workorder/item/"

#define QMCPAPI_SEARCH                   @"i/a/api/workorder/search"

#define QMCPAPI_COMMODITYSTEP            @"i/a/api/commodity/step?lastUpdateTime="
//*********************取件接口*******************//
#define QMCPAPI_PICKUPITEM               @"i/a/api/salesorder/item/"
#define QMCPAPI_PICKUPSIGNATURE          @"i/a/api/salesorder/item/"
#define QMCPAPI_ITEM_COMPLETE            @"i/a/api/salesorder/itemcomplete/"


//*********************清点接口*******************//
#define QMCPAPI_POSTINVENTORY   @"i/a/api/salesorder/item/"

//*********************摄像头接口*******************//
//获取当前账号所有摄像头
#define QMCPAPI_ALL_CAMERA               @"i/a/api/camera/"
//获取当前工单已开摄像头
#define QMCPAPI_CURRENT_CAMERA           @"i/a/api/camera/workorder/"
//切换工单摄像头
#define QMCPAPI_CAMERA_SWITCH            @"i/a/api/camera/switch/workorder/"
//获取当前工单已开摄像头
#define QMCPAPI_CURRENT_SALESORDER_CAMERA           @"i/a/api/camera/salesorder/"
//切换订单摄像头
#define QMCPAPI_CAMERA_SALESORDER_SWITCH            @"i/a/api/camera/switch/salesorder/"

//*********************订单接口*******************//
//我的订单
#define QMCPAPI_SALESORDERMINE           @"i/a/api/salesorder/mine?lastUpdateTime="
//待接订单
#define QMCPAPI_SALESORDERCONFIRM        @"i/a/api/salesorder/confirm?lastUpdateTime="
//接单
#define QMCPAPI_SALESORDERGRAB           @"i/a/api/salesorder/confirm/"
//完成订单
#define QMCPAPI_SALESORDERCOMPLETE       @"i/a/api/salesorder/complete/"
//商家下单
#define QMCPAPI_BUSINESSSALESORDER       @"/i/a/api/salesorder/create"
//搜索清点订单
#define QMCPAPI_SALESORDERSEARCH         @"i/a/api/salesorder/check"
#define QMCPAPI_SALESORDERITEM           @"i/a/api/salesorder/commodityItem/"
#define QMCPAPI_POSTSALESORDERSTEP       @"i/a/api/salesorder/"

//*********************表单接口*******************//
#define QMCPAPI_FORMTEMPLATE             @"i/a/api/salesorder/form/template?salesOrderCode="
#define QMCPAPI_FORMDATA                 @"i/a/api/salesorder/form/data?salesOrderCode="
#define QMCPAPI_SAVE_FORMDATA            @"i/a/api/salesorder/form/data"
#define QMCPAPI_DELETE_FORMDATA          @"i/a/api/salesorder/form/data/"




#endif
