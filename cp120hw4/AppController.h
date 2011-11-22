//
//  AppController.h
//  cp120hw4
//
//  Created by Jeremy McCarthy on 11/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PreferenceController;

@interface AppController : NSObject {
    PreferenceController *preferenceController;
}

- (IBAction)showPreferencePanel:(id)sender;

@end