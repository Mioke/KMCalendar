# KMCalendar
A calendar with two types: TypeMonth and TypeWeek, it can transform between two types with animation.

Bacis operations:

![Screenshot](https://github.com/Mioke/KMCalendar/blob/master/screenshots/KMCalendarDemo.gif)

# How to use

1.Download or clone from github, copy the `KMCalendar` folder into your project.

2.`#import "KMCalendar"` where you want to use.

3.Initialize the calendar use custom function, deliver `recordDateArray` will show the little dot under the day.

```objective-c
  self.calendar = [[KMCalendar alloc] initWithOrigin:CGPointMake(0.f, 0.f)
                                       recordDateArray:nil
                                        andResizeBlock:^{
                                            // do UI Resize if needed
                                        }];
  self.calendar.delegate = self;
  [self.view addSubview:self.calendar];
```

4.Conform the protocol of `KMCalendarDelegate`.
```objective-c
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
```

5.Usage in `UIScrollView` the other views would be layout under the calendar. In `UITableView`, you should set the `EdgeInset` of tableView, inset.top should be calendar's height + gap width.

6.See more information, you can see the demo inside the project.

# LICENCE
All the source code are release under the MIT Licence, see more information in file `LICENCE`
