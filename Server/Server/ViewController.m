//
//  ViewController.m
//  Server
//
//  Created by KeSen on 8/8/16.
//  Copyright © 2016 SenKe. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"

#import "Message.pb.h"
#import "MessageHandle.h"

#import "NSDictionary+KS.h"

#define kTcpTag 1

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
    
    NSString *_loginAccount;
}
- (void)viewDidLoad {
    [super viewDidLoad];
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
    [self initSocket];
    
    NSError *error = nil;
    BOOL result = [_listenSocket acceptOnPort:_port error:&error];
    if (result) {
        [self addText:@"服务器: 创建监听socket:成功"];
    } else {
        [self addText:@"服务器: 创建监听socket:失败"];
    }
}

- (IBAction)closeSocket:(id)sender {
    [_listenSocket disconnect];
    _listenSocket = nil;
    
    [_sessionSocket disconnect];
    _sessionSocket = nil;
}

- (IBAction)sendData:(NSButton *)sender
{
    Message *message = [MessageHandle buildString:@"你好，我是服务器"];
    [_sessionSocket writeData:message.data withTimeout:-1 tag:1];
}

- (IBAction)cleanTextField:(id)sender
{
    self.textField.stringValue = @"";
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
    [sock readDataWithTimeout:-1 tag:tag];
    
    Message *message = [Message parseFromData:data];
    
    [self responseMessage:message];
}

- (void)responseMessage:(Message *)message
{
    Message *responseMsg = nil;
    
    switch (message.messageType) {
        case MSGTypeHeartBeat: {
            NSDictionary *dict = [NSDictionary ks_dictionaryFromString:message.body];
            _loginAccount = dict[@"account"];
            [self addText:[NSString stringWithFormat:@"receive heart beat %@", _loginAccount]];
            responseMsg = [MessageHandle buildHeatPackageResponseWithAcount:_loginAccount msgId:message.messageId];
            break;
        }
            
        case MSGTypePlayMedioRequest: {
            [self addText:@"play medio"];
            NSDictionary *dict = @{@"success":@(YES)};
            responseMsg = [MessageHandle buildPlayMedioResponsePackage:dict msgId:message.messageId];
            break;
        }
            
        default:
            break;
    }
    
    [_sessionSocket writeData:responseMsg.data withTimeout:-1 tag:kTcpTag];
}


@end
