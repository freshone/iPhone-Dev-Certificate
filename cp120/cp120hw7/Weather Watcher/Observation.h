//
//  Observation.h
//  Weather Watcher
//
//  Created by Jeremy McCarthy on 12/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Station;

@interface Observation : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate *time;
@property (nonatomic, retain) NSNumber *temp;
@property (nonatomic, retain) NSNumber *windSpeed;
@property (nonatomic, retain) NSNumber *pressure;
@property (nonatomic, retain) Station *station;

+ (Observation *)findOrCreateObservationWithStation:(Station *)aStation
                                               time:(NSDate *)aTime
                                               temp:(NSNumber *)aTemp
                                          windSpeed:(NSNumber *)aWindSpeed
                                           pressure:(NSNumber *)aPressure
                                                moc:(NSManagedObjectContext *)moc;

@end
