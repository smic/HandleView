//
//  NSView+Canvas.m
//  HandleView
//
//  Created by Stephan Michels on 27.10.10.
//  Copyright 2010 Beilstein Institut. All rights reserved.
//

#import "NSView+HandleView.h"


int bringToFront(id itemA, id itemB, void *target);

@implementation NSView (HandleView)

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

int bringToFront(id itemA, id itemB, void *target) {
    if (itemA == target) {
        return NSOrderedDescending;
    } else if (itemB == target) {
        return NSOrderedAscending;
    } else {
        return NSOrderedSame;
    }
}

