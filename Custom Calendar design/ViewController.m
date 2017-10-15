//
//  ViewController.m
//  Custom Calendar design
//
//  Created by shourov datta on 10/14/17.
//  Copyright © 2017 shourov datta. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) CalendarView * customCalendarView;
@property (nonatomic, strong) NSCalendar * gregorian;
@property (nonatomic, assign) NSInteger currentYear;
@property (nonatomic, strong) NSMutableArray *eventsArray;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtDescription;
@property (weak, nonatomic) IBOutlet UIView *createView;
@property (weak, nonatomic) IBOutlet UIView *readerView;
@property (weak, nonatomic) IBOutlet UILabel *lblEventTitle;

@end

@interface EventsModel : NSObject
@property(nonatomic, assign) NSString  *title;
@property(nonatomic, strong) NSString  *details;
@property(nonatomic , strong) NSDate *eventDate;
@end


@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.title = @"Custom Calendar";
    
    _gregorian       = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    _customCalendarView                             = [[CalendarView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 390)];
    _customCalendarView.delegate                    = self;
    _customCalendarView.datasource                  = self;
    _customCalendarView.calendarDate                = [NSDate date];
    _customCalendarView.monthAndDayTextColor        = RGBCOLOR(0, 174, 255);
 
    _customCalendarView.borderColor                 = [UIColor whiteColor];
    _customCalendarView.borderWidth                 = 5;
    _customCalendarView.buttonCornerRadius = 8;
    _customCalendarView.allowsChangeMonthByDayTap   = YES;
    _customCalendarView.allowsChangeMonthByButtons  = YES;
    _customCalendarView.keepSelDayWhenMonthChange   = YES;
    _customCalendarView.nextMonthAnimation          = UIViewAnimationOptionTransitionFlipFromRight;
    _customCalendarView.prevMonthAnimation          = UIViewAnimationOptionTransitionFlipFromLeft;
    _customCalendarView.isAllowedEventCreation = YES;
    _customCalendarView.eventCreationColor = RGBCOLOR(238,124,52);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:_customCalendarView];
        _customCalendarView.center = CGPointMake(self.view.center.x, _customCalendarView.center.y);
    });
    
    NSDateComponents * yearComponent = [_gregorian components:NSCalendarUnitYear fromDate:[NSDate date]];
    _currentYear = yearComponent.year;
    
    _eventsArray = [[NSMutableArray alloc]init];
    
    // default data event days
    {
    NSDate *now = [NSDate date];
    NSDate *twoDaysLater = [now dateByAddingTimeInterval:+2*24*60*60];
    NSDate *sevenDaysLater = [now dateByAddingTimeInterval:+7*24*60*60];
    NSDate *twelveDaysLater = [now dateByAddingTimeInterval:+12*24*60*60];

    
 
    EventsModel *eventModel = [[EventsModel alloc]init];
    eventModel.title = @"AAA";
    eventModel.details = @"some description";
    eventModel.eventDate = twoDaysLater;
    [_eventsArray addObject:eventModel];
     
    {
    EventsModel *eventModel = [[EventsModel alloc]init];
    eventModel.title = @"BBB";
    eventModel.details = @"some description";
    eventModel.eventDate = sevenDaysLater;
    [_eventsArray addObject:eventModel];
    }
        
    {
            EventsModel *eventModel = [[EventsModel alloc]init];
            eventModel.title = @"CCC";
            eventModel.details = @"some description";
            eventModel.eventDate = twelveDaysLater;
            [_eventsArray addObject:eventModel];
    }
    
    }
    
    self.createView.hidden = true;
    self.readerView.hidden = true;

}

#pragma mark - Gesture recognizer

-(void)swipeleft:(id)sender
{
    [_customCalendarView showNextMonth];
}

-(void)swiperight:(id)sender
{
    [_customCalendarView showPreviousMonth];
}

#pragma mark - CalendarDelegate protocol conformance

