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
}

@property (readwrite, copy) NSString *name;
@property (readwrite, assign) float hourlyPay;

@end
