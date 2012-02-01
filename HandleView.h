//
//  HandleView.h
//  HandleView
//
//  Created by Stephan Michels on 27.10.10.
//  Copyright (c) 2012 Stephan Michels Softwareentwicklung und Beratung. All rights reserved.
//

#import <Cocoa/Cocoa.h>


typedef enum _HandleType {
	kHandleTypeNormal = 0,
	kHandleTypeSpecial = 1
} HandleType;

@protocol HandleViewDelegate;

@interface HandleView : NSView

@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) HandleType type;
@property (nonatomic, assign) NSColor *color;
@property (nonatomic, assign) id<HandleViewDelegate> delegate;

- (id)initWithPosition:(CGPoint)point;
+ (HandleView*)handleViewWithPosition:(CGPoint)point;

@end


@protocol HandleViewDelegate <NSObject>

@optional
- (void)handleView:(HandleView*)handleView didBeginMoving:(CGPoint)position;
- (BOOL)handleView:(HandleView*)handleView shouldChangePosition:(CGPoint)position;
- (CGPoint)handleView:(HandleView*)handleView willChangePosition:(CGPoint)position;
- (void)handleView:(HandleView*)handleView didChangePosition:(CGPoint)position;
- (void)handleView:(HandleView*)handleView didEndMoving:(CGPoint)position;

@end