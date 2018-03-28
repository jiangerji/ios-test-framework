//
//  NSString+QMSafe.h
//  StarMaker
//
//  Created by 江林 on 2018/1/31.
//  Copyright © 2018年 uShow. All rights reserved.
//

#ifndef NSString_QMSafe_h
#define NSString_QMSafe_h

@interface NSString (QMSafe)

+ (void)runSafeGuard;

#ifdef DEBUG
+ (void)testCase;
#endif

@end

#endif /* NSString_QMSafe_h */
