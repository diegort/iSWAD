//
//  ConfigureTestViewController.h
//  iSWAD
//
//  Created by Diego Montesinos on 09/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class getTestConfigOutput, tagsArray, questionsArray;
@interface ConfigureTestViewController : UIViewController{

}

@property int courseCode;
@property (retain, nonatomic) getTestConfigOutput* config;

@end
