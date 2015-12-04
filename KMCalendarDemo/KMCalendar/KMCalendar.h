//
//  KMCalendar.h
//  KMCalendarDemo
//
//  Created by Klein Mioke on 15/12/4.
//  Copyright © 2015年 KleinMioke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMCalendarHelper.h"
#import "KMCalendarView.h"
#import "KMCalendarHeaderView.h"

@protocol KMCalendarDelegate <NSObject>

- (void)calendarSelectedDate:(NSDate *)date;

@optional

- (void)calendarScrollToPreMonth;
- (void)calendarScrollToNextMonth;

@end

@interface KMCalendar : UIView

@property (nonatomic          ) KMCalendarType       type;

@property (nonatomic, readonly) CGFloat              heightOfCurrentType;

@property (nonatomic, strong  ) KMCalendarView       *calendarView;
@property (nonatomic, strong  ) KMCalendarHeaderView *headerView;
@property (nonatomic, strong  ) UIView               *footerView;

/**
 *  ues in gesture animation
 */
@property (nonatomic) BOOL isFooterHide;
@property (nonatomic) BOOL isHeaderHide;
@property (nonatomic) BOOL isAnimating;

@property (nonatomic, weak) id <KMCalendarDelegate> delegate;
@property (nonatomic, weak) NSMutableArray *recordDateArray;

- (instancetype)initWithOrigin:(CGPoint)origin
               recordDateArray:(NSMutableArray *)dateArray
                andResizeBlock:(void (^)(void))block
                     delayLoad:(CGFloat)second;

- (instancetype)initWithOrigin:(CGPoint)origin
               recordDateArray:(NSMutableArray *)dateArray
                andResizeBlock:(void (^)(void))block;

- (instancetype)initWithOrigin:(CGPoint)origin recordDateArray:(NSMutableArray *)dateArray headerType:(KMCalendarHeaderType)type andResizeBlock:(void (^)(void))block;

- (void)transformToType:(KMCalendarType)type;

- (void)resizeFooterView:(CGFloat)offset;
- (void)offsetHeight:(CGFloat)offset;

- (void)scrollingAnimationWithOffset:(CGFloat)yOffset;
- (void)endDragAnimationWithOffset:(CGFloat)yOffset scrollView:(UIScrollView *)scrollView;
- (void)endDecelaratingAnimationWithOffset:(CGFloat)yOffset scrollView:(UIScrollView *)scrollView;

- (void)backToToday;
- (void)reloadCalendar;

- (void)outerSetSelectedDate:(NSDate *)date andNeedReload:(BOOL)flag;

- (void)addBackToTodayButtonInFooterView;

@end
