//
//  ViewController.m
//  UDPServer
//
//  Created by sen.ke on 2017/8/11.
//  Copyright © 2017年 sen.ke. All rights reserved.
//  监听UDP广播

#import "ViewController.h"
#import "GCDAsyncUdpSocket.h"

// if (port < 0 || port > 65535)
#define kSendDataPort 8085

@interface ViewController()<GCDAsyncUdpSocketDelegate>

@end

@implementation ViewController {
    GCDAsyncUdpSocket *_udpSocket;
    int _tag;
    NSTimer *_timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self start];
}

- (void)start {
    _tag = 0;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error = nil;
    
    if (![_udpSocket bindToPort:kSendDataPort error:&error]) {
        NSLog(@"Error starting server (bind): %@", error);
        return;
    }
    
    if (![_udpSocket beginReceiving:&error]) {
        [_udpSocket close];
        NSLog(@"Error starting server (recv): %@", error);
        return;
    }
    
    NSLog(@"Udp Echo server started on port %d", kSendDataPort);
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
        /* If you want to get a display friendly version of the IPv4 or IPv6 address, you could do this:
         
         NSString *host = nil;
         uint16_t port = 0;
         [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
         
         */
        
        NSLog(@"%@", msg);
    } else {
        NSLog(@"Error converting received data into UTF-8 String");
    }
    
//    [_udpSocket sendData:data toAddress:address withTimeout:-1 tag:0];
    
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error {
    NSLog(@"udpSocket关闭");
}

@end
