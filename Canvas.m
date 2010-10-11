//
//  Canvas.m
//  HandleView
//
//  Created by Stephan Michels on 11.10.10.
//  Copyright 2010 Beilstein Institut. All rights reserved.
//

#import "Canvas.h"
#import "HandleView.h"


@implementation Canvas

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib {
	handleView1 = [[HandleView handleVewWitPoint:NSMakePoint(100, 100)] retain];
	handleView1.delegate = self;
	[self addSubview:handleView1];
	
	handleView2 = [[HandleView handleVewWitPoint:NSMakePoint(200, 150)] retain];
	handleView2.delegate = self;
	[self addSubview:handleView2];
}

- (void)handleView:(HandleView*)handleView didChangePoint:(NSPoint)point {
	[self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)rect {
    // Drawing code here.
	[[NSColor redColor] set];
	NSRectFill(self.bounds);
	
	[[NSColor blackColor] set];
	[NSBezierPath strokeLineFromPoint:handleView1.point toPoint:handleView2.point];
}

@end
