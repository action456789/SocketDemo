//
//  LongConnectionService.m
//  Client
//
//  Created by ke sen. on 2017/2/8.
//  Copyright © 2017年 SenKe. All rights reserved.
//

#import "KKConnectSocketService.h"
#import "KKGCDTimer.h"
#import "Message.pb.h"
#import "MessageHandle.h"
#import "NSDictionary+KS.h"
#import "KKMessageService.h"

#define kRetryCount 5
#define kConnectTimeout 10
#define kTcpTag 1

@interface KKConnectSocketService() <GCDAsyncSocketDelegate>

@end

@implementation KKConnectSocketService {
    NSString *_ipAddr;
    int _port;
    
    dispatch_semaphore_t _socketWriteSemaphore;
    
    NSUInteger _reconnectCount;
    
    NSOperationQueue *_currentOprationQueue;
}

singleton_implementation(KKConnectSocketService)

- (instancetype)init
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
        if (_instance) {
            _port = 5555;
            _ipAddr = @"127.0.0.1";
            //        _ipAddr = @"172.168.1.103";
            
            _socketWriteSemaphore = dispatch_semaphore_create(0);
            _socketQueue = dispatch_queue_create("com.kesen.longConnection", DISPATCH_QUEUE_SERIAL);
            _reconnectCount = 0;
        }
    });
    return _instance;
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
        sleep(3);
        
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
        [_currentOprationQueue addOperationWithBlock:^{ // 重连
            [self reconnect];
        }];
    }
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    [sock readDataWithTimeout:-1 tag:tag];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    [sock readDataWithTimeout:-1 tag:tag];
    
    Message *message = [Message parseFromData:data];
    [self responseMessage:message];
}

- (void)responseMessage:(Message *)msg {
//    switch (msg.messageType) {
//        case MSGTypeHeartBeat: {// 心跳
//            NSLog(@"recieve: heart beat");
//
//            break;
//        }
//            
//        case MSGTypePlayMedioResponse: { // 播放媒体响应
////            if (_playMedioResult) {
////                NSDictionary *dict = [NSDictionary ks_dictionaryFromString:msg.body];
////                _playMedioResult(dict);
////            }
//            
//            break;
//        }
//            
//        case MSGTypeString: {
//            NSLog(@"收到字符串消息:%@", msg.header);
//        }
//            
//        default:
//            break;
//    }
    KK_ThreadSafeDictionary *dict = KKMessageService.sharedInstance.hasBeenSendMsgDict;
    for (NSString *key in dict) {
        KKMsg *value = (KKMsg *)dict[key];
        if ([msg.messageId isEqualToString:key]) {
            NSDictionary *dict = [NSDictionary ks_dictionaryFromString:msg.body];
            value.timeout = NO;
            if (value.callback) {
                value.callback(dict, nil);
            }
            break;
        }
        
    }
}
@end
