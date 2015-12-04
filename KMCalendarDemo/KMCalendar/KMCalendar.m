//
//  KMCalendar.m
//  KMCalendarDemo
//
//  Created by Klein Mioke on 15/12/4.
//  Copyright © 2015年 KleinMioke. All rights reserved.
//

#import "KMCalendar.h"

#define SPACEING_VALUE_BETWEEN_VIEWS 10.f

#define FOOTER_HEIGHT 40.f
#define HEADER_HEIGHT 40.f
#define WEEKDAY_HEIGHT 20.f

#define SELF_HEIGHT self.headerView.frame.size.height + _calendarScrollView.frame.size.height + self.footerView.frame.size.height

@interface KMCalendar () <UIScrollViewDelegate>
{
    CGFloat _openedHeight;
    CGFloat _closedHeight;
    
    CGFloat _calendarViewHeight;
    
    UIView *_footerLine;
    UIScrollView *_calendarScrollView;
    
    KMCalendarView *_preMonth;
    KMCalendarView *_nextMonth;
    /**
     *  选中的天的日期
     */
    NSDate *_sDate;
    
    void(^_resizeBlock)(void);
    
    BOOL _isNeedDelegateRespond;
    
    CGFloat _delay;
    
    KMCalendarHeaderType _headerType;
}
/**
 *  当前显示的月份日期
 */
@property (nonatomic, strong) NSDate *currentDate;

@end

@implementation KMCalendar

#pragma mark - initialization

- (instancetype)init
{
    if (self = [super init]) {
        [self initialize];
        
    }
    return self;
}

- (instancetype)initWithOrigin:(CGPoint)origin recordDateArray:(NSMutableArray *)dateArray headerType:(KMCalendarHeaderType)type andResizeBlock:(void (^)(void))block {
    
    _headerType = type;
    if (self = [self initWithOrigin:origin recordDateArray:dateArray andResizeBlock:block]) {
        
    }
    return self;
}

- (instancetype)initWithOrigin:(CGPoint)origin
               recordDateArray:(NSMutableArray *)dateArray
                andResizeBlock:(void (^)(void))block
                     delayLoad:(CGFloat)second {
    _delay = second;
    if (self = [self initWithOrigin:origin recordDateArray:dateArray andResizeBlock:block]) {
        
        return self;
    }
    return nil;
}

- (instancetype)initWithOrigin:(CGPoint)origin recordDateArray:(NSMutableArray *)dateArray andResizeBlock:(void (^)(void))block
{
    if (self = [super init]) {
        self.recordDateArray = dateArray;
        _isNeedDelegateRespond = NO;
        [self initialize];
        self.type = KMCalendarTypeMonth;
        _resizeBlock = block;
        
        CGRect rect = self.frame;
        rect.origin = origin;
        self.frame = rect;
        
    }
    return self;
}

- (void)initialize
{
    self.clipsToBounds = YES;
    self.isHeaderHide = NO;
    self.isFooterHide = NO;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear |NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitTimeZone | NSCalendarUnitHour fromDate:[NSDate date]];
    [comps setHour:12];
    self.currentDate = [calendar dateFromComponents:comps];
    KMLog(@"init date :%@", self.currentDate);
    
    [self initSubviews];
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, SELF_HEIGHT);
    _openedHeight = SELF_HEIGHT;
    _heightOfCurrentType = SELF_HEIGHT;
    
    self.backgroundColor = [UIColor whiteColor];
    self.autoresizesSubviews = NO;
}

