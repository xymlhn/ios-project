//
//  QMCPAPI.h
//  iosapp
//
//  Created by 谢永明 on 16/3/4.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#ifndef iosapp_QMCPAPI_h
#define iosapp_QMCPAPI_h

#define QMCPAPI_ADDRESS             @"http://192.168.13.25:8080/"
//#define QMCPAPI_ADDRESS                  @"http://www.efw365.com/"

//*********************基础接口*******************//
//登录
#define QMCPAPI_LOGIN                    @"api/login"
//登出
#define QMCPAPI_LOGOUT                   @"api/logout"
//提交个推id
#define QMCPAPI_GETUI                    @"i/a/api/push/id"
#define QMCPAPI_SERVER_TIME              @"a/api/servertime"
#define QMCPAPI_NICKNAME                 @"i/a/api/user/nickname"
#define QMCPAPI_ATTACHMENT               @"i/a/api/attachment/"
//上班
#define QMCPAPI_ISONWORK                 @"i/a/api/isonwork"
//gps
#define QMCPAPI_LOCATION                 @"i/a/api/gis/location/"
//获取图片url
#define QMCPAPI_IMAGEURL                 @"i/a/api/attachment/get"
//用户头像
#define QMCPAPI_USERICONURL              @"i/a/api/user/info/portrait/"
//帮助
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
//搜索工单
#define QMCPAPI_SEARCH                   @"i/a/api/workorder/search"

#define QMCPAPI_COMMODITYSTEP            @"i/a/api/commodity/step?lastUpdateTime="
//*********************取件接口*******************//
#define QMCPAPI_PICKUPITEM               @"i/a/api/salesorder/item/"
#define QMCPAPI_PICKUPSIGNATURE          @"i/a/api/salesorder/item/"
#define QMCPAPI_ITEM_COMPLETE            @"i/a/api/salesorder/itemcomplete/"


//*********************清点接口*******************//
//提交清点数据
#define QMCPAPI_POSTINVENTORY   @"i/a/api/salesorder/item/"
//搜索清点订单
#define QMCPAPI_SALESORDERSEARCH         @"i/a/api/salesorder/check"
#define QMCPAPI_SALESORDERITEM           @"i/a/api/salesorder/commodityItem/"

//*********************摄像头接口*******************//
//获取当前账号所有摄像头
#define QMCPAPI_ALL_CAMERA                         @"i/a/api/camera/"
//获取当前工单已开摄像头
#define QMCPAPI_WORKORDER_CURRENT_CAMERA           @"i/a/api/camera/workorder/"
//获取当前顶单已开摄像头
#define QMCPAPI_SALESORDER_CURRENT_CAMERA           @"i/a/api/camera/salesorder/"
//切换工单摄像头
#define QMCPAPI_CAMERA_WORKORDER_SWITCH             @"i/a/api/camera/switch/workorder/"
//切换订单摄像头
#define QMCPAPI_CAMERA_SALESORDER_SWITCH            @"i/a/api/camera/switch/salesorder/"

//*********************订单接口*******************//
//我的订单
#define QMCPAPI_SALESORDERMINE           @"i/a/api/salesorder/mine?lastUpdateTime="
//待接订单
#define QMCPAPI_SALESORDERCONFIRM        @"i/a/api/salesorder/confirm?lastUpdateTime="
//接单
#define QMCPAPI_SALESORDERGRAB           @"i/a/api/salesorder/confirm/"
//订单时间戳
#define QMCPAPI_SALESORDER_TIMESTAMP     @"i/a/api/salesorder/timestamp/"
//完成订单
#define QMCPAPI_SALESORDERCOMPLETE       @"i/a/api/salesorder/complete/"
//商家下单
#define QMCPAPI_BUSINESSSALESORDER       @"/i/a/api/salesorder/create"
//提交订单步骤
#define QMCPAPI_POSTSALESORDERSTEP       @"i/a/api/salesorder/"
//订单详细
#define QMCPAPI_SALESORDERDETAIL         @"/i/a/api/salesorder/"
//更改协议价
#define QMCPAPI_SALESORDERAGREEPRICE     @"/i/a/api/salesorder/agreementprice/"
//*********************表单接口*******************//
//获取表单模板
#define QMCPAPI_FORMTEMPLATE             @"i/a/api/salesorder/form/template?salesOrderCode="
//获取表单数据
#define QMCPAPI_FORMDATA                 @"i/a/api/salesorder/form/data?salesOrderCode="
//提交表单数据
#define QMCPAPI_SAVE_FORMDATA            @"i/a/api/salesorder/form/data"
//删除表单数据
#define QMCPAPI_DELETE_FORMDATA          @"i/a/api/salesorder/form/data/"




#endif
