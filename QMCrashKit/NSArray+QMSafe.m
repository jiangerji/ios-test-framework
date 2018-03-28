
//
//  NSArray+Safe.m
//  StarMaker
//
//  Created by 李泉 on 2016/12/17.
//  Copyright © 2016年 uShow. All rights reserved.
//


#import "NSArray+QMSafe.h"
#import "NSObject+QMSwizzle.h"
#import "QMCrashKit.h"

@implementation NSArray (QMSafe)

//这个方法无论如何都会执行
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
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("__NSArray0") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(emptyObjectIndex:)];
        [objc_getClass("__NSArrayI") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(arrObjectIndex:)];
        [objc_getClass("__NSArrayM") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(mutableObjectIndex:)];
        [objc_getClass("__NSArrayM") swizzleMethod:@selector(insertObject:atIndex:) swizzledSelector:@selector(mutableInsertObject:atIndex:)];
    });
}

- (id)emptyObjectIndex:(NSUInteger)index{
    [QMCrashKit qmReportCrash:NSStringFromClass(self.class) selector:NSStringFromSelector(_cmd)];
    return nil;
}

- (id)arrObjectIndex:(NSUInteger)index{
    id result = nil;
    
    if (index >= self.count) {
        [QMCrashKit qmReportCrash:NSStringFromClass(self.class) selector:NSStringFromSelector(_cmd)];
    } else {
        result = [self arrObjectIndex:index];
    }
    
    return result;
}

- (id)mutableObjectIndex:(NSUInteger)index{
    @autoreleasepool {
        id result = nil;
        
        if (index >= self.count) {
            [QMCrashKit qmReportCrash:NSStringFromClass(self.class) selector:NSStringFromSelector(_cmd)];
        } else {
            @try {
                result = [self mutableObjectIndex:index];
            } @catch (NSException *exception) {
                [QMCrashKit reportException:exception];
            }
        }
        
        return result;
    }
}

- (void)mutableInsertObject:(id)object atIndex:(NSUInteger)index {
    @autoreleasepool {
        if (object && index <= self.count) {
            @try {
                [self mutableInsertObject:object atIndex:index];
            } @catch (NSException *exception) {
                [QMCrashKit reportException:exception];
            }
        } else {
            [QMCrashKit qmReportCrash:NSStringFromClass(self.class) selector:NSStringFromSelector(_cmd)];
        }
    }
}

@end

#pragma NSDictionary safe

@interface NSDictionary (Safe)

@end
@implementation NSDictionary (Safe)

+ (void)load{
    //    static dispatch_once_t onceToken;
    //    dispatch_once(&onceToken, ^{
    //            [objc_getClass("__NSDictionaryM") swizzleMethod:@selector(setObject:forKey:) swizzledSelector:@selector(mutableSetObject:forKey:)];
    //    });
}

- (void)mutableSetObject:(id)obj forKey:(NSString *)key{
    if (obj && key) {
        [self mutableSetObject:obj forKey:key];
    }
}
@end
@interface UIScrollView (BackgestureRecognizer)

@end
@implementation UIScrollView (BackgestureRecognizer)

+ (void)load{
    
    
  //  [objc_getClass("UIScrollView") swizzleMethod:@selector(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:) swizzledSelector:@selector(safeGestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)];
    
}

- (BOOL)safeGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    CGPoint point = [otherGestureRecognizer locationInView:self];
    NSLog(@"%f %f",point.x,self.contentOffset.x);
    //((point.x - self.contentOffset.x)<= 40.f && point.x >0)
    //self.contentOffset.x <= 0 && otherGestureRecognizer.state == UIGestureRecognizerStateBegan
//    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]
//         && [otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
//        if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"_FDFullscreenPopGestureRecognizerDelegate")]) {
//            [self.panGestureRecognizer requireGestureRecognizerToFail:otherGestureRecognizer];
//            return YES;
//        }
//    }
    if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"_FDFullscreenPopGestureRecognizerDelegate")]) {
        [self.panGestureRecognizer requireGestureRecognizerToFail:otherGestureRecognizer];
        return YES;
    }
    return NO;
}
@end
