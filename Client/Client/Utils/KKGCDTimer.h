//
//  GCDTimer.h
//  SKS_Collection
//
//  Created by KeSen on 9/12/16.
//  Copyright © 2016 SenKe. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, GCDTimerAccuracy) {
    GCDTimerAccuracyBest = 0, // default
    GCDTimerAccuracyGood = 1,
    GCDTimerAccuracyNormal = 5,
};

@interface KKGCDTimer : NSObject

@property (nonatomic, assign) GCDTimerAccuracy accuracy;

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)ti
                                         queue:(dispatch_queue_t)queue
                                       repeats:(BOOL)isRepeats
                                         delay:(NSTimeInterval)delay
                                      accuracy:(GCDTimerAccuracy)accuracy
                                         block:(void (^)())block;

- (void)invalidate;

@end
