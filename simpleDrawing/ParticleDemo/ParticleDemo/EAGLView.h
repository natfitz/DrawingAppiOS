//
//  EAGLView.h
//  ParticleDemo
//
//  Created by Nathan Fitzgibbon on 11/12/13.
//  Copyright (c) 2013 Nathan Fitzgibbon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "Texture2D.h"
#import "Image.h"
#import "ParticleEmitter.h"
#import "AppState.h"

/*
 This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView subclass.
 The view content is basically an EAGL surface you render your OpenGL scene into.
 Note that setting the view non-opaque will only work if the EAGL surface has an alpha channel.
 */
@interface EAGLView : UIView {
    
@private
    /* The pixel dimensions of the backbuffer */
    GLint backingWidth;
    GLint backingHeight;
    
    EAGLContext *context;
    
    /* OpenGL names for the renderbuffer and framebuffers used to render to this view */
    GLuint viewRenderbuffer, viewFramebuffer;
    
    /* OpenGL name for the depth buffer that is attached to viewFramebuffer, if it exists (0 if it does not exist) */
    GLuint depthRenderbuffer;
	
	/* Time since the last frame was rendered */
	CFTimeInterval lastTime;
	
	/* State to define if OGL has been initialised or not */
	BOOL glInitialised;
	
	/* Bounds of the current screen */
	CGRect screenBounds;
	
	
	NSTimer *gameLoopTimer;
    AppState* sharedAppState;
	Image *sprite;
	ParticleEmitter *pe;
	
}

- (void)renderScene;
- (void)mainGameLoop;
- (void)startAnimation;

@end
