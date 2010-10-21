//
//  HandleView.m
//  HandleView
//
//  Created by Stephan Michels on 11.10.10.
//  Copyright 2010 Beilstein Institut. All rights reserved.
//

#import "HandleView.h"

#define HandleSize 4

@implementation HandleView

@synthesize position = mPosition, delegate = mDelegate;

- (id)initWithPosition:(NSPoint)position {
    self = [super initWithFrame:NSInsetRect(NSMakeRect(position.x, position.y, 0, 0), -HandleSize, -HandleSize)];
    if (self) {
        // Initialization code here.
		mPosition = position;
    }
    return self;
}

+ (HandleView*)handleViewWithPosition:(NSPoint)position {
	return [[[HandleView alloc] initWithPosition:position] autorelease];
}

- (void)drawRect:(NSRect)rect {
    // Drawing code here.
	[[NSColor whiteColor] set];
	NSRectFill(self.bounds);
	[[NSColor blackColor] set];
	NSFrameRect(self.bounds);
}

- (void)mouseDown:(NSEvent *)event {
	
	// test the if the position should be changed
	if ([mDelegate respondsToSelector:@selector(handleView:shouldChangePosition:)]) {
		if (![mDelegate handleView:self shouldChangePosition:mPosition]) {
			return;
		}
	}
	
	// bring handle to front
	[self.superview bringSubviewToFront:self];
	
	// set new cursor
	[[NSCursor closedHandCursor] push];
	
	// current position of the mouse pointer
	NSPoint point = [self.superview convertPoint:[event locationInWindow] fromView:nil];
	
	NSRect bounds = self.superview.bounds;
	BOOL firstMove = YES;
	while ([event type]!=NSLeftMouseUp) {
		event = [[self window] nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];
		
		// hide handle on move
		if (firstMove) {
			for (NSView *subview in self.superview.subviews) {
				if ([subview isKindOfClass:[HandleView class]]) {
					[subview setHidden:YES];
				}
			}
			firstMove = NO;
		}
		
		NSPoint currentPoint = [self.superview convertPoint:[event locationInWindow] fromView:nil];
		currentPoint.x = fminf(fmaxf(currentPoint.x, bounds.origin.x), bounds.size.width);
		currentPoint.y = fminf(fmaxf(currentPoint.y, bounds.origin.y), bounds.size.height);
		
		// NSLog(@"point=%@", NSStringFromPoint(point));
		// NSLog(@"currentPoint=%@", NSStringFromPoint(currentPoint));
		
		NSPoint newPosition = NSMakePoint(mPosition.x + currentPoint.x - point.x,
										  mPosition.y + currentPoint.y - point.y);
		
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
		
		self.frame = NSInsetRect(NSMakeRect(mPosition.x, mPosition.y, 0, 0), -HandleSize, -HandleSize);
		
		point = currentPoint;
	}
	
	// restore cursor
	[[NSCursor closedHandCursor] pop];
	
	// make handle visible again
	for (NSView *subview in self.superview.subviews) {
		if ([subview isKindOfClass:[HandleView class]]) {
			[subview setHidden:NO];
		}
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


@end


