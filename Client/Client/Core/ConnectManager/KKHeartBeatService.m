//
//  HeartBeatService.m
//  Client
//
//  Created by ke sen. on 2017/2/8.
//  Copyright © 2017年 SenKe. All rights reserved.
//

#import "KKHeartBeatService.h"
#import "KKConnectSocketService.h"
#import "KKGCDTimer.h"

#import "Message.pb.h"
#import "MessageHandle.h"
#import "KKMessageService.h"
#import "NSDictionary+KS.h"

@interface KKHeartBeatService()

@end

@implementation KKHeartBeatService {
    KKGCDTimer *_heartBeatTimer;
}

singleton_implementation(KKHeartBeatService)

- (void)start {

    dispatch_queue_t queue = KKConnectSocketService.sharedInstance.socketQueue;
    GCDAsyncSocket *socket = KKConnectSocketService.sharedInstance.socket;
    
    if (_heartBeatTimer == nil) {
        _heartBeatTimer = [KKGCDTimer scheduledTimerWithTimeInterval:5 queue:queue repeats:YES delay:0 accuracy:GCDTimerAccuracyNormal block:^{
            if (socket.isConnected) {
                [KKMessageService.sharedInstance sendMessageType:MSGTypeHeartBeat call:^(NSDictionary *resultDict, NSError *error) {
                    
                    if (error) {
                        NSLog(@"L O N G: 心跳包回包错误");
                    } else {
                        NSLog(@"L O N G: %@", [resultDict ks_jsonString]);
                    }
                }];
                NSLog(@"L O N G: 发送心跳包");
            }
        }];
    }
}

@end
