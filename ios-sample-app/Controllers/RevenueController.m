//
//  RevenueController.m
//  ios-sample-app
//
//  Created by Eyal Rabinovich on 19/11/2019.
//  Copyright © 2019 Singular Labs. All rights reserved.
//

#import "RevenueController.h"
#import "Singular.h"
#import "Utils.h"

@implementation RevenueController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    pickerData = @[@"EUR",@"GBP",@"ILS",@"INR",@"JPY",@"KRW",@"USD"];
}

- (IBAction)sendRevenueEvent:(id)sender {
    NSString* eventName = self.eventNameField.text;
    NSString* currency = self.currencyField.text;
    double revenue = [self getRevenue];
    
    if([Utils isEmptyOrNull:eventName]){
        [Utils displayMessage:@"Please enter a valid event name" withView:self];
        return;
    }
    
    if([Utils isEmptyOrNull:currency]){
        [Utils displayMessage:@"Please enter a valid currency" withView:self];
        return;
    }
    
    if(revenue <= 0){
        [Utils displayMessage:@"Revenue can't be zero or empty" withView:self];
        return;
    }
    
    // Reporting a simple revenue event to Singular
    [Singular customRevenue:eventName currency:currency amount:revenue];
    
    [Utils displayMessage:@"Revenue event sent" withView:self];
}

- (IBAction)sendRevenueEventWithArgs:(id)sender {
    NSString* eventName = self.eventNameField.text;
    NSString* currency = self.currencyField.text;
    double revenue = [self getRevenue];
    
    if([Utils isEmptyOrNull:eventName]){
        [Utils displayMessage:@"Please enter a valid event name" withView:self];
        return;
    }
    
    if([Utils isEmptyOrNull:currency]){
        [Utils displayMessage:@"Please enter a valid currency" withView:self];
        return;
    }
    
    if(revenue <= 0){
        [Utils displayMessage:@"Revenue must be a number greater than 0" withView:self];
        return;
    }
    
    // Reporting a simple revenue event with your custom attributes to pass with the event
    NSMutableDictionary* args = [[NSMutableDictionary alloc] init];
    [args setObject:@"value1" forKey:@"key1"];
    [args setObject:@"value2" forKey:@"key2"];
    
    [Singular customRevenue:eventName currency:currency amount:revenue withAttributes:args];
    [Utils displayMessage:@"Revenue event sent" withView:self];
}

- (double)getRevenue{
    if ([Utils isEmptyOrNull:self.revenueField.text]){
        return 0;
    }
    
    return [self.revenueField.text doubleValue];
}

// Currency Picker logic
- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return pickerData.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return pickerData[row];
}

- (IBAction)showCurrencyPicker:(id)sender {
    self.currencyPicker = [[UIPickerView alloc] init];
    self.currencyPicker.dataSource = self;
    self.currencyPicker.delegate = self;
    
    UIToolbar* toolbar = [[UIToolbar alloc] init];
    toolbar.barStyle = UIBarStyleBlack;
    toolbar.translucent = YES;
    [toolbar sizeToFit];
    
    // Aligns the done button to the right
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(doneClicked:)];
    
    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
    
    self.currencyField.inputView = self.currencyPicker;
    self.currencyField.inputAccessoryView = toolbar;
}

-(void)doneClicked:(id)sender{
    [self.currencyField resignFirstResponder];
    NSString* currency = [self pickerView:self.currencyPicker titleForRow:[self.currencyPicker selectedRowInComponent:0] forComponent:0];
    [self.currencyField setText:currency];
}

@end
