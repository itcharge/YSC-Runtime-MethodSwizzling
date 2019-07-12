//
//  XXXPlaceholderView.m
//  Runtime-MethodSwizzling
//
//  Created by WalkingBoy on 2019/7/12.
//  Copyright © 2019 bujige. All rights reserved.
//

#import "XXXPlaceholderView.h"

@interface XXXPlaceholderView ()

@property (nonatomic, strong) UIButton *reloadButton;

@end

@implementation XXXPlaceholderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

/**
 * reloadButton 初始化
 */
- (UIButton *)reloadButton
{
    if (!_reloadButton) {
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reloadButton.frame = CGRectMake(0, 0, 150, 150);
        _reloadButton.center = self.center;
        _reloadButton.layer.cornerRadius = 75.0;
        [_reloadButton setBackgroundImage:[UIImage imageNamed:@"nodata-file.png"] forState:UIControlStateNormal];
        [_reloadButton setTitle:@"暂无数据，请重新加载!" forState:UIControlStateNormal];
        [_reloadButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_reloadButton setTitleEdgeInsets:UIEdgeInsetsMake(200, -50, 0, -50)];
        [_reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        CGRect rect = _reloadButton.frame;
        rect.origin.y -= 50;
        _reloadButton.frame = rect;
    }
    return _reloadButton;
}


- (void)createUI {
    self.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
    [self addSubview:self.reloadButton];
}

- (void)reloadButtonClick:(UIButton *)sender {
    if (self.reloadClickBlock) {
        self.reloadClickBlock();
    }
}
@end
