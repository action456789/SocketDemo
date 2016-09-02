//
//  ViewController.m
//  Client
//
//  Created by KeSen on 7/8/16.
//  Copyright © 2016 SenKe. All rights reserved.
//

// TODO: 消息加密与解密

#import "ViewController.h"
#import "GCDAsyncSocket.h"

#import "Message.pb.h"
#import "MessageHandle.h"

#import "NSDictionary+KS.h"

#define kTcpTag 1

typedef void (^PlayMedioResultBlock)(NSDictionary *resultDict);

@interface ViewController ()<GCDAsyncSocketDelegate>
{
    PlayMedioResultBlock _playMedioResult;
}

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
        Message *heartPackage = [MessageHandle buildHeatPackageWithAccount:@"18811112222"];
        [_socket writeData:heartPackage.data withTimeout:-1 tag:kTcpTag];
    });
    dispatch_resume(_heartBeatTimer);
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
    [self sendPlayMedioRequestWithReslut:^(NSDictionary *resultDict) {
        [self addText:[NSString stringWithFormat:@"response: play medio %d", [resultDict[@"success"] boolValue]]];
    }];
}

#pragma mark request message

- (void)sendPlayMedioRequestWithReslut:(PlayMedioResultBlock)result
{
    _playMedioResult = result;
    
    Message *request = [MessageHandle buildPlayMedioRequestPackage];
    [_socket writeData:request.data withTimeout:-1 tag:kTcpTag];
    
    [self addText:@"request: play medio"];
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
    [sock readDataWithTimeout:-1 tag:tag];
    
    Message *message = [Message parseFromData:data];
    [self responseMessage:message];
}

- (void)responseMessage:(Message *)msg
{
    Message *responseMsg = nil;
    
    switch (msg.messageType) {
        case MSGTypeHeartBeat: {// 心跳
           [self addText:@"recieve: heart beat"];
            break;
        }
            
        case MSGTypePlayMedioResponse: { // 播放媒体响应
            if (_playMedioResult) {
                NSDictionary *dict = [NSDictionary ks_dictionaryFromString:msg.body];
                _playMedioResult(dict);
            }
            
            break;
        }
            
        default:
            break;
    }
    
    [_socket writeData:responseMsg.data withTimeout:-1 tag:kTcpTag];
}

@end
