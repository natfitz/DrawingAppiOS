//
//  MainViewController.h
//  simpleParticle
//
//  Created by Nathan Fitzgibbon on 11/6/13.
//  Copyright (c) 2013 Nathan Fitzgibbon. All rights reserved.
//

#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "EmitterShader.h"

@interface MainViewController : UIView{
    
    
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
	
	
	EmitterShader *pe;
    
}



@end
