//
//  NSView+SMCanvas.m
//  HandleView
//
//  Created by Stephan Michels on 27.10.10.
//  Copyright (c) 2012 Stephan Michels Softwareentwicklung und Beratung. All rights reserved.
//

#import "NSView+HandleView.h"


NSComparisonResult SMBringToFront(id itemA, id itemB, void *target);

@implementation NSView (SMHandleView)

- (void)bringSubviewToFront:(NSView *)subview {
    [self sortSubviewsUsingFunction:SMBringToFront context:subview];
}

- (NSRect)alignRectToBase:(NSRect)rect {
	NSRect newRect = [self convertRectToBase:rect];
	newRect.origin.x = floorf(newRect.origin.x);
	newRect.origin.y = floorf(newRect.origin.y);
	newRect.size.width = floorf(newRect.size.width);
	newRect.size.height = floorf(newRect.size.height);
	newRect = [self convertRectFromBase:newRect];
	return newRect;
}

@end

NSComparisonResult SMBringToFront(id itemA, id itemB, void *target) {
    if (itemA == target) {
        return NSOrderedDescending;
    } else if (itemB == target) {
        return NSOrderedAscending;
    } else {
        return NSOrderedSame;
    }
}

