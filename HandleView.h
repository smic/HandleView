//
//  HandleView.h
//  HandleView
//
//  Created by Stephan Michels on 11.10.10.
//  Copyright 2010 Beilstein Institut. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class HandleView;

@protocol HandleViewDelegate <NSObject>

@optional
- (void)handleView:(HandleView*)handleView didBeginMoving:(NSPoint)position;
- (BOOL)handleView:(HandleView*)handleView shouldChangePosition:(NSPoint)position;
- (NSPoint)handleView:(HandleView*)handleView willChangePosition:(NSPoint)position;
- (void)handleView:(HandleView*)handleView didChangePosition:(NSPoint)position;
- (void)handleView:(HandleView*)handleView didEndMoving:(NSPoint)position;

@end


@interface HandleView : NSView {
	NSPoint mPosition;
	id<HandleViewDelegate> mDelegate;
}

@property (nonatomic, assign) NSPoint position;
@property (nonatomic, assign) id<HandleViewDelegate> delegate;

- (id)initWithPosition:(NSPoint)point;
+ (HandleView*)handleViewWithPosition:(NSPoint)point;

@end

@interface NSView (HandleViewAdditions)

- (void)bringSubviewToFront:(NSView *)subview;
- (NSRect)alignRectToBase:(NSRect)rect;

@end

