//
//  Created by ShareSDK.cn on 13-1-14.
//  官网地址:http://www.ShareSDK.cn
//  技术支持邮箱:support@sharesdk.cn
//  官方微信:ShareSDK   （如果发布新版本的话，我们将会第一时间通过微信将版本更新内容推送给您。如果使用过程中有任何问题，也可以通过微信与我们取得联系，我们将会在24小时内给予回复）
//  商务QQ:4006852216
//  Copyright (c) 2013年 ShareSDK.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *	@brief	新浪地理位置信息
 */
@interface SSSinaWeiboGeo : NSObject <NSCoding>
{
@private
    NSMutableDictionary *_sourceData;
}

/**
 *	@brief	类型：Point
 */
@property (nonatomic,readonly) NSString *type;

/**
 *	@brief	纬度
 */
@property (nonatomic,readonly) CGFloat latitude;

/**
 *	@brief	经度
 */
@property (nonatomic,readonly) CGFloat longitude;

/**
 *	@brief	源数据
 */
@property (nonatomic,retain) NSDictionary *sourceData;

/**
 *	@brief	创建地理位置信息
 *
 *	@param 	response 	回复数据
 *
 *	@return	地理位置信息
 */
+ (SSSinaWeiboGeo *)geoWithResponse:(NSDictionary *)response;

@end
