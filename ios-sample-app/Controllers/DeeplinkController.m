//
//  DeeplinkController.m
//  ios-sample-app
//
//  Created by Eyal Rabinovich on 20/11/2019.
//  Copyright © 2019 Singular Labs. All rights reserved.
//

#import "DeeplinkController.h"
#import "AppDelegate.h"
#import "Constants.h"

@implementation DeeplinkController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    
    // Getting the deeplink data from the AppDelegate
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSDictionary* deeplinkData = appDelegate.deeplinkData;
    
    // If there's no deeplink data available, do nothing
    if(!deeplinkData){
        return;
    }
    
    // Clear the deeplink data so it won't be used twice
    appDelegate.deeplinkData = nil;
    
    // Display deeplink data
    [self.deeplinkField setText:[deeplinkData objectForKey:DEEPLINK]];
    [self.passthroughField setText:[deeplinkData objectForKey:PASSTHROUGH]];
    [self.isDeferredField setText:[deeplinkData objectForKey:IS_DEFERRED] ? @"Yes" : @"No"];
}

@end
