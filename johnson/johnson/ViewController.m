//
//  ViewController.m
//  johnson
//
//  Created by bradleyjohnson on 16/8/25.
//  Copyright © 2016年 bradleyjohnson. All rights reserved.
//

#import "ViewController.h"
#import "BJPay.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (IBAction)jump:(id)sender {
    
    NSString * orderString = [NSString stringWithFormat:@"title=iPhone&info=phoneproductinapple&money=6000"];
    
    [[BJPay defaultService] payOrder:orderString fromScheme:@"johnson" callback:^(NSDictionary *dictionary) {
        
        NSInteger resultcode = [[dictionary objectForKey:@"resultcode"] integerValue];
        
        switch (resultcode) {
            case 0:
            {
                NSLog(@"支付失败");
            }
                break;
            case 2000:
            {
                NSLog(@"支付取消");
            }
                break;
            case 6000:
            {
                NSLog(@"支付成功");
            }
                break;
            case 9000:
            {
                NSLog(@"支付未知");
            }
                break;
        }
        
    }];
    
}


@end
