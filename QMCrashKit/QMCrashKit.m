//
//  QMCrashKit.m
//  StarMaker
//
//  Created by 江林 on 2018/1/29.
//  Copyright © 2018年 uShow. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Crashlytics/Crashlytics.h>

#import "QMCrashKit.h"

@implementation QMCrashKit

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 启动底层崩溃拦截
        [NSURL runSafeGuard];
        [NSString runSafeGuard];
        [NSMutableString runSafeGuard];
        [NSMutableDictionary runSafeGuard];
    });
}

+ (void)reportException:(NSString *)name reason:(NSString *)reason {
    NSArray<NSNumber *> *callstacks = [NSThread callStackReturnAddresses];
    
    NSMutableArray<CLSStackFrame *> *stackFrames = nil;
    if ([callstacks count] > 1) {
        stackFrames = [[NSMutableArray<CLSStackFrame *> alloc] init];
        for (int i = 1; i < [callstacks count]; i++) {
            [stackFrames addObject:[CLSStackFrame stackFrameWithAddress:[callstacks[i] integerValue]]];
        }
    }
    
    [[Crashlytics sharedInstance] recordCustomExceptionName: name
                                                     reason: reason
                                                 frameArray: stackFrames];
}

+ (void)reportException:(NSException *)exception {
    if (exception) {
        @try {
            NSArray *stack = [exception callStackReturnAddresses];
            [[Crashlytics sharedInstance] recordCustomExceptionName: exception.name
                                                             reason: exception.reason
                                                         frameArray: stack];
        } @catch (NSException *exception) {
            
        }
    }
}

#pragma debug

#ifdef DEBUG

/*但是不同的创建数组的方法导致不同的类簇（其实也就是不同的指针），下面我们就看
 
 NSArray *arr1 =  @[@"1",@"2"];
 
 NSArray *arr2 =  [[NSArray alloc]init];
 
 NSArray *arr2 =  [[NSArray alloc]initwithobjocts:@"1",nil];
 
 NSArray *arr3 =  [NSArray alloc];
 
 NSMutbleArray *arr4 =  [NSMutbleArray array];
 
 你会发现：
 
 1、arr2类名叫_NSArray0
 2、未init的arr3，类名叫做_NSPlaceHolderArray;
 3、初始化后的可变数组类名都叫_NSArrayM;
 4、初始化后的不可变数组类名都叫_NSArrayI.
 */
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"

+ (void)debugArray {
    NSArray *arr1 = [[NSArray alloc] init];
    [arr1 objectAtIndex:1];
    
    NSMutableArray *mutableArr2 = [[NSMutableArray alloc] init];
    [mutableArr2 objectAtIndex:2];
    
    [mutableArr2 insertObject:nil atIndex:0];
}

#pragma clang diagnostic pop
#endif

@end
