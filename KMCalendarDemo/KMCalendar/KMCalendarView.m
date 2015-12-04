//
//  KMCalendarView.m
//  KMCalendarDemo
//
//  Created by Klein Mioke on 15/12/4.
//  Copyright © 2015年 KleinMioke. All rights reserved.
//

#import "KMCalendarView.h"
#import "NSDate+KMCalendar.h"
#import "KMCalendarItem.h"

@implementation KMCalendarView
{
    NSInteger _numberOfDayInMonth;
    NSInteger _weekday;
    
    NSInteger _numberOfLine;
    CGFloat _originalY;
    
    NSMutableArray *_itemArray;
    void (^_clickBlock)(NSDate *, BOOL outOfMonth);
}

- (instancetype)init
{
    if (self = [super init]) {
        self.frame = CGRectMake(0.f, 0.f, UI_SCREEN_WIDTH, 150.f);
        _originalY = 0.f;
        self.backgroundColor = [UIColor whiteColor];
        _itemArray = [NSMutableArray array];
        self.type = KMCalendarTypeMonth;
    }
    return self;
}

- (instancetype)initWithDate:(NSDate *)date
             recordDateArray:(NSArray *)dateArray
                returnHeight:(void (^)(CGFloat height))block
              clickDateBlock:(void (^)(NSDate *date, BOOL outOfMonth))block2
{
    self = [self init];
    self.recordDateArray = dateArray;
    [self initCalendarItemsWithDate:date clickDateBlock:block2];
    block(_numberOfLine * 30.f);
    
    CGRect rect = self.frame;
    rect.size.height = _numberOfLine * 30.f;
    self.frame = rect;
    
    return self;
}
/**
 *  重置方法，仅在Type为Month时使用
 *
 *  @param date  重置之后的月份
 *  @param block 返回高度及相应相应方法
 */
- (void)resetWithDate:(NSDate *)date returnHeight:(void (^)(CGFloat height))block
{
    //    [self removeAllItems];
    //    [self initCalendarItemsWithDate:date clickDateBlock:nil];
    
    self.date = date;
    BOOL flag = NO;
    if ([self.date km_isMonthEqualToDate:[NSDate date]]) {
        flag = YES;
    }
    _numberOfDayInMonth = [date km_numberOfDaysInMonth];
    _numberOfLine = 1;
    _weekday = [date km_firstWeekDayInMonth];
    
    __block NSInteger day = 1;
    __block NSInteger offset = day - _weekday;
    
    [_itemArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        KMCalendarItem *item = (KMCalendarItem *)obj;
        BOOL isToday = NO;
        if (flag) {
            if (day == [NSDate date].day) {
                isToday = YES;
            }
        }
        if ((idx + 1) >= _weekday && day <= _numberOfDayInMonth) {
            NSDate *itemDate = [[date km_firstDayInMonth] km_offsetDay:day - 1];
            BOOL isRecord = NO;
            for (NSDate *temp_date in self.recordDateArray) {
                if ([temp_date km_isDayEqualToDate:itemDate]) {
                    isRecord = YES;
                    break;
                }
            }
            [item setDay:[NSString stringWithFormat:@"%d", (int)day]
              outOfMonth:NO
                 isToday:isToday
                isRecord:isRecord];
            item.tag = day;
            day ++;
            if (item.hidden == YES) {
                //                [item setHidden:NO withAnimation:YES];
            }
        } else {
            NSDate *itemDate = [[date km_firstDayInMonth] km_offsetDay:offset];
            if ([itemDate km_isDayEqualToDate:[NSDate date]]) {
                isToday = YES;
            }
            BOOL isRecord = NO;
            for (NSDate *temp_date in self.recordDateArray) {
                if ([temp_date km_isDayEqualToDate:itemDate]) {
                    isRecord = YES;
                    break;
                }
            }
            [item setDay:[NSString stringWithFormat:@"%ld", (long)[[date km_firstDayInMonth] km_offsetDay:offset].day]
              outOfMonth:YES
                 isToday:isToday
                isRecord:isRecord];
            item.tag = [[date km_firstDayInMonth] km_offsetDay:offset].day + 100;
            
            //            [item setHidden:YES withAnimation:YES];
        }
        offset ++;
        if (item.isSelected) {
            [item setSelected:NO];
        }
    }];
    
    if ((_numberOfDayInMonth - (8 - _weekday)) % 7) {
        _numberOfLine = (_numberOfDayInMonth - (8 - _weekday)) / 7 + 2;
    } else {
        _numberOfLine = (_numberOfDayInMonth - (8 - _weekday)) / 7 + 1;
    }
    
    if ([date km_isMonthEqualToDate:self.selectedDay]) {
        [self setDateSelected:self.selectedDay];
        self.currentLine = [self.selectedDay km_weekOfMonth];
    } else if ([self.selectedDay km_isWeekEqualToDate:[date km_firstDayInMonth]] ||
               [self.selectedDay km_isWeekEqualToDate:[date km_lastDayInMonth]]) {
        
        KMCalendarItem *item = (KMCalendarItem *)[self viewWithTag:100 + self.selectedDay.day];
        [item setSelected:YES];
    } else {
        self.currentLine = 1;
    }
    if (block) {
        block(_numberOfLine * 30.f);
    }
    
    CGRect rect = self.frame;
    rect.size.height = _numberOfLine * 30.f;
    self.frame = rect;
}
/**
 *  按月显示时初始化方法
 *
 *  @param date  显示月份
 *  @param block 点击item时触发响应事件
 */
