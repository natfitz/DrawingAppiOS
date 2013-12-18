//
//  ViewController.h
//  DrawingApp2
//
//  Created by Nathan Fitzgibbon on 11/25/13.
//  Copyright (c) 2013 Nathan Fitzgibbon. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewController : UIViewController{
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
    
 
}

@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *tempDrawImage;
@property (nonatomic, retain) NSMutableArray *pointArray;




@end
