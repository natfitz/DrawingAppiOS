//
//  ViewController.m
//  DrawingApp2
//
//  Created by Nathan Fitzgibbon on 11/25/13.
//  Copyright (c) 2013 Nathan Fitzgibbon. All rights reserved.
//

#import "ViewController.h"
#import "RIOInterface.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize pointArray;
@synthesize currentFrequency;
@synthesize rioRef;
@synthesize currentAmp;



- (void)viewDidLoad
{
    rioRef = [RIOInterface sharedInstance];
    [rioRef setSampleRate:44100];
	[rioRef setFrequency:294];
	[rioRef initializeAudioSession];

    
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 1.0;
    opacity = 1.0;
    pointArray = [[NSMutableArray alloc] init];
    [rioRef startListening:self];

    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    [pointArray addObject:[NSValue valueWithCGPoint:currentPoint]];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    
    for (int p=0; p < pointArray.count; p++){
        NSValue *val = [pointArray objectAtIndex:p];
        CGPoint curP = [val CGPointValue];
        float dist =sqrt(pow(currentPoint.x-curP.x,2)+pow(currentPoint.y-curP.y,2));
        float linkChance = p/pointArray.count + dist/100;
        // currentPoint.dist(curP)/100;
        if (linkChance < .4){
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), curP.x, curP.y);
            
        }
    }
    
    
    //    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    //    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.tempDrawImage setAlpha:opacity];
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!mouseSwiped) {
        UIGraphicsBeginImageContext(self.view.frame.size);
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    UIGraphicsBeginImageContext(self.mainImage.frame.size);
    [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
    self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    self.tempDrawImage.image = nil;
    UIGraphicsEndImageContext();
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if ( event.subtype == UIEventSubtypeMotionShake )
    {
        self.mainImage.image = nil;
        [pointArray removeAllObjects];
    }
    
    if ( [super respondsToSelector:@selector(motionEnded:withEvent:)] )
        [super motionEnded:motion withEvent:event];
}
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)frequencyChangedWithValue:(float)newFrequency{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	self.currentFrequency = newFrequency;
    [pool drain];
	pool = nil;
    
//    float x = arc4random_uniform(500);
//    float y = arc4random_uniform(500);
//    
//    CGPoint currentPoint = CGPointMake(x,y);
//    [pointArray addObject:[NSValue valueWithCGPoint:currentPoint]];
//    
//    UIGraphicsBeginImageContext(self.view.frame.size);
//    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    printf("length of pointarray: %i\n",pointArray.count);
//    
//    for (int p=0; p < pointArray.count; p++){
//        NSValue *val = [pointArray objectAtIndex:p];
//        CGPoint curP = [val CGPointValue];
//        float dist =sqrt(pow(currentPoint.x-curP.x,2)+pow(currentPoint.y-curP.y,2));
//        float linkChance = p/pointArray.count + dist/100;
//        // currentPoint.dist(curP)/100;
//        if (linkChance < .4){
//            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
//            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), curP.x, curP.y);
//            
//        }
//    }
//	
//    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
//    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
//    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
//    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
//    
//    CGContextStrokePath(UIGraphicsGetCurrentContext());
//    self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
//    [self.tempDrawImage setAlpha:opacity];
//    UIGraphicsEndImageContext();
//    
//    lastPoint = currentPoint;
//    
   // [self drawWeb];
}

//- (void) drawWeb {
//    
//    if(!mouseSwiped) {
//        UIGraphicsBeginImageContext(self.view.frame.size);
//        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
//        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
//        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
//        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
//        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
//        CGContextStrokePath(UIGraphicsGetCurrentContext());
//        CGContextFlush(UIGraphicsGetCurrentContext());
//        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//    }
//    
//    UIGraphicsBeginImageContext(self.mainImage.frame.size);
//    [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
//    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
//    self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
//    self.tempDrawImage.image = nil;
//    UIGraphicsEndImageContext();
//    
//}

- (void)dealloc
{
    
    [super dealloc];
}
@end
