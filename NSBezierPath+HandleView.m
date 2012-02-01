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

+ (NSBezierPath *)bezierPathWithArrowWithPoint1:(NSPoint)point1 point2:(NSPoint)point2 headSize:(CGFloat)headSize {
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path appendArrowWithPoint1:point1 point2:point2 headSize:headSize];
    return path;
}

- (void)appendArrowWithPoint1:(NSPoint)point1 point2:(NSPoint)point2 headSize:(CGFloat)headSize {
    
    CGPoint d = CGPointSub(point2, point1);
    CGFloat length = CGPointLength(d);
    if (length <= 0) {
        NSLog(@"Invalid length for arrow: %f", length);
        return;
    }
    
    CGPoint n = CGPointNormalize(d);
    CGPoint o = CGPointOrthogonal(n);
    
    CGFloat headSize2 = headSize / 2.0f;
    
    // tail
    [self moveToPoint:CGPointScaleAdd(point1, o, headSize2)];
    [self lineToPoint:CGPointScaleAdd(point1, o, -headSize2)];
    
    // head
    [self lineToPoint:CGPointScaleAdd2(point2, o, -headSize2, n, -headSize)];
    [self lineToPoint:CGPointScaleAdd2(point2, o, -headSize, n, -headSize)];
    [self lineToPoint:point2];
    [self lineToPoint:CGPointScaleAdd2(point2, o, headSize, n, -headSize)];
    [self lineToPoint:CGPointScaleAdd2(point2, o, headSize2, n, -headSize)];
    [self closePath];
}

@end
