//
//  UIButton+DelaySwizzling.m
//  Runtime-MethodSwizzling
//
//  Created by WalkingBoy on 2019/7/11.
//  Copyright © 2019 bujige. All rights reserved.
//

#import "UIButton+DelaySwizzling.h"
#import <objc/runtime.h>

@interface UIButton()

// 重复点击间隔
@property (nonatomic, assign) NSTimeInterval xxx_acceptEventInterval;

@end


@implementation UIButton (DelaySwizzling)

#pragma mark - 避免 UIButton 重复点击

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = @selector(sendAction:to:forEvent:);
        SEL swizzledSelector = @selector(xxx_sendAction:to:forEvent:);

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

- (void)xxx_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    // 如果想要设置统一的间隔时间，可以在此处加上以下几句
    if (self.xxx_acceptEventInterval <= 0) {
        // 如果没有自定义时间间隔，则默认为 0.4 秒
        self.xxx_acceptEventInterval = 0.4;
    }
    
    // 是否小于设定的时间间隔
    BOOL needSendAction = (NSDate.date.timeIntervalSince1970 - self.xxx_acceptEventTime >= self.xxx_acceptEventInterval);
    
    // 更新上一次点击时间戳
    if (self.xxx_acceptEventInterval > 0) {
        self.xxx_acceptEventTime = NSDate.date.timeIntervalSince1970;
    }
    
    // 两次点击的时间间隔小于设定的时间间隔时，才执行响应事件
    if (needSendAction) {
        [self xxx_sendAction:action to:target forEvent:event];
    }
}

- (NSTimeInterval )xxx_acceptEventInterval{
    return [objc_getAssociatedObject(self, "UIControl_acceptEventInterval") doubleValue];
}

- (void)setXxx_acceptEventInterval:(NSTimeInterval)xxx_acceptEventInterval{
    objc_setAssociatedObject(self, "UIControl_acceptEventInterval", @(xxx_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval )xxx_acceptEventTime{
    return [objc_getAssociatedObject(self, "UIControl_acceptEventTime") doubleValue];
}

- (void)setXxx_acceptEventTime:(NSTimeInterval)xxx_acceptEventTime{
    objc_setAssociatedObject(self, "UIControl_acceptEventTime", @(xxx_acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
