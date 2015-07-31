//
//  MainViewController.m
//  Crystal Weather
//
//  Created by Klaus Cheung on 15/7/31.
//  Copyright (c) 2015年 Klaus Cheung. All rights reserved.
//

#import "MainViewController.h"
#import "MacroDefinition.h"

@interface MainViewController ()

@property (strong, nonatomic) UIView *blackView; // 动画效果黑色视图

- (void)initializeUserInterface;
- (void)processGestureReconizer:(UIGestureRecognizer *)gesture;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUserInterface];
}

#pragma mark -- Initialize
- (void)initializeUserInterface {
    // 设置主界面阴影
    self.view.layer.shadowOffset  = CGSizeMake(- 10, 5);
    self.view.layer.shadowColor   = [UIColor blackColor].CGColor;
    self.view.layer.shadowOpacity = 0.7;
    
    // 将实现动画的视图添加到主界面并设为透明
    _blackView                 = [[UIView alloc] initWithFrame:self.view.frame];
    _blackView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500];
    _blackView.alpha           = 0;
    [self.view addSubview:_blackView];
    // 给动画视图添加单机和拖拽手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(processGestureReconizer:)];
    singleTap.numberOfTapsRequired    = 1;
    [_blackView addGestureRecognizer:singleTap];
    UIPanGestureRecognizer *pan       = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(processGestureReconizer:)];
    [_blackView addGestureRecognizer:pan];
}

#pragma mark -- Custom Method
// 手势响应事件
- (void)processGestureReconizer:(UIGestureRecognizer *)gesture {
    if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) { // 如果是点击手势
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SlideMenuButtonNotification" object:@"close"];
        [UIView animateWithDuration:0.3 animations:^{
            _blackView.alpha = 0;
            self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }];
        
        
    } else if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) { // 如果是拖拽手势
        
        
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gesture;
        static CGPoint startCenter;
        if (pan.state == UIGestureRecognizerStateBegan) {
            
            startCenter = self.view.center;
            
        }
        
        else if (pan.state == UIGestureRecognizerStateChanged) {
            
            CGPoint translation = [pan translationInView:self.view];
            if (startCenter.x + translation.x + 1 >= SCREEN_WIDTH / 2 && startCenter.x + translation.x - 1 < SCREEN_WIDTH * 1.1 - 1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SlideMenuViewAnimationNotification" object:[NSString stringWithFormat:@"%lf", fabs([pan translationInView:self.view].x)]];
                self.view.center = CGPointMake(startCenter.x + translation.x, self.view.center.y);
                _blackView.alpha = 1 - fabs([pan translationInView:self.view].x / 100);
            }
        }
        
        else if (pan.state == UIGestureRecognizerStateEnded) {
            
            if ([pan translationInView:self.view].x > -125) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SlideMenuButtonNotification" object:@"open"];
                [UIView animateWithDuration:0.3 animations:^{
                    _blackView.alpha = 1;
                    self.view.frame = CGRectMake(SCREEN_WIDTH * 0.6, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                }];
            } else if ([pan translationInView:self.view].x < -125) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SlideMenuButtonNotification" object:@"close"];
                [UIView animateWithDuration:0.3 animations:^{
                    _blackView.alpha = 0;
                    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                }];
            }
            startCenter = CGPointZero;
        }
        
        
    }
}

// 侧滑菜单按钮响应事件
- (IBAction)pressedSlideMenuButtonEvent:(UIButton *)sender {
    if (self.view.center.x == SCREEN_WIDTH / 2) { // 如果主界面中心点的x不为屏幕中心点的x
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SlideMenuButtonNotification" object:@"open"];
        [UIView animateWithDuration:0.3 animations:^{
            _blackView.alpha = 1;
            self.view.frame  = CGRectMake(SCREEN_WIDTH * 0.6, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }];
    } else { // 否则
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SlideMenuButtonNotification" object:@"close"];
        [UIView animateWithDuration:0.3 animations:^{
            _blackView.alpha = 0;
            self.view.frame  = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }];
    }
}
@end
