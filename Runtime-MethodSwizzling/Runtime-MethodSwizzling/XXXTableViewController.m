//
//  XXXTableViewController.m
//  Runtime-MethodSwizzling
//
//  Created by WalkingBoy on 2019/7/12.
//  Copyright © 2019 bujige. All rights reserved.
//

#import "XXXTableViewController.h"
#import "UITableView+ReloadDataSwizzling.h"

@interface XXXTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation XXXTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self createUI];
    
    
}

- (void)createUI {
    self.title = @"UITableViewPlaceholder";
    self.view.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TAB"];
    //模拟刷新操作
    __weak typeof(self) weakSelf = self;
    [self.tableView setReloadBlock:^{
        [weakSelf refresh];
    }];
    [self.view addSubview:_tableView];
    
    _refreshControl = [[UIRefreshControl alloc]init];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_refreshControl];

}

- (void)initData {
    _dataArr = [[NSMutableArray alloc] init];
}

- (void)refresh {
    //模拟刷新 偶数调用有数据 奇数无数据
    [_refreshControl beginRefreshing];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        static NSUInteger i = 0;
        if (i %2 == 0) {
            for (NSInteger i = 0; i < arc4random()%10; i++) {
                [self.dataArr addObject:[NSString stringWithFormat:@"卖报的小画家随机测试数据%ld",i]];
            }
        } else {
            [self.dataArr removeAllObjects];
        }
        i++;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        });
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TAB"];
    cell.textLabel.text = _dataArr[indexPath.row];
    return cell;
}

@end
