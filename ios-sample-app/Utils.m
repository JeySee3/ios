//
//  Utils.m
//  ios-sample-app
//
//  Created by Eyal Rabinovich on 21/11/2019.
//  Copyright © 2019 Singular Labs. All rights reserved.
//

#import "Utils.h"
#import "Constants.h"

@implementation Utils

+ (BOOL)isEmptyOrNull:(NSString *)text{
    if(!text || ![text length] ||
       ![[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]){
        return YES;
    }
    
    return NO;
}

+ (void)displayMessage:(NSString*) message withView:(UIViewController*) view{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];

    [view presentViewController:alert animated:YES completion:nil];

    int duration = 1; // duration in seconds

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
