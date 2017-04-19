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
#import "KK_ThreadSafeDictionary.h"
#import "KKMsg.h"
#import "MessageHandle.h"

@interface KKMessageService : NSObject

singleton_interface(KKMessageService)

@property (nonatomic, strong) KK_ThreadSafeDictionary *hasBeenSendMsgDict;

- (void)sendMessageType:(MSGType)type call:(Result)callback;

@end
