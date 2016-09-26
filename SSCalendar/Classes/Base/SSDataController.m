//
//  SSDataStore.m
//  eSchoolView
//
//  Created by Steven Preston on 7/2/13.
//  Copyright (c) 2013 Stellar16. All rights reserved.
//

#import "SSDataController.h"
#import "SSCalendarCache.h"
#import "SSCalendarCountCache.h"
#import "SSYearNode.h"
#import "SSDayNode.h"
#import "SSConstants.h"

@implementation SSDataController

#pragma mark - Static Methods

+ (SSDataController *)shared
{
    static SSDataController *_sharedDataStore = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedDataStore = [[self alloc] init];
    });
    return _sharedDataStore;
}

#pragma mark - Lifecycle Methods

- (id)init
{
    self = [super init];
    if (self) {
        self.calendarCache = [[SSCalendarCache alloc] init];
        self.calendarCountCache = [[SSCalendarCountCache alloc] init];
    }
    return self;
}

#pragma mark - Event Request Methods

- (BOOL)areEventsLoadedForYear:(NSInteger)year Month:(NSInteger)month
{
    return [_calendarCache areEventsLoadedForYear:year Month:month];
}

- (BOOL)hasEventsYear:(NSInteger)year Month:(NSInteger)month Date:(NSInteger)day
{
    return [_calendarCountCache hasEventsWithYear:year Month:month Day:day];
}

- (NSArray *)cachedEventsForYear:(NSInteger)year Month:(NSInteger)month Day:(NSInteger)day
{
    return [_calendarCache getEventsForYear:year Month:month Day:day];
}

- (NSArray *)calendarYears
{
    if (_calendarYears == nil) {
        NSInteger year = [SSCalendarUtils currentYear];
        
        SSYearNode *yearNode = [[SSYearNode alloc] initWithValue:year];
        SSYearNode *yearNode1 = [[SSYearNode alloc] initWithValue:year + 1];
        SSYearNode *yearNode2 = [[SSYearNode alloc] initWithValue:year + 2];
        SSYearNode *yearNode3 = [[SSYearNode alloc] initWithValue:year + 3];
        SSYearNode *yearNode4 = [[SSYearNode alloc] initWithValue:year + 4];
        
        self.calendarYears = @[yearNode, yearNode1,  yearNode2, yearNode3, yearNode4];
    }
    return _calendarYears;
}

- (void)updateCalendarYears {
    for (SSYearNode *year in _calendarYears) {
        for (SSDayNode *day in year.days) {
            day.hasEvents = [[SSDataController shared] hasEventsYear:day.year Month:day.month Date:day.value];
        }
    }
}

@end
