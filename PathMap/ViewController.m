//
//  ViewController.m
//  PathMap
//
//  Created by Jeremy McCarthy on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
- (void)updatePathOverlay;
@end

@implementation ViewController

@synthesize locationManager = _locationManager;
@synthesize locationMapView = _locationMapView;
@synthesize pathCoordinates = _pathCoordinates;
@synthesize pathOverlay = _pathOverlay;
@synthesize distanceTraveled = _distanceTraveled;
@synthesize distanceLabel = _distanceLabel;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pathCoordinates = [[[NSMutableArray alloc] init] autorelease];
    [self updatePathOverlay];
    [self.locationMapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    [self.locationMapView setShowsUserLocation:YES];
    [self.locationMapView setDelegate:self];
    
    if([CLLocationManager locationServicesEnabled])
    {
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        [self.locationManager setDelegate:self];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
        [self.locationManager setPurpose:@"To map your path"];
        [self.locationManager startUpdatingLocation];
    }
    else
    {
        NSLog(@"Location Manager did not initialize properly.");
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.pathCoordinates = nil;
    self.locationManager = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortrait);
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{    
    if(!((newLocation.coordinate.latitude == oldLocation.coordinate.latitude) &&
       (newLocation.coordinate.longitude == oldLocation.coordinate.longitude)))
    {
        NSLog(@"Location Received, adding...");
        [self.pathCoordinates addObject:newLocation];
        [self updatePathOverlay];
    }
    else
    {
        NSLog(@"Location Duplicate, skipping...");
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if(error.code == kCLErrorDenied)
    {
        NSLog(@"User denied access to location services.");
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if(mapView == self.locationMapView)
    {
        MKPolylineView *view = [[[MKPolylineView alloc] initWithPolyline:overlay] autorelease];
        [view setStrokeColor:[[UIColor blueColor] colorWithAlphaComponent:0.7f]];
        [view setLineWidth:5.0f];
        return view;
    }
    else
    {
        return nil;
    }
}

- (void)updatePathOverlay
{
    CLLocationCoordinate2D coordinates[self.pathCoordinates.count];
    
    int i = 0;
    double distance = 0.0f;
    CLLocation *lastLocation = nil;
    for(CLLocation *location in self.pathCoordinates)
    {
        coordinates[i] = location.coordinate;
        if(i > 0)
        {
            distance += [location distanceFromLocation:lastLocation];
        }
        lastLocation = location;
        i++;
    }
    
    MKPolyline *newOverlay = [MKPolyline polylineWithCoordinates:coordinates count:self.pathCoordinates.count];
    [self.locationMapView addOverlay:newOverlay];
    [self.locationMapView removeOverlay:self.pathOverlay];
    self.pathOverlay = newOverlay;
    
    NSString *distanceString = [[[NSNumber numberWithInt:(int)distance] stringValue] stringByAppendingString:@" m"];
    [self.distanceLabel setText:[@"Distance   " stringByAppendingString:distanceString]];
}

- (IBAction)enableTrackingMode:(id)sender
{
    [self.locationMapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
}

- (IBAction)enableViewPathMode:(id)sender
{
    [self.locationMapView setVisibleMapRect:[self.pathOverlay boundingMapRect] animated:YES];
}

- (IBAction)resetPath:(id)sender
{
    self.pathCoordinates = [[[NSMutableArray alloc] init] autorelease];
    [self updatePathOverlay];
}


@end
