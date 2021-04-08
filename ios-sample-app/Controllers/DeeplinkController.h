//
//  DeeplinkController.h
//  ios-sample-app
//
//  Created by Eyal Rabinovich on 20/11/2019.
//  Copyright © 2019 Singular Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeeplinkController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *deeplinkField;
@property (weak, nonatomic) IBOutlet UILabel *passthroughField;
@property (weak, nonatomic) IBOutlet UILabel *isDeferredField;

@end
