//
//  Msg.m
//  Client
//
//  Created by ke sen. on 2017/2/9.
//  Copyright © 2017年 SenKe. All rights reserved.
//

#import "KKMsg.h"
#import "MessageHandle.h"

// 消息 ID 固定长度，20个字符长度字符串
#define kMsgIdLenth 20

@implementation KKMsg {
    long _msgIndex;
}

- (instancetype)init {
    if (self = [super init]) {
        _msgIndex = 1;
    }
    return self;
}

+ (instancetype)heartbeartMsg {
    return nil;
}

- (instancetype)initWithMessage:(Message *)message {
    KKMsg *msg = [KKMsg new];
    msg.msgId = message.messageId;
    msg.msgBody = message;
    msg.sendTimestamp = [[NSDate date] timeIntervalSince1970];
    msg.callback = nil;
    msg.timeout = YES;
    return msg;
}

+ (instancetype)buildHeartbeartMsg {
    Message *heartPackage = [MessageHandle buildHeatPackageWithAccount:@"18811112222"];
    KKMsg *msg = [[KKMsg alloc] initWithMessage:heartPackage];
    return msg;
}

- (NSString *)createMsgId {
    NSString *msgIdStr = [NSString stringWithFormat:@"%ld", (long)_msgIndex++ % 1000000];
    while (msgIdStr.length < kMsgIdLenth) {
        msgIdStr = [NSString stringWithFormat:@"0%@",msgIdStr];
    }
    return msgIdStr;
}

@end
