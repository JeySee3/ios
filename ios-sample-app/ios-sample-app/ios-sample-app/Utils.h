//
//  Utils.h
//  ios-sample-app
//
//  Created by Eyal Rabinovich on 21/11/2019.
//  Copyright © 2019 Singular Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Utils : NSObject

+ (BOOL)isEmptyOrNull:(NSString *)text;
+ (void)displayMessage:(NSString*) message withView:(UIViewController*) view;

@end
