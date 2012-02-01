//
//  SMEllipse.m
//  HandleView
//
//  Created by Stephan Michels on 25.10.10.
//  Copyright (c) 2012 Stephan Michels Softwareentwicklung und Beratung. All rights reserved.
//

#import "SMEllipse.h"


@implementation SMEllipse

@synthesize center = mCenter, size = mSize;

- (id)initWithCenter:(CGPoint)center size:(CGSize)size {
	self = [super init];
	if (self) {
		self.center = center;
		self.size = size;
	}
	return self;
}

+ (SMEllipse*)ellipseGraphicWithCenter:(CGPoint)center size:(CGSize)size {
	return [[[SMEllipse alloc] initWithCenter:center size:size] autorelease];
}

- (CGRect)bounds {
	return CGRectMake(mCenter.x - mSize.width / 2.0f, mCenter.y - mSize.height / 2.0f, mSize.width, mSize.height);
}

@end
