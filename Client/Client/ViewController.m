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
#import "ConnectSocketService.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController {
    ConnectSocketService *_connectService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _connectService = [[ConnectSocketService alloc] init];
        [_connectService connectSocket];
    });
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




@end
