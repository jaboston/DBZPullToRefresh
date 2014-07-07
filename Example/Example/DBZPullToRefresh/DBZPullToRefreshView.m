//
//  DBZPullToRefreshView.m
//
//  Created by Kenji Abe on 2014/04/05.
//  Copyright (c) 2014年 Kenji Abe. All rights reserved.
//
//
//  Modified and forked by Joseph Boston 2014. (c) dubizzle.com .

#import "DBZPullToRefreshView.h"

@interface DBZPullToRefreshView ()
@property (nonatomic, assign, readwrite) BOOL isRefreshing;
@property (nonatomic, strong) UIView *refreshBarView;
@property (nonatomic, strong) NSMutableArray *refreshIndicators;
@property int colourPos;
@property int maxIndicators;
@end

@implementation DBZPullToRefreshView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.refreshBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, frame.size.height)];
        [self addSubview:self.refreshBarView];
        // plus one to take into account the background colour
        //grey
        self.progressColor = [UIColor colorWithRed:59.0f / 255.f green:66.0f / 255.f blue:69.0f / 255.f alpha:1.0];
        //dark red
        //self.progressColor = [UIColor colorWithRed:143.0f / 255.f green:0.0f / 255.f blue:6.0f / 255.f alpha:1.0];
        _maxIndicators = 5;
        
        NSMutableArray *mColours = [[NSMutableArray alloc] init];
        //default yellow properties for rent
        [mColours addObject:[UIColor colorWithRed:241.f / 255.f green:186.0f / 255.f blue:69.0f / 255.f alpha:1.0]];
        //default red
        [mColours addObject:[UIColor colorWithRed:184.0f/255.0 green:0.0f/255.0 blue:7.0f/255.0 alpha:1.0f]];
        //default light blue properties for sale
        [mColours addObject:[UIColor colorWithRed:41.f / 255.f green:164.0f / 255.f blue:215.0f / 255.f alpha:1.0]];
        //obergine for motors
        [mColours addObject:[UIColor colorWithRed:124.f / 255.f green:96.0f / 255.f blue:133.0f / 255.f alpha:1.0]];
        //light green for classifieds
        [mColours addObject:[UIColor colorWithRed:104.f / 255.f green:189.0f / 255.f blue:69.0f / 255.f alpha:1.0]];
        
        _colours = mColours;

    }
    return self;
}

- (void)setRefreshBarProgress:(CGFloat)progress
{
    self.refreshBarView.backgroundColor = self.progressColor;
    CGRect frame = self.refreshBarView.frame;
    CGFloat x = (self.frame.size.width / 2) - (progress / 2);
    frame.size.width = progress;
    frame.origin.x = x;
    self.refreshBarView.frame = frame;
}

- (BOOL)isProgressFull
{
    CGFloat width = self.refreshBarView.frame.size.width;
    return width > self.frame.size.width;
}

- (void)startRefresh
{
    self.isRefreshing = YES;

    [self setRefreshBarProgress:0];

    self.refreshIndicators = [[NSMutableArray alloc] init];

    //self.progressColor = [_colours objectAtIndex:_colourPos];
    
    for (NSInteger i = 0; i < _maxIndicators; i++) {
        int frameWidth = self.frame.size.width;
        UIView *indicator = [[UIView alloc] initWithFrame:CGRectMake(-frameWidth, 0, frameWidth, self.frame.size.height)];
        indicator.backgroundColor = [_colours objectAtIndex:_colourPos];

        float delay = ((float)1/_maxIndicators) * i;

        [UIView animateWithDuration:1.2 delay:delay options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionRepeat animations:^{
            CGRect frame = indicator.frame;
            frame.origin.x = self.frame.size.width;
            indicator.frame = frame;
            indicator.backgroundColor = [_colours objectAtIndex:_colourPos];
            if(_colourPos < _colours.count-1) _colourPos++; else _colourPos = 0;

        } completion:^(BOOL finished) {
//            self.progressColor = [_colours objectAtIndex:_colourPos];
//            self.backgroundColor = [_colours objectAtIndex:_colourPos];
        }];

        [self addSubview:indicator];

        [self.refreshIndicators addObject:indicator];
        
    }

    self.backgroundColor = self.progressColor;
}

- (void)finishRefresh
{
    self.isRefreshing = NO;

    self.backgroundColor = [UIColor clearColor];
    [self.refreshIndicators enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [(UIView *)obj removeFromSuperview];
    }];
    [self.refreshIndicators removeAllObjects];
}

@end
