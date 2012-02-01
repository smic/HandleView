//
//  SMCanvas.h
//  HandleView
//
//  Created by Stephan Michels on 27.10.10.
//  Copyright (c) 2012 Stephan Michels Softwareentwicklung und Beratung. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SMHandleView.h"


@interface SMCanvas : NSView <SMHandleViewDelegate>

@property (nonatomic, assign) CGPoint point1;
@property (nonatomic, assign) CGPoint point2;

@end
