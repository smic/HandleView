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


@interface SMCanvas ()

@property (nonatomic, retain) SMHandleView *handleView1;
@property (nonatomic, retain) SMHandleView *handleView2;
@property (nonatomic, retain) SMHandleView *handleView3;

@property (nonatomic, readonly) CGPoint point3;

@end


@implementation SMCanvas

@synthesize point1 = _point1;
@synthesize point2 = _point2;
@synthesize headWidth = _headWidth;
@synthesize shaftWidth = _shaftWidth;

@synthesize handleView1 = _handleView1;
@synthesize handleView2 = _handleView2;
@synthesize handleView3 = _handleView3;

- (CGPoint)point3 {
    CGPoint d = CGPointSub(self.point2, self.point1);
    CGPoint n = CGPointNormalize(d);
    CGPoint o = CGPointOrthogonal(n);
    
    return CGPointScaleAdd2(self.point1, o, -self.shaftWidth, n, self.headWidth);
}

+ (NSSet *)keyPathsForValuesAffectingPoint3 {
    return [NSSet setWithObjects:@"point1", @"point2", @"headWidth", @"shaftWidth", nil];
}

#pragma mark - Initialization / Deallocation

- (void)awakeFromNib {
    self.point1 = NSMakePoint(300, 150);
    self.point2 = NSMakePoint(100, 250);
    self.headWidth = 50.0f;
    self.shaftWidth = 20.0f;
    
	self.handleView1 = [SMHandleView handleView];
    [self.handleView1 bind:@"position" toObject:self withKeyPath:@"point1" options:nil];
	self.handleView1.delegate = self;
	[self addSubview:self.handleView1];
	
	self.handleView2 = [SMHandleView handleView];
    [self.handleView2 bind:@"position" toObject:self withKeyPath:@"point2" options:nil];
    self.handleView2.delegate = self;
	[self addSubview:self.handleView2];	
    
    self.handleView3 = [SMHandleView handleView];
    self.handleView3.special = YES;
    self.handleView3.color = [NSColor blueColor];
    [self.handleView3 bind:@"position" toObject:self withKeyPath:@"point3" options:nil];
    self.handleView3.delegate = self;
	[self addSubview:self.handleView3];	
}

- (void)dealloc {
    [self.handleView1 unbind:@"position"];
    [self.handleView2 unbind:@"position"];
    [self.handleView3 unbind:@"position"];
    
    self.handleView1 = nil;
	self.handleView2 = nil;
    self.handleView3 = nil;
	
	[super dealloc];
}

#pragma mark - Handle view delegate

- (void)handleView:(SMHandleView*)handleView didBeginMoving:(CGPoint)position {
	// hide handles during the move
	[self.handleView1 setHidden:YES];
	[self.handleView2 setHidden:YES];
    [self.handleView3 setHidden:YES];
}

- (CGPoint)handleView:(SMHandleView*)handleView willChangePosition:(CGPoint)position {
		
    if (self.handleView1 == handleView) {
        // restrict the point to the bounds of the view
        position = CGRectClampPoint(self.bounds, position);
        
        // ensure a minimum arrow length
        CGPoint d = CGPointSub(self.point2, position);
        CGFloat arrowLength = CGPointLength(d);
        if (arrowLength == 0.0f) {
            position = self.point1;
        } else if (arrowLength < 30.0f) {
            position = CGPointScaleAdd(self.point2, d, -30.0f / arrowLength);
        }
        // else nothing
        
        // set first point of the arrow
        self.point1 = position;
        
        // restrict and update arrow head and shaft width
        CGFloat headWidth = self.headWidth;
        CGFloat shaftWidth = self.shaftWidth;
        arrowLength = CGPointDistanceToPoint(self.point1, self.point2);
        headWidth = MIN(arrowLength - 10.0f, MAX(20.0f, headWidth));
        shaftWidth = MIN(headWidth - 10.0f, MAX(10.0f, shaftWidth));
        self.headWidth = headWidth;
        self.shaftWidth = shaftWidth;
        
    } else if (self.handleView2 == handleView) {
        // set last point by the handle
        position = CGRectClampPoint(self.bounds, position);
        
        // ensure a minimum arrow length
        CGPoint d = CGPointSub(position, self.point1);
        CGFloat arrowLength = CGPointLength(d);
        if (arrowLength == 0.0f) {
            position = self.point2;
        } else if (arrowLength < 30.0f) {
            position = CGPointScaleAdd(self.point1, d, 30.0f / arrowLength);
        }
        // else nothing
        
        // set last point by the handle
        self.point2 = position;
        
        // restrict and update arrow head and shaft width
        CGFloat headWidth = self.headWidth;
        CGFloat shaftWidth = self.shaftWidth;
        arrowLength = CGPointDistanceToPoint(self.point1, self.point2);
        headWidth = MIN(arrowLength - 10.0f, MAX(20.0f, headWidth));
        shaftWidth = MIN(headWidth - 10.0f, MAX(10.0f, shaftWidth));
        self.headWidth = headWidth;
        self.shaftWidth = shaftWidth;
        
    } else if (self.handleView3 == handleView) {
        // set width of the arrow head and shaft by the handle
        CGPoint point3 = position;
        
        CGPoint d = CGPointSub(self.point2, self.point1);
        CGFloat arrowLength = CGPointLength(d);
        
        CGPoint a = CGPointSub(point3, self.point1);
        
        CGPoint n = CGPointNormalize(d);
        CGPoint o = CGPointOrthogonal(n);
        
        CGFloat headWidth = CGPointDot(a, n);
        // the negative sign come from the definition of point3
        CGFloat shaftWidth = -CGPointDot(a, o);
        
        // restrict the values to valid values
        headWidth = MIN(arrowLength - 10.0f, MAX(20.0f, headWidth));
        shaftWidth = MIN(headWidth - 10.0f, MAX(10.0f, shaftWidth));
 
        // set arrow head and shaft width and update point3 by it
        self.headWidth = headWidth;
        self.shaftWidth = shaftWidth;
        
        // caluculate the new position over ther getter of point3
        position = self.point3;
    }
	return position;
}

- (void)handleView:(SMHandleView*)handleView didChangePosition:(CGPoint)position {
	[self setNeedsDisplay:YES];
}

- (void)handleView:(SMHandleView*)handleView didEndMoving:(CGPoint)position {
	// show handles again after the move
	[self.handleView1 setHidden:NO];
	[self.handleView2 setHidden:NO];
    [self.handleView3 setHidden:NO];
}

#pragma mark - Drawing

- (void)drawRect:(NSRect)rect {
    // Drawing code here.
    [[NSColor colorWithCalibratedRed:0.482 green:0.675 blue:0.263 alpha:1.] setFill];
    [[NSColor blackColor] setStroke];

    NSBezierPath *path = [NSBezierPath bezierPathWithArrowWithPoint1:self.point1 
                                                              point2:self.point2 
                                                           headWidth:self.headWidth 
                                                          shaftWidth:self.shaftWidth];

    [path fill];
    [path stroke];
}

- (BOOL)isFlipped {
    return YES;
}

@end
