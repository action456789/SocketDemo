//
//  MessageHandle.m
//  Client
//
//  Created by KeSen on 8/9/16.
//  Copyright © 2016 SenKe. All rights reserved.
//

#import "MessageHandle.h"
#import "NSDictionary+KS.h"

#define kValidate(str) (str && ![str isEqualToString:@""])

@implementation MessageHandle

+ (Message *)buildHeatPackageWithAccount:(NSString *)account
{
    MessageBuilder *builder = [Message builder];
    builder.messageType = MSGTypeHeartBeat;
    builder.messageId = [self createMessageId];
    builder.version = KMessageVersion;
    builder.header = @"";
    
    if (kValidate(account)) {
        NSDictionary *dict = @{@"account": account};
        builder.body = [dict ks_jsonString];
    }
    
    Message *msg = [builder build];
    
    return msg;
}

+ (Message *)buildPlayMedioRequestPackage
{
    MessageBuilder *builder = [Message builder];
    builder.messageType = MSGTypePlayMedioRequest;
    builder.messageId = [self createMessageId];
    builder.version = KMessageVersion;
    builder.header = @"";
    
    Message *msg = [builder build];
    
    return msg;
}

+ (Message *)buildPlayMedioResponsePackage:(NSDictionary *)dict
{
    MessageBuilder *builder = [Message builder];
    builder.messageType = MSGTypePlayMedioResponse;
    builder.messageId = [self createMessageId];
    builder.version = KMessageVersion;
    builder.header = @"";
    builder.body = [dict ks_jsonString];
    
    Message *msg = [builder build];
    
    return msg;
}

+ (Message *)buildString:(NSString *)string
{
    MessageBuilder *builder = [Message builder];
    builder.messageType = MSGTypeString;
    builder.messageId = [self createMessageId];
    builder.version = KMessageVersion;
    builder.header = string;
    
    Message *msg = [builder build];
    
    return msg;
}

+ (NSString *)createMessageId
{
    NSString *timestampString = [NSString stringWithFormat:@"%.0f",  [[NSDate date] timeIntervalSince1970]*1000];
    return [NSString stringWithFormat:@"%@%d%d%d", timestampString, arc4random_uniform(10), arc4random_uniform(10), arc4random_uniform(10)];
}

@end
