//
//  SMEllipseGraphicView.m
//  HandleView
//
//  Created by Stephan Michels on 25.10.10.
//  Copyright (c) 2012 Stephan Michels Softwareentwicklung und Beratung. All rights reserved.
//

#import "SMEllipseView.h"


const CGFloat padding = 10.0f;

@interface SMEllipseView ()

@property (nonatomic, retain) SMHandleView *handleView1;
@property (nonatomic, retain) SMHandleView *handleView2;
@property (nonatomic, retain) SMHandleView *handleView3;

@end

@implementation SMEllipseView

@synthesize graphic = _graphic;

@synthesize handleView1 = _handleView1;
@synthesize handleView2 = _handleView2;
@synthesize handleView3 = _handleView3;

#pragma mark - Initialization / Deallocation

- (id)initWithGraphic:(SMEllipse *)graphic {
    self = [super initWithFrame:CGRectInset(graphic.bounds, -padding, -padding)];
    if (self) {
        // Initialization code here.
		self.graphic = graphic;
		
		self.handleView1 = [SMHandleView handleViewWithPosition:NSMakePoint(self.graphic.center.x - self.frame.origin.x, 
                                                                          self.graphic.center.y - self.frame.origin.y)];
		self.handleView1.delegate = self;
		[self addSubview:self.handleView1];
		
		self.handleView2 = [SMHandleView handleViewWithPosition:NSMakePoint(self.graphic.center.x - self.frame.origin.x + self.graphic.size.width / 2.0f, 
                                                                          self.graphic.center.y - self.frame.origin.y)];
		self.handleView2.type = kHandleTypeSpecial;
		self.handleView2.color = [NSColor redColor];
		self.handleView2.delegate = self;
		[self addSubview:self.handleView2];
		
		self.handleView3 = [SMHandleView handleViewWithPosition:NSMakePoint(self.graphic.center.x - self.frame.origin.x, 
                                                                          self.graphic.center.y - self.frame.origin.y + self.graphic.size.height / 2.0f)];
		self.handleView3.type = kHandleTypeSpecial;
		self.handleView3.color = [NSColor redColor];
		self.handleView3.delegate = self;
		[self addSubview:self.handleView3];
    }
    return self;
}

- (void)dealloc {
	self.graphic = nil;
	
	self.handleView1 = nil;
	self.handleView2 = nil;
	self.handleView3 = nil;
	
	[super dealloc];
}

#pragma mark - Drawing

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

#pragma mark - Handle view delegate

- (CGPoint)handleView:(SMHandleView *)handleView willChangePosition:(CGPoint)position {
	
    if (self.handleView2 == handleView) {
		position.y = self.handleView1.position.y;
    } else if (self.handleView3 == handleView) {
		position.x = self.handleView1.position.x;
    }
	return position;
}

- (void)handleView:(SMHandleView *)handleView didChangePosition:(CGPoint)position {
	if (self.handleView1 == handleView) {
		self.graphic.center = CGPointMake(position.x + self.frame.origin.x,
										  position.y + self.frame.origin.y);
	} else if (self.handleView2 == handleView) {
		self.graphic.size = CGSizeMake((position.x + self.frame.origin.x - self.graphic.center.x) * 2.0f,
                                       self.graphic.size.height);
	} else if (self.handleView3 == handleView) {
		self.graphic.size = CGSizeMake(self.graphic.size.width,
									   (position.y + self.frame.origin.y - self.graphic.center.y) * 2.0f);
	}
	
	self.frame = CGRectInset(self.graphic.bounds, -padding, -padding);
    
	self.handleView1.position = NSMakePoint(self.graphic.center.x - self.frame.origin.x, 
                                            self.graphic.center.y - self.frame.origin.y);
	
	self.handleView2.position = NSMakePoint(self.graphic.center.x - self.frame.origin.x + self.graphic.size.width / 2.0f, 
                                            self.graphic.center.y - self.frame.origin.y);
	
	self.handleView3.position = NSMakePoint(self.graphic.center.x - self.frame.origin.x, 
                                            self.graphic.center.y - self.frame.origin.y + self.graphic.size.height / 2.0f);
}

@end
