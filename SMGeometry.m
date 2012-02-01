//
//  SMGeometry.m
//  HandleView
//
//  Created by Stephan Michels on 01.02.12.
//  Copyright (c) 2012 Stephan Michels Softwareentwicklung und Beratung. All rights reserved.
//

#import "SMGeometry.h"


CGPoint CGPointSub(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x - point2.x, 
                       point1.y - point2.y);
}

CGFloat CGPointLength(CGPoint point) {
    return hypotf(point.x, point.y);
}

CGPoint CGPointNormalize(CGPoint point) {
    CGFloat length = hypotf(point.x, point.y);
    return CGPointMake(point.x / length, 
                       point.y / length);
}

CGPoint CGPointOrthogonal(CGPoint point) {
    return CGPointMake(point.y, -point.x);
}

CGPoint CGPointScaleAdd(CGPoint point1, CGPoint point2, CGFloat scale) {
    return CGPointMake(point1.x + point2.x * scale, 
                       point1.y + point2.y * scale);
}

CGPoint CGPointScaleAdd2(CGPoint point1, CGPoint point2, CGFloat scale2, CGPoint point3, CGFloat scale3) {
    return CGPointMake(point1.x + point2.x * scale2 + point3.x * scale3, 
                       point1.y + point2.y * scale2 + point3.y * scale3);
}

