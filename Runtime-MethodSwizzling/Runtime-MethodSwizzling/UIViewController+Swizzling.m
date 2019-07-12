//
//  UIViewController+Swizzling.m
//  Runtime-MethodSwizzling
//
//  Created by WalkingBoy on 2019/7/9.
//  Copyright © 2019 bujige. All rights reserved.
//

#import "UIViewController+Swizzling.h"
#import <objc/runtime.h>

#pragma mark - 全局页面统计功能

@implementation UIViewController (Swizzling)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(xxx_viewWillAppear:);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        BOOL didAddMethod = class_addMethod(class,
                                            originalSelector,
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}


// 原始方法
- (void)originalFunction {
    NSLog(@"originalFunction");
}

#pragma mark - Method Swizzling

- (void)xxx_viewWillAppear:(BOOL)animated {
    
    if (![self isKindOfClass:[UIViewController class]]) {  // 剔除系统 UIViewController
        // 添加统计代码
        NSLog(@"进入页面：%@", [self class]);
    }
    
    [self xxx_viewWillAppear:animated];
}

@end
