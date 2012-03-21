//
//  Station.m
//  Weather Watcher
//
//  Created by Jeremy McCarthy on 12/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Station.h"
#import "Observation.h"

static NSUInteger stationCount = 0;

@implementation Station
@dynamic name;
@dynamic code;
@dynamic latitude;
@dynamic longitude;
@dynamic observations;

- (void)awakeFromInsert
{
    self.code = [NSString stringWithFormat:@"WKRP%02d", ++stationCount];
    self.name = [NSString stringWithFormat:@"Station %@", self.code];
    self.latitude = [NSNumber numberWithDouble:47.5 + (rand() % 100) * 0.01];
    self.longitude = [NSNumber numberWithDouble:-122.5 + (rand() % 100) * 0.01];
}

- (void)createFakeData
{
    for(int i = 0; i < 10; i++) {
        Observation *newObservation = [NSEntityDescription insertNewObjectForEntityForName:@"Observation" inManagedObjectContext:self.managedObjectContext];
        newObservation.station = self;
    }
}

@end
