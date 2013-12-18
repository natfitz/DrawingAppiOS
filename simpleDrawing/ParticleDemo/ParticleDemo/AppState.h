//
//  AppState.h
//  ParticleDemo
//
//  Created by Nathan Fitzgibbon on 11/12/13.
//  Copyright (c) 2013 Nathan Fitzgibbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>


@interface AppState : NSObject {
    
	//Currently bound texture
	GLuint currentlyBoundTexture;
}

@property (nonatomic, assign) GLuint currentlyBoundTexture;

+ (AppState*)sharedAppState;

@end
