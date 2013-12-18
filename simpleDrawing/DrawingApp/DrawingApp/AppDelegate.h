//
//  AppDelegate.h
//  DrawingApp
//
//  Created by Nathan Fitzgibbon on 11/18/13.
//  Copyright (c) 2013 Nathan Fitzgibbon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLView.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    GLView* _glView;

}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) IBOutlet GLView *glView;

@end
