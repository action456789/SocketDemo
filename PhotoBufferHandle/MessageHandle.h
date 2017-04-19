//
//  MessageHandle.h
//  Client
//
//  Created by KeSen on 8/9/16.
//  Copyright © 2016 SenKe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.pb.h"

typedef NS_ENUM(NSUInteger, MSGType) {
    MSGTypeHeartBeat = 1000,
    MSGTypeControl,
    
    MSGTypeConnectSuccess = 2000,
    
    MSGTypePlayMedioRequest = 3001,
    MSGTypePlayMedioResponse,
    
    MSGTypeString = 4000,
};
typedef NS_ENUM(NSUInteger, MSGID) {
    MSGIDHeartBeat = 1000,
    
    MSGIDPlayMedioRequest = 2001,
    MSGIDPlayMedioResponse,
};

#define KMessageVersion          @"1.0.0"

@interface MessageHandle : NSObject

+ (Message *)buildHeatPackageWithAccount:(NSString *)account;
+ (Message *)buildHeatPackageResponseWithAcount:(NSString *)account msgId:(NSString *)msgId;

+ (Message *)buildPlayMedioRequestPackage;
+ (Message *)buildPlayMedioResponsePackage:(NSDictionary *)dict msgId:(NSString *)msgId;

+ (Message *)buildString:(NSString *)string;

+ (NSString *)createMessageId;

@end
