//
//  EllipseGraphic.h
//  HandleView
//
//  Created by Stephan Michels on 25.10.10.
//  Copyright 2010 Beilstein Institut. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Ellipse : NSObject {
	CGPoint mCenter;
	CGSize mSize;
}

@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGSize size;

@property (nonatomic, readonly) CGRect bounds;

- (id)initWithCenter:(CGPoint)center size:(CGSize)size;

+ (Ellipse*)ellipseGraphicWithCenter:(CGPoint)center size:(CGSize)size;

@end
