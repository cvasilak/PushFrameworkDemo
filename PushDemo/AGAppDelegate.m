//
//  AGAppDelegate.m
//  PushDemo
//
//  Created by Christos Vasilakis on 4/8/14.
//
//

#import "AGAppDelegate.h"

#import <AeroGearPush/AeroGearPush.h>

@implementation AGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    // register with Apple Push Notification Service (APNS)
    // to retrieve the device token.
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
     
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Push Notification handling

// Upon successfully registration with APNS, we register the device to 'AeroGear Push Server' 
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken 
{
    // initialize "Registration helper" object using the
    // base URL where the "AeroGear Unified Push Server" is running.
    AGDeviceRegistration *registration =
    
        [[AGDeviceRegistration alloc] initWithServerURL:[NSURL URLWithString:@"http://192.168.1.10:8080/ag-push"]];
    
    // perform registration of this device
    [registration registerWithClientInfo:^(id<AGClientDeviceInformation> clientInfo) {
        // set up configuration parameters

        // apply the deviceToken as received by Apple's Push Notification service
        [clientInfo setDeviceToken:deviceToken];

        // You need to fill the 'Variant Id' together with the 'Variant Secret'
        // both received when performing the variant registration with the server.
        // See section "Register an iOS Variant" in the guide:
        // http://aerogear.org/docs/guides/aerogear-push-ios/unified-push-server/
        [clientInfo setVariantID:@"8b62bb1c-f488-48f3-bb10-6609bb08ecbd"];
        [clientInfo setVariantSecret:@"c61307f4-f287-45ec-9db1-e0fd4e9e7676"];
        
        // --optional config--
        // set some 'useful' hardware information params
        UIDevice *currentDevice = [UIDevice currentDevice];
        
        [clientInfo setOperatingSystem:[currentDevice systemName]];
        [clientInfo setOsVersion:[currentDevice systemVersion]];
        [clientInfo setDeviceType: [currentDevice model]];

    } success:^() {
        
        // successfully registered!

    } failure:^(NSError *error) {
        // An error occurred during registration.
        // Let's log it for now
        NSLog(@"PushEE registration Error: %@", error);
    }];
}

// Callback called after failing to register with APNS
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    // Log the error for now
    NSLog(@"APNs Error: %@", error);
}

// When the program is in the foreground, this callback receives the Payload of the received Push Notification message
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                    message:userInfo[@"aps"][@"alert"]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];

    [alert show];
    NSLog(@"%@", userInfo);
    
}

// Uncomment if you want to support 'silent' Push Notifications feature in iOS 7.
// Please note:
//            - iOS 7 will call this method (if implemented) instead of the standard
//              didReceiveRemoteNotification: to handle the request. The generated 
//              template code will smartly forward the call to this method if it detects
//              the application runs in foreground.
//            - ensure that 'Remote notifications' capability is enabled on the app target.
//
// Note: If your application has no need for background processing, using the didReceiveRemoteNotification: method
//       is recommended.
/*
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

    if (application.applicationState == UIApplicationStateBackground) {
        // perform tasks that are best suited for background processing,
        // such as download data that is related to the push notification
        ...
        
        // afterwards it is required to invoke the given block:
        completionHandler(UIBackgroundFetchResultNewData); // download of data did succeed
    } else {
        // foreground .....
        [self application:application didReceiveRemoteNotification:userInfo];
    }
}
*/
@end
