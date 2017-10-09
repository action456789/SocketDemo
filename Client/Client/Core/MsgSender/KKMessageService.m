//
//  MessageManager.m
//  Client
//
//  Created by ke sen. on 2017/2/9.
//  Copyright © 2017年 SenKe. All rights reserved.
//

#import "KKMessageService.h"
#import "KK_ThreadSafeArray.h"
#import "KKGCDTimer.h"
#import "KKConnectSocketService.h"

#define kTimeout 20

@interface KKMessageService()<GCDAsyncSocketDelegate>

@end

@implementation KKMessageService {
    GCDAsyncSocket *_socket;
    
    KK_ThreadSafeArray *_msgQueue;
    
    KKGCDTimer *_monitorTimer;
}

singleton_implementation(KKMessageService)

- (instancetype)init
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
        if (_instance) {
            _msgQueue = [KK_ThreadSafeArray array];
            _hasBeenSendMsgDict = [KK_ThreadSafeDictionary dictionary];
            
            dispatch_queue_t queue = KKConnectSocketService.sharedInstance.socketQueue;
            _socket = KKConnectSocketService.sharedInstance.socket;
            
            NSMutableArray *successMsgKeys = [NSMutableArray array];
            NSMutableArray *failedMsgKeys = [NSMutableArray array];
            
            _monitorTimer = [KKGCDTimer scheduledTimerWithTimeInterval:5 queue:queue repeats:YES delay:10 accuracy:GCDTimerAccuracyBest block:^{
                
                for (NSString *key in self.hasBeenSendMsgDict) {
                    KKMsg *value = (KKMsg *)self.hasBeenSendMsgDict[key];
                    
                    // 相差的时间，单位： 秒
                    NSTimeInterval timeFlies = CFAbsoluteTimeGetCurrent() - value.sendTimestamp;

                    if (value.timeout == NO) {
                        [successMsgKeys addObject:key];
                    } else if (timeFlies > kTimeout) { // 超时
                        NSDictionary *userInfo = @{@"L O N G": @"访问超时",
                                                   @"msg id": value.msgId
                                                   };
                        NSError *domainError = [NSError errorWithDomain:@"L o n g" code:0 userInfo:userInfo];
                        value.callback(nil, domainError);
                        [failedMsgKeys addObject:key];
                    }
                }
                
                [self.hasBeenSendMsgDict removeObjectsForKeys:successMsgKeys];
                [successMsgKeys removeAllObjects];
                
                [self.hasBeenSendMsgDict removeObjectsForKeys:failedMsgKeys];
                [failedMsgKeys removeAllObjects];
            }];
        }
    });
    return _instance;
}

- (void)enqueueMessage:(KKMsg *)msg {
    [_msgQueue push:msg];
}

- (void)dispatchMessage:(KKMsg *)msg {
    // TODO: HTTP message
    
}

- (void)sendMessageType:(MSGType)type call:(Result)callback {
    Message *message = nil;
    
    if (type == MSGTypeHeartBeat) {
        message = [MessageHandle buildHeatPackageWithAccount:@"18811112222"];
    } else if (type == MSGTypePlayMedioRequest) {
        message = [MessageHandle buildPlayMedioRequestPackage];
    }
    
    KKMsg *msg = [[KKMsg alloc] initWithMessage:message];
    msg.callback = callback;
    
    NSLog(@"L O N G: id:%@ 包已发送", msg.msgId);
    
    [_socket writeData:msg.msgBody.data withTimeout:-1 tag:1];
    
    // 放入字典
    [self.hasBeenSendMsgDict setObject:msg forKey:msg.msgId];
}

@end
