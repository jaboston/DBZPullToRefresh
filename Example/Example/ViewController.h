//
//  ViewController.h
//  Example
//
//  Created by Kenji Abe on 2014/04/06.
//  Copyright (c) 2014年 Kenji Abe. All rights reserved.
//
//
//
//  Modified and forked by Joseph Boston 2014. (c) dubizzle.com .

#import <UIKit/UIKit.h>
#import "DBZPullToRefresh/DBZPullToRefresh.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, DBZPullToRefreshDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
