//
//  ViewController.m
//  Runtime-MethodSwizzling
//
//  Created by WalkingBoy on 2019/7/9.
//  Copyright © 2019 bujige. All rights reserved.
//

#import "ViewController.h"
#import "XXXTableViewController.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self SwizzlingMethod];

    [self originalFunction];
    [self swizzledFunction];
    
//    // 按钮延迟点击相关示例代码
//    UIButton *button = [[UIButton alloc] initWithFrame: CGRectMake(100, 100, 100, 100)];
//    button.backgroundColor = [UIColor redColor];
//    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
}

#pragma mark - TableView、CollectionView 异常加载占位图
// 若想看 TableView 异常加载显示占位图效果，请打开以下代码
//- (void)viewDidAppear:(BOOL)animated {
//
//    XXXTableViewController *tableVC = [[XXXTableViewController alloc] init];
//    [self presentViewController:tableVC animated:YES completion:nil];
//}

#pragma mark - Swizzling Method 简单使用
// 交换 原方法 和 替换方法 的方法实现
- (void)SwizzlingMethod {
    // 当前类
    Class class = [self class];
    
    // 原方法名 和 替换方法名
    SEL originalSelector = @selector(originalFunction);
    SEL swizzledSelector = @selector(swizzledFunction);
    
    // 原方法结构体 和 替换方法结构体
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    // 调用交换两个方法的实现
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

// 原始方法
- (void)originalFunction {
    NSLog(@"originalFunction");
}

// 替换方法
- (void)swizzledFunction {
    NSLog(@"swizzledFunction");
}


#pragma mark - 按钮延迟点击相关代码

// 按钮点击事件
- (void)buttonClick:(UIButton *)button {
    NSLog(@"点击了按钮");
}

@end
