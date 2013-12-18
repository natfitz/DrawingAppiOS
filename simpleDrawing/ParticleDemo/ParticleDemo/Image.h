//
//  Image.h
//  simpleParticle
//
//  Created by Nathan Fitzgibbon on 11/12/13.
//  Copyright (c) 2013 Nathan Fitzgibbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Texture2D.h"

typedef struct _Quad2 {
	float tl_x, tl_y;
	float tr_x, tr_y;
	float bl_x, bl_y;
	float br_x, br_y;
} Quad2;

@interface Image : NSObject {
	
    
	// The OpenGL texture to be used for this image
	Texture2D		*texture;
	// The width of the image
	NSUInteger		imageWidth;
	// The height of the image
	NSUInteger		imageHeight;
	// The texture coordinate width to use to find the image
	NSUInteger		textureWidth;
	// The texture coordinate height to use to find the image
	NSUInteger		textureHeight;
	// The maximum texture coordinate width maximum 1.0f
	float			maxTexWidth;
	// The maximum texture coordinate height maximum 1.0f
	float			maxTexHeight;
	// The texture width to pixel ratio
	float			texWidthRatio;
	// The texture height to pixel ratio
	float			texHeightRatio;
	// The X offset to use when looking for our image
	NSUInteger		textureOffsetX;
	// The Y offset to use when looking for our image
	NSUInteger		textureOffsetY;
	// Angle to which the image should be rotated
	float			rotation;
	// Scale at which to draw the image
	float			scale;
	// Flip horizontally
	BOOL			flipHorizontally;
	// Flip Vertically
	BOOL			flipVertically;
	// Colour Filter = Red, Green, Blue, Alpha
	float			colourFilter[4];
    
	// Vertex arrays
	Quad2			*vertices;
	Quad2			*texCoords;
	GLushort		*indices;
}

@property(nonatomic, readonly)Texture2D			*texture;
@property(nonatomic)NSUInteger					imageWidth;
@property(nonatomic)NSUInteger					imageHeight;
@property(nonatomic, readonly)NSUInteger		textureWidth;
@property(nonatomic, readonly)NSUInteger		textureHeight;
@property(nonatomic, readonly)float				texWidthRatio;
@property(nonatomic, readonly)float				texHeightRatio;
@property(nonatomic)NSUInteger					textureOffsetX;
@property(nonatomic)NSUInteger					textureOffsetY;
@property(nonatomic)float						rotation;
@property(nonatomic)float						scale;
@property(nonatomic) BOOL						flipVertically;
@property(nonatomic) BOOL						flipHorizontally;
@property(nonatomic)Quad2						*vertices;
@property(nonatomic)Quad2						*texCoords;

// Initializers
- (id)initWithTexture:(Texture2D *)tex;
- (id)initWithTexture:(Texture2D *)tex scale:(float)imageScale;
- (id)initWithImage:(UIImage *)image;
- (id)initWithImage:(UIImage *)image filter:(GLenum)filter;
- (id)initWithImage:(UIImage *)image scale:(float)imageScale;
- (id)initWithImage:(UIImage *)image scale:(float)imageScale filter:(GLenum)filter;

// Action methods
- (Image*)getSubImageAtPoint:(CGPoint)point subImageWidth:(GLuint)subImageWidth subImageHeight:(GLuint)subImageHeight scale:(float)subImageScale;
- (void)renderAtPoint:(CGPoint)point centerOfImage:(BOOL)center;
- (void)renderSubImageAtPoint:(CGPoint)point offset:(CGPoint)offsetPoint subImageWidth:(GLfloat)subImageWidth subImageHeight:(GLfloat)imageHeigt centerOfImage:(BOOL)center;
- (void)calculateVerticesAtPoint:(CGPoint)point subImageWidth:(GLuint)subImageWidth subImageHeight:(GLuint)subImageHeight centerOfImage:(BOOL)center;
- (void)calculateTexCoordsAtOffset:(CGPoint)offsetPoint subImageWidth:(GLuint)subImageWidth subImageHeight:(GLuint)subImageHeight;

// Setters
- (void)setColourFilterRed:(float)red green:(float)green blue:(float)blue alpha:(float)a;
- (void)setAlpha:(float)alpha;

@end
