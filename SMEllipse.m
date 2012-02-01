//
//  SMEllipse.m
//  HandleView
//
//  Created by Stephan Michels on 25.10.10.
//  Copyright (c) 2012 Stephan Michels Softwareentwicklung und Beratung. All rights reserved.
//

#import "SMEllipse.h"


@implementation SMEllipse

@synthesize center = _center;
@synthesize size = _size;

- (id)initWithCenter:(CGPoint)center size:(CGSize)size {
	self = [super init];
	if (self) {
		self.center = center;
		self.size = size;
	}
	return self;
}

+ (SMEllipse *)ellipseGraphicWithCenter:(CGPoint)center size:(CGSize)size {
	return [[[SMEllipse alloc] initWithCenter:center size:size] autorelease];
}

- (CGRect)bounds {
	return CGRectMake(self.center.x - self.size.width / 2.0f, 
                      self.center.y - self.size.height / 2.0f, 
                      self.size.width, 
                      self.size.height);
}

@end
