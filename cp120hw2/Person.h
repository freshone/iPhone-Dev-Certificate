//
//  Person.h
//  cp120hw2
//
//  Created by Jeremy McCarthy on 10/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject {
    NSString *name;
    float hourlyPay;
}

- (NSString *)name;
- (float)hourlyPay;
- (void)setName:(NSString *)inputName;
- (void)setHourlyPay:(float)inputHourlyPay;

@end
