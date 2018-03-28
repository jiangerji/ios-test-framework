//
//  NSObject+QMSwizzle.h
//  StarMaker
//
//  Created by 江林 on 2018/1/26.
//  Copyright © 2018年 uShow. All rights reserved.
//

#ifndef NSObject_QMSwizzle_h
#define NSObject_QMSwizzle_h

#import <Foundation/Foundation.h>

#import "QMCrashKit.h"

/*
 * This category adds methods to the NSObject.
 */
@interface NSObject(QMSwizzle)

- (void)swizzleMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;

+ (void)swizzleClassMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;

+ (void)qmReportCrash:(NSString *)className selector:(NSString *)selector;

@end

#endif /* NSObject_QMSwizzle_h */
