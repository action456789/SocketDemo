//
//  MessageManager.h
//  Client
//
//  Created by ke sen. on 2017/2/9.
//  Copyright © 2017年 SenKe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GCDAsyncSocket.h>
#import "Singleton.h"

@interface KKMessageManager : NSObject

singleton_interface(KKMessageManager)

- (void)configureSocket:(GCDAsyncSocket *)socket;

@end
