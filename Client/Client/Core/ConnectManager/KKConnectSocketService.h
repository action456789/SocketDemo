//
//  LongConnectionService.h
//  Client
//
//  Created by ke sen. on 2017/2/8.
//  Copyright © 2017年 SenKe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GCDAsyncSocket.h>
@class KKConnectSocketService;

@protocol KKConnectSocketServiceDelegate <NSObject>
@optional;
- (void)connectSocketOffline;
@end

@interface KKConnectSocketService : NSObject

@property (nonatomic, strong, readonly) GCDAsyncSocket  *socket;
@property (nonatomic,weak) id <KKConnectSocketServiceDelegate> delegate;

- (BOOL)connectSocket;

@end
