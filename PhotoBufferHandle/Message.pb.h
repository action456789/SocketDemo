// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import <ProtocolBuffers/ProtocolBuffers.h>

// @@protoc_insertion_point(imports)

@class Message;
@class MessageBuilder;



@interface MessageRoot : NSObject {
}
+ (PBExtensionRegistry*) extensionRegistry;
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry;
@end

#define Message_messageType @"messageType"
#define Message_messageId @"messageId"
#define Message_version @"version"
#define Message_header @"header"
#define Message_body @"body"
@interface Message : PBGeneratedMessage<GeneratedMessageProtocol> {
@private
  BOOL hasMessageType_:1;
  BOOL hasMessageId_:1;
  BOOL hasVersion_:1;
  BOOL hasHeader_:1;
  BOOL hasBody_:1;
  SInt32 messageType;
  NSString* messageId;
  NSString* version;
  NSString* header;
  NSString* body;
}
- (BOOL) hasMessageType;
- (BOOL) hasMessageId;
- (BOOL) hasVersion;
- (BOOL) hasHeader;
- (BOOL) hasBody;
@property (readonly) SInt32 messageType;
@property (readonly, strong) NSString* messageId;
@property (readonly, strong) NSString* version;
@property (readonly, strong) NSString* header;
@property (readonly, strong) NSString* body;

+ (instancetype) defaultInstance;
- (instancetype) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (MessageBuilder*) builder;
+ (MessageBuilder*) builder;
+ (MessageBuilder*) builderWithPrototype:(Message*) prototype;
- (MessageBuilder*) toBuilder;

+ (Message*) parseFromData:(NSData*) data;
+ (Message*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Message*) parseFromInputStream:(NSInputStream*) input;
+ (Message*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Message*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (Message*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface MessageBuilder : PBGeneratedMessageBuilder {
@private
  Message* resultMessage;
}

- (Message*) defaultInstance;

- (MessageBuilder*) clear;
- (MessageBuilder*) clone;

- (Message*) build;
- (Message*) buildPartial;

- (MessageBuilder*) mergeFrom:(Message*) other;
- (MessageBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (MessageBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasMessageType;
- (SInt32) messageType;
- (MessageBuilder*) setMessageType:(SInt32) value;
- (MessageBuilder*) clearMessageType;

- (BOOL) hasMessageId;
- (NSString*) messageId;
- (MessageBuilder*) setMessageId:(NSString*) value;
- (MessageBuilder*) clearMessageId;

- (BOOL) hasVersion;
- (NSString*) version;
- (MessageBuilder*) setVersion:(NSString*) value;
- (MessageBuilder*) clearVersion;

- (BOOL) hasHeader;
- (NSString*) header;
- (MessageBuilder*) setHeader:(NSString*) value;
- (MessageBuilder*) clearHeader;

- (BOOL) hasBody;
- (NSString*) body;
- (MessageBuilder*) setBody:(NSString*) value;
- (MessageBuilder*) clearBody;
@end


// @@protoc_insertion_point(global_scope)