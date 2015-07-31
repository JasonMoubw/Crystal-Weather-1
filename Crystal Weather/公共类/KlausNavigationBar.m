//
//  KlausNavigationBar.m
//  Crystal Weather
//
//  Created by Klaus Cheung on 15/7/31.
//  Copyright (c) 2015年 Klaus Cheung. All rights reserved.
//

#import "KlausNavigationBar.h"
#import "MacroDefinition.h"

@implementation KlausNavigationBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.300];
    }
    return self;
}

@end