- (void)initSubviews
{
    self.headerView = [[KMCalendarHeaderView alloc] initWithType:_headerType
                                            onClickPreMonthBlock:^{
                                                  [self scrollBackToPreMonth];
                                            }
                                           onClickNextMonthBlock:^{
                                                  [self scrollToNextMonth];
                                           }
                                         onClickBackToTodayBlock:^{
                                                  [self backToToday];
                                         }];
    [self addSubview:self.headerView];
    
    _calendarScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.headerView.frame.origin.y + self.headerView.frame.size.height, UI_SCREEN_WIDTH, 150.f)];
    [_calendarScrollView setContentSize:CGSizeMake(UI_SCREEN_WIDTH * 3, 0)];
    _calendarScrollView.pagingEnabled = YES;
    _calendarScrollView.showsHorizontalScrollIndicator = NO;
    _calendarScrollView.bounces = NO;
    [_calendarScrollView setContentOffset:CGPointMake(UI_SCREEN_WIDTH, 0)];
    _calendarScrollView.delegate = self;
    [self addSubview:_calendarScrollView];
    
    self.calendarView = [[KMCalendarView alloc] initWithDate:self.currentDate
                                               recordDateArray:_recordDateArray
                                                  returnHeight:^(CGFloat height) {
                                                      
                                                      CGRect rect = _calendarScrollView.frame;
                                                      rect.size.height = height;
                                                      _calendarScrollView.frame = rect;
                                                      
                                                  }
                                                clickDateBlock:^(NSDate *date, BOOL outOfMonth) {
                                                    KMLog(@"\n=========\nclick: %@", date);
                                                    
                                                    if (self.calendarView.type == KMCalendarTypeWeek && outOfMonth) {
                                                        NSCalendar *cal = [NSCalendar currentCalendar];
                                                        NSDateComponents *comps = [cal components:NSCalendarUnitYear |NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitTimeZone | NSCalendarUnitHour fromDate:date];
                                                        [comps setHour:12];
                                                        
                                                        date = [cal dateFromComponents:comps];
                                                        
                                                        self.currentDate = date;
                                                        [self reloadCalendarViewTypeWeek];
                                                        [self setSelectedDate:date];
                                                    } else if (self.calendarView.type == KMCalendarTypeMonth && outOfMonth) {
                                                        
                                                        NSCalendar *cal = [NSCalendar currentCalendar];
                                                        NSDateComponents *comps = [cal components:NSCalendarUnitYear |NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitTimeZone | NSCalendarUnitHour fromDate:date];
                                                        
                                                        if (comps.day > 20) {
                                                            [_calendarScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                                                        } else {
                                                            [_calendarScrollView setContentOffset:CGPointMake(UI_SCREEN_WIDTH * 2, 0) animated:YES];
                                                        }
                                                        [self setSelectedDate:date];
                                                        
                                                    } else {
                                                        [self setSelectedDate:date];
                                                    }
                                                    
                                                    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarSelectedDate:)]) {
                                                        [self.delegate calendarSelectedDate:date];
                                                    }
                                                }];
    
//    [self.calendarView setX:XKAppWidth];
    CGRect frame = self.calendarView.frame;
    frame.origin.x = UI_SCREEN_WIDTH;
    self.calendarView.frame = frame;
    
    [_calendarScrollView addSubview:self.calendarView];
    [self.calendarView setDateSelected:self.currentDate];
    _sDate = self.currentDate;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _preMonth = [[KMCalendarView alloc] initWithDate:[KMCalendarHelper getPreviousMonth:self.currentDate]
                                               recordDateArray:_recordDateArray
                                                  returnHeight:^(CGFloat height) {
                                                      
                                                  }
                                                clickDateBlock:nil];
            CGRect frame = _preMonth.frame;
            frame.origin.x = 0.f;
            _preMonth.frame = frame;
            
            [_calendarScrollView addSubview:_preMonth];
            [_preMonth setDateSelected:self.currentDate];
        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _nextMonth = [[KMCalendarView alloc] initWithDate:[KMCalendarHelper getNextMonth:self.currentDate]
                                                recordDateArray:_recordDateArray
                                                   returnHeight:^(CGFloat height) {
                                                       
                                                   }
                                                 clickDateBlock:nil];
            CGRect frame = _nextMonth.frame;
            frame.origin.x = UI_SCREEN_WIDTH * 2;
            _nextMonth.frame = frame;

            [_calendarScrollView addSubview:_nextMonth];
            [_nextMonth setDateSelected:self.currentDate];
        });
    });
    
    
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, _calendarScrollView.frame.origin.y + _calendarScrollView.frame.size.height, UI_SCREEN_WIDTH, 40.f)];
    self.footerView.backgroundColor = [UIColor whiteColor];
    self.footerView.clipsToBounds = YES;
    [self addSubview:self.footerView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(27.f, 0.f, 150.f, 40.f)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"为记录日期";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor =  [[UIColor blackColor] colorWithAlphaComponent:0.8];
    
    [self.footerView addSubview:label];
    
    UIImageView *dot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dotGreen"]];
    dot.frame = CGRectMake(18.f, 19.f, 4.f, 4.f);
    [self.footerView addSubview:dot];
    
    _footerLine = [[UIView alloc] initWithFrame:CGRectMake(0.f, self.frame.size.height - 0.5f, UI_SCREEN_WIDTH, 0.5f)];
    _footerLine.backgroundColor = [UIColor grayColor];
    
    [self addSubview:_footerLine];
}

