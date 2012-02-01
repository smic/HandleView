//
//  HandleView.h
//  HandleView
//
//  Created by Stephan Michels on 27.10.10.
//  Copyright (c) 2012 Stephan Michels Softwareentwicklung und Beratung. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@protocol SMHandleViewDelegate;

@interface SMHandleView : NSView

@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign, getter = isSpecial) BOOL special;
@property (nonatomic, retain) NSColor *color;
@property (nonatomic, assign) id<SMHandleViewDelegate> delegate;

+ (SMHandleView *)handleView;

@end


@protocol SMHandleViewDelegate <NSObject>

@optional
- (void)handleView:(SMHandleView *)handleView didBeginMoving:(CGPoint)position;
- (BOOL)handleView:(SMHandleView *)handleView shouldChangePosition:(CGPoint)position;
- (CGPoint)handleView:(SMHandleView *)handleView willChangePosition:(CGPoint)position;
- (void)handleView:(SMHandleView *)handleView didChangePosition:(CGPoint)position;
- (void)handleView:(SMHandleView *)handleView didEndMoving:(CGPoint)position;

@end