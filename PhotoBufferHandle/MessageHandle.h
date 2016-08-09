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
    MSGTypeHeartBeat,
    MSGTypeChart,
    MSGTypeControl,
};

#define KMessageVersion          @"1.0.0"

#define MSGID_C2S_PLAY_MEDIA_SYN @"MSGID_C2S_PLAY_MEDIA_SYN"
#define MSGID_S2C_PLAY_MEDIA_ACK @"MSGID_S2C_PLAY_MEDIA_ACK"

#define MSGID_C2S_HEART_PACKAGE  @"MSGID_C2S_HEART_PACKAGE"
#define MSGID_S2C_HEART_PACKAGE  @"MSGID_S2C_HEART_PACKAGE"

#define MSGID_CMD_REMOTECONTROL_OPERCODE @"MSGID_CMD_REMOTECONTROL_OPERCODE"

@interface MessageHandle : NSObject

+ (BOOL)isHeatPackageC2S:(Message *)msg;
+ (BOOL)isHeatPackageS2C:(Message *)msg;

+ (BOOL)isPlayMedioRequestPackage:(Message *)msg;
+ (BOOL)isPlayMedioResponsePackage:(Message *)msg;

+ (Message *)buildHeatPackageS2C;
+ (Message *)buildHeatPackageC2S;

+ (Message *)buildPlayMedioRequestPackage;
+ (Message *)buildPlayMedioResponsePackage;

@end
