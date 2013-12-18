//
//  ViewController.h
//  DrawingApp2
//
//  Created by Nathan Fitzgibbon on 11/25/13.
//  Copyright (c) 2013 Nathan Fitzgibbon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RIOInterface.h"

@class RIOInterface;

@interface ViewController : UIViewController{
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
    
    RIOInterface *rioRef;
    float currentFrequency;
    float currentAmp;
}

@property (retain, nonatomic) IBOutlet UIImageView *mainImage;
@property (retain, nonatomic) IBOutlet UIImageView *tempDrawImage;
@property (nonatomic, retain) NSMutableArray *pointArray;

@property(nonatomic, assign) RIOInterface *rioRef;
@property(nonatomic, assign) float currentFrequency;
@property(nonatomic, assign) float currentAmp;
- (void)frequencyChangedWithValue:(float)newFrequency;


@end
