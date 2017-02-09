//
//  MessageManager.m
//  Client
//
//  Created by ke sen. on 2017/2/9.
//  Copyright © 2017年 SenKe. All rights reserved.
//

#import "KKMessageManager.h"
#import "KKMsg.h"
#import "KK_ThreadSafeArray.h"

#import "Message.pb.h"
#import "MessageHandle.h"

@implementation KKMessageManager {
    KK_ThreadSafeArray *_queue;
}

- (instancetype)init {
    if (self = [super init]) {
        _queue = [KK_ThreadSafeArray array];
    }
    
    return self;
}

- (void)enqueueMsg:(KKMsg *)msg {
    [_queue push:msg];
}

- (void)dispatchMsg:(KKMsg *)msg {
    KKMsg *message = (KKMsg *)[_queue pop];
    if (message) {
        
    }
}

@end
