//
//  ShaderProcessor.h
//  simpleParticle
//
//  Created by Nathan Fitzgibbon on 11/6/13.
//  Copyright (c) 2013 Nathan Fitzgibbon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShaderProcessor : NSObject

- (GLuint)BuildProgram:(const char*)vertexShaderSource with:(const char*)fragmentShaderSource;

@end
