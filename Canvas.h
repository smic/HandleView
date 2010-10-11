//
//  Canvas.h
//  HandleView
//
//  Created by Stephan Michels on 11.10.10.
//  Copyright 2010 Beilstein Institut. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HandleView.h"

@interface Canvas : NSView <HandleViewDelegate> {
	HandleView *handleView1;
	HandleView *handleView2;
}

@end
