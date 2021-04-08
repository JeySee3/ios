//
//  CustomEventsController.h
//  ios-sample-app
//
//  Created by Eyal Rabinovich on 19/11/2019.
//  Copyright © 2019 Singular Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomEventsController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *eventNameField;
- (IBAction)sendEvent:(id)sender;
- (IBAction)sendEventsWithAttributes:(id)sender;

@end
