//
//  NSURL_QMSafe.m
//  StarMaker
//
//  Created by 江林 on 2018/1/30.
//  Copyright © 2018年 uShow. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSObject+QMSwizzle.h"

@implementation NSURL (QMSafe)

#ifdef DEBUG
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"

+ (void)testCase {
    NSString *baseUrl = nil;
    NSURL *url = [[NSURL alloc] init];
    [url initWithString:baseUrl];
    NSLog(@"NSURL: url is %@.", url);
    
    [url initWithString:baseUrl relativeToURL:nil];
    NSLog(@"NSURL: url is %@.", url);
    
    [url initFileURLWithPath:baseUrl];
    NSLog(@"NSURL: url is %@.", url);
    
    [url initFileURLWithPath:baseUrl relativeToURL:nil];
    
    [url initFileURLWithPath:baseUrl isDirectory:NO];
    
    [url initFileURLWithPath:baseUrl isDirectory:NO relativeToURL:nil];
    NSLog(@"NSURL: url is %@.", url);
    
    [url URLByAppendingPathComponent:baseUrl];
    
    url = [NSURL fileURLWithPath:baseUrl];
}
#endif

#pragma clang diagnostic pop
+ (void)runSafeGuard {
    // class private function
    [NSURL swizzleClassMethod:@selector(fileURLWithPath:) swizzledSelector:@selector(QM_safeFileURLWithPath:)];
    [NSURL swizzleClassMethod:@selector(fileURLWithPath:isDirectory:) swizzledSelector:@selector(QM_safeFileURLWithPath:isDirectory:)];
    [NSURL swizzleClassMethod:@selector(fileURLWithPathComponents:) swizzledSelector:@selector(QM_safeFileURLWithPathComponents:)];
    [NSURL swizzleClassMethod:@selector(fileURLWithPath:isDirectory:relativeToURL:) swizzledSelector:@selector(QM_safeFileURLWithPath:isDirectory:relativeToURL:)];
    
    // private function swizzle
    [NSURL swizzleMethod:@selector(initWithString:relativeToURL:) swizzledSelector:@selector(QM_safeInitWithString:relativeToURL:)];
    [NSURL swizzleMethod:@selector(initFileURLWithPath:) swizzledSelector:@selector(QM_safeInitFileURLWithPath:)];
    [NSURL swizzleMethod:@selector(initFileURLWithPath:isDirectory:) swizzledSelector:@selector(QM_safeInitFileURLWithPath:isDirectory:)];
    [NSURL swizzleMethod:@selector(URLByAppendingPathComponent:) swizzledSelector:@selector(QM_safeURLByAppendingPathComponent:)];
    [NSURL swizzleMethod:@selector(initFileURLWithPath:isDirectory:relativeToURL:) swizzledSelector:@selector(QM_safeInitFileURLWithPath:isDirectory:relativeToURL:)];
    [NSURL swizzleMethod:@selector(initFileURLWithPath:relativeToURL:) swizzledSelector:@selector(QM_safeInitFileURLWithPath:relativeToURL:)];
}

#pragma mark - Class Private Function

+ (NSURL *)QM_safeFileURLWithPath:(NSString *)path {
    if(!path) {
        [NSURL qmReportCrash:NSStringFromClass(self) selector:NSStringFromSelector(_cmd)];
        return nil;
    }
    
    return [self QM_safeFileURLWithPath:path];
}

+ (NSURL *)QM_safeFileURLWithPath:(NSString *)path isDirectory:(BOOL)isDir {
    if(!path) {
        [NSURL qmReportCrash:NSStringFromClass(self) selector:NSStringFromSelector(_cmd)];
        return nil;
    }
    
    return [self QM_safeFileURLWithPath:path isDirectory:isDir];
}

+ (NSURL *)QM_safeFileURLWithPathComponents:(NSArray<NSString *> *)components {
    if(!components) {
        [NSURL qmReportCrash:NSStringFromClass(self) selector:NSStringFromSelector(_cmd)];
        return nil;
    }
    
    return [self QM_safeFileURLWithPathComponents:components];
}

+ (NSURL *)QM_safeFileURLWithPath:(NSString *)path
                      isDirectory:(BOOL)isDir
                    relativeToURL:(NSURL *)baseURL {
    if (!path || ![path isKindOfClass:[NSString class]]) {
        [NSURL qmReportCrash:NSStringFromClass(self) selector:NSStringFromSelector(_cmd)];
        return nil;
    }
    
    return [self QM_safeFileURLWithPath:path isDirectory:isDir relativeToURL:baseURL];
}

#pragma mark - Object Private Function

- (instancetype)QM_safeURLByAppendingPathComponent:(NSString *)pathComponent {
    if (!pathComponent) {
        [NSURL qmReportCrash:NSStringFromClass(self.class) selector:NSStringFromSelector(_cmd)];
        return nil;
    }
    
    return [self QM_safeURLByAppendingPathComponent:pathComponent];
}

- (instancetype)QM_safeInitWithString:(NSString *)URLString relativeToURL:(NSURL *)baseURL {
    if (!URLString || ![URLString isKindOfClass:[NSString class]]) {
        [NSURL qmReportCrash:NSStringFromClass(self.class) selector:NSStringFromSelector(_cmd)];
        return nil;
    }
    
    return [self QM_safeInitWithString:URLString relativeToURL:baseURL];
}

- (instancetype)QM_safeInitFileURLWithPath:(NSString *)path {
    if (!path || ![path isKindOfClass:[NSString class]]) {
        [NSURL qmReportCrash:NSStringFromClass(self.class) selector:NSStringFromSelector(_cmd)];
        return nil;
    }
    
    return [self QM_safeInitFileURLWithPath:path];
}

- (instancetype)QM_safeInitFileURLWithPath:(NSString *)path
                             relativeToURL:(NSURL *)baseURL {
    if (!path || ![path isKindOfClass:[NSString class]]) {
        [NSURL qmReportCrash:NSStringFromClass(self.class) selector:NSStringFromSelector(_cmd)];
        return nil;
    }
    
    return [self QM_safeInitFileURLWithPath:path relativeToURL:baseURL];
}

- (instancetype)QM_safeInitFileURLWithPath:(NSString *)path
                               isDirectory:(BOOL)isDir {
    if (!path || ![path isKindOfClass:[NSString class]]) {
        [NSURL qmReportCrash:NSStringFromClass(self.class) selector:NSStringFromSelector(_cmd)];
        return nil;
    }
    
    return [self QM_safeInitFileURLWithPath:path isDirectory:isDir];
}

- (instancetype)QM_safeInitFileURLWithPath:(NSString *)path
                               isDirectory:(BOOL)isDir
                             relativeToURL:(NSURL *)baseURL {
    if (!path || ![path isKindOfClass:[NSString class]]) {
        [NSURL qmReportCrash:NSStringFromClass(self.class) selector:NSStringFromSelector(_cmd)];
        return nil;
    }
    
    return [self QM_safeInitFileURLWithPath:path isDirectory:isDir relativeToURL:baseURL];
}

@end
