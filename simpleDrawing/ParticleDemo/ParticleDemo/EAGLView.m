//
//  EAGLView.m
//  ParticleDemo
//
//  Created by Nathan Fitzgibbon on 11/12/13.
//  Copyright (c) 2013 Nathan Fitzgibbon. All rights reserved.
//

#import "EAGLView.h"
#import "ParticleTemplate.h"
#import "ParticleEmitter.h"
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import <mach/mach.h>
#import <mach/mach_time.h>

#define USE_DEPTH_BUFFER 0

@interface EAGLView ()

@property (nonatomic, retain) EAGLContext *context;

- (BOOL) createFramebuffer;
- (void) destroyFramebuffer;
- (void) updateScene:(float)delta;
- (void) renderScene;
- (void) initOpenGL;

@end
@implementation EAGLView
@synthesize context;


// You must implement this method
+ (Class)layerClass {
    return [CAEAGLLayer class];
}


//The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder {
    
    if ((self = [super initWithCoder:coder])) {
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!context || ![EAGLContext setCurrentContext:context]) {
            //[self release];
            return nil;
        }
		
		// Get the bounds of the main screen
		screenBounds = [[UIScreen mainScreen] bounds];
		
		// Go and initialise the game entities and graphics etc
        [self initGame];
    }
    return self;
}

- (void)initGame {
	NSLog(@"initGame");
    sharedAppState = [AppState sharedAppState];
	glInitialised = NO;
	
		// Init particle emitter
	/*pe = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
														   position:Vector2fMake(0, 1000)
 	 										 sourcePositionVariance:Vector2fMake(5, 5)
															  speed:1.5f
													  speedVariance:0.5f
												   particleLifeSpan:1.0f
										   particleLifespanVariance:0.5f
															  angle:90.0f
													  angleVariance:15
															gravity:Vector2fMake(0.0f, -0.00f)
														 startColor:Color4fMake(0.76f, 0.12f, 0.3f, 1.0f)
												 startColorVariance:Color4fMake(1.0f, 0.0f, 0.0f, 1.0f)
														finishColor:Color4fMake(0.0f, 0.4f, 1.0f, 0.0f)
												finishColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)
													   maxParticles:500
													   particleSize:64
											   particleSizeVariance:0
														   duration:-1
													  blendAdditive:YES]; */
	
	// Set the initial value for lastTime
	lastTime = CFAbsoluteTimeGetCurrent();
}

- (void)mainGameLoop {
	//NSLog(@"test 2");
	// Create variables to hold the current time and calculated delta
	CFTimeInterval		time;
	float				delta;
	
	// This is the heart of the game loop and will keep on looping until it is told otherwise
    //	while(true) {
    
    // Create an autorelease pool which can be used within this tight loop.  This is a memory
    // leak when using NSString stringWithFormat in the renderScene method.  Adding a specific
    // autorelease pool stops the memory leak
   // NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // I found this trick on iDevGames.com.  The command below pumps events which take place
    // such as screen touches etc so they are handled and then runs our code.  This means
    // that we are always in sync with VBL rather than an NSTimer and VBL being out of sync
    while(CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.002, TRUE) == kCFRunLoopRunHandledSource);
    
    // Get the current time and calculate the delta between the lasttime and now
    // We multiply the delta by 1000 to give us milliseconds
    time = CFAbsoluteTimeGetCurrent();
    delta = (time - lastTime);
    
    // Go and update the game logic and then render the scene
    [self updateScene:delta];
    [self renderScene];
    
    // Set the lasttime to the current time ready for the next pass
    lastTime = time;
    
    // Release the autorelease pool so that it is drained
   // [pool release];
    //	}
}


- (void)updateScene:(float)delta {
	[pe update:delta];
}


- (void)renderScene {
    
	// If OpenGL has not yet been initialised then go and initialise it
	if(!glInitialised) {
		[self initOpenGL];
	}
    
	// Set the current EAGLContext and bind to the framebuffer.  This will direct all OGL commands to the
	// framebuffer and the associated renderbuffer attachment which is where our scene will be rendered
	[EAGLContext setCurrentContext:context];
    glBindFramebuffer(GL_FRAMEBUFFER, viewFramebuffer);
    
	// Define the viewport.  Changing the settings for the viewport can allow you to scale the viewport
	// as well as the dimensions etc and so I'm setting it for each frame in case we want to change it
	glViewport(0, 0, screenBounds.size.width , screenBounds.size.height);
	
	// Clear the screen.  If we are going to draw a background image then this clear is not necessary
	// as drawing the background image will destroy the previous image
	glClear(GL_COLOR_BUFFER_BIT);
	
	// Setup how the images are to be blended when rendered.  This could be changed at different points during your
	// render process if you wanted to apply different effects
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
	[pe renderParticles];
    
    
	// Bind to the renderbuffer and then present this image to the current context
    glBindRenderbuffer(GL_RENDERBUFFER, viewRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER];
}


