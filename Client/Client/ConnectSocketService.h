//
//  LongConnectionService.h
//  Client
//
//  Created by ke sen. on 2017/2/8.
//  Copyright © 2017年 SenKe. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ConnectSocketService;

@protocol ConnectSocketServiceDelegate <NSObject>
@optional;
- (void)connectSocketOffline;
@end

@interface ConnectSocketService : NSObject

@property (nonatomic,weak) id <ConnectSocketServiceDelegate> delegate;

- (BOOL)connectSocket;

@end
