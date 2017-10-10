//
//  ViewController.m
//  UDPClient
//
//  Created by sen.ke on 2017/8/11.
//  Copyright © 2017年 sen.ke. All rights reserved.
//  客户端发送广播

#import "ViewController.h"

#import "KKUDPServer.h"

@implementation ViewController {
    KKUDPServer *_udpServer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _udpServer = [[KKUDPServer alloc] init];
    [_udpServer bindPort:0];
    [_udpServer startListening];
    [_udpServer enableBoardcast];
}

- (IBAction)sendBoardcaseAction:(id)sender {
    [_udpServer startScanningPort:8085];
}

@end
