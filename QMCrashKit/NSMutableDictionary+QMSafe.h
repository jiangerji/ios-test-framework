//
//  NSMutableDictionary+QMSafe.h
//  StarMaker
//
//  Created by 江林 on 2018/2/1.
//  Copyright © 2018年 uShow. All rights reserved.
//

#ifndef NSMutableDictionary_QMSafe_h
#define NSMutableDictionary_QMSafe_h

@interface NSMutableDictionary (QMSafe)

+ (void)runSafeGuard;

#ifdef DEBUG
+ (void)testCase;
#endif

@end

#endif /* NSMutableDictionary_QMSafe_h */
