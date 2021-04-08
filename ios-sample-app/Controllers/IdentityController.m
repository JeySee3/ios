//
//  IdentifyController.m
//  ios-sample-app
//
//  Created by Eyal Rabinovich on 01/12/2019.
//  Copyright © 2019 Singular Labs. All rights reserved.
//

#import "IdentityController.h"
#import "Singular.h"
#import "Utils.h"

@interface IdentityController ()

@end

@implementation IdentityController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)setCustomUserId:(id)sender {
    NSString* customUserId = self.customUserIdField.text;
    
    if([Utils isEmptyOrNull:customUserId]){
        [Utils displayMessage:@"Please enter a valid Custom User Id" withView:self];
    }
    
    // Once set, the Custom User Id will persist between runs until `[Singular unsetCustomUserId]` is called.
    // This can also be called before SDK init if you want the first session to include the Custom User Id.
    [Singular setCustomUserId:customUserId];

    [Utils displayMessage:[[NSString alloc] initWithFormat:@"Custom User Id set to: %@", customUserId] withView:self];
}

- (IBAction)unsetCustomUserId:(id)sender {
    [Singular unsetCustomUserId];
    [Utils displayMessage:@"Custom User Id unset" withView:self];
}

@end
