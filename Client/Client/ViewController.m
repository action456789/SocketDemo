//
//  ViewController.m
//  Client
//
//  Created by KeSen on 7/8/16.
//  Copyright © 2016 SenKe. All rights reserved.
//

// TODO: 消息加密与解密

#import "ViewController.h"
#import "TCPConnectHandle.h"
#import "KKConnectSocketService.h"
#import "KKHeartBeatService.h"
#import "KKMessageService.h"
#import "NSDictionary+KS.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //TODO: 连接时会卡死主线程
    
    if ([KKConnectSocketService.sharedInstance connectSocket]) {
        [KKHeartBeatService.sharedInstance start];
    }
}


- (void)addText:(NSString *)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.textView.text = [self.textView.text stringByAppendingFormat:@"%@\n", text];
    });
}

- (IBAction)connect:(UIButton *)sender
{
    [[TCPConnectHandle sharedInstance] connectWithManual:YES];
}

- (IBAction)sendData:(UIButton *)sender
{
    [[TCPConnectHandle sharedInstance] sendPlayMedioRequestWithReslut:^(NSDictionary *resultDict) {
        [self addText:[NSString stringWithFormat:@"play medio - [成功],  %d", [resultDict[@"success"] boolValue]]];
    }];
}
- (IBAction)testSendData:(id)sender {
    [KKMessageService.sharedInstance sendMessageType:MSGTypeHeartBeat call:^(NSDictionary *resultDict, NSError *error) {
        if (error) {
            NSLog(@"L O N G: 心跳包回包错误");
        } else {
            NSLog(@"L O N G: %@", [resultDict ks_jsonString]);
        }
    }];
    NSLog(@"L O N G: 发送心跳包");
}

@end
