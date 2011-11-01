//
//  MyDocument.h
//  cp120hw3
//
//  Created by Jeremy McCarthy on 10/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Meeting.h"

@interface MyDocument : NSDocument {
    Meeting *meeting;
}

@end
