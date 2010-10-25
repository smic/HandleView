//
//  EllipseGraphicView.h
//  HandleView
//
//  Created by Stephan Michels on 25.10.10.
//  Copyright 2010 Beilstein Institut. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EllipseGraphic.h"
#import "HandleView.h"


@interface EllipseGraphicView : NSView <HandleViewDelegate> {
	EllipseGraphic *mGraphic;
	
	HandleView *mHandleView1;
	HandleView *mHandleView2;
	HandleView *mHandleView3;
}

@property (nonatomic, retain) EllipseGraphic *graphic;

- (id)initWithGraphic:(EllipseGraphic*)graphic;

@end