- (void)initOpenGL {
	// Switch to GL_PROJECTION matrix mode and reset the current matrix with the identity matrix
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	
	// Setup Ortho for the current matrix mode.  This describes a transformation that is applied to
	// the projection.  For our needs we are defining the fact that 1 pixel on the screen is equal to
	// one OGL unit by defining the horizontal and vertical clipping planes to be from 0 to the views
	// dimensions.  The far clipping plane is set to -1 and the near to 1
	glOrthof(0, screenBounds.size.width, 0, screenBounds.size.height, -1, 1);
	
	// Switch to GL_MODELVIEW so we can now draw our objects
	glMatrixMode(GL_MODELVIEW);
	
	// Setup how textures should be rendered i.e. how a texture with alpha should be rendered ontop of
	// another texture.  We are setting this to GL_BLEND_SRC by default and not changing it during the
	// game
	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_BLEND_SRC);
	
	// We are going to be using GL_VERTEX_ARRAY to do all drawing within our game so it can be enabled once
	// If this was not the case then this would be set for each frame as necessary
	glEnableClientState(GL_VERTEX_ARRAY);
	
	// We are not using the depth buffer in our 2D game so depth testing can be disabled.  If depth
	// testing was required then a depth buffer would need to be created as well as enabling the depth
	// test
	glDisable(GL_DEPTH_TEST);
	
	// Set the colour to use when clearing the screen with glClear
	glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
	
	// Mark OGL as initialised
	glInitialised = YES;
}

- (void)layoutSubviews {
    [EAGLContext setCurrentContext:context];
    [self destroyFramebuffer];
    [self createFramebuffer];
    [self renderScene];
}


- (BOOL)createFramebuffer {
    
    glGenFramebuffers(1, &viewFramebuffer);
    glGenRenderbuffers(1, &viewRenderbuffer);
    
    glBindFramebuffer(GL_FRAMEBUFFER, viewFramebuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, viewRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)self.layer];
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, viewRenderbuffer);
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    
    if (USE_DEPTH_BUFFER) {
        glGenRenderbuffers(1, &depthRenderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, depthRenderbuffer);
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, backingWidth, backingHeight);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderbuffer);
    }
    
    if(glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
        return NO;
    }
    
    return YES;
}


- (void)startAnimation {
    //NSLog(@"test 1");
    gameLoopTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60 target:self selector:@selector(mainGameLoop) userInfo:nil repeats:YES];
}


- (void)destroyFramebuffer {
    
    glDeleteFramebuffers(1, &viewFramebuffer);
    viewFramebuffer = 0;
    glDeleteRenderbuffers(1, &viewRenderbuffer);
    viewRenderbuffer = 0;
    
    if(depthRenderbuffer) {
        glDeleteRenderbuffers(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
}


- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    NSLog(@"x = %f y = %f", location.x, location.y);
    
	pe = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
														   position:Vector2fMake(location.x, location.y)
 	 										 sourcePositionVariance:Vector2fMake(5, 5)
															  speed:1.5f
													  speedVariance:0.5f
												   particleLifeSpan:2.0f
										   particleLifespanVariance:0.5f
															  angle:90.0f
													  angleVariance:360
															gravity:Vector2fMake(0.0f, -0.10f)
														 startColor:Color4fMake(0.4f, 0.12f, 0.3f, 1.0f)
												 startColorVariance:Color4fMake(0.7f, 0.2f, 0.4f, 1.0f)
														finishColor:Color4fMake(0.0f, 0.4f, 1.0f, 1.0f)
												finishColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)
													   maxParticles:150
													   particleSize:10
											   particleSizeVariance:5
														   duration:1
													  blendAdditive:YES]; 
}

- (void)dealloc {
	//[pe release];
	
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    //[context release];
    //[super dealloc];
}


@end
