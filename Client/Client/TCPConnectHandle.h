//
//  TCPConnectHandle.h
//  Client
//
//  Created by KeSen on 9/20/16.
//  Copyright © 2016 SenKe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

typedef void (^PlayMedioResultBlock)(NSDictionary *resultDict);

#define kConnectSuccessNotification @"kConnectSuccessNotification"
#define kDisconnectedNotification @"kDisconnectedNotification"

@interface TCPConnectHandle : NSObject

singleton_interface(TCPConnectHandle);

- (void)connectWithManual:(BOOL)isManual;

- (void)sendPlayMedioRequestWithReslut:(PlayMedioResultBlock)result;

@end
