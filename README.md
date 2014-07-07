# DBZPullToRefresh

UI Component like ActionBar-PullToRefresh of Android for iOS.

![How it looks](https://github.com/jaboston/DBZPullToRefresh/blob/master/screenshot.gif "dubizzle styled pull to refresh")

## Requirements

* iOS6.0 or later
* ARC

## Installation

1. git clone git@github.com:jaboston/DBZPullToRefresh.git

2. drag and drop the DBZPullToRefresh folder in to your project.

3. Use the example as a guide. It is beautiful. 

## Usage

```objc
#import "DBZPullToRefreshView.h"
```

```objc
// Create refresh view
DBZPullToRefreshView *refreshView = [[DBZPullToRefreshView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 3)];
[self.view addSubview:refreshView];

// Setup PullToRefresh
self.pullToRefresh = [[DBZPullToRefresh alloc] initWithTableView:self.tableView
                                                     refreshView:refreshView
                                               tableViewDelegate:self];
self.tableView.delegate = self.pullToRefresh;
self.pullToRefresh.delegate = self;   // STZPullToRefreshDelegate
```

see Example directory project.

## Author

Kenji Abe, kenji@star-zero.com

Modified (by opinion improved ;)) by J.A.Boston.

## License

STZPullToRefresh is available under the MIT license. See the LICENSE file for more info.

