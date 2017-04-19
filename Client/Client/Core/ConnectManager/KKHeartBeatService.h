//
//  HeartBeatService.h
//  Client
//
//  Created by ke sen. on 2017/2/8.
//  Copyright © 2017年 SenKe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

#define kTcpTag 1

@interface KKHeartBeatService : NSObject

singleton_interface(KKHeartBeatService)

- (void)start;

@end
