//
//  EllipseGraphicView.h
//  HandleView
//
//  Created by Stephan Michels on 25.10.10.
//  Copyright 2010 Beilstein Institut. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Ellipse.h"
#import "HandleView.h"


@interface EllipseView : NSView <HandleViewDelegate> {
	Ellipse *mGraphic;
	
	HandleView *mHandleView1;
	HandleView *mHandleView2;
	HandleView *mHandleView3;
}

@property (nonatomic, retain) Ellipse *graphic;

- (id)initWithGraphic:(Ellipse*)graphic;

@end
