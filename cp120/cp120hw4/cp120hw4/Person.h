//
//  Person.h
//  cp120hw2
//
//  Created by Jeremy McCarthy on 10/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject <NSCoding> {
    NSString *name;
    float hourlyPay;
    NSUndoManager *undoManager;
}

@property (readwrite, retain) NSUndoManager *undoManager;

- (NSString *)name;
- (void)setName:(NSString *)newName;
- (float)hourlyPay;
- (void)setHourlyPay:(float)newPay;

@end
