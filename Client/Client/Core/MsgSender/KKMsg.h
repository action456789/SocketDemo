//
//  Msg.h
//  Client
//
//  Created by ke sen. on 2017/2/9.
//  Copyright © 2017年 SenKe. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Result)(NSDictionary *resultDict);

@interface KKMsg : NSObject

@property (nonatomic, assign) Result result; // 回调
@property (nonatomic, copy) NSString *msgId; // 消息id
@property (nonatomic, assign) NSTimeInterval sendTimestamp; // 发送时间戳

@end
