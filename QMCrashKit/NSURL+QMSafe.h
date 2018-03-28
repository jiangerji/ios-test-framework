//
//  NSURL+QMSafe.h
//  StarMaker
//
//  Created by 江林 on 2018/1/30.
//  Copyright © 2018年 uShow. All rights reserved.
//

#ifndef NSURL_QMSafe_h
#define NSURL_QMSafe_h

@interface NSURL (QMSafe)

+ (void)runSafeGuard;

#ifdef DEBUG
+ (void)testCase;
#endif

@end

#endif /* NSURL_QMSafe_h */
