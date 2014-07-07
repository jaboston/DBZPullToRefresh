//
//  DBZPullToRefreshView.h
//
//  Created by Kenji Abe on 2014/04/05.
//  Copyright (c) 2014年 Kenji Abe. All rights reserved.
//
//
//
//  Modified and forked by Joseph Boston 2014. (c) dubizzle.com .

#import <UIKit/UIKit.h>

/**
 `DBZPullToRefreshView` is the View for refresh animation.
 
 To be managed by `DBZPullToRefresh`, there is no need to work directly with this.
 */
@interface DBZPullToRefreshView : UIView

///---------------------
/// @name Setting Properties
///---------------------

/**
 Refresh status.
 */
@property (nonatomic, assign, readonly) BOOL isRefreshing;

/**
 Color of the refresh bar.
 */
@property (nonatomic, strong) UIColor *progressColor;

///---------------------
/// @name Refresh bar staus
///---------------------


/**
 Color of the refresh bar.
 */
@property (nonatomic, strong) NSArray *colours;
///---------------------
/// @name Colour of bars in loader.
///---------------------


/**
 Set the progress of refresh bar.
 
 @param progress Progress of refresh bar.
 */
- (void)setRefreshBarProgress:(CGFloat)progress;

/**
 Return whether progress full.
 */
- (BOOL)isProgressFull;

///---------------------
/// @name Refresh Animation
///---------------------

/**
 Start refresh animation manually. Send to the delegate after the start.
 */
- (void)startRefresh;

/**
 Stop refresh animation.
 */
- (void)finishRefresh;

@end
