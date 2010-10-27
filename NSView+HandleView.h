//
//  NSView+Canvas.h
//  HandleView
//
//  Created by Stephan Michels on 27.10.10.
//  Copyright 2010 Beilstein Institut. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSView (HandleView)

- (void)bringSubviewToFront:(NSView *)subview;
- (NSRect)alignRectToBase:(NSRect)rect;

@end
