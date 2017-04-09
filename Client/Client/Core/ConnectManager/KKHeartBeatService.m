//
//  HeartBeatService.m
//  Client
//
//  Created by ke sen. on 2017/2/8.
//  Copyright © 2017年 SenKe. All rights reserved.
//

#import "KKHeartBeatService.h"
#import "KKConnectSocketService.h"
#import <GCDAsyncSocket.h>
#import "KKGCDTimer.h"

#import "Message.pb.h"
#import "MessageHandle.h"

@interface KKHeartBeatService()<GCDAsyncSocketDelegate>

@end

@implementation KKHeartBeatService {
    KKConnectSocketService *_connectService;
    
    KKGCDTimer *_heartBeatTimer;
    dispatch_queue_t _heartBeatQueue;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _connectService = [KKConnectSocketService new];
    }
    return self;
}

- (void)start {
    [_connectService connectSocket];
    _connectService.socket.delegate = self;
    
    if (_connectService.socket.isConnected) {
        [self startHeartBeat];
    }
}

- (void)startHeartBeat
{
    if (!_heartBeatQueue) {
        _heartBeatQueue = dispatch_queue_create("com.kesen.client.tcp.socket.heart_beat", DISPATCH_QUEUE_SERIAL);
    }
    _heartBeatTimer = [KKGCDTimer scheduledTimerWithTimeInterval:5 queue:_heartBeatQueue repeats:YES delay:0 accuracy:GCDTimerAccuracyNormal block:^{
        NSLog(@"发送心跳包");
        Message *heartPackage = [MessageHandle buildHeatPackageWithAccount:@"18811112222"];
        [_connectService.socket writeData:heartPackage.data withTimeout:-1 tag:kTcpTag];
    }];
}

- (NSData *)buildHeartbeartPackage {
    return nil;
}

# pragma mark - <GCDAsyncSocketDelegate>


@end
