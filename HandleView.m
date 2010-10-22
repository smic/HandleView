//
//  HandleView.m
//  HandleView
//
//  Created by Stephan Michels on 11.10.10.
//  Copyright 2010 Beilstein Institut. All rights reserved.
//

#import "HandleView.h"

#define HandleSize 4.0f
#define HandlePadding 1.0f 

@implementation HandleView

@synthesize position = mPosition, delegate = mDelegate;

- (id)initWithPosition:(NSPoint)position {	
    self = [super initWithFrame:NSMakeRect(0, 0, -HandleSize, -HandleSize)];
    if (self) {
        // Initialization code here.
		mPosition = position;
		
		self.frame = [self alignRectToBase:NSInsetRect(NSMakeRect(position.x, position.y, 0, 0), -HandleSize - HandlePadding, -HandleSize - HandlePadding)];
    }
    return self;
}

+ (HandleView*)handleViewWithPosition:(NSPoint)position {
	return [[[HandleView alloc] initWithPosition:position] autorelease];
}

- (void)drawRect:(NSRect)rect {
    // Drawing code here.
	CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
	
	CGRect bounds = NSRectToCGRect(self.bounds);
	bounds = CGRectInset(bounds, HandlePadding, HandlePadding); 
	
	CGContextSaveGState(context);
	
	CGContextSetAllowsAntialiasing(context, NO);
	
	CGContextSetGrayFillColor(context, 1.0f, 1.0f);
	CGContextFillRect(context, bounds);
	
	CGContextSetGrayStrokeColor(context, 0.0f, 1.0f);
	CGContextStrokeRect(context, bounds);
	
	CGContextSetAllowsAntialiasing(context, YES);
	
	CGContextRestoreGState(context);
}

- (void)mouseDown:(NSEvent *)event {
	
	// begin moving
	if ([mDelegate respondsToSelector:@selector(handleView:didBeginMoving:)]) {
		[mDelegate handleView:self didBeginMoving:mPosition];
	}
	
	// test the if the position should be changed
	if ([mDelegate respondsToSelector:@selector(handleView:shouldChangePosition:)]) {
		if (![mDelegate handleView:self shouldChangePosition:mPosition]) {
			
			// end moving
			if ([mDelegate respondsToSelector:@selector(handleView:didBeginMoving:)]) {
				[mDelegate handleView:self didEndMoving:mPosition];
			}
			return;
		}
	}
	
	// bring handle to front
	[self.superview bringSubviewToFront:self];
	
	// set new cursor
	[[NSCursor closedHandCursor] push];
	
	// current position of the mouse pointer
	NSPoint point = [self.superview convertPoint:[event locationInWindow] fromView:nil];
	
	while ([event type]!=NSLeftMouseUp) {
		event = [[self window] nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];
		
		NSPoint currentPoint = [self.superview convertPoint:[event locationInWindow] fromView:nil];
		
		/*NSPoint newPosition = NSMakePoint(mPosition.x + currentPoint.x - point.x,
										  mPosition.y + currentPoint.y - point.y);*/
		NSPoint newPosition = NSMakePoint(currentPoint.x,
										  currentPoint.y);
		
		if ([mDelegate respondsToSelector:@selector(handleView:willChangePosition:)]) {
			newPosition = [mDelegate handleView:self willChangePosition:newPosition];
		}
//		mPoint.x += currentPoint.x - point.x;
//		mPoint.y += currentPoint.y - point.y;
		mPosition = newPosition;
		
		if ([mDelegate respondsToSelector:@selector(handleView:didChangePosition:)]) {
			[mDelegate handleView:self didChangePosition:newPosition];
		}
		
		// NSLog(@"mPoint=%@", NSStringFromPoint(mPoint));
		
		//self.frame = NSInsetRect(NSMakeRect(mPosition.x, mPosition.y, 0, 0), -HandleSize, -HandleSize);
		self.frame = [self alignRectToBase:NSInsetRect(NSMakeRect(mPosition.x, mPosition.y, 0, 0), -HandleSize - HandlePadding, -HandleSize - HandlePadding)];
		
		point = currentPoint;
	}
	
	// restore cursor
	[[NSCursor closedHandCursor] pop];
	
	// end moving
	if ([mDelegate respondsToSelector:@selector(handleView:didBeginMoving:)]) {
		[mDelegate handleView:self didEndMoving:mPosition];
	}
}

- (void) resetCursorRects {
    [super resetCursorRects];
    [self addCursorRect:self.bounds cursor:[NSCursor openHandCursor]];
}

@end


int bringToFront(id itemA, id itemB, void *target) {
    if (itemA == target) {
        return NSOrderedDescending;
    } else if (itemB == target) {
        return NSOrderedAscending;
    } else {
        return NSOrderedSame;
    }
}

@implementation NSView (HandleViewAdditions)

- (void)bringSubviewToFront:(NSView *)subview {
    [self sortSubviewsUsingFunction:bringToFront context:subview];
}

- (NSRect)alignRectToBase:(NSRect)rect {
	NSRect newRect = [self convertRectToBase:rect];
	newRect.origin.x = floor(newRect.origin.x);
	newRect.origin.y = floor(newRect.origin.y);
	newRect.size.width = floor(newRect.size.width);
	newRect.size.height = floor(newRect.size.height);
	newRect = [self convertRectFromBase:newRect];
	return newRect;
}


@end


