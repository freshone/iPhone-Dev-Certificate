//
//  MyDocument.m
//  Weather Watcher
//
//  Created by Jeremy McCarthy on 12/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyDocument.h"
#import "Station.h"
#import "Observation.h"

static NSString *GET_STATIONS_URL_STRING = @"http://api.wunderground.com/api/97042a4b23a3051c/geolookup/q/";
static NSString *GET_OBSERVATIONS_URL_STRING = @"http://api.wunderground.com/api/97042a4b23a3051c/geolookup/conditions/q/";


@implementation MyDocument

@synthesize locationManager;
@synthesize myLocation;

- (id)init
{
    self = [super init];
    if (self) {
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
        self.locationManager.distanceFilter = 1000;
        /*if(self.myLocation == nil) {
            if(self.locationManager.location == nil) {
                self.myLocation = [[[CLLocation alloc] initWithLatitude:38.5763 longitude:-121.4915] autorelease];
            }
            else {
                self.myLocation = [[[CLLocation alloc] initWithObject:self.locationManager.location] autorelease];
            }
        }*/
    }
    return self;
}

- (void)dealloc
{
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
    [super dealloc];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.myLocation = newLocation;
    [self update];
}

- (void)update
{
    if(self.myLocation != nil) {
        [self updateStationsForLocation:self.myLocation];
    }
}

- (void)updateStationsForLocation:(CLLocation *)aLocation
{
    CLLocationCoordinate2D locCoords = aLocation.coordinate;
    NSString *URLString = [NSString stringWithFormat:@"%@%f,%f.xml", GET_STATIONS_URL_STRING, locCoords.latitude, locCoords.longitude];
    NSURL *stationsURL = [NSURL URLWithString:URLString];
    NSLog(@"%@",URLString);
    NSString *response = [NSString stringWithContentsOfURL:stationsURL encoding:NSUTF8StringEncoding error:nil];
    NSXMLDocument *xml = [[NSXMLDocument alloc] initWithXMLString:response options:0 error:nil];
    NSArray *stationsArray = [[[[[[[xml.rootElement 
                                  elementsForName:@"location"] lastObject]
                                  elementsForName:@"nearby_weather_stations"] lastObject]
                                  elementsForName:@"airport"] lastObject]
                                  elementsForName:@"station"];
    
    [xml release];
    
    for(NSXMLElement *e in stationsArray) {
        Station *tempStation = 
        [Station findOrCreateStationWithCode:[[[e elementsForName:@"icao"] lastObject] stringValue]
                                        name:[[[e elementsForName:@"city"] lastObject] stringValue]
                                    latitude:[NSNumber numberWithDouble:[[[[e elementsForName:@"lat"] lastObject] stringValue] doubleValue]]
                                  longitutde:[NSNumber numberWithDouble:[[[[e elementsForName:@"lon"] lastObject] stringValue] doubleValue]]
                                         moc:[self managedObjectContext]];
        [self updateObservationsForStation:tempStation];
    }
}

- (void)updateObservationsForStation:(Station *)aStation
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@.xml", GET_OBSERVATIONS_URL_STRING, aStation.code];
    NSURL *observationsURL = [NSURL URLWithString:URLString];
    NSLog(@"%@",URLString);
    NSString *response = [NSString stringWithContentsOfURL:observationsURL encoding:NSUTF8StringEncoding error:nil];
    NSXMLDocument *xml = [[NSXMLDocument alloc] initWithXMLString:response options:0 error:nil];
    NSXMLElement *e = [[xml.rootElement elementsForName:@"current_observation"] lastObject];
    [Observation findOrCreateObservationWithStation:aStation
                                                time:[NSDate dateWithTimeIntervalSince1970:[[[[e elementsForName:@"observation_epoch"] lastObject] stringValue] doubleValue]]
                                                temp:[NSNumber numberWithInt:[[[[e elementsForName:@"temp_f"] lastObject] stringValue] intValue]]
                                           windSpeed:[NSNumber numberWithInt:[[[[e elementsForName:@"wind_mph"] lastObject] stringValue] intValue]]
                                            pressure:[NSNumber numberWithInt:[[[[e elementsForName:@"pressure_mb"] lastObject] stringValue] intValue]]
                                                 moc:[self managedObjectContext]];
    [xml release];
}

- (NSString *)windowNibName
{
    return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    //[self update];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

@end
