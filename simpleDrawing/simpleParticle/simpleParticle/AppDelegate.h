//
//  AppDelegate.h
//  simpleParticle
//
//  Created by Nathan Fitzgibbon on 11/6/13.
//  Copyright (c) 2013 Nathan Fitzgibbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface OGLGameAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MainViewController *glView;
	int currentTexture;
	NSTimer *gameLoopTimer;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MainViewController *glView;
@property (nonatomic, assign) int currentTexture;

@end
