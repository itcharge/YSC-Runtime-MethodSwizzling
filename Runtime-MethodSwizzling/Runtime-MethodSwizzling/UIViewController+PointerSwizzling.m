//
//  UIViewController+PointerSwizzling.m
//  Runtime-MethodSwizzling
//
//  Created by WalkingBoy on 2019/7/12.
//  Copyright © 2019 bujige. All rights reserved.
//

#import "UIViewController+PointerSwizzling.h"
#import <objc/runtime.h>

#pragma mark - 方案 B 使用指针函数进行 Method Swizzling 

typedef IMP *IMPPointer;

// 交换方法函数
static void MethodSwizzle(id self, SEL _cmd, id arg1);
// 原始方法函数指针
static void (*MethodOriginal)(id self, SEL _cmd, id arg1);

// 交换方法函数
static void MethodSwizzle(id self, SEL _cmd, id arg1) {
    
    // 在这里添加 交换方法的相关代码
    NSLog(@"swizzledFunc");
    
    MethodOriginal(self, _cmd, arg1);
}

BOOL class_swizzleMethodAndStore(Class class, SEL original, IMP replacement, IMPPointer store) {
    IMP imp = NULL;
    Method method = class_getInstanceMethod(class, original);
    if (method) {
        const char *type = method_getTypeEncoding(method);
        imp = class_replaceMethod(class, original, replacement, type);
        if (!imp) {
            imp = method_getImplementation(method);
        }
    }
    if (imp && store) { *store = imp; }
    return (imp != NULL);
}

@implementation UIViewController (PointerSwizzling)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzle:@selector(originalFunc) with:(IMP)MethodSwizzle store:(IMP *)&MethodOriginal];
    });
}

+ (BOOL)swizzle:(SEL)original with:(IMP)replacement store:(IMPPointer)store {
    return class_swizzleMethodAndStore(self, original, replacement, store);
}

// 原始方法
- (void)originalFunc {
    NSLog(@"originalFunc");
}

@end
