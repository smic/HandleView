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

@synthesize point = mPoint, delegate = mDelegate;

- (id)initWitPoint:(NSPoint)point {
    self = [super initWithFrame:NSInsetRect(NSMakeRect(point.x, point.y, 0, 0), -HandleSize, -HandleSize)];
    if (self) {
        // Initialization code here.
		mPoint = point;
    }
    return self;
}

+ (HandleView*)handleVewWitPoint:(NSPoint)point {
	return [[[HandleView alloc] initWitPoint:point] autorelease];
}

- (void)drawRect:(NSRect)rect {
    // Drawing code here.
	[[NSColor lightGrayColor] set];
	NSRectFill(self.bounds);
	[[NSColor blackColor] set];
	NSFrameRect(self.bounds);
}

- (void)mouseDown:(NSEvent *)event {
	// bring handle to front
	[self.superview bringSubviewToFront:self];
	
	NSPoint point = [self.superview convertPoint:[event locationInWindow] fromView:nil];
	
	NSRect bounds = self.superview.bounds;
	while ([event type]!=NSLeftMouseUp) {
		event = [[self window] nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];
		NSPoint currentPoint = [self.superview convertPoint:[event locationInWindow] fromView:nil];
		currentPoint.x = fminf(fmaxf(currentPoint.x, bounds.origin.x), bounds.size.width);
		currentPoint.y = fminf(fmaxf(currentPoint.y, bounds.origin.y), bounds.size.height);
		
		// NSLog(@"point=%@", NSStringFromPoint(point));
		// NSLog(@"currentPoint=%@", NSStringFromPoint(currentPoint));
		
		NSPoint newPoint = NSMakePoint(mPoint.x + currentPoint.x - point.x,
									   mPoint.y + currentPoint.y - point.y);
		
		if ([mDelegate respondsToSelector:@selector(handleView:willChangePoint:)]) {
			[mDelegate handleView:self willChangePoint:newPoint];
		}
//		mPoint.x += currentPoint.x - point.x;
//		mPoint.y += currentPoint.y - point.y;
		mPoint = newPoint;
		
		if ([mDelegate respondsToSelector:@selector(handleView:didChangePoint:)]) {
			[mDelegate handleView:self didChangePoint:newPoint];
		}
		
		// NSLog(@"mPoint=%@", NSStringFromPoint(mPoint));
		
		self.frame = NSInsetRect(NSMakeRect(mPoint.x, mPoint.y, 0, 0), -HandleSize, -HandleSize);
		
		point = currentPoint;
	}
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


