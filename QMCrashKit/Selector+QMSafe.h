//
//  Selector+QMSafe.h
//  Solo
//
//  Created by 江林 on 2018/2/27.
//  Copyright © 2018年 Starmaker Interactive Inc. All rights reserved.
//

#ifndef Selector_QMSafe_h
#define Selector_QMSafe_h

// 用于截获发送到未实现的selector的消息
@interface NSObject (UnRecognizedSelHandler)

@end

#endif /* Selector_QMSafe_h */
