//
//  HandleView.m
//  HandleView
//

#import "HandleView.h"
#import "NSColor+CGColor.h"

#define HandleSize 4.0f
#define HandlePadding 1.0f 

@implementation HandleView

@synthesize position = mPosition, type = mType, color = mColor, delegate = mDelegate;

- (id)initWithPosition:(NSPoint)position {	
    self = [super initWithFrame:NSMakeRect(0, 0, -HandleSize, -HandleSize)];
    if (self) {
        // Initialization code here.
		self.position = position;
		self.type = kHandleTypeNormal;
		self.color = [NSColor whiteColor];
		
		self.frame = [self alignRectToBase:NSInsetRect(NSMakeRect(position.x, position.y, 0, 0), -HandleSize - HandlePadding, -HandleSize - HandlePadding)];
		
		[self addObserver:self forKeyPath:@"position" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
		[self addObserver:self forKeyPath:@"type" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
		[self addObserver:self forKeyPath:@"color" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
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
	
	CGColorRef fillColor = [self.color createCGColor];
	CGContextSetFillColorWithColor(context, fillColor);
	CGColorRelease(fillColor);
	
	//CGContextSetGrayFillColor(context, 1.0f, 1.0f);
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
	NSPoint currentPoint = [self.superview convertPoint:[event locationInWindow] fromView:nil];
	NSPoint relativePoint = NSMakePoint(mPosition.x - currentPoint.x, mPosition.y - currentPoint.y);
	
	// waiting for dragging events
	while ([event type]!=NSLeftMouseUp) {
		event = [[self window] nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];
		
		// current position of the mouse pointer
		currentPoint = [self.superview convertPoint:[event locationInWindow] fromView:nil];
		
		NSPoint newPosition = NSMakePoint(currentPoint.x + relativePoint.x,
										  currentPoint.y + relativePoint.y);
		
		// will change position
		if ([mDelegate respondsToSelector:@selector(handleView:willChangePosition:)]) {
			newPosition = [mDelegate handleView:self willChangePosition:newPosition];
		}
		
		// set new position
		mPosition = newPosition;
		
		// did change position
		if ([mDelegate respondsToSelector:@selector(handleView:didChangePosition:)]) {
			[mDelegate handleView:self didChangePosition:newPosition];
		}
		
		// set frame for new position
		self.frame = [self alignRectToBase:NSInsetRect(NSMakeRect(mPosition.x, mPosition.y, 0, 0), -HandleSize - HandlePadding, -HandleSize - HandlePadding)];
	}
	
	// restore cursor
	[[NSCursor closedHandCursor] pop];
	
	// end moving
	if ([mDelegate respondsToSelector:@selector(handleView:didBeginMoving:)]) {
		[mDelegate handleView:self didEndMoving:mPosition];
	}
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
	if([keyPath isEqualToString:@"position"]) {
		// set frame for new position
		self.frame = [self alignRectToBase:NSInsetRect(NSMakeRect(mPosition.x, mPosition.y, 0, 0), -HandleSize - HandlePadding, -HandleSize - HandlePadding)];
	} else if([keyPath isEqualToString:@"type"]) {
		[self setNeedsDisplay:YES];
	} else if([keyPath isEqualToString:@"color"]) {
		[self setNeedsDisplay:YES];
	}
}


// "OpenHand" as standard mouse cursor
- (void) resetCursorRects {
    [super resetCursorRects];
    [self addCursorRect:self.bounds cursor:[NSCursor openHandCursor]];
}

- (void)dealloc {
	[self removeObserver:self forKeyPath:@"position"];
	[self removeObserver:self forKeyPath:@"type"];
	[self removeObserver:self forKeyPath:@"color"];
	
	self.color = nil;
	
	[super dealloc];
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


