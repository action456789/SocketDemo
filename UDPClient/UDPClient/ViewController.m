//
//  ViewController.m
//  UDPClient
//
//  Created by sen.ke on 2017/8/11.
//  Copyright © 2017年 sen.ke. All rights reserved.
//  客户端发送广播

#import "ViewController.h"
#import "GCDAsyncUdpSocket.h"

#define kSendDataPort 8085

@interface ViewController ()<GCDAsyncUdpSocketDelegate>

@end

@implementation ViewController {
    GCDAsyncUdpSocket *_udpSocket;
    NSTimer *_timer;
    long _tag;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self start];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)start {
    _tag = 0;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error = nil;
    
    if (![_udpSocket bindToPort:0 error:&error]) {
        NSLog(@"Error starting server (bind): %@", error);
        return;
    }
    
    [_udpSocket beginReceiving:&error];
    if (error) {
        NSLog(@"Error enable broadcast: %@", error);
        return;
    }
    
    [_udpSocket enableBroadcast:YES error:&error];
    if (error) {
        NSLog(@"Error enable broadcast: %@", error);
        return;
    }
    
    NSLog(@"Udp Echo server started on port %d", kSendDataPort);
}

- (void)startSendBoardcaseMessage {
    _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
}

- (void)timerEvent {
    [self startScan];
}

-(void)startScan {
    NSString *msg = @"mapleTest";
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    NSString *host = @"255.255.255.255";//此处如果写成固定的IP就是对特定的server监测；我这种写法是为了多方监测
    [_udpSocket sendData:data toHost:host port:kSendDataPort withTimeout:-1 tag:_tag++];
    
    NSLog(@"SENT (%i): %@", (int)_tag, msg);
}

- (IBAction)sendBoardcaseAction:(id)sender {
    [self startScan]; // 立即执行一次
    [self startSendBoardcaseMessage];
}

#pragma - mark GCDAsyncUdpSocketDelegate

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
    if (tag == 100) {
        NSLog(@"表示标记为100的数据发送完成了");
    }
    NSLog(@"%ld", tag);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
    NSLog(@"标记为tag %ld的发送失败 失败原因 %@",tag, error);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (msg) {
        NSLog(@"RECV: %@", msg);
    } else {
        NSString *host = nil;
        uint16_t port = 0;
        [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
        NSLog(@"RECV: Unknown message from: %@:%hu", host, port);
    }
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error {
    NSLog(@"udpSocket关闭");
}

@end
