//
//  UDPServer.h
//  UDPServer
//
//  Created by sen.ke on 2017/10/10.
//  Copyright © 2017年 sen.ke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKUDPServer : NSObject

@property (nonatomic, assign) BOOL isRunning;

- (instancetype)init;

- (void)enableBoardcast;

- (void)bindPort:(int16_t)port;

- (void)startListening;
- (void)stopListening;

- (void)startScanningPort:(int16_t)port;

- (void)sendData:(NSData *)data toHost:(NSString *)host port:(int16_t)port;


@end
