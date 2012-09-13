//
//  CustomUITextView.m
//  iSWAD
//
//  Created by Diego Montesinos on 14/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomUITextView.h"

@implementation CustomUITextView

- (void)drawRect:(CGRect)rect {
    
    
    UIGraphicsBeginImageContext(self.frame.size);
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(currentContext, 3.0); //or whatever width you want
    CGContextSetRGBStrokeColor(currentContext, 0.0, 0.0, 0.0, 1.0); 
    
    CGRect myRect = CGContextGetClipBoundingBox(currentContext);
    //printf("rect = %f,%f,%f,%f\n", myRect.origin.x, myRect.origin.y, myRect.size.width, myRect.size.height);
    
    CGContextStrokeRect(currentContext, myRect);
    UIImage *backgroundImage = (UIImage *)UIGraphicsGetImageFromCurrentImageContext();
    UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [myImageView setImage:backgroundImage];
    [self addSubview:myImageView];
    [backgroundImage release];
    
    UIGraphicsEndImageContext();
}

@end