//
//  MessageConstant.h
//  Client
//
//  Created by KeSen on 8/8/16.
//  Copyright © 2016 SenKe. All rights reserved.
//

#ifndef MessageConstant_h
#define MessageConstant_h


typedef NS_ENUM(NSUInteger, MSGType) {
    MSGTypeHeartBeat,
    MSGTypeChart,
    MSGTypeControl,
};

#define KMessageVersion                  @"1.0.0"

#define MSGID_C2S_PLAY_MEDIA_SYN         @"MSGID_C2S_PLAY_MEDIA_SYN"
#define MSGID_S2C_PLAY_MEDIA_ACK         @"MSGID_S2C_PLAY_MEDIA_ACK"

#define MSGID_C2S_HEART_PACKAGE          @"MSGID_C2S_HEART_PACKAGE"
#define MSGID_S2C_HEART_PACKAGE          @"MSGID_S2C_HEART_PACKAGE"

#define MSGID_CMD_REMOTECONTROL_OPERCODE @"MSGID_CMD_REMOTECONTROL_OPERCODE"


#endif /* MessageConstant_h */
