//
//  Observation.m
//  Weather Watcher
//
//  Created by Jeremy McCarthy on 12/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Observation.h"
#import "Station.h"


@implementation Observation
@dynamic time;
@dynamic temp;
@dynamic windSpeed;
@dynamic pressure;
@dynamic station;

- (void)awakeFromInsert
{
    NSString *dateString = [NSString
                                stringWithFormat:@"%d/%d/2011 %d:%d:%d",
                                rand() % 12 + 1,
                                rand() % 28 + 1,
                                rand() % 24,
                                rand() % 60,
                                rand() % 60];
    self.time = [NSDate dateWithNaturalLanguageString:dateString];
    self.temp = [NSNumber numberWithDouble:-15.5 + (rand() % 1000) * 0.1];
    self.windSpeed = [NSNumber numberWithDouble:(rand() % 200) * 0.1];
    self.pressure = [NSNumber numberWithDouble:1000 + (rand() % 500) * 0.1];    
}

@end
