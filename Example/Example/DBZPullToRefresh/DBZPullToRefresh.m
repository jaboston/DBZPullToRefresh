//
//  DBZPullToRefresh.m
//
//  Created by Kenji Abe on 2014/04/05.
//  Copyright (c) 2014年 Kenji Abe. All rights reserved.
//
//
//  Modified and forked by Joseph Boston 2014. (c) dubizzle.com .
#import "DBZPullToRefresh.h"

@interface DBZPullToRefresh ()
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, weak) id<UITableViewDelegate> tableViewProxyDelegate;
@property (nonatomic, weak) id<UICollectionViewDelegate> collectionViewProxyDelegate;
@property (nonatomic, weak) id<UIScrollViewDelegate> scrollViewProxyDelegate;

@property (nonatomic, strong) DBZPullToRefreshView *refreshView;

@property (nonatomic, assign) BOOL isScrollTopPosition;
@property (nonatomic, assign) BOOL isScrollDragging;
@property (nonatomic, assign) CGFloat scrollingMax;

@end

@implementation DBZPullToRefresh

static CGFloat const kPregoressWeight = 1.2;

- (id)initWithTableView:(UITableView *)tableView refreshView:(DBZPullToRefreshView *)refreshView
{
    return [self initWithTableView:tableView refreshView:refreshView tableViewDelegate:nil];
}

- (id)initWithTableView:(UITableView *)tableView refreshView:(DBZPullToRefreshView *)refreshView tableViewDelegate:(id<UITableViewDelegate>)tableViewDelegate
{
    self = [super init];
    if (self) {
        self.tableViewProxyDelegate = tableViewDelegate;

        self.tableView = tableView;
        self.tableView.bounces = NO;

        self.isScrollTopPosition = YES;
        self.isScrollDragging = NO;

        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        pan.delegate = self;
        [self.tableView addGestureRecognizer:pan];

        self.refreshView = refreshView;
    }

    return self;
}

- (id)initWithCollectionView:(UICollectionView *)collectionView refreshView:(DBZPullToRefreshView *)refreshView collectionViewDelegate:(id<UICollectionViewDelegate>)collectionViewDelegate
{
    self = [super init];
    if (self) {
        self.collectionViewProxyDelegate = collectionViewDelegate;
        
        self.collectionView = collectionView;
        self.collectionView.bounces = NO;
        
        self.isScrollTopPosition = YES;
        self.isScrollDragging = NO;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        pan.delegate = self;
        [self.collectionView addGestureRecognizer:pan];
        
        self.refreshView = refreshView;
    }
    
    return self;
}

- (void)startRefresh
{
    if (self.delegate) {
        [self.delegate pullToRefreshDidStart];
    }

    [self.refreshView startRefresh];
}

- (void)finishRefresh
{
    [self.refreshView finishRefresh];
}

#pragma mark UIPanGestureRecognizer
- (void)panAction:(UIPanGestureRecognizer *)sender
{
    CGPoint location = [sender translationInView:self.tableView];

    if ([self.refreshView isRefreshing]) {
        return;
    }

    if (location.y > 0 && self.isScrollTopPosition && self.isScrollDragging) {
        [self.refreshView setRefreshBarProgress:location.y * kPregoressWeight];
        if (self.scrollingMax < location.y) {
            self.scrollingMax = location.y;
        }

        if (self.scrollingMax - 10 > location.y) {
            self.isScrollDragging = NO;
            [self.refreshView setRefreshBarProgress:0];
        }
    }
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


#pragma mark - UITableViewDelegate <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.tableViewProxyDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.tableViewProxyDelegate scrollViewDidScroll:scrollView];
    }

    CGFloat offset = scrollView.contentOffset.y + scrollView.contentInset.top;

    if (offset > 0) {
        self.isScrollTopPosition = NO;
        [self.refreshView setRefreshBarProgress:0];

        scrollView.bounces = YES;

    } else if (offset == 0) {
        self.isScrollTopPosition = YES;

        scrollView.bounces = NO;
    }
    
    if([self.tableViewProxyDelegate respondsToSelector:@selector(scrollViewDidScroll:)]){
        [self.tableViewProxyDelegate scrollViewDidScroll:scrollView];
    }
    
    if([self.collectionViewProxyDelegate respondsToSelector:@selector(scrollViewDidScroll:)]){
        [self.collectionViewProxyDelegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    if ([self.tableViewProxyDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
        [self.tableViewProxyDelegate scrollViewDidScrollToTop:scrollView];
    }
    
    if ([self.collectionViewProxyDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
        [self.collectionViewProxyDelegate scrollViewDidScrollToTop:scrollView];
    }

    self.isScrollTopPosition = YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.tableViewProxyDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.tableViewProxyDelegate scrollViewWillBeginDragging:scrollView];
    }
    
    if ([self.collectionViewProxyDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.collectionViewProxyDelegate scrollViewWillBeginDragging:scrollView];
    }

    self.isScrollDragging = YES;
    self.scrollingMax = 0;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([self.tableViewProxyDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.tableViewProxyDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
    
    if ([self.collectionViewProxyDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.collectionViewProxyDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }

    if ([self.refreshView isProgressFull]) {
        [self startRefresh];
    }

    self.isScrollDragging = NO;
    [self.refreshView setRefreshBarProgress:0];

}
#pragma mark - UICollectionView Delegate methods. 

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        [self.collectionViewProxyDelegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
        
    }
}

-(void) collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(collectionView:didEndDisplayingCell:forItemAtIndexPath:)]) {
        [self.collectionViewProxyDelegate collectionView:collectionView didEndDisplayingCell:cell forItemAtIndexPath:indexPath];
    }
    
}

-(void) collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(collectionView:didEndDisplayingSupplementaryView:forElementOfKind:atIndexPath:)])
    {
        [self.collectionViewProxyDelegate collectionView:collectionView didEndDisplayingSupplementaryView:view forElementOfKind:elementKind atIndexPath:indexPath];
    }
    
}

- (void) collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if([self.delegate respondsToSelector:@selector(collectionView:didHighlightItemAtIndexPath:)])
    {
        [self.collectionViewProxyDelegate collectionView:collectionView didHighlightItemAtIndexPath:indexPath];
    }
}

- (void) collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if([self.delegate respondsToSelector:@selector(collectionView:didUnhighlightItemAtIndexPath:)]){
        [self.collectionViewProxyDelegate collectionView:collectionView didUnhighlightItemAtIndexPath:indexPath];
    }
}

- (void) collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if([self.delegate respondsToSelector:@selector(collectionView:performAction:forItemAtIndexPath:withSender:)]){
        [self.collectionViewProxyDelegate collectionView:collectionView performAction:action forItemAtIndexPath:indexPath withSender:sender];
    }
}


#pragma mark - Method Forwarding
- (BOOL)respondsToSelector:(SEL)aSelector
{
    return [super respondsToSelector:aSelector] || [self.tableViewProxyDelegate respondsToSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if ([self.tableViewProxyDelegate respondsToSelector:aSelector]) {
        return [(id) self.tableViewProxyDelegate methodSignatureForSelector:aSelector];
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if ([self.tableViewProxyDelegate respondsToSelector:[anInvocation selector]]) {
        [anInvocation invokeWithTarget:self.tableViewProxyDelegate];
    }
}

@end
