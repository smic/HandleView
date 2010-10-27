//
//  EllipseGraphic.m
//  HandleView
//
//  Created by Stephan Michels on 25.10.10.
//  Copyright 2010 Beilstein Institut. All rights reserved.
//

#import "Ellipse.h"


@implementation Ellipse

@synthesize center = mCenter, size = mSize;

- (id)initWithCenter:(CGPoint)center size:(CGSize)size {
	self = [super init];
	if (self) {
		self.center = center;
		self.size = size;
	}
	return self;
}

+ (Ellipse*)ellipseGraphicWithCenter:(CGPoint)center size:(CGSize)size {
	return [[[Ellipse alloc] initWithCenter:center size:size] autorelease];
}

- (CGRect)bounds {
	return CGRectMake(mCenter.x - mSize.width / 2.0f, mCenter.y - mSize.height / 2.0f, mSize.width, mSize.height);
}

@end