- (void)setSelectedDate:(NSDate *)date
{
    _sDate = date;
    [self.calendarView setDateSelected:date];
    [_preMonth setDateSelected:date];
    [_nextMonth setDateSelected:date];
}

- (void)outerSetSelectedDate:(NSDate *)date andNeedReload:(BOOL)flag
{
    _sDate = date;
    
    if (flag) {
        [self setSelectedDate:date];
    } else {
        self.calendarView.selectedDay = date;
        _preMonth.selectedDay = date;
        _nextMonth.selectedDay = date;
    }
}

#pragma mark - animations

/**
 *  改变显示的样式（周或月）
 *
 *  @param type 将要改变的样式
 */
- (void)transformToType:(KMCalendarType)type
{
    self.type = type;
    _preMonth.type = type;
    self.calendarView.type = type;
    _nextMonth.type = type;
    
    if (type == KMCalendarTypeMonth) {
        [self reloadCalendarViewTypeMonth];
        
    } else {
        if ([_sDate km_isMonthEqualToDate:self.currentDate]) {
            [self reloadCalendarViewTypeWeekWithDate:_sDate animation:NO];
            self.currentDate = _sDate;
            
        } else {
            self.currentDate = [self.currentDate km_firstDayInMonth];
            [self reloadCalendarViewTypeWeekWithDate:self.currentDate animation:NO];
        }
    }
}

- (void)resizeFooterView:(CGFloat)offset
{
    CGRect newRect = self.footerView.frame;
    newRect.size.height = 40.f + offset;
    self.footerView.frame = newRect;
}
/**
 *  根据offset重绘frame大小
 *
 *  @param offset 偏移量
 */
- (void)offsetHeight:(CGFloat)offset
{
    CGRect newRect = self.frame;
    newRect.size.height = _openedHeight + offset;
    self.frame = newRect;
    
    newRect = _footerLine.frame;
    newRect.origin.y = self.frame.size.height - 0.5f;
    _footerLine.frame = newRect;
}

