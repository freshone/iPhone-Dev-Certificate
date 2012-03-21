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

+ (Station *)findOrCreateStationWithCode:(NSString *)aCode
                                   name:(NSString *)aName
                               latitude:(NSNumber *)aLat
                             longitutde:(NSNumber *)aLong
                                    moc:(NSManagedObjectContext *)moc
{
    NSDictionary *predicateVariables = [NSDictionary dictionaryWithObject:aCode forKey:@"icaoCode"];
    NSPredicate *predicateTemplate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"code == $icaoCode"]];
    NSPredicate *localPredicate = [predicateTemplate predicateWithSubstitutionVariables:predicateVariables];
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Station" inManagedObjectContext:moc]];
    [fetchRequest setPredicate:localPredicate];
    
    NSError *error;
    NSArray *existingStations = [moc executeFetchRequest:fetchRequest error:&error];
    
    Station *matchingStation;
    if(existingStations.count == 0) {
        matchingStation = [NSEntityDescription insertNewObjectForEntityForName:@"Station" inManagedObjectContext:moc];
        matchingStation.code = aCode;
        matchingStation.name = aName;
        matchingStation.latitude = aLat;
        matchingStation.longitude = aLong;
    }
    else {
        matchingStation = existingStations.lastObject;
    }
    
    return matchingStation;
}

@end
