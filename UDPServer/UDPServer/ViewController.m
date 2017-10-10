//
//  ViewController.m
//  UDPServer
//
//  Created by sen.ke on 2017/8/11.
//  Copyright © 2017年 sen.ke. All rights reserved.
//  监听UDP广播

#import "ViewController.h"
#import "KKUDPServer.h"

@implementation ViewController {
    KKUDPServer *_udpServer;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _udpServer = [[KKUDPServer alloc] init];
    [_udpServer bindPort:8085];
    [_udpServer startListening];
}





@end
