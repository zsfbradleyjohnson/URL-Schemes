//
//  BJPay.h
//  johnson
//
//  Created by bradleyjohnson on 16/8/25.
//  Copyright © 2016年 bradleyjohnson. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,BJPayResult) {
    BJPayResult_Failure = 0,
    BJPayResult_Cancle  = 2000,
    BJPayResult_Success = 6000,
    BJPayResult_Unknow  = 9000,
};

typedef void(^CompletionBlock)(NSDictionary * dictionary);

@interface BJPay : NSObject

/**
 *  创建支付单例服务
 *
 *  @return 返回单例对象
 */
+ (instancetype)defaultService;




/**
 *  支付接口
 *
 *  @param orderStr       订单信息
 *  @param schemeStr      调用支付的app注册在info.plist中的scheme
 *  @param compltionBlock 支付结果回调Block
 */
- (void)payOrder:(NSString *)orderStr
      fromScheme:(NSString *)schemeStr
        callback:(CompletionBlock)completionBlock;




/**
 *  处理钱包或者独立快捷app支付跳回商户app携带的支付结果Url
 *
 *  @param resultUrl 支付结果url，传入后由SDK解析，统一在上面的pay方法的callback中回调
 *  @param completionBlock 跳钱包支付结果回调，保证跳转钱包支付过程中，即使调用方app被系统kill时，能通过这个回调取到支付结果。
 */
- (void)processOrderWithPaymentResult:(NSURL *)resultUrl
                      standbyCallback:(CompletionBlock)completionBlock;




@end