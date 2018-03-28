//
//  NSMutableString+QMSafe.m
//  StarMaker
//
//  Created by 江林 on 2018/2/1.
//  Copyright © 2018年 uShow. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSObject+QMSwizzle.h"

@implementation NSMutableString (QMSafe)

#ifdef DEBUG
+ (void)testCase {
    NSString *nilS = nil;
    NSMutableString *s = [NSMutableString stringWithFormat:@"%@ %@", @"hello", @"world"];
    [s setString:nilS];
    
    [s appendString:nilS];
    
    [s deleteCharactersInRange:NSMakeRange(11, 100)];
    [s deleteCharactersInRange:NSMakeRange(10, 1)]; // 这本身就不会崩溃
    [s deleteCharactersInRange:NSMakeRange(10, 0)]; // 这本身就不会崩溃
    
    [s insertString:nilS atIndex:0];
    [s insertString:@"haha" atIndex:20];
    
    [s replaceCharactersInRange:NSMakeRange(100, 10) withString:nilS];
    [s replaceCharactersInRange:NSMakeRange(0, 5) withString:nilS];
    
    [s replaceOccurrencesOfString:nilS withString:nilS options:NSLiteralSearch range:NSMakeRange(100, 1)];
    [s replaceOccurrencesOfString:@"Hello" withString:nilS options:NSLiteralSearch range:NSMakeRange(100, 1)];
    [s replaceOccurrencesOfString:@"Hello" withString:@"Yelp" options:NSLiteralSearch range:NSMakeRange(100, 1)];
    [s replaceOccurrencesOfString:@"Hello" withString:@"Yelp" options:NSLiteralSearch range:NSMakeRange(0, 12)];
}
#endif

+ (void)runSafeGuard {
    [objc_getClass("__NSCFString") swizzleMethod:@selector(setString:) swizzledSelector:@selector(QM_safeSetString:)];
    
    [objc_getClass("__NSCFString") swizzleMethod:@selector(appendString:) swizzledSelector:@selector(QM_safeAppendString:)];

    [objc_getClass("__NSCFString") swizzleMethod:@selector(deleteCharactersInRange:) swizzledSelector:@selector(QM_safeDeleteCharactersInRange:)];

    [objc_getClass("__NSCFString") swizzleMethod:@selector(insertString:atIndex:) swizzledSelector:@selector(QM_safeInsertString:atIndex:)];

    [objc_getClass("__NSCFString") swizzleMethod:@selector(replaceCharactersInRange:withString:) swizzledSelector:@selector(QM_safeReplaceCharactersInRange:withString:)];

    [objc_getClass("__NSCFString") swizzleMethod:@selector(replaceOccurrencesOfString:withString:options:range:) swizzledSelector:@selector(QM_safeReplaceOccurrencesOfString:withString:options:range:)];
   
}

#pragma mark - Object Private Function

- (void)QM_safeSetString:(NSString *)aString {
    if (!aString || ![aString isKindOfClass:[NSString class]]) {
        [QMCrashKit qmReportCrash:NSStringFromClass(self.class) selector:NSStringFromSelector(_cmd)];
        return;
    }
    
    return [self QM_safeSetString:aString];
}

- (void)QM_safeAppendString:(NSString *)aString {
    if (!aString || ![aString isKindOfClass:[NSString class]]) {
        [QMCrashKit qmReportCrash:NSStringFromClass(self.class) selector:NSStringFromSelector(_cmd)];
        return;
    }
    
    return [self QM_safeAppendString:aString];
}

- (void)QM_safeDeleteCharactersInRange:(NSRange)range {
    if (range.location > self.length || range.location + range.length > self.length) {
        [QMCrashKit qmReportCrash:NSStringFromClass(self.class) selector:NSStringFromSelector(_cmd)];
        return;
    }
    
    [self QM_safeDeleteCharactersInRange:range];
}

- (void)QM_safeInsertString:(NSString *)aString atIndex:(NSUInteger)loc {
    if (!aString || ![aString isKindOfClass:[NSString class]]) {
        [QMCrashKit qmReportCrash:NSStringFromClass(self.class) selector:NSStringFromSelector(_cmd)];
        return;
    }
    
    if (loc > self.length) {
        [QMCrashKit qmReportCrash:NSStringFromClass(self.class) selector:NSStringFromSelector(_cmd)];
        return;
    }
    
    [self QM_safeInsertString:aString atIndex:loc];
}

- (void)QM_safeReplaceCharactersInRange:(NSRange)range withString:(NSString *)aString {
    if (range.location > self.length || range.location + range.length > self.length) {
        [QMCrashKit qmReportCrash:NSStringFromClass(self.class) selector:NSStringFromSelector(_cmd)];
        return;
    }
    
    if (!aString || ![aString isKindOfClass:[NSString class]]) {
        [QMCrashKit qmReportCrash:NSStringFromClass(self.class) selector:NSStringFromSelector(_cmd)];
        return;
    }
    
    [self QM_safeReplaceCharactersInRange:range withString:aString];
}

- (NSUInteger)QM_safeReplaceOccurrencesOfString:(NSString *)target
                                     withString:(NSString *)replacement
                                        options:(NSStringCompareOptions)options
                                          range:(NSRange)searchRange {
    if (!target || ![target isKindOfClass:[NSString class]]) {
        [QMCrashKit qmReportCrash:NSStringFromClass(self.class) selector:NSStringFromSelector(_cmd)];
        return 0;
    }
    
    if (!replacement || ![replacement isKindOfClass:[NSString class]]) {
        [QMCrashKit qmReportCrash:NSStringFromClass(self.class) selector:NSStringFromSelector(_cmd)];
        return 0;
    }
    
    if (searchRange.location > self.length || searchRange.location + searchRange.length > self.length) {
        [QMCrashKit qmReportCrash:NSStringFromClass(self.class) selector:NSStringFromSelector(_cmd)];
        return 0;
    }
    
    return [self QM_safeReplaceOccurrencesOfString:target
                                        withString:replacement
                                           options:options
                                             range:searchRange];
}


@end
