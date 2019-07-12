//
//  XXXPlaceholderView.h
//  Runtime-MethodSwizzling
//
//  Created by WalkingBoy on 2019/7/12.
//  Copyright © 2019 bujige. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXXPlaceholderView : UIView

@property (nonatomic, copy) void(^reloadClickBlock)(void);

@end

NS_ASSUME_NONNULL_END
