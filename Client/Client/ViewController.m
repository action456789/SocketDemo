//
//  ViewController.m
//  Client
//
//  Created by KeSen on 7/8/16.
//  Copyright © 2016 SenKe. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"

#define USE_SECURE_CONNECTION 0

@interface ViewController ()<GCDAsyncSocketDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController
{
    BOOL _isConnected;
    
    NSString *_ipAddr;
    int _port;
    
    GCDAsyncSocket  *_socket;
    dispatch_queue_t _socketQueue;
    
    dispatch_source_t _heartBeatTimer;
    dispatch_queue_t _heartBeatQueue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSocket];
}

- (void)addText:(NSString *)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.textView.text = [self.textView.text stringByAppendingFormat:@"%@\n", text];
    });
}

- (IBAction)connect:(UIButton *)sender
{
    NSError *error = nil;
    BOOL result = [_socket connectToHost:_ipAddr onPort:_port withTimeout:-1 error:&error];
    if (result) {
        [self addText:@"客户端: 创建socket成功"];
    } else {
        [self addText:@"客户端: 创建socket失败"];
    }
}
- (IBAction)sendData:(UIButton *)sender
{
    NSString *str = @"客户端: 你爱我吗";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [_socket writeData:data withTimeout:-1 tag:1];
    
    [self addText:str];
}

- (void)initSocket
{
    _port = 5555;
    _ipAddr = @"127.0.0.1";
    _socketQueue = dispatch_queue_create("com.kesen.client.tcp.socket", DISPATCH_QUEUE_SERIAL);
    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:_socketQueue];
}

- (void)startHeartBeat
{
    if (!_isConnected) {
        return;
    }
    
    if (_heartBeatQueue) {
        dispatch_source_cancel(_heartBeatTimer);
    }
    
    
    NSTimeInterval interval = 5.0f;
    NSTimeInterval delay = 5.0f;
    _heartBeatQueue = dispatch_queue_create("com.kesen.client.tcp.socket.heart_beat", DISPATCH_QUEUE_SERIAL);
    
    _heartBeatTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _heartBeatQueue);
    dispatch_source_set_timer(_heartBeatTimer, dispatch_time(DISPATCH_TIME_NOW, delay), interval * NSEC_PER_SEC, 1.0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_heartBeatTimer, ^{
        NSData *msg = [@"heartBeat:Client" dataUsingEncoding:NSUTF8StringEncoding];
        [_socket writeData:msg withTimeout:-1 tag:1];
    });
    dispatch_resume(_heartBeatTimer);
}

#pragma mark Socket Delegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    [self addText:@"客户端: 已连接上主机"];
    
    _isConnected = YES;
    
    [self startHeartBeat];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    [self addText:@"客户端: 已断开连接"];
    _isConnected = NO;
    NSLog(@"%@\n, error%@", @"socketDidDisconnect", err.description);
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    [sock readDataWithTimeout:-1 tag:tag];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self addText:[NSString stringWithFormat:@"服务器: %@", msg]];
    
    [sock readDataWithTimeout:-1 tag:tag];
}

@end
