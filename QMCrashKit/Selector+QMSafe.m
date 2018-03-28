//
//  Selector+QMSafe.m
//  Solo
//
//  Created by 江林 on 2018/2/27.
//  Copyright © 2018年 Starmaker Interactive Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Selector+QMSafe.h"
#import "QMUnRecognizedSelHandler.h"
#import "AppDelegate.h"
#import "QMCrashKit.h"

id dynamicMethodIMP(id self, SEL _cmd){
    NSString *className = nil;
    if ([self isKindOfClass:[QMUnRecognizedSelHandler class] ]) {
        className = [self orignalClassName];
    }
    
    NSString *unrecognizedMethodName = nil;
    if (_cmd) {
        unrecognizedMethodName = NSStringFromSelector(_cmd);
    }
    
#ifdef DEBUG
    // 测试环境下，弹出提示框
    NSString *error = [NSString stringWithFormat:@"errorClass->:%@\n errorFuction->%@\n errorReason->UnRecognized Selector", className, unrecognizedMethodName];
    QM_ALERT_VIEW(@"程序异常，请联系开发人员", error);
#endif
    
    [QMCrashKit qmReportCrash:className selector:unrecognizedMethodName];
    
    // 对于某些需要返回值的selector, 返回一个nil
    return nil;
}

#pragma mark 方法调换
static inline void change_method(Class _originalClass, SEL _originalSel, Class _newClass, SEL _newSel){
    Method methodOriginal = class_getInstanceMethod(_originalClass, _originalSel);
    Method methodNew = class_getInstanceMethod(_newClass, _newSel);
    method_exchangeImplementations(methodOriginal, methodNew);
}

// 是否已经拦截unrecognized method exception
// 因为在iOS 11上，系统类的category的load可能会被调用两次，所以需要这么一个恶心的操作
static BOOL SMUnRecognizedSelHandlerInited = NO;

@implementation NSObject (UnRecognizedSelHandler)
+ (void)load{
    if (SMUnRecognizedSelHandlerInited) {
        return;
    }
    
    //线判断有没有key，再判断根据数据判断能不能hook.
    BOOL canHook = YES; // [[NSUserDefaults standardUserDefaults] boolForKey:SMCanHook];
    
    if (canHook) {
        SMUnRecognizedSelHandlerInited = YES;
        change_method([self class], @selector(forwardingTargetForSelector:), [self class], @selector(SM_forwardingTargetForSelector:));
    }
}

// 判断是不是系统类
+ (BOOL)isSystemeClass:(Class)clazz {
    if (!clazz) {
        return NO;
    }
    
    NSBundle *mainB = [NSBundle bundleForClass:clazz];
    if (mainB == [NSBundle mainBundle]) {
        return NO;
    } else {
        return YES;
    }
}

// 判断某个方法是不是重载了父类的实现
+ (BOOL)aIsMethodOverride:(Class)cls selector:(SEL)sel {
    IMP clsIMP = class_getMethodImplementation(cls, sel);
    IMP superClsIMP = class_getMethodImplementation([cls superclass], sel);
    return clsIMP != superClsIMP;
}

// 位于白名单的类，不需要截获
+ (BOOL)isInwhitList:(Class)class {
    if (!class) {
        return YES;
    }
    
    if ([NSStringFromClass(class) hasPrefix:@"_"] || [NSStringFromClass(class) hasPrefix:@"UI"]) {
        return YES;
    }
    
    if ([class isKindOfClass:[[UIView appearance] class]]) {
        return  YES;
    }
    
    return NO;
}

- (id)SM_forwardingTargetForSelector:(SEL)aSelector {
    //config借口返回会有时差,所以这里也要进行拦截
    Class clazz = [self class];
    
    if ([NSObject isSystemeClass:clazz] || [NSObject isInwhitList:clazz] || [NSObject aIsMethodOverride:clazz selector:aSelector]) {
        return [self SM_forwardingTargetForSelector:aSelector];
    }
    
    if (![self respondsToSelector:aSelector] && ![NSObject aIsMethodOverride:clazz selector:aSelector]) {
        id proxy = nil;
        proxy = [self SM_forwardingTargetForSelector:aSelector];
        if (!proxy) {
            proxy  = [QMUnRecognizedSelHandler new];
            ((QMUnRecognizedSelHandler*) proxy).orignalClassName = NSStringFromClass([self class]);
            if (class_addMethod([QMUnRecognizedSelHandler class], aSelector, (IMP)dynamicMethodIMP, "v@:")) {
                NSLog(@"catch unrecognize method.\n");
            }
        }
        return proxy;
        
    }else{
        return [self SM_forwardingTargetForSelector:aSelector];
    }
}

@end

