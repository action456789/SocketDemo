//
//  UDPServer.m
//  UDPServer
//
//  Created by sen.ke on 2017/10/10.
//  Copyright © 2017年 sen.ke. All rights reserved.
//

#import "KKUDPServer.h"
#import "GCDAsyncUdpSocket.h"

#define kBaseErrorMsg @"KKUDPServer"

@interface KKUDPServer()<GCDAsyncUdpSocketDelegate>
@end

@implementation KKUDPServer {
    GCDAsyncUdpSocket *_udpSocket;
    int _tag;
    int16_t _bindedPort;
    int16_t _sendDataPort;
    
    NSTimer *_scanPortTimer;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _tag = 0;
        
        dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:globalQueue];
    }
    return self;
}

- (int16_t)validatePort:(int16_t)port {
    if (port < 0 || port > 65535) {
        NSLog(@"%@: 端口号不合法", kBaseErrorMsg);
        port = 0;
    }
    return port;
}

- (void)bindPort:(int16_t)port {
    _bindedPort = [self validatePort:port];
    NSError *error = nil;
    if (![_udpSocket bindToPort:port error:&error]) {
        NSLog(@"%@ Error (bind): %@", kBaseErrorMsg, error);
    }
}

- (void)enableBoardcast {
    NSError *error = nil;
    [_udpSocket enableBroadcast:YES error:&error];
    if (error) {
        NSLog(@"Error enable broadcast: %@", error);
        return;
    }
}

- (void)startListening {
    NSError *error = nil;
    if (![_udpSocket beginReceiving:&error]) {
        [_udpSocket close];
        
        NSLog(@"%@ Error (recv): %@", kBaseErrorMsg, error);
    }
}

- (void)stopListening {
    [_udpSocket close];
    [_udpSocket setDelegate:nil delegateQueue:[_udpSocket delegateQueue]];
    _udpSocket = nil;
}

- (void)startScanningPort:(int16_t)port {
    port = [self validatePort:port];
    NSString *msg = @"mapleTest";
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    NSString *host = @"255.255.255.255";
    
    [self sendData:data toHost:host port:port];
    
    NSLog(@"SENT (%i): %@", (int)_tag, msg);
}

- (void)sendData:(NSData *)data toHost:(NSString *)host port:(int16_t)port {
    [_udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:_tag++];
}

#pragma - mark GCDAsyncUdpSocketDelegate

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
    if (tag == 100) {
        NSLog(@"表示标记为100的数据发送完成了");
    }
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
    NSLog(@"标记为tag %ld的发送失败 失败原因 %@",tag, error);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
                                               fromAddress:(NSData *)address
                                         withFilterContext:(id)filterContext {
    
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (msg) {
        NSLog(@"RECV: %@", msg);
    } else {
        NSString *host = nil;
        uint16_t port = 0;
        [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
        NSLog(@"RECV: Unknown message from: %@:%hu", host, port);
    }
    
    //    [_udpSocket sendData:data toAddress:address withTimeout:-1 tag:0];
    
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error {
    NSLog(@"udpSocket关闭");
}

@end
