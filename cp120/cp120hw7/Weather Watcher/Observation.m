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

+ (Observation *)findOrCreateObservationWithStation:(Station *)aStation
                                               time:(NSDate *)aTime
                                               temp:(NSNumber *)aTemp
                                          windSpeed:(NSNumber *)aWindSpeed
                                           pressure:(NSNumber *)aPressure
                                                moc:(NSManagedObjectContext *)moc
{
    NSDictionary *predicateVariables = [NSDictionary dictionaryWithObjectsAndKeys:aStation.code, @"icaoCode", aTime, @"timestamp", nil];
    NSPredicate *predicateTemplate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"station.code == $icaoCode AND time == $timestamp"]];
    NSPredicate *localPredicate = [predicateTemplate predicateWithSubstitutionVariables:predicateVariables];
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Observation" inManagedObjectContext:moc]];
    [fetchRequest setPredicate:localPredicate];
    
    NSError *error;
    NSArray *existingObservations = [moc executeFetchRequest:fetchRequest error:&error];
    
    Observation *matchingObservation;
    if(existingObservations.count == 0) {
        matchingObservation = [NSEntityDescription insertNewObjectForEntityForName:@"Observation" inManagedObjectContext:moc];
        matchingObservation.time = aTime;
        matchingObservation.temp = aTemp;
        matchingObservation.windSpeed = aWindSpeed;
        matchingObservation.pressure = aPressure;
        matchingObservation.station = aStation;

    }
    else {
        matchingObservation = existingObservations.lastObject;
    }
    
    return matchingObservation;
}


@end
