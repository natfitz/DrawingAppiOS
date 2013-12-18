//
//  AppDelegate.h
//  ParticleDemo
//
//  Created by Nathan Fitzgibbon on 11/12/13.
//  Copyright (c) 2013 Nathan Fitzgibbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EAGLView;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    EAGLView *glView;
	int currentTexture;
	NSTimer *gameLoopTimer;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet EAGLView *glView;
@property (nonatomic, assign) int currentTexture;

@end
