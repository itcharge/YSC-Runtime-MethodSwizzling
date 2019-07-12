//
//  UITableView+ReloadDataSwizzling.h
//  Runtime-MethodSwizzling
//
//  Created by WalkingBoy on 2019/7/11.
//  Copyright © 2019 bujige. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (ReloadDataSwizzling)

@property (nonatomic, assign) BOOL firstReload;
@property (nonatomic, strong) UIView *placeholderView;
@property (nonatomic,   copy) void(^reloadBlock)(void);

@end

NS_ASSUME_NONNULL_END
