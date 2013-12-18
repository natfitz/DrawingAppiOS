//
//  AppDelegate.h
//  SimpleDrawing3
//
//  Created by Nathan Fitzgibbon on 11/13/13.
//  Copyright (c) 2013 Nathan Fitzgibbon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLView.h"
@interface AppDelegate : NSObject <UIApplicationDelegate>{
    

    GLView* _glView;
}

@property (nonatomic, retain) IBOutlet GLView *glView;
@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
