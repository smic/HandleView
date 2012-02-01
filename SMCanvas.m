//
//  SMCanvas.m
//  HandleView
//
//  Created by Stephan Michels on 27.10.10.
//  Copyright (c) 2012 Stephan Michels Softwareentwicklung und Beratung. All rights reserved.
//

#import "SMCanvas.h"
#import "SMHandleView.h"
#import "SMGeometry.h"
#import "NSBezierPath+HandleView.h"


CGFloat CGFloatClamp(CGFloat value, CGFloat min, CGFloat max) {
	if (value > max)
		return max;
	else if (value < min)
		return min;
	return value;
}


@interface SMCanvas ()

@property (nonatomic, retain) SMHandleView *handleView1;
@property (nonatomic, retain) SMHandleView *handleView2;

@end


@implementation SMCanvas

@synthesize point1 = _point1;
@synthesize point2 = _point2;

@synthesize handleView1 = _handleView1;
@synthesize handleView2 = _handleView2;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib {
	self.handleView1 = [SMHandleView handleViewWithPosition:NSMakePoint(100, 50)];
	self.handleView1.delegate = self;
	[self addSubview:self.handleView1];
	
	self.handleView2 = [SMHandleView handleViewWithPosition:NSMakePoint(300, 150)];
    self.handleView2.delegate = self;
	[self addSubview:self.handleView2];	
    
    self.point1 = self.handleView1.position;
    self.point2 = self.handleView2.position;
}

- (void)dealloc {
    self.handleView1 = nil;
	self.handleView2 = nil;
	
	[super dealloc];
}

#pragma mark - Handle view delegate

- (void)handleView:(SMHandleView*)handleView didBeginMoving:(CGPoint)position {
	// make handles visible again
	[self.handleView1 setHidden:YES];
	[self.handleView2 setHidden:YES];
}

- (CGPoint)handleView:(SMHandleView*)handleView willChangePosition:(CGPoint)position {
	
	
//    if (self.handleView1 == handleView) {
//        CGPoint center = NSMakePoint(100, 100);
//        CGFloat dx = position.x - center.x;
//        CGFloat dy = position.y - center.y;
//        CGFloat length = hypotf(dx, dy);
//        if (length == 0) {
//            return NSMakePoint(150, 100);
//        }
//        CGFloat radius = 50;
//        return NSMakePoint(center.x + dx * radius / length, center.y + dy * radius / length);
//    } else if (self.handleView2 == handleView) {
//        CGRect rect = self.bounds;
//        return NSMakePoint(CGFloatClamp(position.x, CGRectGetMinX(rect), CGRectGetMaxX(rect)), 
//                           CGFloatClamp(position.y, CGRectGetMinY(rect), CGRectGetMaxY(rect)));
//    }
    if (self.handleView1 == handleView) {
        self.point1 = handleView.position;
    } else if (self.handleView2 == handleView) {
        self.point2 = handleView.position;
    }
	return position;
}

- (void)handleView:(SMHandleView*)handleView didChangePosition:(CGPoint)position {
	[self setNeedsDisplay:YES];
}

- (void)handleView:(SMHandleView*)handleView didEndMoving:(CGPoint)position {
	// show handles on move
	[self.handleView1 setHidden:NO];
	[self.handleView2 setHidden:NO];
}

#pragma mark - Drawing

- (void)drawRect:(NSRect)rect {
    // Drawing code here.
    [[NSColor redColor] setFill];
    [[NSColor blackColor] setStroke];

    CGPoint point1 = self.point1;
    CGPoint point2 = self.point2;
	
    CGFloat headSize = 50.0f;
    
    NSBezierPath *path = [NSBezierPath bezierPathWithArrowWithPoint1:point1 point2:point2 headSize:headSize];

    [path fill];
    [path stroke];
}

@end
