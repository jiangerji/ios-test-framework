//
//  NSMutableString+QMSafe.h
//  StarMaker
//
//  Created by 江林 on 2018/2/1.
//  Copyright © 2018年 uShow. All rights reserved.
//

#ifndef NSMutableString_QMSafe_h
#define NSMutableString_QMSafe_h

@interface NSMutableString (QMSafe)

+ (void)runSafeGuard;

#ifdef DEBUG
+ (void)testCase;
#endif

@end

#endif /* NSMutableString_QMSafe_h */
