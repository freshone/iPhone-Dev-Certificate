//
//  ViewController.h
//  PathMap
//
//  Created by Jeremy McCarthy on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface ViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) IBOutlet MKMapView *locationMapView;
@property (nonatomic, retain) NSMutableArray *pathCoordinates;
@property (nonatomic, retain) MKPolyline *pathOverlay;
@property (nonatomic, retain) IBOutlet UILabel *distanceLabel;

- (IBAction)enableTrackingMode:(id)sender;
- (IBAction)enableViewPathMode:(id)sender;
- (IBAction)resetPath:(id)sender;


@end
