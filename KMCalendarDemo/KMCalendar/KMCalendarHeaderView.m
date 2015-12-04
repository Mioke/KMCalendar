//
//  KMCalendarHeaderView.m
//  KMCalendarDemo
//
//  Created by Klein Mioke on 15/12/4.
//  Copyright © 2015年 KleinMioke. All rights reserved.
//

#import "KMCalendarHeaderView.h"
#import "NSDate+KMCalendar.h"

#define LABEL_WIDTH ([UIScreen mainScreen].bounds.size.width - 30.f) / 7
#define LABEL_HEIGHT 20.f

@implementation KMCalendarHeaderView
{
    UIView *_dateView;
    
    UIButton *preMonthButton;
    UIButton *nextMonthButton;
    UILabel *dateLabel;
    
    UIView *weekdayView;
    
    UIButton *_backToTodayButton;
    
    void (^_preMonth)(void);
    void (^_nextMonth)(void);
    void (^_backToToday)(void);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (instancetype)initWithType:(KMCalendarHeaderType)type onClickPreMonthBlock:(void (^)(void))preMonth onClickNextMonthBlock:(void (^)(void))nextMonth onClickBackToTodayBlock:(void (^)(void))backToToday
{
    _preMonth = preMonth;
    _nextMonth = nextMonth;
    _backToToday = backToToday;
    
    if (self = [super init]) {
        
        if (type == KMCalendarHeaderTypeDefault) {
            
            self.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 40.f + LABEL_HEIGHT);
            self.backgroundColor = [UIColor whiteColor];
            
            _dateView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, UI_SCREEN_WIDTH, 40.f)];
            preMonthButton = [[UIButton alloc] initWithFrame:CGRectMake(15.f, 13.25f, 13.5f, 13.5f)];
            [preMonthButton setBackgroundImage:[UIImage imageNamed:@"record_calendar_left"] forState:UIControlStateNormal];
            [preMonthButton addTarget:self action:@selector(clickPreMonth) forControlEvents:UIControlEventTouchUpInside];
            
            nextMonthButton = [[UIButton alloc] initWithFrame:CGRectMake(130.f, 13.25f, 13.5f, 13.5f)];
            [nextMonthButton setBackgroundImage:[UIImage imageNamed:@"record_calendar_right"] forState:UIControlStateNormal];
            [nextMonthButton addTarget:self action:@selector(clickNextMonth) forControlEvents:UIControlEventTouchUpInside];
            
            dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.f, 5.f, 100.f, 30.f)];
            [dateLabel setFont:[UIFont systemFontOfSize:16]];
            [dateLabel setTextAlignment:NSTextAlignmentCenter];
            
            [_dateView addSubview:preMonthButton];
            [_dateView addSubview:dateLabel];
            [_dateView addSubview:nextMonthButton];
            
            [self addSubview:_dateView];
            
            weekdayView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 40.f, UI_SCREEN_WIDTH, LABEL_HEIGHT)];
            weekdayView.backgroundColor = DEFAULT_TINT_COLOR;
            [self addSubview:weekdayView];
            
            NSArray *dateStringArr = [NSArray arrayWithObjects:@"日", @"一", @"二", @"三", @"四", @"五", @"六", nil];
            CGFloat _xPoint = 15.f;
            for (int i = 0; i < 7; i ++) {
                [weekdayView addSubview:
                 [self weekdayLabelWithOrigin:CGPointMake(_xPoint, 0.f)
                                      andText:dateStringArr[i]]];
                _xPoint += LABEL_WIDTH;
            }
            
            
            if (!self.date) {
                self.date = [NSDate date];
                
                dateLabel.text = [self.date km_formatInKMCalendar];
            }
            
            _backToTodayButton = [[UIButton alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 100.f, 5.f, 100.f, 30.f)];
            [_backToTodayButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [_backToTodayButton setTitleColor:DEFAULT_TINT_COLOR forState:UIControlStateNormal];
            [_backToTodayButton setTitle:@"今天" forState:UIControlStateNormal];
            [_backToTodayButton addTarget:self action:@selector(clickBackToTodayButton) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:_backToTodayButton];
            
        } else if (type == KMCalendarHeaderTypeSimple) {
            
            self.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, LABEL_HEIGHT);
            self.backgroundColor = [UIColor whiteColor];
            
            weekdayView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, UI_SCREEN_WIDTH, LABEL_HEIGHT)];
            weekdayView.backgroundColor = DEFAULT_TINT_COLOR;
            [self addSubview:weekdayView];
            
            NSArray *dateStringArr = [NSArray arrayWithObjects:@"日", @"一", @"二", @"三", @"四", @"五", @"六", nil];
            CGFloat _xPoint = 15.f;
            for (int i = 0; i < 7; i ++) {
                [weekdayView addSubview:
                 [self weekdayLabelWithOrigin:CGPointMake(_xPoint, 0.f)
                                      andText:dateStringArr[i]]];
                _xPoint += LABEL_WIDTH;
            }
        }
    }
    return self;
}

- (UILabel *)weekdayLabelWithOrigin:(CGPoint)origin andText:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(origin.x, origin.y, LABEL_WIDTH, LABEL_HEIGHT)];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont boldSystemFontOfSize:14.f]];
    [label setTextColor:[UIColor whiteColor]];
    [label setText:text];
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    dateLabel.text = [date km_formatInKMCalendar];
}

- (void)clickBackToTodayButton
{
    _backToToday();
}

- (void)clickPreMonth
{
    _preMonth();
}

- (void)clickNextMonth
{
    _nextMonth();
}

@end
