//
//  SMEllipse.h
//  HandleView
//
//  Created by Stephan Michels on 25.10.10.
//  Copyright (c) 2012 Stephan Michels Softwareentwicklung und Beratung. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SMEllipse : NSObject {
	CGPoint mCenter;
	CGSize mSize;
}

@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGSize size;

@property (nonatomic, readonly) CGRect bounds;

- (id)initWithCenter:(CGPoint)center size:(CGSize)size;

+ (SMEllipse*)ellipseGraphicWithCenter:(CGPoint)center size:(CGSize)size;

@end
