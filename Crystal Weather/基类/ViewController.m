//
//  ViewController.m
//  Crystal Weather
//
//  Created by Klaus Cheung on 15/7/31.
//  Copyright (c) 2015年 Klaus Cheung. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MacroDefinition.h"
#import "BackgroundViewController.h"

@interface ViewController ()

@property (nonatomic) AVPlayer *player;

@end

@implementation ViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUserInterface];
}

#pragma mark -- Initialize
- (void)initializeUserInterface {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"LaunchVideo" ofType:@"mov"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    self.player.volume = 0;
    

    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    playerLayer.frame = SCREEN_BOUNDS;
    [self.view.layer addSublayer:playerLayer];
    
    [self.player play];
    
    [self.player.currentItem addObserver:self forKeyPath:AVPlayerItemDidPlayToEndTimeNotification options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 80, 80)];
    titleLabel.alpha = 0.0f;
    titleLabel.center = self.view.center;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"Crystal";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    titleLabel.font = [UIFont systemFontOfSize:72];
    titleLabel.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [self.view addSubview:titleLabel];
    
    UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0;
    [self.view addSubview:view];
    
    [UIView animateWithDuration:5 animations:^{
        titleLabel.alpha = 1;
        titleLabel.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            view.alpha = 1;
        }];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BackgroundViewController *backgroundVC = [[BackgroundViewController alloc] init];
        backgroundVC.modalTransitionStyle = 2;
        [self presentViewController:backgroundVC animated:YES completion:nil];
    });
}

#pragma mark -- Custom Method

// 视频循环播放
- (void)moviePlayDidEnd:(NSNotification*)notification{
    
    AVPlayerItem *item = [notification object];
    [item seekToTime:kCMTimeZero];
    [self.player play];
}

@end
