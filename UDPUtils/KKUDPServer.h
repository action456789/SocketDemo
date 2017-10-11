//
//  UDPServer.h
//  UDPServer
//
//  Created by sen.ke on 2017/10/10.
//  Copyright © 2017年 sen.ke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKUDPServer : NSObject

- (instancetype)init;


/**
 允许广播
 */
- (void)enableBoardcast;


/**
 绑定端口

 @param port 端口号
 */
- (void)bindPort:(int16_t)port;


/**
 监听绑定的端口，接收数据需要开启监听
 */
- (void)startListening;


/**
 停止监听
 */
- (void)stopListening;


/**
 扫描某个端口，向网络中所有主机的port端口发送广播

 @param port 端口号
 */
- (void)startScanningPort:(int16_t)port;


/**
 发送数据

 @param data 要发送的二进制数据
 @param host 主机
 @param port 端口号
 */
- (void)sendData:(NSData *)data toHost:(NSString *)host port:(int16_t)port;


@end
