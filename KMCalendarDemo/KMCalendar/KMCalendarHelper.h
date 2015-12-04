//
//  KMCalendarHelper.h
//  KMCalendarDemo
//
//  Created by Klein Mioke on 15/12/4.
//  Copyright © 2015年 KleinMioke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+Hex.h"
#import "NSDate+KMCalendar.h"

#define DEFAULT_TINT_COLOR [UIColor colorWithRed:52/255.0 green:167/255.0 blue:1 alpha:1]

#define ASSIST_LINE_COLOR [UIColor colorFromHexString:@"#E0E0E0"]

#define DEFAULT_FONT [UIFont systemFontOfSize: 13]

#define UI_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#ifdef DEBUG
#define KMLog(...) NSLog(__VA_ARGS__)
#else
#define KMLog(...)
#endif

typedef NS_ENUM(NSInteger, KMCalendarType) {
    KMCalendarTypeWeek,
    KMCalendarTypeMonth
};

typedef NS_ENUM(NSInteger, KMCalendarHeaderType) {
    KMCalendarHeaderTypeDefault = 0,
    KMCalendarHeaderTypeCustom,
    KMCalendarHeaderTypeSimple
};

@interface KMCalendarHelper : NSObject

+ (NSDate *)getPreviousMonth:(NSDate *)date;
+ (NSDate *)getNextMonth:(NSDate *)date;

+ (BOOL)checkSameDay:(NSDate *)date1 another:(NSDate *)date2;

@end