// Get selected date
-(void)selectedDate:(NSDate *)selectedDate
{
    
    if(_customCalendarView.selectedDateEvents.count > 0){
        self.createView.hidden = false;
        return;
    }
    else{
        self.createView.hidden = true;
    }
    
    for (EventsModel * event in self.eventsArray) {
        
        NSDateFormatter *format=[[NSDateFormatter alloc]init];
        [format setDateFormat:@"yyyy-MM-dd ZZZ"];
        NSString *dateOfDays = [format stringFromDate:selectedDate];
        
        NSString *dateWhichContainsEvent = [format stringFromDate:event.eventDate];
        
        if ([dateOfDays isEqual:dateWhichContainsEvent]) {
            
            // set title label and details label
            
            self.readerView.hidden = false;
            self.lblEventTitle.text = event.title;
            return;
 
        }
        
        else
            self.readerView.hidden = true;
 
    }
    
    NSLog(@"dayChangedToDate %@(GMT)",selectedDate);
}

#pragma mark - CalendarDataSource protocol conformance

-(DayCellConfigure *)dataForDate:(NSDate *)date
{
    
    
    // create events view and event read view configure
    
    self.createView.hidden = true;
    self.readerView.hidden = true;

    
    
    DayCellConfigure *config = [[DayCellConfigure alloc]init];
    
    // date label
    NSDateFormatter *format         = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd"];
 
    //day cell properties without Event
    config.cellBackgroundColor =  RGBCOLOR(245,245,245);
    config.subtitle = nil;

    
    
    // already selected date will yellow color
    for (NSDate *singleDate in _customCalendarView.selectedDateEvents) {
        NSString *dateString            = [format stringFromDate:singleDate] ;
        
        if ([singleDate isEqual:date]) {
            config.cellBackgroundColor =  _customCalendarView.eventCreationColor;
            config.subtitle = nil;
        }
        NSLog(@"date  %@(GMT)",dateString);
    }

    
    //day cell properties with Event

    for (EventsModel * event in self.eventsArray) {
        
        NSDateFormatter *format=[[NSDateFormatter alloc]init];
        [format setDateFormat:@"yyyy-MM-dd ZZZ"];
        NSString *dateOfDays = [format stringFromDate:date];

        NSString *dateWhichContainsEvent = [format stringFromDate:event.eventDate];

        if ([dateOfDays isEqual:dateWhichContainsEvent]) {
            
            config.cellBackgroundColor =   RGBCOLOR(215, 215, 215);
            config.subtitle = event.title;
            
            // selectedDateEvents save into events so remove this index
            [_customCalendarView.selectedDateEvents removeObject:date ];
            
        }
        
    }
    config.cellBtnTextColor = [UIColor darkGrayColor];
    
    return config;
    
}

-(BOOL)canSwipeToDate:(NSDate *)date
{
    NSDateComponents * yearComponent = [_gregorian components:NSCalendarUnitYear fromDate:date];
    return (yearComponent.year >= _currentYear+50 || yearComponent.year <= _currentYear+50);
}

#pragma mark - Action methods

- (IBAction)saveEvents:(id)sender {
    
    if (self.txtTitle.text && self.txtTitle.text.length > 0) {
        
 
        // already selected date will yellow color
        for (NSDate *singleDate in _customCalendarView.selectedDateEvents) {
            EventsModel *eventModel = [[EventsModel alloc]init];
            eventModel.title = self.txtTitle.text;
            eventModel.details = @"some description";
            eventModel.eventDate = singleDate;
            [_eventsArray addObject:eventModel];

            
        }
        [self.customCalendarView setNeedsDisplay];
        self.createView.hidden = true;
        self.readerView.hidden = true;
        
    }
    
    
    
}
- (IBAction)eventReadMode:(id)sender {
    _customCalendarView.isAllowedEventCreation = NO;
    [_customCalendarView.selectedDateEvents removeAllObjects];
    [_customCalendarView setNeedsDisplay];
    
}
- (IBAction)caleedarEventCreationMode:(id)sender {
    _customCalendarView.isAllowedEventCreation = YES;

}

@end


#pragma mark - Model Class
@implementation EventsModel

-(instancetype)init{

    self = [super init];

    if (self) {

        self.title = nil;
        self.details =nil;
        self.eventDate =nil;
    }

    return self;

}

@end