- (void)scrollingAnimationWithOffset:(CGFloat)yOffset
{
    if (_calendarScrollView.isUserInteractionEnabled) {
        [_calendarScrollView setUserInteractionEnabled:NO];
    }
    if (self.isAnimating) {
        return;
    }
    if (yOffset <= 0.f) {
        [self setY:-yOffset];
        [self offsetHeight:0.f];
        if (self.calendarView.frame.origin.y != 0.f) {
            [self.calendarView offsetYPoint:0.f];
        }
        
        if (self.isHeaderHide) {
            self.isHeaderHide = NO;
        }
        
        if (self.isFooterHide) {
            self.isFooterHide = NO;
        }
    } else if (yOffset <= HEADER_HEIGHT) {
        
        if (self.isFooterHide) {
            self.isFooterHide = NO;
            [self offsetHeight:0.f];
        }
        if (self.isHeaderHide) {
            self.isHeaderHide = NO;
        }
        
        [self setY:-yOffset];
        if (self.calendarView.frame.origin.y != 0.f) {
            [self.calendarView offsetYPoint:0.f];
        }
        
        
    } else if (yOffset <= HEADER_HEIGHT + SPACEING_VALUE_BETWEEN_VIEWS) {
        
    } else if (yOffset <= HEADER_HEIGHT + SPACEING_VALUE_BETWEEN_VIEWS + FOOTER_HEIGHT) {
        if (!self.isHeaderHide) {
            self.isHeaderHide = YES;
            [self setY:-HEADER_HEIGHT];
        }
        if (self.isFooterHide) {
            self.isFooterHide = NO;
        }
        
        [self offsetHeight:-yOffset + HEADER_HEIGHT + SPACEING_VALUE_BETWEEN_VIEWS];
    } else {
        if (!self.isFooterHide) {
            self.isFooterHide = YES;
            [self offsetHeight:-FOOTER_HEIGHT];
        }
        if (!self.isHeaderHide) {
            self.isHeaderHide = YES;
            [self setY:-HEADER_HEIGHT];
        }
        if (yOffset <= self.calendarView.frame.size.height - [self.calendarView animationEndBottomLine] + 80.f + SPACEING_VALUE_BETWEEN_VIEWS) {
            
            [self offsetHeight:-yOffset + FOOTER_HEIGHT + SPACEING_VALUE_BETWEEN_VIEWS];
        } else if (yOffset <= self.calendarView.frame.size.height - [self.calendarView animationEndBottomLine] + 80.f + SPACEING_VALUE_BETWEEN_VIEWS + [self.calendarView animationEndTopLine]) {
            
            //            [self offsetHeight:self.calendarView.height - [self.calendarView animationEndBottomLine] + 80.f + SPACEING_VALUE_BETWEEN_VIEWS];
            [self.calendarView offsetYPoint:-yOffset + _heightOfCurrentType - WEEKDAY_HEIGHT - [self.calendarView animationEndBottomLine]+ SPACEING_VALUE_BETWEEN_VIEWS];
            [self offsetHeight:-yOffset + HEADER_HEIGHT + SPACEING_VALUE_BETWEEN_VIEWS];
            
        } else {
            [self offsetHeight:-self.heightOfCurrentType + FOOTER_HEIGHT + HEADER_HEIGHT + SPACEING_VALUE_BETWEEN_VIEWS];
            [self.calendarView offsetYPoint:-[self.calendarView animationEndTopLine]];
        }
    }
}

- (void)endDragAnimationWithOffset:(CGFloat)yOffset scrollView:(UIScrollView *)scrollView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!scrollView.isDecelerating) {
            if (yOffset > 150.f && yOffset <= _heightOfCurrentType - 20.f) {
                if (self.type == KMCalendarTypeMonth) {
                    [self closeAnimation:scrollView];
                    [self transformToType:KMCalendarTypeWeek];
                } else {
                    [self closeAnimation:scrollView];
                }
            } else if (yOffset > 0 && yOffset <= 150.f) {
                
                if (self.type == KMCalendarTypeWeek) {
                    [self openAnimation:scrollView];
                    [self transformToType:KMCalendarTypeMonth];
                } else {
                    [self openAnimation:scrollView];
                }
            }
            if (!_calendarScrollView.isUserInteractionEnabled) {
                [_calendarScrollView setUserInteractionEnabled:YES];
            }
        }
    });
}

- (void)closeAnimation:(UIScrollView *)scrollView
{
    self.isAnimating = YES;
    [UIView animateWithDuration:0.3f animations:^{
        [self offsetHeight:-self.heightOfCurrentType + FOOTER_HEIGHT + HEADER_HEIGHT + SPACEING_VALUE_BETWEEN_VIEWS];
        [self.calendarView offsetYPoint:-[self.calendarView animationEndTopLine]];
        [self setY:-40.f];
        [scrollView setContentOffset:CGPointMake(0.f, _heightOfCurrentType - 40.f)];
    } completion:^(BOOL finished) {
        self.isAnimating = NO;
        KMLog(@"offset: %g", scrollView.contentOffset.y);
    }];
}

