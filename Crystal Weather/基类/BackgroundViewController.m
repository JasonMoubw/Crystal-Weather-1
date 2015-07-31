//
//  BackgroundViewController.m
//  Crystal Weather
//
//  Created by Klaus Cheung on 15/7/31.
//  Copyright (c) 2015年 Klaus Cheung. All rights reserved.
//

#import "BackgroundViewController.h"
#import "MacroDefinition.h"
#import "MainViewController.h"
#import "SlideMenuViewController.h"

@interface BackgroundViewController ()

@property (strong, nonatomic) SlideMenuViewController *slideMenuVC; // 侧滑菜单

- (void)initializeUserInterface;
- (void)slideMenuButtonPressedEvent:(NSNotification *)notification;
- (void)slideMenuViewAnimationEvent:(NSNotification *)notification;

@end

@implementation BackgroundViewController

// 移除通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUserInterface];
}

#pragma mark -- Initialize
- (void)initializeUserInterface {
    
    // 设置背景图片
    UIImage *backgroundImage = [UIImage imageNamed:@"SlideMenuBackgroundImage"];
    self.view.layer.contents = (id)backgroundImage.CGImage;
    
    // 初始化主界面和侧滑菜单
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainViewController *mainVC   = [mainStoryboard instantiateViewControllerWithIdentifier:@"MainView"];
    _slideMenuVC                 = [mainStoryboard instantiateViewControllerWithIdentifier:@"SlideMenuView"];
    // 设置侧滑菜单的偏移量以实现动画效果
    _slideMenuVC.view.center     = CGPointMake(SCREEN_WIDTH / 2 + 30, SCREEN_HEIGHT / 2 + 30);
    _slideMenuVC.view.alpha      = 0.1;
    
    // 将主界面和侧滑菜单设为自控制器并放到viewController
    [self addChildViewController:mainVC];
    [self addChildViewController:_slideMenuVC];
    [self.view addSubview:_slideMenuVC.view];
    [self.view addSubview:mainVC.view];
    
    // 创建通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slideMenuButtonPressedEvent:) name:@"SlideMenuButtonNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slideMenuViewAnimationEvent:) name:@"SlideMenuViewAnimationNotification" object:nil];
}

#pragma mark -- Custom Method
// 侧滑菜单按钮通知响应事件
- (void)slideMenuButtonPressedEvent:(NSNotification *)notification {
    if ([notification.object isEqualToString:@"open"]) {
        [UIView animateWithDuration:0.3 animations:^{
            _slideMenuVC.view.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
            _slideMenuVC.view.alpha = 1;
        }];
        
    } else if ([notification.object isEqualToString:@"close"]) {
        [UIView animateWithDuration:0.3 animations:^{
            _slideMenuVC.view.center = CGPointMake(SCREEN_WIDTH / 2 + 30, SCREEN_HEIGHT / 2 + 30);
            _slideMenuVC.view.alpha = 0.1;
        }];
    }
}

// 侧滑菜单动画通知响应事件
- (void)slideMenuViewAnimationEvent:(NSNotification *)notification {
    _slideMenuVC.view.center = CGPointMake(SCREEN_WIDTH / 2 + ([notification.object doubleValue] / 8.3), SCREEN_HEIGHT / 2 + ([notification.object doubleValue] / 8.3));
    _slideMenuVC.view.alpha  = 1 - [notification.object doubleValue] / 250;
}

@end
