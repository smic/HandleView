//
//  HandleView.m
//  HandleView
//
//  Created by Stephan Michels on 27.10.10.
//  Copyright (c) 2012 Stephan Michels Softwareentwicklung und Beratung. All rights reserved.
//

#import "HandleView.h"
#import "NSView+HandleView.h"
#import "NSColor+CGColor.h"


#define HandleSize 4.0f
#define HandlePadding 1.0f 

static char HandleViewObservationContext;

@implementation HandleView

@synthesize position = _position;
@synthesize type = _type;
@synthesize color = _color;
@synthesize delegate = _delegate;

#pragma mark - Initialization / Deallocation

- (id)initWithPosition:(CGPoint)position {	
    self = [super initWithFrame:NSMakeRect(0, 0, -HandleSize, -HandleSize)];
    if (self) {
        // Initialization code here.
		self.position = position;
		self.type = kHandleTypeNormal;
		self.color = [NSColor whiteColor];
		
//		self.frame = [self alignRectToBase:NSInsetRect(NSMakeRect(position.x, position.y, 0, 0), -HandleSize - HandlePadding, -HandleSize - HandlePadding)];
		
		[self addObserver:self forKeyPath:@"position" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial) context:&HandleViewObservationContext];
		[self addObserver:self forKeyPath:@"type" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial) context:&HandleViewObservationContext];
		[self addObserver:self forKeyPath:@"color" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial) context:&HandleViewObservationContext];
    }
    return self;
}

+ (HandleView*)handleViewWithPosition:(CGPoint)position {
	return [[[HandleView alloc] initWithPosition:position] autorelease];
}

- (void)dealloc {
	[self removeObserver:self forKeyPath:@"position" context:&HandleViewObservationContext];
	[self removeObserver:self forKeyPath:@"type" context:&HandleViewObservationContext];
	[self removeObserver:self forKeyPath:@"color" context:&HandleViewObservationContext];
	
	self.color = nil;
	
	[super dealloc];
}

#pragma mark - Drawing

- (void)drawRect:(NSRect)rect {
    // Drawing code here.
	CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
	
	CGRect bounds = self.bounds;
	bounds = CGRectInset(bounds, HandlePadding, HandlePadding); 
	
	CGContextSaveGState(context);
	
	CGColorRef fillColor = [self.color createCGColor];
	CGContextSetFillColorWithColor(context, fillColor);
	CGColorRelease(fillColor);
	
	CGContextSetGrayStrokeColor(context, 0.0f, 1.0f);
	
	if (self.type == kHandleTypeNormal) {
		CGContextSetAllowsAntialiasing(context, NO);
	
		// fill background
		CGContextFillRect(context, bounds);
	
		// stroke frame
		CGContextStrokeRect(context, bounds);
	
		CGContextSetAllowsAntialiasing(context, YES);
	} else if (self.type == kHandleTypeSpecial) {
		CGContextBeginPath(context);
		CGContextAddEllipseInRect(context, bounds);
		
		CGContextDrawPath(context, kCGPathFillStroke);
	}
	
	CGContextRestoreGState(context);
}

#pragma mark - Mouse handling

- (void)mouseDown:(NSEvent *)event {
	
    id<HandleViewDelegate> delegate = self.delegate;
    NSPoint position = self.position;
    
	// begin moving
	if ([delegate respondsToSelector:@selector(handleView:didBeginMoving:)]) {
		[delegate handleView:self didBeginMoving:position];
	}
	
	// test the if the position should be changed
	if ([delegate respondsToSelector:@selector(handleView:shouldChangePosition:)]) {
		if (![delegate handleView:self shouldChangePosition:position]) {
			
			// end moving
			if ([delegate respondsToSelector:@selector(handleView:didBeginMoving:)]) {
				[delegate handleView:self didEndMoving:position];
			}
			return;
		}
	}
	
	// bring handle to front
	[self.superview bringSubviewToFront:self];
	
	// set new cursor
	[[NSCursor closedHandCursor] push];
	
	// current position of the mouse pointer
	CGPoint currentPoint = [self.superview convertPoint:[event locationInWindow] fromView:nil];
	CGPoint relativePoint = NSMakePoint(position.x - currentPoint.x, position.y - currentPoint.y);
	
	// waiting for dragging events
	while ([event type]!=NSLeftMouseUp) {
		event = [[self window] nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];
		
		// current position of the mouse pointer
		currentPoint = [self.superview convertPoint:[event locationInWindow] fromView:nil];
		
		position = NSMakePoint(currentPoint.x + relativePoint.x,
                               currentPoint.y + relativePoint.y);
		
		// will change position
		if ([delegate respondsToSelector:@selector(handleView:willChangePosition:)]) {
			position = [delegate handleView:self willChangePosition:position];
		}
		
		// set new position
		self.position = position;
		
		// did change position
		if ([delegate respondsToSelector:@selector(handleView:didChangePosition:)]) {
			[delegate handleView:self didChangePosition:position];
		}
		
		// set frame for new position
//		self.frame = [self alignRectToBase:NSInsetRect(NSMakeRect(mPosition.x, mPosition.y, 0, 0), -HandleSize - HandlePadding, -HandleSize - HandlePadding)];
	}
	
	// restore cursor
	[[NSCursor closedHandCursor] pop];
	
	// end moving
	if ([delegate respondsToSelector:@selector(handleView:didBeginMoving:)]) {
		[delegate handleView:self didEndMoving:position];
	}
}

// "OpenHand" as standard mouse cursor
- (void) resetCursorRects {
    [super resetCursorRects];
    [self addCursorRect:self.bounds cursor:[NSCursor openHandCursor]];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (context != &HandleViewObservationContext) {
        [super observeValueForKeyPath:keyPath 
                             ofObject:object 
                               change:change 
                              context:context];
        return;
    }
    
	if([keyPath isEqualToString:@"position"]) {
		// set frame for new position
		self.frame = [self alignRectToBase:NSInsetRect(NSMakeRect(self.position.x, 
                                                                  self.position.y, 
                                                                  0, 0), 
                                                       -HandleSize - HandlePadding, 
                                                       -HandleSize - HandlePadding)];
	} else if([keyPath isEqualToString:@"type"]) {
		[self setNeedsDisplay:YES];
	} else if([keyPath isEqualToString:@"color"]) {
		[self setNeedsDisplay:YES];
	}
}

@end