- (void)initCalendarItemsWithDate:(NSDate *)date clickDateBlock:(void (^)(NSDate *date, BOOL outOfMonth))block
{
    self.date = date;
    BOOL flag = NO;
    if ([self.date km_isMonthEqualToDate:[NSDate date]]) {
        flag = YES;
    }
    
    if (!_clickBlock) {
        _clickBlock = block;
    }
    
    CGFloat _xPoint = 15.f, _yPoint = 0.f;
    
    _numberOfDayInMonth = [date km_numberOfDaysInMonth];
    _numberOfLine = 1;
    _weekday = [date km_firstWeekDayInMonth];
    
    NSInteger day = 1;
    NSInteger offset = day - _weekday;
    
    for (int i = 1; i <= 42; i ++) {
        if (_xPoint > UI_SCREEN_WIDTH - 15.f - ITEM_WIDTH / 2) {
            _xPoint = 15.f;
            _yPoint += 30.f;
            if (day <= _numberOfDayInMonth) {
                _numberOfLine ++;
            }
        }
        BOOL isToday = NO;
        if (flag) {
            if (day == [NSDate date].day) {
                isToday = YES;
            }
        }
        
        KMCalendarItem *item =
        [[KMCalendarItem alloc] initWithOrigin:CGPointMake(_xPoint, _yPoint)
                                       withTitle:@"-"
                                          record:NO
                                      isSelected:NO
                                      outOfMonth:NO
                                         isToday:NO
                                    onClickBlock:^(KMCalendarItem *item) {
                                        if (item.isSelected == NO) {
                                            [_itemArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                KMCalendarItem *it = (KMCalendarItem *)obj;
                                                if (it.tag != item.tag && it.isSelected == YES) {
                                                    [it setSelected:NO];
                                                }
                                            }];
                                            
                                            NSCalendar *cal = [NSCalendar currentCalendar];
                                            NSDateComponents *comps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitTimeZone fromDate:self.date];
                                            
                                            if (item.outOfMonth) {
                                                [comps setDay:item.tag - 100];
                                                if (comps.day < 8) {
                                                    [comps setMonth:comps.month + 1];
                                                } else {
                                                    [comps setMonth:comps.month - 1];
                                                }
                                                
                                            } else {
                                                [comps setDay:item.tag];
                                            }
                                            [comps setHour:12];
                                            NSDate *clickedDate = [cal dateFromComponents:comps];
                                            _clickBlock(clickedDate, item.outOfMonth);
                                            
                                            self.selectedLine = [clickedDate km_weekOfMonth];
                                            self.currentLine = self.selectedLine;
                                            
                                        } else {
                                            return;
                                        }
                                    }];
        if (i >= _weekday && day <= _numberOfDayInMonth) {
            NSDate *itemDate = [[date km_firstDayInMonth] km_offsetDay:day - 1];
            BOOL isRecord = NO;
            for (NSDate *temp_date in self.recordDateArray) {
                if ([temp_date km_isDayEqualToDate:itemDate]) {
                    isRecord = YES;
                    break;
                }
            }
            [item setDay:[NSString stringWithFormat:@"%d", (int)day]
              outOfMonth:NO
                 isToday:isToday
                isRecord:isRecord];
            item.tag = day;
            day ++;
        } else {
            NSDate *itemDate = [[date km_firstDayInMonth] km_offsetDay:offset];
            if ([itemDate km_isDayEqualToDate:[NSDate date]]) {
                isToday = YES;
            }
            BOOL isRecord = NO;
            for (NSDate *temp_date in self.recordDateArray) {
                if ([temp_date km_isDayEqualToDate:itemDate]) {
                    isRecord = YES;
                    break;
                }
            }
            [item setDay:[NSString stringWithFormat:@"%ld", (long)[[date km_firstDayInMonth] km_offsetDay:offset].day]
              outOfMonth:YES
                 isToday:isToday
                isRecord:isRecord];
            item.tag = [[date km_firstDayInMonth] km_offsetDay:offset].day + 100;
            
            
            //            [item setHidden:YES withAnimation:NO];
        }
        offset ++;
        
        [_itemArray addObject:item];
        [self addSubview:item];
        
        _xPoint += ITEM_WIDTH;
    }
}
/**
 *  设置选中的日期
 *
 *  @param date 选中日期
 */
