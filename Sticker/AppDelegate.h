//
//  AppDelegate.h
//  Sticker
//
//  Created by Q on 11/23/14.
//  Copyright (c) 2014 Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) BOOL unlockedAll;
@property (nonatomic, assign) BOOL unlockedAnimals;
@property (nonatomic, assign) BOOL unlockedDinosaur;
@property (nonatomic, assign) BOOL unlockedHaunted;
@property (nonatomic, assign) BOOL unlockedMotherNature;
@property (nonatomic, assign) BOOL unlockedSciFi;
@property (nonatomic, assign) BOOL unlockedSeaCreatures;
@property (nonatomic, assign) BOOL unlockedWar;
@property (nonatomic, assign) BOOL unlockedZombie;
@property (nonatomic, strong) UIImage *stickerImage;


@end

