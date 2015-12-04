//
//  ViewController.m
//  KMCalendarDemo
//
//  Created by Klein Mioke on 15/12/4.
//  Copyright © 2015年 KleinMioke. All rights reserved.
//

#import "ViewController.h"
#import "KMCalendar.h"

#define SPACEING_VALUE_BETWEEN_VIEWS 10.f

@interface ViewController () <KMCalendarDelegate, UIScrollViewDelegate>

@property UIScrollView *scrollView;
@property KMCalendar *calendar;
@property UIView *otherViews;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.scrollView = ({
        UIScrollView *view = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:view];
        view.delegate = self;
        view.contentSize = CGSizeMake(0, 1000);
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        view;
    });
    
    self.calendar = [[KMCalendar alloc] initWithOrigin:CGPointMake(0.f, 0.f)
                                       recordDateArray:nil
                                        andResizeBlock:^{
                                            // do UI Resize
                                            
                                            CGRect rect = self.otherViews.frame;
                                            rect.origin.y = self.calendar.frame.size.height + SPACEING_VALUE_BETWEEN_VIEWS;
                                            self.otherViews.frame = rect;
                                        }];
    self.calendar.delegate = self;
    [self.view addSubview:self.calendar];
    
    self.otherViews = [[UIView alloc] initWithFrame:CGRectMake(0, self.calendar.frame.size.height + self.calendar.frame.origin.y + SPACEING_VALUE_BETWEEN_VIEWS, UI_SCREEN_WIDTH, 200)];
    self.otherViews.backgroundColor = [UIColor whiteColor];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor darkGrayColor];
    
    [self.otherViews addSubview:line];
    
    [self.scrollView addSubview:self.otherViews];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KMCalendarDelegate

- (void)calendarSelectedDate:(NSDate *)date {
    KMLog(@"%@", date);
}

#pragma mark - UIScrollViewDelegate 

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset = scrollView.contentOffset.y;
    
    [self.calendar scrollingAnimationWithOffset:yOffset];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat yOffset = scrollView.contentOffset.y;
    [self.calendar endDragAnimationWithOffset:yOffset scrollView:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat yOffset = scrollView.contentOffset.y;
    [self.calendar endDecelaratingAnimationWithOffset:yOffset scrollView:scrollView];
    
}
@end