- (void)setDateSelected:(NSDate *)date
{
    self.selectedDay = date;
    [_itemArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        KMCalendarItem *item = (KMCalendarItem *)obj;
        if (item.isSelected) {
            [item setSelected:NO];
        }
    }];
    if (self.type == KMCalendarTypeMonth) {
        
        if (![date km_isMonthEqualToDate:self.date]) {
            self.currentLine = 1;
            return;
        }
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comps = [calendar components:NSCalendarUnitDay fromDate:date];
        KMCalendarItem *item = (KMCalendarItem *)[self viewWithTag:comps.day];
        
        self.selectedLine = (int)(item.frame.origin.y / 30 + 1);
        self.currentLine = self.selectedLine;
        [item setSelected:YES];
        
    } else {
        
        if (![self.selectedDay km_isWeekEqualToDate:self.date]) {
            return;
        }
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comps = [calendar components:NSCalendarUnitDay fromDate:date];
        KMCalendarItem *item;
        if ([self.selectedDay km_isMonthEqualToDate:self.date]) {
            item = (KMCalendarItem *)[self viewWithTag:comps.day];
            
        } else {
            item = (KMCalendarItem *)[self viewWithTag:comps.day + 100];
        }
        self.selectedLine = (int)(item.frame.origin.y / 30 + 1);
        [item setSelected:YES];
    }
}

- (void)removeAllItems
{
    [_itemArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        KMCalendarItem *item = (KMCalendarItem *)obj;
        [item removeFromSuperview];
    }];
    [_itemArray removeAllObjects];
}

#pragma mark - type of week

- (void)setTypeToWeek
{
    [self resetWeekStyleWithDate:self.selectedDay];
}
/**
 *  scrollview中间视图主要显示的日历
 *
 *  @param date    将要显示的周的日期
 *  @param yesOrNo 是否有动画
 */
- (void)resetWeekStyleAsPrimaryView:(NSDate *)date animation:(BOOL)yesOrNo returnHeight:(void (^)(CGFloat height))block
{
    [_itemArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        KMCalendarItem *item = (KMCalendarItem *)obj;
        if (item.isHidden) {
            //            [item setHidden:NO withAnimation:YES];
        }
    }];
    
    if (![date km_isMonthEqualToDate:self.date]) {
        [_itemArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            KMCalendarItem *item = (KMCalendarItem *)obj;
            if (item.isSelected) {
                [item setSelected:NO];
            }
        }];
        [self resetWithDate:date returnHeight:^(CGFloat height) {
            block(height);
        }];
    }
    self.currentLine = [date km_weekOfMonth];
    CGFloat offset = [self offsetOfDate:date];
    if (yesOrNo) {
        [UIView animateWithDuration:0.2f animations:^{
            [self offsetYPoint:offset];
        }];
    } else {
        [self offsetYPoint:offset];
    }
}
/**
 *  次视图上显示的日历
 *
 *  @param date 将要显示的周的日期
 */
- (void)resetWeekStyleWithDate:(NSDate *)date
{
    self.type = KMCalendarTypeWeek;
    
    self.date = date;
    BOOL flag = NO;
    if ([self.date km_isMonthEqualToDate:[NSDate date]]) {
        flag = YES;
    }
    
    int offset = 0 - [self.date km_returnWeekday];
    
    [_itemArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        KMCalendarItem *item = (KMCalendarItem *)obj;
        BOOL isToday = NO;
        
        if (idx < 7) {
            NSDate *itemDate = [self.date km_offsetDay:offset + idx + 1];
            if ([itemDate km_isDayEqualToDate:[NSDate date]]) {
                isToday = YES;
            }
            BOOL outOfMonth = ![itemDate km_isMonthEqualToDate:self.date];
            if (outOfMonth) {
                item.tag = itemDate.day + 100;
                
            } else {
                item.tag = itemDate.day;
            }
            BOOL isRecord = NO;
            for (NSDate *temp_date in self.recordDateArray) {
                if ([temp_date km_isDayEqualToDate:itemDate]) {
                    isRecord = YES;
                    break;
                }
            }
            [item setDay:[NSString stringWithFormat:@"%ld", (long)itemDate.day]
              outOfMonth:outOfMonth
                 isToday:isToday
                isRecord:isRecord];
            if (item.isHidden) {
                //                [item setHidden:NO withAnimation:YES];
            }
        } else {
            item.tag = 0;
        }
    }];
    [self setDateSelected:self.selectedDay];
}

- (CGFloat)animationEndTopLine
{
    return (self.currentLine - 1) * 30.f;
}

- (CGFloat)animationEndBottomLine
{
    return self.currentLine * 30.f;
}

- (CGFloat)offsetOfDate:(NSDate *)date
{
    CGFloat offset = -1.f;
    if (![date km_isMonthEqualToDate:self.date]) {
        return offset;
    }
    offset = ([date km_weekOfMonth] - 1) * 30.f;
    return - offset;
}

- (void)offsetYPoint:(CGFloat)offset
{
    CGRect rect = self.frame;
    rect.origin.y = _originalY + offset;
    self.frame = rect;
}

- (void)clickDayOutOfMonth:(void (^)(int))block
{
    
}
@end
