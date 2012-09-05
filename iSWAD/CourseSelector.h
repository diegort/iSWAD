//
//  CourseSelector.h
//  iSWAD
//
//  Created by Diego Montesinos on 10/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseSelector : NSObject{
	UIApplication* app;
	
	id target;
	SEL act;
}

- (id) initWithTarget:(id) tg selector: (SEL) sel;

- (void) showSelector;
- (void) showSelector:(int)level;

- (int) getSelectedCode;
- (NSString *) getSelectedName;
@end