- (void)openAnimation:(UIScrollView *)scrollView
{
    self.isAnimating = YES;
    [UIView animateWithDuration:0.3f animations:^{
        [self offsetHeight:0.f];
        [self.calendarView offsetYPoint:0.f];
        [self setY:0.f];
        [scrollView setContentOffset:CGPointMake(0, 0)];
    } completion:^(BOOL finished) {
        self.isAnimating = NO;
    }];
}

- (void)endDecelaratingAnimationWithOffset:(CGFloat)yOffset scrollView:(UIScrollView *)scrollView
{
    if (yOffset > 150.f && yOffset <= _heightOfCurrentType - 20.f) {
        if (self.type == KMCalendarTypeMonth) {
            [self closeAnimation:scrollView];
            [self transformToType:KMCalendarTypeWeek];
        } else {
            [self closeAnimation:scrollView];
        }
    } else if (yOffset >= 0 && yOffset <= 150.f) {
        
        if (self.type == KMCalendarTypeWeek) {
            [self openAnimation:scrollView];
            [self transformToType:KMCalendarTypeMonth];
        } else {
            [self openAnimation:scrollView];
        }
    } else if (yOffset > _heightOfCurrentType - 20.f) {
        [self transformToType:KMCalendarTypeWeek];
    }
    if (!_calendarScrollView.isUserInteractionEnabled) {
        [_calendarScrollView setUserInteractionEnabled:YES];
    }
}

- (void)resizeFrameWithAnimation:(BOOL)yesOrNo
{
    if (yesOrNo) {
        [UIView animateWithDuration:0.25f animations:^{
            CGRect rect = _calendarScrollView.frame;
            rect.size.height = _calendarViewHeight;
            _calendarScrollView.frame = rect;
            
            rect = self.footerView.frame;
            rect.origin.y = _calendarScrollView.frame.origin.y + _calendarScrollView.frame.size.height;
            self.footerView.frame = rect;
            
            rect = self.frame;
            rect.size.height = SELF_HEIGHT;
            _openedHeight = SELF_HEIGHT;
            _heightOfCurrentType = SELF_HEIGHT;
            self.frame = rect;
            
            rect = _footerLine.frame;
            rect.origin.y = self.frame.size.height - 0.5f;
            _footerLine.frame = rect;

            _resizeBlock();
            
        } completion:^(BOOL finished) {
            
        }];
    } else {
        CGRect rect = _calendarScrollView.frame;
        rect.size.height = _calendarViewHeight;
        _calendarScrollView.frame = rect;
        
        rect = self.footerView.frame;
        rect.origin.y = _calendarScrollView.frame.origin.y + _calendarScrollView.frame.size.height;
        self.footerView.frame = rect;
        
        rect = self.frame;
        rect.size.height = SELF_HEIGHT;
        _openedHeight = SELF_HEIGHT;
        _heightOfCurrentType = SELF_HEIGHT;
        self.frame = rect;
        
        rect = _footerLine.frame;
        rect.origin.y = self.frame.size.height - 0.5f;
        _footerLine.frame = rect;
    }
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self redrawCalendarViews:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self redrawCalendarViews:scrollView];
}

