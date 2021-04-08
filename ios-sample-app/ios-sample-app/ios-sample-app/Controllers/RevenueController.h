//
//  RevenueController.h
//  ios-sample-app
//
//  Created by Eyal Rabinovich on 19/11/2019.
//  Copyright © 2019 Singular Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RevenueController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>{
    NSArray* pickerData;
}

@property (strong, nonatomic) IBOutlet UITextField *eventNameField;
@property (strong, nonatomic) IBOutlet UITextField *currencyField;
@property (strong, nonatomic) IBOutlet UITextField *revenueField;
@property (strong, nonatomic) IBOutlet UIPickerView *currencyPicker;

@end
