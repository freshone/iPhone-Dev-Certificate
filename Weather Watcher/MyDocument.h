//
//  MyDocument.h
//  Weather Watcher
//
//  Created by Jeremy McCarthy on 12/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreLocation/CoreLocation.h>
#import "Station.h"

@interface MyDocument : NSPersistentDocument <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    CLLocation *myLocation;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *myLocation;

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;
- (void)update;
- (void)updateStationsForLocation:(CLLocation *)aLocation;
- (void)updateObservationsForStation:(Station *)aStation;

@end
