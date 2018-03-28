//
//  NSString+QMSafe.m
//  StarMaker
//
//  Created by 江林 on 2018/1/31.
//  Copyright © 2018年 uShow. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSObject+QMSwizzle.h"

@implementation NSString (QMSafe)

#ifdef DEBUG
+ (void)testCaseInternal:(NSString *)s {
    [s characterAtIndex:100];
    
    NSRange range = {0, 100};
    [s substringWithRange:range];
    [s substringToIndex:100];
    [s substringFromIndex:100];
    
    NSString *a = nil;
    [s stringByAppendingString:a];
    
    [s rangeOfString:a];
    [s rangeOfString:@"not found" options:NSBackwardsSearch range:NSMakeRange(100, 100)];
}

+ (void)testCase {
    NSString *s = [NSString stringWithFormat:@"%@ %@", @"Hello", @"World"]; // __NSCFString
    [NSString testCaseInternal:s];
    
    s = @"testCase"; // __NSCFConstantString
    [NSString testCaseInternal:s];
}
#endif

+ (void)runSafeGuard {
    // class private function
    [NSString swizzleMethod:@selector(stringByAppendingString:) swizzledSelector:@selector(qm_safeStringByAppendingString:)];
    
    // private function swizzle
    // 顺序非常重要，__NSCFConstantString的替换需要在__NSCFString之前
    [objc_getClass("__NSCFConstantString") swizzleMethod:@selector(characterAtIndex:) swizzledSelector:@selector(qm_safeCharacterAtIndex:)];
    [objc_getClass("__NSCFConstantString") swizzleMethod:@selector(substringWithRange:) swizzledSelector:@selector(qm_safeSubstringWithRange:)];
    [objc_getClass("__NSCFConstantString") swizzleMethod:@selector(substringToIndex:) swizzledSelector:@selector(qm_safeSubstringToIndex:)];
    [objc_getClass("__NSCFConstantString") swizzleMethod:@selector(substringFromIndex:) swizzledSelector:@selector(qm_safeSubstringFromIndex:)];
    [objc_getClass("__NSCFConstantString") swizzleMethod:@selector(rangeOfString:options:range:locale:) swizzledSelector:@selector(qm_safeRangeOfString:options:range:locale:)];

    [objc_getClass("__NSCFString") swizzleMethod:@selector(characterAtIndex:) swizzledSelector:@selector(qm_safeCharacterAtIndex:)];
    [objc_getClass("__NSCFString") swizzleMethod:@selector(substringWithRange:) swizzledSelector:@selector(qm_safeSubstringWithRange:)];
    [objc_getClass("__NSCFString") swizzleMethod:@selector(substringToIndex:) swizzledSelector:@selector(qm_safeSubstringToIndex:)];
    [objc_getClass("__NSCFString") swizzleMethod:@selector(substringFromIndex:) swizzledSelector:@selector(qm_safeSubstringFromIndex:)];
    [objc_getClass("__NSCFString") swizzleMethod:@selector(rangeOfString:options:range:locale:) swizzledSelector:@selector(qm_safeRangeOfString:options:range:locale:)];
}


#pragma mark - Object Private Function
- (unichar)qm_safeCharacterAtIndex:(NSUInteger)index {
    if (index >= [self length]) {
        [QMCrashKit qmReportCrash:NSStringFromClass(self.class) selector:NSStringFromSelector(_cmd)];
        return 0;
    }
    return [self qm_safeCharacterAtIndex:index];
}

- (NSString *)qm_safeSubstringWithRange:(NSRange)range {
    if (range.location + range.length > self.length) {
        [QMCrashKit qmReportCrash:NSStringFromClass(self.class) selector:NSStringFromSelector(_cmd)];
        return @"";
    }
    return [self qm_safeSubstringWithRange:range];
}

- (NSString *)qm_safeSubstringToIndex:(NSUInteger)to {
    if (to > self.length) {
        [QMCrashKit qmReportCrash:NSStringFromClass(self.class) selector:NSStringFromSelector(_cmd)];
        return nil;
    }
    
    return [self qm_safeSubstringToIndex:to];
}

- (NSString *)qm_safeSubstringFromIndex:(NSUInteger)from {
    if (from > self.length) {
        [QMCrashKit qmReportCrash:NSStringFromClass(self.class) selector:NSStringFromSelector(_cmd)];
        return nil;
    }
    
    return [self qm_safeSubstringFromIndex:from];
}

- (NSString *)qm_safeStringByAppendingString:(NSString *)aString {
    if (!aString || ![aString isKindOfClass:[NSString class]]) {
        [QMCrashKit qmReportCrash:NSStringFromClass(self.class) selector:NSStringFromSelector(_cmd)];
        return nil;
    }
    
    return [self qm_safeStringByAppendingString:aString];
}

- (NSRange)qm_safeRangeOfString:(NSString *)searchString
                        options:(NSStringCompareOptions)mask
                          range:(NSRange)searchRange
                         locale:(NSLocale *)locale {
    if (!searchString || ![searchString isKindOfClass:[NSString class]]) {
        [QMCrashKit qmReportCrash:NSStringFromClass(self.class) selector:NSStringFromSelector(_cmd)];
        return NSMakeRange(NSNotFound, 0);
    }
    
    if (searchRange.location > self.length || searchRange.location + searchRange.length > self.length) {
        [QMCrashKit qmReportCrash:NSStringFromClass(self.class) selector:NSStringFromSelector(_cmd)];
        return NSMakeRange(NSNotFound, 0);
    }
    
    return [self qm_safeRangeOfString:searchString options:mask range:searchRange locale:locale];
}

@end
