//
//  LongConnectionService.m
//  Client
//
//  Created by ke sen. on 2017/2/8.
//  Copyright © 2017年 SenKe. All rights reserved.
//

#import "ConnectSocketService.h"
#import <GCDAsyncSocket.h>

#define kRetryCount 30
#define kConnectTimeout 10

//typedef NS_ENUM(NSUInteger, ConnectType) {
//    ConnectTypeConnect, // 主动连接, default value
//    ConnectTypeReconnect, // 连接失败，重连
//    ConnectTypeOfflineReconnect, // 连接成功后，断线重连
//};

@interface ConnectSocketService() <GCDAsyncSocketDelegate>

@end

@implementation ConnectSocketService {
    NSString *_ipAddr;
    int _port;
    
    GCDAsyncSocket  *_socket;
    dispatch_queue_t _socketQueue;
    dispatch_semaphore_t _socketWriteSemaphore;
    
    NSUInteger _reconnectCount;
    
    NSOperationQueue *_currentOprationQueue;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _port = 5555;
        _ipAddr = @"127.0.0.1";
//        _ipAddr = @"172.168.1.103";
        
        _socketWriteSemaphore = dispatch_semaphore_create(0);
        _socketQueue = dispatch_queue_create("com.kesen.longConnection", DISPATCH_QUEUE_SERIAL);
        _reconnectCount = 0;
    }
    return self;
}

- (BOOL)connectSocket {
    _currentOprationQueue = [NSOperationQueue currentQueue];
    
    if (![self connect] && ![self reconnect]) {
        return NO;
    }
    return YES;
}

- (BOOL)connect {
    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:_socketQueue];
    
    NSError *error = nil;
    [_socket connectToHost:_ipAddr onPort:_port withTimeout:kConnectTimeout error:&error];
    if (error) {
        NSLog(@"L O N G: connect failed: %@", error);
        return NO;
    }
    
    dispatch_semaphore_wait(_socketWriteSemaphore, dispatch_time(DISPATCH_TIME_NOW, (int64_t)((kConnectTimeout + 1) * NSEC_PER_SEC)));
    
    return _socket.isConnected;
}

- (BOOL)reconnect {
    if (_socket.isConnected) {return YES;}
    _reconnectCount = 0;
    
    while (_reconnectCount < kRetryCount) {
        _reconnectCount++;
        NSLog(@"L O N G: reconnect : %ld times", (long)_reconnectCount);
        
        [self connect];
        sleep(1);
        if (_socket.isConnected) {
            return YES;
        }
    }
    return NO;
}

- (void)clean {
    if (_socket) {
        [_socket setDelegate:nil delegateQueue:nil];
        [_socket disconnect];
        _socket = nil;
    }
}

# pragma mark - <GCDAsyncSocketDelegate>

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    dispatch_semaphore_signal(_socketWriteSemaphore);
    
    NSLog(@"L O N G: connectSocket success: address=%@", _ipAddr);
    
    _reconnectCount = -1;
    
    [sock readDataWithTimeout:-1 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    if (_reconnectCount == kRetryCount) {
        NSLog(@"L O N G: connect failed: reach max reconnect count %lu", (unsigned long)_reconnectCount);
    } else {
        NSLog(@"L O N G: socket disconnected: error=%@", err);
    }
    
    [self clean];
    
    dispatch_semaphore_signal(_socketWriteSemaphore);
    
    if (_reconnectCount == -1) { // 掉线
        if (self.delegate && [self.delegate respondsToSelector:@selector(connectSocketOffline)]) {
            [self.delegate connectSocketOffline];
        }
        
        [_currentOprationQueue addOperationWithBlock:^{ // 重连
            [self reconnect];
        }];
    }
}

@end
