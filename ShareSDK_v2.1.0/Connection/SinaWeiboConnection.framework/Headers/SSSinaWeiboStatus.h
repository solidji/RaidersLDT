//
//  Created by ShareSDK.cn on 13-1-14.
//  官网地址:http://www.ShareSDK.cn
//  技术支持邮箱:support@sharesdk.cn
//  官方微信:ShareSDK   （如果发布新版本的话，我们将会第一时间通过微信将版本更新内容推送给您。如果使用过程中有任何问题，也可以通过微信与我们取得联系，我们将会在24小时内给予回复）
//  商务QQ:4006852216
//  Copyright (c) 2013年 ShareSDK.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSSinaWeiboVisible.h"
#import "SSSinaWeiboGeo.h"

@class SSSinaWeiboUser;

/**
 *	@brief	微博信息
 */
@interface SSSinaWeiboStatus : NSObject <NSCoding>
{
@private
    NSMutableDictionary *_sourceData;
}

/**
 *	@brief	微博创建时间
 */
@property (nonatomic,readonly) NSString *createdAt;

/**
 *	@brief	字符串型的微博ID
 */
@property (nonatomic,readonly) NSString *sidStr;

/**
 *	@brief	微博ID
 */
@property (nonatomic,readonly) long long sid;

/**
 *	@brief	微博MID
 */
@property (nonatomic,readonly) long long mid;

/**
 *	@brief	微博信息内容
 */
@property (nonatomic,readonly) NSString *text;

/**
 *	@brief	微博来源
 */
@property (nonatomic,readonly) NSString *source;

/**
 *	@brief	是否已收藏，true：是，false：否
 */
@property (nonatomic,readonly) BOOL favorited;

/**
 *	@brief	是否被截断，true：是，false：否
 */
@property (nonatomic,readonly) BOOL truncated;

/**
 *	@brief	回复ID
 */
@property (nonatomic,readonly) NSString *inReplyToStatusId;

/**
 *	@brief	回复人UID
 */
@property (nonatomic,readonly) NSString *inReplyToUserId;

/**
 *	@brief	回复人昵称
 */
@property (nonatomic,readonly) NSString *inReplyToScreenName;

/**
 *	@brief	缩略图片地址，没有时不返回此字段
 */
@property (nonatomic,readonly) NSString *thumbnailPic;

/**
 *	@brief	中等尺寸图片地址，没有时不返回此字段
 */
@property (nonatomic,readonly) NSString *bmiddlePic;

/**
 *	@brief	原始图片地址，没有时不返回此字段
 */
@property (nonatomic,readonly) NSString *originalPic;

/**
 *	@brief	地理信息字段
 */
@property (nonatomic,readonly) SSSinaWeiboGeo *geo;

/**
 *	@brief	微博作者的用户信息字段
 */
@property (nonatomic,readonly) SSSinaWeiboUser *user;

/**
 *	@brief	转发数
 */
@property (nonatomic,readonly) NSInteger repostsCount;

/**
 *	@brief	评论数
 */
@property (nonatomic,readonly) NSInteger commentsCount;

/**
 *	@brief	暂未支持
 */
@property (nonatomic,readonly) NSInteger attitudesCount;

/**
 *	@brief	暂未支持
 */
@property (nonatomic,readonly) NSInteger mlevel;

/**
 *	@brief	微博的可见性及指定可见分组信息
 */
@property (nonatomic,readonly) SSSinaWeiboVisible *visible;

/**
 *	@brief	被转发微博信息
 */
@property (nonatomic,readonly) SSSinaWeiboStatus *retweetedStatus;

/**
 *	@brief	源数据
 */
@property (nonatomic,retain) NSDictionary *sourceData;

/**
 *	@brief	创建微博信息
 *
 *	@param 	response 	服务器回复数据
 *
 *	@return	微博信息
 */
+ (SSSinaWeiboStatus *)statusWithResponse:(NSDictionary *)response;

@end