- (void)redrawCalendarViews:(UIScrollView *)scrollView
{
    if (self.type == KMCalendarTypeMonth) {
        
        if (scrollView.contentOffset.x < UI_SCREEN_WIDTH) {
            
            self.currentDate = [KMCalendarHelper getPreviousMonth:self.currentDate];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(calendarScrollToPreMonth)]) {
                [self.delegate calendarScrollToPreMonth];
            }
            
        } else if (scrollView.contentOffset.x >= UI_SCREEN_WIDTH * 2) {
            
            self.currentDate = [KMCalendarHelper getNextMonth:self.currentDate];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(calendarScrollToNextMonth)]) {
                [self.delegate calendarScrollToNextMonth];
            }
        }
        [self reloadCalendarViewTypeMonth];
        
    } else {
        NSDate *date;
        
        if (scrollView.contentOffset.x < UI_SCREEN_WIDTH) {
            date = [self.currentDate km_offsetWeekOfYear:-1];
            
            if (![date km_isMonthEqualToDate:self.currentDate]) {
                NSCalendar *calendar = [NSCalendar currentCalendar];
                NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitTimeZone fromDate:self.currentDate];
                [comps setDay:1];
                [comps setHour:12];
                NSDate *newDate = [calendar dateFromComponents:comps];
                
                if ([newDate km_isWeekEqualToDate:date]) {
                    self.currentDate = newDate;
                } else {
                    self.currentDate = date;
                }
            } else {
                self.currentDate = date;
            }
            KMLog(@"current date: %@", self.currentDate);
            [self reloadCalendarViewTypeWeek];
            
        } else if (scrollView.contentOffset.x >= UI_SCREEN_WIDTH * 2) {
            date = [self.currentDate km_offsetWeekOfYear:1];
            
            if (![date km_isMonthEqualToDate:self.currentDate]) {
                NSCalendar *calendar = [NSCalendar currentCalendar];
                NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitTimeZone fromDate:self.currentDate];
                [comps setDay:[self.currentDate km_numberOfDaysInMonth]];
                [comps setHour:12];
                NSDate *newDate = [calendar dateFromComponents:comps];
                
                if ([newDate km_isWeekEqualToDate:date]) {
                    self.currentDate = newDate;
                } else {
                    self.currentDate = date;
                }
            } else {
                self.currentDate = date;
            }
            KMLog(@"current date: %@", self.currentDate);
            [self reloadCalendarViewTypeWeek];
        }
    }
    if (_isNeedDelegateRespond) {
        [self.delegate calendarSelectedDate:_sDate];
        _isNeedDelegateRespond = NO;
    }
}

#pragma mark - reload funtions

- (void)reloadCalendarViewTypeMonth
{
    __block CGFloat delta = 0.f;
    
    CGRect rect = self.calendarView.frame;
    rect.origin.y = 0;
    self.calendarView.frame = rect;
    
    [self.calendarView resetWithDate:self.currentDate
                        returnHeight:^(CGFloat height) {
                            delta = height - _calendarViewHeight;
                            _calendarViewHeight = height;
                        }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_preMonth resetWithDate:[KMCalendarHelper getPreviousMonth:self.currentDate]
                    returnHeight:^(CGFloat height) {
                        
                    }];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [_nextMonth resetWithDate:[KMCalendarHelper getNextMonth:self.currentDate]
                     returnHeight:^(CGFloat height) {
                         
                     }];
    });
    
    [self.headerView setDate:self.currentDate];
    
    [_calendarScrollView setContentOffset:CGPointMake(UI_SCREEN_WIDTH, 0.f)];
    [self resizeFrameWithAnimation:YES];
}

- (void)reloadCalendarViewTypeWeek
{
    [self reloadCalendarViewTypeWeekWithDate:self.currentDate animation:NO];
}

