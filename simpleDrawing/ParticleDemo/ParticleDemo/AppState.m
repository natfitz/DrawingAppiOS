//
//  AppState.m
//  ParticleDemo
//
//  Created by Nathan Fitzgibbon on 11/12/13.
//  Copyright (c) 2013 Nathan Fitzgibbon. All rights reserved.
//

#import "AppState.h"

@implementation AppState
@synthesize currentlyBoundTexture;

+ (AppState*)sharedAppState {
	
	static AppState *sharedAppState;
	
	@synchronized(self) {
		if(!sharedAppState) {
			sharedAppState = [[AppState alloc] init];
		}
	}
	
	return sharedAppState;
}


@end
