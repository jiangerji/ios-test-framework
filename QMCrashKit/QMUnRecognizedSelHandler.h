//
//  QMUnRecognizedSelHandler.h
//  Solo
//
//  Created by 江林 on 2018/2/27.
//  Copyright © 2018年 Starmaker Interactive Inc. All rights reserved.
//

#ifndef QMUnRecognizedSelHandler_h
#define QMUnRecognizedSelHandler_h

// 用于将没有定义的selector，发送到这个对象进行处理
@interface QMUnRecognizedSelHandler : NSObject

// 发生unrecognized method异常的类名
@property (nonatomic, strong) NSString *orignalClassName;

@end

#endif /* QMUnRecognizedSelHandler_h */
