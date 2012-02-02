//
//  HandleView+NSBezierPath.m
//  HandleView
//
//  Created by Stephan Michels on 01.02.12.
//  Copyright (c) 2012 Stephan Michels Softwareentwicklung und Beratung. All rights reserved.
//

#import "NSBezierPath+HandleView.h"
#import "SMGeometry.h"


@implementation NSBezierPath (HandleView)

+ (NSBezierPath *)bezierPathWithArrowWithPoint1:(NSPoint)point1 
                                         point2:(NSPoint)point2 
                                       headWidth:(CGFloat)headWidth
                                      shaftWidth:(CGFloat)shaftWidth {
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path appendArrowWithPoint1:point1 
                         point2:point2 
                       headWidth:headWidth
                      shaftWidth:shaftWidth];
    return path;
}

- (void)appendArrowWithPoint1:(NSPoint)point1 
                       point2:(NSPoint)point2 
                     headWidth:(CGFloat)headWidth
                    shaftWidth:(CGFloat)shaftWidth {
    
    CGPoint d = CGPointSub(point2, point1);
    CGFloat length = CGPointLength(d);
    if (length <= 0) {
        NSLog(@"Invalid length for arrow: %f", length);
        return;
    }
    
    // restrict values to valid values
    headWidth = MIN(length - 10.0f, MAX(20.0f, headWidth));
    shaftWidth = MIN(headWidth - 10.0f, MAX(10.0f, shaftWidth));

    
    CGPoint n = CGPointNormalize(d);
    CGPoint o = CGPointOrthogonal(n);    
    
    // tail
    [self moveToPoint:CGPointScaleAdd(point2, o, shaftWidth)];
    [self lineToPoint:CGPointScaleAdd(point2, o, -shaftWidth)];
    
    // head
    [self lineToPoint:CGPointScaleAdd2(point1, o, -shaftWidth, n, headWidth)];
    [self lineToPoint:CGPointScaleAdd2(point1, o, -headWidth, n, headWidth)];
    [self lineToPoint:point1];
    [self lineToPoint:CGPointScaleAdd2(point1, o, headWidth, n, headWidth)];
    [self lineToPoint:CGPointScaleAdd2(point1, o, shaftWidth, n, headWidth)];
    [self closePath];
}

@end
