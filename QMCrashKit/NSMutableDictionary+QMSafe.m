//
//  NSMutableDictionary+QMSafe.m
//  StarMaker
//
//  Created by 江林 on 2018/2/1.
//  Copyright © 2018年 uShow. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSObject+QMSwizzle.h"

@implementation NSMutableDictionary (QMSafe)

#pragma mark - Class Public Function

#ifdef DEBUG
+ (void)testCase {
    NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
    NSString *rightKey = @"rightKey";
    NSString *rignthValue = @"rightValue";
    
    NSString *nilKey = nil;
    NSString *nilValue = nil;
    
    [d setObject:nilValue forKey:rightKey];
    [d setObject:rignthValue forKey:nilKey];
    
    [d removeObjectForKey:nilKey];
    [d removeObjectForKey:rightKey];
    
    [d setValue:nilValue forKey:rightKey]; // this line is ok
    [d setValue:rignthValue forKey:nilKey];
}
#endif

+ (void)runSafeGuard {
    [objc_getClass("__NSDictionaryM") swizzleMethod:@selector(setObject:forKey:) swizzledSelector:@selector(QM_safeSetObject:forKey:)];
    [objc_getClass("__NSDictionaryM") swizzleMethod:@selector(removeObjectForKey:) swizzledSelector:@selector(QM_safeRemoveObjectForKey:)];
}

#pragma mark - Object Private Function

- (void)QM_safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if(!anObject || !aKey) {
        [QMCrashKit qmReportCrash:NSStringFromClass(self.class) selector:NSStringFromSelector(_cmd)];
        return;
    }
    
    [self QM_safeSetObject:anObject forKey:aKey];
}

- (void)QM_safeRemoveObjectForKey:(id<NSCopying>)aKey {
    if(!aKey) {
        [QMCrashKit qmReportCrash:NSStringFromClass(self.class) selector:NSStringFromSelector(_cmd)];
        return;
    }
    
    [self QM_safeRemoveObjectForKey:aKey];
}

- (void)QM_safeSetValue:(id)anObject forKey:(id<NSCopying>)aKey {
    if(!aKey) {
        [QMCrashKit qmReportCrash:NSStringFromClass(self.class) selector:NSStringFromSelector(_cmd)];
        return;
    }
    
    [self QM_safeSetValue:anObject forKey:aKey];
}

@end
