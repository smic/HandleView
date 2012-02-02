//
//  HandleView.m
//  HandleView
//
//  Created by Stephan Michels on 27.10.10.
//  Copyright (c) 2012 Stephan Michels Softwareentwicklung und Beratung. All rights reserved.
//

#import "SMHandleView.h"
#import "NSView+HandleView.h"
#import "NSColor+CGColor.h"


#define HandleSize 4.0f

static char SMHandleViewObservationContext;

@implementation SMHandleView

@synthesize position = _position;
@synthesize special = _special;
@synthesize color = _color;
@synthesize delegate = _delegate;

#pragma mark - Initialization / Deallocation

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
		self.position = CGPointZero;
		self.special = NO;
		self.color = [NSColor whiteColor];
		
		[self addObserver:self forKeyPath:@"position" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial) context:&SMHandleViewObservationContext];
		[self addObserver:self forKeyPath:@"special" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial) context:&SMHandleViewObservationContext];
		[self addObserver:self forKeyPath:@"color" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial) context:&SMHandleViewObservationContext];
    }
    return self;
}

+ (SMHandleView *)handleView {
	return [[[SMHandleView alloc] initWithFrame:NSZeroRect] autorelease];
}

- (void)dealloc {
	[self removeObserver:self forKeyPath:@"position" context:&SMHandleViewObservationContext];
	[self removeObserver:self forKeyPath:@"special" context:&SMHandleViewObservationContext];
	[self removeObserver:self forKeyPath:@"color" context:&SMHandleViewObservationContext];
	
	self.color = nil;
	
	[super dealloc];
}

#pragma mark - Drawing

- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.    
    NSRect rect = NSMakeRect(self.bounds.origin.x + 0.5f, 
                             self.bounds.origin.y + 0.5f, 
                             self.bounds.size.width - 1.0f, 
                             self.bounds.size.height - 1.0f);
    
    NSBezierPath *path = [self isSpecial] ? [NSBezierPath bezierPathWithOvalInRect:rect] : [NSBezierPath bezierPathWithRect:rect];
    [path setLineWidth:0.0f];
    
    if (self.color) {
        [self.color setFill];
    } else {
        [[NSColor whiteColor] setFill];
    }
    [[NSColor blackColor] setStroke];
    
    [path fill];
    [path stroke];
}

#pragma mark - Mouse handling

- (void)mouseDown:(NSEvent *)event {
	
    id<SMHandleViewDelegate> delegate = self.delegate;
    NSPoint position = self.position;
    
	// bring handle to front
    [self.superview bringSubviewToFront:self];
    
    // set new cursor
    [[NSCursor closedHandCursor] push];
    
	// current position of the mouse pointer
	CGPoint currentPoint = [self.superview convertPoint:[event locationInWindow] fromView:nil];
	CGPoint relativePoint = NSMakePoint(position.x - currentPoint.x, position.y - currentPoint.y);
    CGPoint previousPoint = currentPoint;
    
	// waiting for dragging events
    BOOL moved = NO;
	while ([event type]!=NSLeftMouseUp) {
		event = [[self window] nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];
        
		// current position of the mouse pointer
		currentPoint = [self.superview convertPoint:[event locationInWindow] fromView:nil];
        
        // do nothing until the current point changed
        if (CGPointEqualToPoint(currentPoint, previousPoint)) {
            continue;
        }
        
        // delay calling the delegate until the handle are really moved
        if (!moved) {
            // test the if the position should be changed
            if ([delegate respondsToSelector:@selector(handleView:shouldChangePosition:)]) {
                if (![delegate handleView:self shouldChangePosition:position]) {
                    return;
                }
            }
            
            moved = YES;
        }
        
		position = NSMakePoint(currentPoint.x + relativePoint.x,
                               currentPoint.y + relativePoint.y);
		
		// will change position
		if ([delegate respondsToSelector:@selector(handleView:willChangePosition:)]) {
			position = [delegate handleView:self willChangePosition:position];
		}
		
		// set new position
		self.position = position;
        
        previousPoint = currentPoint;
	}
    
	// restore previous cursor
	[NSCursor pop];
	
    if (moved) {
        // did change position
		if ([delegate respondsToSelector:@selector(handleView:didChangePosition:)]) {
			[delegate handleView:self didChangePosition:position];
		}
    }
}

// "OpenHand" as standard mouse cursor
// Source: http://borkware.com/quickies/single?id=200
- (void)resetCursorRects {
    [super resetCursorRects];
    [self addCursorRect:self.bounds cursor:[NSCursor openHandCursor]];
}

#pragma mark - KVO

- (NSRect)frameForPosition:(NSPoint)position {
    return [self alignRectToBase:NSInsetRect(NSMakeRect(position.x, 
                                                        position.y, 
                                                        0, 0), 
                                             -HandleSize, 
                                             -HandleSize)];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (context != &SMHandleViewObservationContext) {
        [super observeValueForKeyPath:keyPath 
                             ofObject:object 
                               change:change 
                              context:context];
        return;
    }
    
	if([keyPath isEqualToString:@"position"]) {
		// set frame for new position
		self.frame = [self frameForPosition:self.position];
	} else if([keyPath isEqualToString:@"special"]) {
		[self setNeedsDisplay:YES];
	} else if([keyPath isEqualToString:@"color"]) {
		[self setNeedsDisplay:YES];
	}
}

@end
