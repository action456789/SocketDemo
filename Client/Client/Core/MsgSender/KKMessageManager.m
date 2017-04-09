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
#import "KK_ThreadSafeDictionary.h"

@interface KKMessageManager()

@end

@implementation KKMessageManager {
    GCDAsyncSocket *_socket;
    
    KK_ThreadSafeArray *_msgQueue;
    KK_ThreadSafeDictionary *_hasBeenSendMsgDict;
}

singleton_implementation(KKMessageManager)

- (instancetype)init
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
        if (_instance) {
            _msgQueue = [KK_ThreadSafeArray array];
            _hasBeenSendMsgDict = [KK_ThreadSafeDictionary dictionary];
        }
    });
    return _instance;
}

- (void)configureSocket:(GCDAsyncSocket *)socket {
    _socket = socket;
}

- (void)enqueueMessage:(KKMsg *)msg {
    [_msgQueue push:msg];
}

- (void)dispatchMessage:(KKMsg *)msg {
    // TODO: HTTP message
    
    [self sendSocketMessage:msg];
}

- (void)sendSocketMessage:(KKMsg *)msg {
    [_socket writeData:msg.msgBody.data withTimeout:-1 tag:1];
    
    // 放入字典
    [_hasBeenSendMsgDict setObject:msg forKey:msg.msgId];
}

@end
