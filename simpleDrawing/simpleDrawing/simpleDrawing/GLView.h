//
//  GLView.h
//  simpleDrawing
//
//  Created by Nathan Fitzgibbon on 11/6/13.
//  Copyright (c) 2013 Nathan Fitzgibbon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

@interface OpenGLView : UIView {
    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
    GLuint _colorRenderBuffer;
}



@end
