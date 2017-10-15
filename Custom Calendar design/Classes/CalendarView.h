

/* Basically I had customised this bellow repository for my project purpose .
 * https://github.com/jubinjacob19/CustomCalendar By jubinjacob19
 *****************************************************************
 // My customise
 * Feature added customiseable every cell from your view controller .
 * Normal calendar with event selection
 * Event Creation
 * iOS 8 or later
 * By Shourov Datta
 */

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]


#import <UIKit/UIKit.h>

@protocol CalendarDelegate;
@protocol CalendarDataSource;


@interface CalendarView : UIView

-(void)showNextMonth;
-(void)showPreviousMonth;

@property (nonatomic,strong) NSDate *calendarDate;
@property (nonatomic,weak) id<CalendarDelegate> delegate;
@property (nonatomic,weak) id<CalendarDataSource> datasource;


// Font
@property (nonatomic, strong) UIFont * defaultFont;
@property (nonatomic, strong) UIFont * titleFont;

// Text color for month and weekday labels
@property (nonatomic, strong) UIColor * monthAndDayTextColor;

// Border
@property (nonatomic, strong) UIColor * borderColor;
@property (nonatomic, assign) NSInteger borderWidth;


// Allows or disallows the user to change month when tapping a day button from another month
@property (nonatomic, assign) BOOL allowsChangeMonthByDayTap;
@property (nonatomic, assign) BOOL allowsChangeMonthBySwipe;
@property (nonatomic, assign) BOOL allowsChangeMonthByButtons;

// origin of the calendar Array
@property (nonatomic, assign) NSInteger originX;
@property (nonatomic, assign) NSInteger originY;

// "Change month" animations
@property (nonatomic, assign) UIViewAnimationOptions nextMonthAnimation;
@property (nonatomic, assign) UIViewAnimationOptions prevMonthAnimation;

// Miscellaneous
@property (nonatomic, assign) BOOL keepSelDayWhenMonthChange;
@property (nonatomic, assign) BOOL hideMonthLabel;

/**
 *
 */
@property (nonatomic, assign) BOOL isAllowedEventCreation;
@property (nonatomic, strong) NSMutableArray *selectedDateEvents;
@property (nonatomic, strong) UIColor * eventCreationColor;
@property (nonatomic, assign) NSInteger buttonCornerRadius;



////


@end

/**
 * Day cell contents
 */
@interface DayCellConfigure : NSObject

@property(nonatomic, strong) NSString  *subtitle;
@property(nonatomic, strong) UIColor   *cellBackgroundColor;
@property(nonatomic, strong) UIColor   *cellBtnTextColor;

@end


@protocol CalendarDelegate <NSObject>

-(void)selectedDate:(NSDate *)date ;

@optional
-(BOOL)shouldChangeDayToDate:(NSDate *)selectedDate;
-(void)setHeightNeeded:(NSInteger)heightNeeded;
-(void)setMonthLabel:(NSString *)monthLabel;
-(void)setEnabledForPrevMonthButton:(BOOL)enablePrev nextMonthButton:(BOOL)enableNext;

@end



@protocol CalendarDataSource <NSObject>

-(DayCellConfigure *)dataForDate:(NSDate *)date;
-(BOOL)canSwipeToDate:(NSDate *)date;

@end


