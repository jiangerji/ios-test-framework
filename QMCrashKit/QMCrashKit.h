//
//  QMCrashKit.h
//  StarMaker
//
//  Created by 江林 on 2018/1/29.
//  Copyright © 2018年 uShow. All rights reserved.
//

#ifndef QMCrashKit_h
#define QMCrashKit_h

#import <Foundation/Foundation.h>
#import <malloc/malloc.h>
 
#import "NSObject+QMSwizzle.h"
#import "NSArray+QMSafe.h"
#import "NSURL+QMSafe.h"
#import "NSString+QMSafe.h"
#import "NSMutableDictionary+QMSafe.h"
#import "Selector+QMSafe.h"

// 提示框，用于测试时候简单提示开发者或者测试同学
#ifdef DEBUG

#define QM_ALERT_VIEW(Title, Message) do {\
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;\
    UIViewController *currentRootViewController = delegate.window.rootViewController;\
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];\
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:Title message:Message preferredStyle:UIAlertControllerStyleAlert];\
    [alertVc addAction:action];\
    [currentRootViewController presentViewController:alertVc animated:YES completion:nil];\
}while(0);

#else

#define QM_ALERT_VIEW(Title, Message)

#endif

@interface QMCrashKit : NSObject

// 上报异常到fabric的non fatal统计
+ (void)reportException:(NSString *)name reason:(NSString *)reason;

// 上报异常到fabric的non fatal统计
+ (void)reportException:(NSException *)exception;

#pragma debug method

#ifdef DEBUG

+ (void)debugArray;

#endif

@end

#define IS_WILD_POINTER(x) (malloc_zone_from_ptr(x)?NO:YES)

#endif /* QMCrashKit_h */
