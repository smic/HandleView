//
//  EllipseGraphicView.h
//  HandleView
//
//  Created by Stephan Michels on 25.10.10.
//  Copyright (c) 2012 Stephan Michels Softwareentwicklung und Beratung. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Ellipse.h"
#import "HandleView.h"


@interface EllipseView : NSView <HandleViewDelegate>

@property (nonatomic, retain) Ellipse *graphic;

- (id)initWithGraphic:(Ellipse*)graphic;

@end
