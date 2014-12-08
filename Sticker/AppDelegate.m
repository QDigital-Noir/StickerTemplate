//
//  AppDelegate.m
//  Sticker
//
//  Created by Q on 11/23/14.
//  Copyright (c) 2014 Q. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Parse Settings
    [Parse setApplicationId:@"4o1l5ZUnS9dZJyTeFo1g44v1OcbcnaypPxz8u3zx"
                  clientKey:@"QiGOdEoURy0Ey5MV0dKkm0t4nvx9hRzQbefIWH0y"];
    
    // Register for Push Notitications, if running iOS 8
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
    else
    {
        // Register for Push Notifications before iOS 8
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                         UIRemoteNotificationTypeAlert |
                                                         UIRemoteNotificationTypeSound)];
    }
    
    // IAP
    //[PFPurchase restore];
    [PFPurchase addObserverForProduct:@"com.intencemedia.moviefxstickers.unlockall"
                                block:^(SKPaymentTransaction *transaction) {
        self.unlockedAll = YES;
        NSLog(@"unlockedAll");
    }];
    [PFPurchase addObserverForProduct:@"com.intencemedia.moviefxstickers.animals"
                                block:^(SKPaymentTransaction *transaction) {
        self.unlockedAnimals = YES;
        NSLog(@"unlockedAnimals");
    }];
    [PFPurchase addObserverForProduct:@"com.intencemedia.moviefxstickers.dinosaur"
                                block:^(SKPaymentTransaction *transaction) {
        self.unlockedDinosaur = YES;
        NSLog(@"unlockedDinosaur");
    }];
    [PFPurchase addObserverForProduct:@"com.intencemedia.moviefxstickers.haunted"
                                block:^(SKPaymentTransaction *transaction) {
        self.unlockedHaunted = YES;
        NSLog(@"unlockedHaunted");
    }];
    [PFPurchase addObserverForProduct:@"com.intencemedia.moviefxstickers.mothernature"
                                block:^(SKPaymentTransaction *transaction) {
        self.unlockedMotherNature = YES;
        NSLog(@"unlockedMotherNature");
    }];
    [PFPurchase addObserverForProduct:@"com.intencemedia.moviefxstickers.scifi"
                                block:^(SKPaymentTransaction *transaction) {
        self.unlockedSciFi = YES;
        NSLog(@"unlockedSciFi");
    }];
    [PFPurchase addObserverForProduct:@"com.intencemedia.moviefxstickers.seacreatures"
                                block:^(SKPaymentTransaction *transaction) {
        self.unlockedSeaCreatures = YES;
        NSLog(@"unlockedSeaCreatures");
    }];
    [PFPurchase addObserverForProduct:@"com.intencemedia.moviefxstickers.war"
                                block:^(SKPaymentTransaction *transaction) {
        self.unlockedWar = YES;
        NSLog(@"unlockedWar");
    }];
    [PFPurchase addObserverForProduct:@"com.intencemedia.moviefxstickers.zombie"
                                block:^(SKPaymentTransaction *transaction) {
        self.unlockedZombie = YES;
        NSLog(@"unlockedZombie");
    }];

    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]]; // Set bar button color
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:242/255.0f green:28/255.0f blue:15/255.0f alpha:1.0f]]; // Set bar background color
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"Bangers-Regular" size:21.0], NSFontAttributeName, nil]];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Push Notifications

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

@end
