//
//  CustomEventsController.m
//  ios-sample-app
//
//  Created by Eyal Rabinovich on 19/11/2019.
//  Copyright © 2019 Singular Labs. All rights reserved.
//

#import "CustomEventsController.h"
#import "Singular.h"
#import "Utils.h"

@implementation CustomEventsController

- (IBAction)sendEvent:(id)sender {
    NSString* eventName =self.eventNameField.text;
    
    if([Utils isEmptyOrNull:eventName]){
        [Utils displayMessage:@"Please enter a valid event name" withView:self];
        return;
    }
    
    // Set Conversion Value manually (when using manualSkanConversionManagement)
    // Note that conversion values may only increase, so only the first call will update it
    [Singular skanUpdateConversionValue:7];
    
    // Reporting a simple event to Singular
    [Singular event:eventName];
    
    [Utils displayMessage:@"Event sent" withView:self];
}

- (IBAction)sendEventsWithAttributes:(id)sender {
    NSString* eventName =self.eventNameField.text;
    
     if([Utils isEmptyOrNull:eventName]){
         [Utils displayMessage:@"Please enter a valid event name" withView:self];
        return;
    }
    
    NSMutableDictionary* args = [[NSMutableDictionary alloc] init];
    [args setObject:@"value1" forKey:@"key1"];
    [args setObject:@"value2" forKey:@"key2"];
    
    // Set Conversion Value manually (when using manualSkanConversionManagement)
    // Note that conversion values may only increase, so only the first call will update it
    [Singular skanUpdateConversionValue:3];
    
    // Reporting a simple event with your custom attributes to pass with the event
    [Singular event:eventName withArgs:args];
    
    [Utils displayMessage:@"Event sent" withView:self];
}

@end
