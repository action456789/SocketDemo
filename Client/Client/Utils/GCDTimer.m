//
//  GCDTimer.m
//  SKS_Collection
//
//  Created by KeSen on 9/12/16.
//  Copyright © 2016 SenKe. All rights reserved.
//

#import "GCDTimer.h"

@interface GCDTimer()

@property (nonatomic, assign) dispatch_source_t timer;
@property (nonatomic, assign) BOOL isClear;

@end

@implementation GCDTimer

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)ti
                                         queue:(dispatch_queue_t)queue
                                       repeats:(BOOL)isRepeats
                                         delay:(NSTimeInterval)delay
                                      accuracy:(GCDTimerAccuracy)accuracy
                                         block:(void (^)())block
{
    GCDTimer *gcdTimer = [GCDTimer new];
    gcdTimer.isClear = NO;
    
    NSTimeInterval leeway = 0.f;
    if (accuracy == GCDTimerAccuracyBest) {
        leeway = 0.f;
    } else if (accuracy == GCDTimerAccuracyGood) {
        leeway = 1.f;
    } else if (accuracy == GCDTimerAccuracyNormal) {
        leeway = 5.f;
    }
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 0.f), ti * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        block();
        if (isRepeats == NO) {
            dispatch_source_cancel(timer);
            gcdTimer.isClear = YES;
        }
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_resume(timer);
    });
    
    gcdTimer.timer = timer;
    
    return gcdTimer;
}


- (void)invalidate
{
    if (self.isClear == NO) {
        dispatch_source_cancel(self.timer);
        self.isClear = YES;
    }
}

- (void)dealloc
{
    [self invalidate];
}

@end
