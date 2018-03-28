//
//  NSObject+QMSwizzle.m
//  StarMaker
//
//  Created by 江林 on 2018/1/26.
//  Copyright © 2018年 uShow. All rights reserved.
//

#import "NSObject+QMSwizzle.h"
#import <objc/runtime.h>

#import <Crashlytics/Crashlytics.h>

@implementation NSObject(QMSwizzle)

- (void)swizzleMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)swizzleClassMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    [object_getClass((id)self) swizzleMethod:originalSelector swizzledSelector:swizzledSelector];
}

// 用于debug环境下，提示测试，系统发生异常，然后向fabric上传此时的调用栈
+ (void)qmReportCrash:(NSString *)className selector:(NSString *)selector {
//#ifdef DEBUG
//    NSArray *crashArray = [NSThread  callStackSymbols];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Not Contact" style:UIAlertActionStyleCancel handler:nil];
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Happend Crash, Pls contact the developer" message:crashArray.description preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:cancelAction];
//
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
//#endif
    NSString *errorName = @"qmReportCrash";
    @try {
        errorName = [NSString stringWithFormat:@"%@:%@", className, selector];
    } @catch (NSException *exception) {
        
    }
    
    // 上传崩溃栈到fabric
    NSError *error = [NSError errorWithDomain:errorName code:0xDEAD userInfo:nil];
    [[Crashlytics sharedInstance] recordError:error];
    
    QMLogD(@"report crash: %@\n", errorName);
}

@end
