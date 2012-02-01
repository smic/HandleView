//
//  HandleView+NSBezierPath.h
//  HandleView
//
//  Created by Stephan Michels on 01.02.12.
//  Copyright (c) 2012 Stephan Michels Softwareentwicklung und Beratung. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSBezierPath (HandleView)

+ (NSBezierPath *)bezierPathWithArrowWithPoint1:(NSPoint)point1 point2:(NSPoint)point2 headSize:(CGFloat)headSize;
- (void)appendArrowWithPoint1:(NSPoint)point1 point2:(NSPoint)point2 headSize:(CGFloat)headSize;

@end
