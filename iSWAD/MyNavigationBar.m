//
//  MyNavigationBar.m
//  iSWAD
//
//  Created by Diego Montesinos on 10/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MyNavigationBar.h"

@implementation MyNavigationBar
@synthesize myImage;

-(void)drawRect:(CGRect)rect
{
    /*if (self.myImage) {
        // draw your own image
        UIColor *color = [UIColor blackColor];
        UIImage *img    = [UIImage imageNamed: @"nav.png"];
        [img drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.tintColor = color;
    } else {
        [super drawRect:rect];
    }*/
    //UIColor *color = [UIColor whiteColor];
    UIImage *img    = [UIImage imageNamed: @"cabecera.png"];
    //[img drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    double x,y;
    x = self.frame.size.width/2 - img.size.width/2;
    y = self.frame.size.height/2 - img.size.height/2;
    [img drawInRect:CGRectMake(x, y, img.size.width, img.size.height)];
    //[img drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    //self.backgroundColor = [UIColor whiteColor];
    self.tintColor = [UIColor lightGrayColor];
    //NSLog(@"%@, %@", self.frame.size.width,self.frame.size.height);
}
@end