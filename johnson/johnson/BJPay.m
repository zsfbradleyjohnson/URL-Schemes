//
//  BJPay.m
//  johnson
//
//  Created by bradleyjohnson on 16/8/25.
//  Copyright © 2016年 bradleyjohnson. All rights reserved.
//

#import "BJPay.h"
#import <UIKit/UIKit.h>

@interface BJPay ()

@property (nonatomic , copy) CompletionBlock dealwithBlock;

@end

static BJPay * pay;

@implementation BJPay

-(void)dealloc
{
    self.dealwithBlock = nil;
}

+(instancetype)defaultService
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pay = [BJPay new];
    });
    
    return pay;
}

/**
 *  支付接口
 *
 *  @param orderStr       订单信息
 *  @param schemeStr      调用支付的app注册在info.plist中的scheme
 *  @param compltionBlock 支付结果回调Block
 */
- (void)payOrder:(NSString *)orderStr
      fromScheme:(NSString *)schemeStr
        callback:(CompletionBlock)completionBlock
{
    if (!schemeStr.length) {
        NSLog(@"schemeStr was empty");
        return;
    }
    
    if (!orderStr.length) {
        NSLog(@"orderStr was empty");
        return;
    }
    
    self.dealwithBlock = completionBlock;
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"bradley://"]]) {
        NSString * urlString = [NSString stringWithFormat:@"bradley://%@?%@",schemeStr,orderStr];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }else{
        NSLog(@"未安装应用!");
    }
}




/**
 *  处理钱包或者独立快捷app支付跳回商户app携带的支付结果Url
 *
 *  @param resultUrl 支付结果url，传入后由SDK解析，统一在上面的pay方法的callback中回调
 *  @param completionBlock 跳钱包支付结果回调，保证跳转钱包支付过程中，即使调用方app被系统kill时，能通过这个回调取到支付结果。
 */
- (void)processOrderWithPaymentResult:(NSURL *)resultUrl
                      standbyCallback:(CompletionBlock)completionBlock
{
    NSString * result = [resultUrl.absoluteString componentsSeparatedByString:@"?"][1];
    NSInteger resultcode = [[[result componentsSeparatedByString:@"&"][0] componentsSeparatedByString:@"="][1] integerValue];
    NSString * resultmessage = [[result componentsSeparatedByString:@"&"][1] componentsSeparatedByString:@"="][1];
    
    NSDictionary * resultDic = @{@"resultcode":@(resultcode),@"resultmessage":resultmessage};
    
    if (completionBlock) {
        completionBlock(@{});
    }
    
    if (self.dealwithBlock) {
        self.dealwithBlock(resultDic);
    }
}


@end
