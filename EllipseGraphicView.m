//
//  EllipseGraphicView.m
//  HandleView
//
//  Created by Stephan Michels on 25.10.10.
//  Copyright 2010 Beilstein Institut. All rights reserved.
//

#import "EllipseGraphicView.h"


const CGFloat padding = 10.0f;


@implementation EllipseGraphicView

@synthesize graphic = mGraphic;

- (id)initWithGraphic:(EllipseGraphic*)graphic {
    self = [super initWithFrame:NSRectFromCGRect(CGRectInset(graphic.bounds, -padding, -padding))];
    if (self) {
        // Initialization code here.
		self.graphic = graphic;
		
		NSLog(@"graphic.bounds = %@", NSStringFromRect(NSRectFromCGRect(graphic.bounds)));
		NSLog(@"frame = %@", NSStringFromRect(self.frame));
		
		
		mHandleView1 = [[HandleView handleViewWithPosition:NSMakePoint(self.graphic.center.x - self.frame.origin.x, 
																	  self.graphic.center.y - self.frame.origin.y)] retain];
		mHandleView1.delegate = self;
		[self addSubview:mHandleView1];
		
		mHandleView2 = [[HandleView handleViewWithPosition:NSMakePoint(self.graphic.center.x - self.frame.origin.x + self.graphic.size.width / 2.0f, 
																	  self.graphic.center.y - self.frame.origin.y)] retain];
		mHandleView2.type = kHandleTypeSpecial;
		mHandleView2.color = [NSColor redColor];
		mHandleView2.delegate = self;
		[self addSubview:mHandleView2];
		
		mHandleView3 = [[HandleView handleViewWithPosition:NSMakePoint(self.graphic.center.x - self.frame.origin.x, 
																	   self.graphic.center.y - self.frame.origin.y + self.graphic.size.height / 2.0f)] retain];
		mHandleView3.type = kHandleTypeSpecial;
		mHandleView3.color = [NSColor redColor];
		mHandleView3.delegate = self;
		[self addSubview:mHandleView3];
    }
    return self;
}

- (void)drawRect:(NSRect)rect {
    // Drawing code here.
	
	CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
	
	CGContextSaveGState(context);
	
	CGRect graphicBounds = self.graphic.bounds;
	graphicBounds.origin.x -= self.frame.origin.x;
	graphicBounds.origin.y -= self.frame.origin.y;
	
	CGContextSetGrayStrokeColor(context, 0.0f, 1.0f);
	CGContextStrokeEllipseInRect(context, graphicBounds);
	
	CGContextRestoreGState(context);
}

- (NSPoint)handleView:(HandleView*)handleView willChangePosition:(NSPoint)position {
	
    if (mHandleView2 == handleView) {
		position.y = mHandleView1.position.y;
    } else if (mHandleView3 == handleView) {
		position.x = mHandleView1.position.x;
    }
	return position;
}

- (void)handleView:(HandleView*)handleView didChangePosition:(NSPoint)position {
	if (mHandleView1 == handleView) {
		self.graphic.center = CGPointMake(position.x + self.frame.origin.x,
										  position.y + self.frame.origin.y);
	} else if (mHandleView2 == handleView) {
		self.graphic.size = CGSizeMake((position.x + self.frame.origin.x - self.graphic.center.x) * 2.0f,
										self.graphic.size.height);
	} else if (mHandleView3 == handleView) {
		self.graphic.size = CGSizeMake(self.graphic.size.width,
									   (position.y + self.frame.origin.y - self.graphic.center.y) * 2.0f);
	}
	
	self.frame = NSRectFromCGRect(CGRectInset(self.graphic.bounds, -padding, -padding));

	mHandleView1.position = NSMakePoint(self.graphic.center.x - self.frame.origin.x, 
									  self.graphic.center.y - self.frame.origin.y);
	
	mHandleView2.position = NSMakePoint(self.graphic.center.x - self.frame.origin.x + self.graphic.size.width / 2.0f, 
									  self.graphic.center.y - self.frame.origin.y);
	
	mHandleView3.position = NSMakePoint(self.graphic.center.x - self.frame.origin.x, 
										self.graphic.center.y - self.frame.origin.y + self.graphic.size.height / 2.0f);
}

- (void)dealloc {
	self.graphic = nil;
	
	[mHandleView1 release];
	[mHandleView2 release];
	[mHandleView3 release];
	
	[super dealloc];
}

@end
