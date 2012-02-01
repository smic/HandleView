//
//  SMEllipseGraphicView.h
//  HandleView
//
//  Created by Stephan Michels on 25.10.10.
//  Copyright (c) 2012 Stephan Michels Softwareentwicklung und Beratung. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SMEllipse.h"
#import "SMHandleView.h"


@interface SMEllipseView : NSView <SMHandleViewDelegate>

@property (nonatomic, retain) SMEllipse *graphic;

- (id)initWithGraphic:(SMEllipse*)graphic;

@end