- (void)reloadCalendarViewTypeWeekWithDate:(NSDate *)date animation:(BOOL)yesOrNo
{
    [self.calendarView resetWeekStyleAsPrimaryView:date
                                         animation:yesOrNo
                                      returnHeight:^(CGFloat height) {
                                          _calendarViewHeight = height;
                                      }];
    
    NSDate *preWeek = [date km_offsetWeekOfYear:-1];
    NSDate *nextWeek = [date km_offsetWeekOfYear:1];
    
    if ([preWeek km_isMonthEqualToDate:date]) {
        [_preMonth resetWeekStyleWithDate:preWeek];
    } else {
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitTimeZone fromDate:date];
        [comps setDay:1];
        [comps setHour:12];
        NSDate *newDate = [calendar dateFromComponents:comps];
        
        if ([newDate km_isWeekEqualToDate:preWeek]) {
            [_preMonth resetWeekStyleWithDate:newDate];
            
        } else {
            [_preMonth resetWeekStyleWithDate:preWeek];
        }
    }
    
    
    if ([nextWeek km_isMonthEqualToDate:date]) {
        [_nextMonth resetWeekStyleWithDate:nextWeek];
    } else {
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitTimeZone fromDate:date];
        [comps setDay:[date km_numberOfDaysInMonth]];
        [comps setHour:12];
        NSDate *newDate = [calendar dateFromComponents:comps];
        
        if ([newDate km_isWeekEqualToDate:nextWeek]) {
            [_nextMonth resetWeekStyleWithDate:newDate];
            
        } else {
            [_nextMonth resetWeekStyleWithDate:nextWeek];
        }
    }
    
    [_calendarScrollView setContentOffset:CGPointMake(UI_SCREEN_WIDTH, 0.f)];
    [self.headerView setDate:date];
    //    [self resizeFrameWithAnimation:NO];
}

- (void)reloadCalendar
{
    if (self.type == KMCalendarTypeMonth) {
        [self reloadCalendarViewTypeMonth];
    } else {
        [self reloadCalendarViewTypeWeek];
    }
}

#pragma mark - public function

- (void)backToToday
{
    if ([self.currentDate km_isMonthEqualToDate:[NSDate date]]) {
        [self setSelectedDate:[NSDate date]];
        [self.delegate calendarSelectedDate:[NSDate date]];
        
    } else {
        [_nextMonth resetWithDate:[NSDate date] returnHeight:nil];
        /**
         *  -1是因为reload方法之前判断scrollview的offset，如果为screenWidth*2的话，currentDate会自动+1
         */
        self.currentDate = [[NSDate date] km_offsetMonth:-1];
        
        [self setSelectedDate:[NSDate date]];
        
        _isNeedDelegateRespond = YES;
        [_calendarScrollView setContentOffset:CGPointMake(UI_SCREEN_WIDTH * 2, 0) animated:YES];
    }
}

- (void)scrollBackToCurrentMonth {
    
    if ([self.currentDate km_isMonthEqualToDate:[NSDate date]]) {
        return;
    } else {
        [_nextMonth resetWithDate:[NSDate date] returnHeight:nil];
        /**
         *  -1是因为reload方法之前判断scrollview的offset，如果为screenWidth*2的话，currentDate会自动+1
         */
        self.currentDate = [[NSDate date] km_offsetMonth:-1];
        
        [self setSelectedDate:[NSDate date]];
        
        _isNeedDelegateRespond = NO;
        [_calendarScrollView setContentOffset:CGPointMake(UI_SCREEN_WIDTH * 2, 0) animated:YES];
    }
}

- (void)scrollBackToPreMonth
{
    [_calendarScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)scrollToNextMonth
{
    [_calendarScrollView setContentOffset:CGPointMake(UI_SCREEN_WIDTH * 2, 0) animated:YES];
}

- (void)addBackToTodayButtonInFooterView {
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.footerView.frame.size.width - 75 - 20, 7, 75, 26)];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.borderColor = DEFAULT_TINT_COLOR.CGColor;
    button.layer.borderWidth = 1;
    
    button.layer.cornerRadius = 4;
    button.layer.masksToBounds = YES;
    
    [button setTitle:@"回今天" forState:UIControlStateNormal];
    [button setTitleColor:DEFAULT_TINT_COLOR forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [button addTarget:self action:@selector(backToToday) forControlEvents:UIControlEventTouchUpInside];
    
    [self.footerView addSubview:button];
}

- (void)setY:(CGFloat)y {
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}
@end
