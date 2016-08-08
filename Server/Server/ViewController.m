//
//  ViewController.m
//  Server
//
//  Created by KeSen on 8/8/16.
//  Copyright © 2016 SenKe. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"

@interface ViewController()<GCDAsyncSocketDelegate>

@property (weak) IBOutlet NSTextField *textField;

@end

@implementation ViewController
{
    int _port;
    
    GCDAsyncSocket *_listenSocket;
    dispatch_queue_t _listenQueue;
    
    GCDAsyncSocket *_sessionSocket;
    dispatch_queue_t _sessionQueue;
    
    dispatch_source_t _recevieDataTimer;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initSocket];
}

- (void)addText:(NSString *)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.textField.stringValue = [self.textField.stringValue stringByAppendingFormat:@"%@\n", text];
    });
}

- (void)initSocket
{
    _port = 5555;
    
    _listenQueue = dispatch_queue_create("com.kesen.client.tcp.socket.listen", DISPATCH_QUEUE_SERIAL);
    _listenSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:_listenQueue];
}

- (IBAction)listen:(NSButtonCell *)sender
{
    NSError *error = nil;
    BOOL result = [_listenSocket acceptOnPort:_port error:&error];
    if (result) {
        [self addText:@"服务器: 创建监听socket:成功"];
    } else {
        [self addText:@"服务器: 创建监听socket:失败"];
    }
}

- (IBAction)sendData:(NSButton *)sender
{
    NSData *data = [@"服务器: 你好" dataUsingEncoding:NSUTF8StringEncoding];
    [_sessionSocket writeData:data withTimeout:-1 tag:1];
}

#pragma mark - GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    [self addText:@"服务器: didAcceptNewSocket"];
    
    _sessionQueue = dispatch_queue_create("com.kesen.client.tcp.socket.session", DISPATCH_QUEUE_SERIAL);
    [newSocket setDelegate:self delegateQueue:_sessionQueue];
    [newSocket readDataWithTimeout:-1 tag:1];
    _sessionSocket = newSocket;
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    [sock readDataWithTimeout:-1 tag:tag];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self addText:[NSString stringWithFormat:@"客户端: 收到消息: %@, %ld", msg, tag]];
    
    if ([msg containsString:@"heartBeat:Client"]) { // 心跳包
        NSData *data = [@"heartBeat:Server" dataUsingEncoding:NSUTF8StringEncoding];
        [sock writeData:data withTimeout:-1 tag:2];
    }
    
    [sock readDataWithTimeout:-1 tag:tag];
}


@end
