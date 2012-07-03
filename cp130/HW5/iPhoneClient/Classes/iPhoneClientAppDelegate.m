//
//  iPhoneClientAppDelegate.m
//  iPhoneClient
//    HW3_1
//
//  Copyright 2010 Chris Parrish

#import "iPhoneClientAppDelegate.h"
#import "RootViewController.h"

@interface iPhoneClientAppDelegate()
@property (nonatomic, retain) IBOutlet UINavigationController* navigationController;
@end

@implementation iPhoneClientAppDelegate
@synthesize window;
@synthesize navigationController;

#pragma mark - Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    [window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
    return YES;
}

#pragma mark - Memory management

- (void)dealloc
{
    [self setNavigationController:nil];
    [self setWindow:nil];
    [super dealloc];
}

@end