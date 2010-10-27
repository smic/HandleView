//
//  NSColor+CGColor.m
//  LogicGates
//
//  Created by Stephan Michels on 05.10.10.
//  Copyright 2010 Beilstein Institut. All rights reserved.
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
