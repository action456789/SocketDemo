//
//  LongConnectionService.h
//  Client
//
//  Created by ke sen. on 2017/2/8.
//  Copyright © 2017年 SenKe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GCDAsyncSocket.h>
#import "Singleton.h"

@interface KKConnectSocketService : NSObject

singleton_interface(KKConnectSocketService)

@property (nonatomic, strong, readonly) GCDAsyncSocket  *socket;
@property (nonatomic, strong, readonly) dispatch_queue_t socketQueue;

- (BOOL)connectSocket;

@end
