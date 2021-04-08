//
//  AppDelegate.m
//  ios-sample-app
//
//  Created by Eyal Rabinovich on 13/11/2019.
//  Copyright © 2019 Singular Labs. All rights reserved.
//

#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import "Singular.h"
#import "Utils.h"
#import "TabController.h"
#import "Constants.h"

#import <AppTrackingTransparency/ATTrackingManager.h>
#import <AdSupport/ASIdentifierManager.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize deeplinkData;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // If your app uses scenes and you want to support Singular Links, please refer to the documentation here:
    // https://support.singular.net/hc/en-us/articles/360038341692
    
    // Starts a new session when the user opens the app if the session timeout has passed / opened using a Singular Link
    SingularConfig *config = [self getConfig];
    config.launchOptions = launchOptions;
    
    // Will be zeros (unless tracking consent was given in a previous session)
    NSString *idfaString = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];

    [Singular start:config];
    
    // Request user consent to use the Advertising Identifier (idfa)
    [self requestTrackingAuthorization];
    
    idfaString = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity
 restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> *restorableObjects))restorationHandler {
    
    // Starts a new session when the user opens the app using a Singular Link while it was in the background
    SingularConfig *config = [self getConfig];
    config.userActivity = userActivity;
    
    [Singular start:config];
    
    // Request user consent to use the Advertising Identifier (idfa)
    [self requestTrackingAuthorization];

    return YES;
}

- (SingularConfig *)getConfig {
    SingularConfig *config = [[SingularConfig alloc] initWithApiKey:APIKEY andSecret:SECRET];
    
    config.singularLinksHandler = ^(SingularLinkParams * params) {
        [self handleSingularLink:params];
    };
    
    // Enable use of SKAN for iOS14 tracking
    // Singular will call registerAppForAdNetworkAttribution for you
    // Invoking [Singular skanRegisterAppForAdNetworkAttribution] will set this value to YES, even if done before/after [Singular start]
    config.skAdNetworkEnabled = YES;
    
    // Enable manual conversion value updates
    // IMPORTANT: set as NO (or just don't set - it defaults to NO) to let Singular manage conversion values
    config.manualSkanConversionManagement = YES;
    
    config.conversionValueUpdatedCallback = ^(NSInteger newConversionValue) {
      // Receive a callback whenever the Conversion Value is updated
    };
    
    // Delay sending events for up to 3 minutes, or until Tracking is Authorized (only on iOS 14)
    config.waitForTrackingAuthorizationWithTimeoutInterval = 180;
    
    return config;
}

- (void)requestTrackingAuthorization {
    if (@available(iOS 14, *)) {
        // call requestTrackingAuthorizationWithCompletionHandler from ATTrackingManager to start the user consent process
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status){
            // your authorization handler here
            // note: the Singular SDK will automatically detect if authorization has been given and initialize itself
        }];
    }
}

- (void)handleSingularLink:(SingularLinkParams*)params{
    NSMutableDictionary* values = [[NSMutableDictionary alloc] init];
    
    [values setObject:[params getDeepLink] forKey:DEEPLINK];
    [values setObject:[params getPassthrough] forKey:PASSTHROUGH];
    [values setObject:[NSNumber numberWithBool:[params isDeferred]] forKey:IS_DEFERRED];
    
    self.deeplinkData = values;
    
    [self navigateToDeeplinkController];
}

-(void)navigateToDeeplinkController{
    
    // UI changes must run on main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        TabController* tabBar = (TabController*)self.window.rootViewController;
    
        // Signal to the TabController the app opened using a Singular Link
        [tabBar openedWithDeeplink];
    });
}

@end

