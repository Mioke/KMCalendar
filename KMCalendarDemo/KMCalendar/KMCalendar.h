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

/**
 *  Initialization
 *
 *  @param origin    origin point of calendar, the calendar is default to screen_width
 *  @param dateArray If you want to have a mark under the day, please deliver NSArray<NSdate *>
 *  @param block     If you have static layout of views, please resize your view's origin when month changed
 *  @param second    delay seconds that should reload after initialization
 *
 *  @return self
 */
- (instancetype)initWithOrigin:(CGPoint)origin
               recordDateArray:(NSMutableArray *)dateArray
                andResizeBlock:(void (^)(void))block
                     delayLoad:(CGFloat)second;
/**
 *  Initialization
 *
 *  @param origin    origin point of calendar, the calendar is default to screen_width
 *  @param dateArray If you want to have a mark under the day, please deliver NSArray<NSdate *>
 *  @param block     If you have static layout of views, please resize your view's origin when month changed
 *
 *  @return self
 */
- (instancetype)initWithOrigin:(CGPoint)origin
               recordDateArray:(NSMutableArray *)dateArray
                andResizeBlock:(void (^)(void))block;
/**
 *  Initialization
 *
 *  @param origin    origin point of calendar, the calendar is default to screen_width
 *  @param dateArray If you want to have a mark under the day, please deliver NSArray<NSdate *>
 *  @param type      Calendar's header type
 *  @param block     If you have static layout of views, please resize your view's origin when month changed
 *
 *  @return self
 */
- (instancetype)initWithOrigin:(CGPoint)origin recordDateArray:(NSMutableArray *)dateArray headerType:(KMCalendarHeaderType)type andResizeBlock:(void (^)(void))block;

/**
 *  Change the type of Calendar
 *
 *  @param type calendar's type: Month or Week
 */
- (void)transformToType:(KMCalendarType)type;

- (void)resizeFooterView:(CGFloat)offset;
- (void)offsetHeight:(CGFloat)offset;

#pragma mark - Animation when user scrolling the scrollView
/* ---- */
- (void)scrollingAnimationWithOffset:(CGFloat)yOffset;
- (void)endDragAnimationWithOffset:(CGFloat)yOffset scrollView:(UIScrollView *)scrollView;
- (void)endDecelaratingAnimationWithOffset:(CGFloat)yOffset scrollView:(UIScrollView *)scrollView;
/* ---- */

/**
 *  Set the current date and UI back to today
 */
- (void)backToToday;
/**
 *  Reload the data of calender
 */
- (void)reloadCalendar;

/**
 *  Function apply coder to call, set the seleceted date.
 *
 *  @param date selected date
 *  @param flag should reload after set
 */
- (void)outerSetSelectedDate:(NSDate *)date andNeedReload:(BOOL)flag;

/**
 *  Add an 'back to today' button in footerView
 */
- (void)addBackToTodayButtonInFooterView;

@end
