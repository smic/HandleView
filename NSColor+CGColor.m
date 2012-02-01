//
//  NSColor+CGColor.m
//  HandleView
//
//  Created by Stephan Michels on 05.10.10.
//  Copyright (c) 2012 Stephan Michels Softwareentwicklung und Beratung. All rights reserved.
//

#import "NSColor+CGColor.h"


@implementation NSColor (CGColor)

- (CGColorRef)createCGColor {
	
    CGColorSpaceRef colorSpace = [[self colorSpace] CGColorSpace];
	
    NSInteger componentCount = [self numberOfComponents];
    CGFloat *components = (CGFloat *)calloc(componentCount, sizeof(CGFloat));
    [self getComponents:components];
	
    CGColorRef color = CGColorCreate(colorSpace, components);
	
    free((void*)components);
	
    return color;	
}

@end
