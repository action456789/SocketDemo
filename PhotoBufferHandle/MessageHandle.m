//
//  MessageHandle.m
//  Client
//
//  Created by KeSen on 8/9/16.
//  Copyright © 2016 SenKe. All rights reserved.
//

#import "MessageHandle.h"

@implementation MessageHandle

+ (Message *)buildHeatPackageS2C
{
    MessageBuilder *builder = [Message builder];
    builder.messageType = MSGTypeHeartBeat;
    builder.messageId = MSGID_S2C_HEART_PACKAGE;
    builder.version = KMessageVersion;
    builder.header = @"";
    builder.body = @"";
    
    Message *msg = [builder build];
    
    return msg;
}

+ (Message *)buildHeatPackageC2S
{
    MessageBuilder *builder = [Message builder];
    builder.messageType = MSGTypeHeartBeat;
    builder.messageId = MSGID_C2S_HEART_PACKAGE;
    builder.version = KMessageVersion;
    builder.header = @"";
    builder.body = @"";
    
    Message *msg = [builder build];
    
    return msg;
}

+ (Message *)buildPlayMedioRequestPackage
{
    MessageBuilder *builder = [Message builder];
    builder.messageType = MSGTypeControl;
    builder.messageId = MSGID_C2S_PLAY_MEDIA_SYN;
    builder.version = KMessageVersion;
    builder.header = @"CMD";
    builder.body = @"PLAY_MEDIA";
    
    Message *msg = [builder build];
    
    return msg;
}

+ (Message *)buildPlayMedioResponsePackage
{
    MessageBuilder *builder = [Message builder];
    builder.messageType = MSGTypeControl;
    builder.messageId = MSGID_S2C_PLAY_MEDIA_ACK;
    builder.version = KMessageVersion;
    builder.header = @"CMD";
    builder.body = @"PLAY_MEDIA";
    
    Message *msg = [builder build];
    
    return msg;
}

+ (BOOL)isHeatPackageC2S:(Message *)msg
{
    return msg && msg.messageType == MSGTypeHeartBeat && [msg.messageId isEqualToString:MSGID_C2S_HEART_PACKAGE];
}

+ (BOOL)isHeatPackageS2C:(Message *)msg
{
    return msg && msg.messageType == MSGTypeHeartBeat && [msg.messageId isEqualToString:MSGID_S2C_HEART_PACKAGE];
}

+ (BOOL)isPlayMedioRequestPackage:(Message *)msg
{
    return msg && msg.messageType == MSGTypeControl && [msg.messageId isEqualToString:MSGID_C2S_PLAY_MEDIA_SYN];
}

+ (BOOL)isPlayMedioResponsePackage:(Message *)msg
{
    return msg && msg.messageType == MSGTypeControl && [msg.messageId isEqualToString:MSGID_S2C_PLAY_MEDIA_ACK];
}

@end
