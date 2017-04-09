//
//  TCPConnectHandle.m
//  Client
//
//  Created by KeSen on 9/20/16.
//  Copyright © 2016 SenKe. All rights reserved.
//

#import "TCPConnectHandle.h"
#import <GCDAsyncSocket.h>

#import "Message.pb.h"
#import "MessageHandle.h"

#import "NSDictionary+KS.h"
#import "KKGCDTimer.h"

#define kTcpTag 1

#define LOCK(...) dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER); \
    __VA_ARGS__; \
dispatch_semaphore_signal(_lock);

@interface TCPConnectHandle()<GCDAsyncSocketDelegate>

@end

@implementation TCPConnectHandle
{
    NSString *_ipAddr;
    int _port;
    
    GCDAsyncSocket  *_socket;
    dispatch_queue_t _socketQueue;
    
    KKGCDTimer *_heartBeatTimer;
    dispatch_queue_t _heartBeatQueue;
    
    NSInteger _reconnectCount;

    KKGCDTimer *_timeoutTimer;
    
    PlayMedioResultBlock _playMedioResult;
}

singleton_implementation(TCPConnectHandle);

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSocket];
        _reconnectCount = 0;
        
        [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            if (_socket) {
                NSLog(@"%d", _socket.isConnected);
            }
        }];
    }
    return self;
}

- (void)initSocket
{
    _port = 5555;
    _ipAddr = @"127.0.0.1";
//    _ipAddr = @"192.168.2.1";
    _socketQueue = dispatch_queue_create("com.kesen.client.tcp.socket", DISPATCH_QUEUE_SERIAL);
    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:_socketQueue];
}

- (void)connectWithManual:(BOOL)isManual;
{
    if (_socket.isConnected) {return;}
    if (isManual) {
        _reconnectCount = 0;
    }
    
    NSError *error = nil;
    BOOL result = [_socket connectToHost:_ipAddr onPort:_port withTimeout:-1 error:&error];
    if (!result) {
        NSLog(@"连接失败");
    }
}

- (void)reconnect
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_reconnectCount < 6) {
            NSLog(@"正在重新连接: %ld", (long)_reconnectCount);
            _reconnectCount++;
            [self connectWithManual:NO];
            
        } else {
            NSLog(@"已达到最大重连次数 ，连接失败");
        }
    });
}

- (void)startHeartBeat
{
    if (!_heartBeatQueue) {
        _heartBeatQueue = dispatch_queue_create("com.kesen.client.tcp.socket.heart_beat", DISPATCH_QUEUE_SERIAL);
    }
    _heartBeatTimer = [KKGCDTimer scheduledTimerWithTimeInterval:5.0 queue:_heartBeatQueue repeats:YES delay:0 accuracy:GCDTimerAccuracyNormal block:^{
        Message *heartPackage = [MessageHandle buildHeatPackageWithAccount:@"18811112222"];
        [_socket writeData:heartPackage.data withTimeout:-1 tag:kTcpTag];
        
        if (_timeoutTimer == nil) {
            _timeoutTimer = [KKGCDTimer scheduledTimerWithTimeInterval:10 queue:_heartBeatQueue repeats:NO delay:30 accuracy:GCDTimerAccuracyNormal block:^{
                // 心跳包超时
                
                NSLog(@"已断开连接");
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kDisconnectedNotification object:nil];
                [_timeoutTimer invalidate];
            }];
        }
    }];
}

#pragma mark request message

- (void)sendPlayMedioRequestWithReslut:(PlayMedioResultBlock)result
{
    _playMedioResult = result;
    
    Message *request = [MessageHandle buildPlayMedioRequestPackage];
    [_socket writeData:request.data withTimeout:-1 tag:kTcpTag];
}

#pragma mark Socket Delegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"客户端: 已连接上主机 %d", _socket.isConnected);
    
    [self startHeartBeat];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kConnectSuccessNotification object:nil];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"%@\n, error%@, %d", @"socketDidDisconnect", err.description, _socket.isConnected);
    [self reconnect];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    [sock readDataWithTimeout:-1 tag:tag];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    [sock readDataWithTimeout:-1 tag:tag];
    
    Message *message = [Message parseFromData:data];
    [self responseMessage:message];
}

- (void)responseMessage:(Message *)msg
{
    Message *responseMsg = nil;
    
    switch (msg.messageType) {
        case MSGTypeHeartBeat: {// 心跳
            NSLog(@"recieve: heart beat");
            [_timeoutTimer invalidate];
            _timeoutTimer = nil;
            break;
        }
            
        case MSGTypePlayMedioResponse: { // 播放媒体响应
            if (_playMedioResult) {
                NSDictionary *dict = [NSDictionary ks_dictionaryFromString:msg.body];
                _playMedioResult(dict);
            }
            
            break;
        }
            
        case MSGTypeString: {
            NSLog(@"收到字符串消息:%@", msg.header);
        }
            
        default:
            break;
    }
    
    [_socket writeData:responseMsg.data withTimeout:-1 tag:kTcpTag];
}

@end
