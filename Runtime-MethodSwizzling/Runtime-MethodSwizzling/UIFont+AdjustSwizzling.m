//
//  UIFont+AdjustSwizzling.m
//  Runtime-MethodSwizzling
//
//  Created by WalkingBoy on 2019/7/11.
//  Copyright © 2019 bujige. All rights reserved.
//



#import "UIFont+AdjustSwizzling.h"
#import <objc/runtime.h>

#define XXX_UISCREEN_WIDTH  375.0

@implementation UIFont (AdjustSwizzling)

#pragma mark - 字体根据屏幕尺寸适配
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSelector = @selector(systemFontOfSize:);
        SEL swizzledSelector = @selector(xxx_systemFontOfSize:);

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

+ (UIFont *)xxx_systemFontOfSize:(CGFloat)fontSize {
    UIFont *newFont = nil;
    newFont = [UIFont xxx_systemFontOfSize:fontSize * [UIScreen mainScreen].bounds.size.width / XXX_UISCREEN_WIDTH];
    
    return newFont;
}
@end
