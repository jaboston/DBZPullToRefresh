//
//  ViewController.m
//  Example
//
//  Created by Kenji Abe on 2014/04/06.
//  Copyright (c) 2014年 Kenji Abe. All rights reserved.
//
//  Modified and forked by Joseph Boston 2014. (c) dubizzle.com .

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) DBZPullToRefresh *pullToRefresh;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    /// Setup pull to refresh
    CGFloat refreshBarY = self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    DBZPullToRefreshView *refreshView = [[DBZPullToRefreshView alloc] initWithFrame:CGRectMake(0, refreshBarY, self.view.frame.size.width, 3)];
    [self.view addSubview:refreshView];

    self.pullToRefresh = [[DBZPullToRefresh alloc] initWithTableView:self.tableView
                                                         refreshView:refreshView
                                                   tableViewDelegate:self];
    self.tableView.delegate = self.pullToRefresh;
    self.pullToRefresh.delegate = self;


    /// Dummy data
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 20; i++) {
        [array addObject:[NSString stringWithFormat:@"%zd", i]];
    }
    self.data = [array copy];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];

    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    cell.textLabel.text = self.data[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSLog(@"didSelectRowAtIndexPath: %@", self.data[indexPath.row]);
}

#pragma mark - DBZPullToRefreshDelegate
- (void)pullToRefreshDidStart
{
    dispatch_queue_t q_global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t q_main = dispatch_get_main_queue();

    dispatch_async(q_global, ^{
        [NSThread sleepForTimeInterval:4];
        dispatch_async(q_main, ^{
            [self.pullToRefresh finishRefresh];
        });
    });
}

@end
