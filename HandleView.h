//
//  HandleView.h
//  HandleView
//
//  Created by Stephan Michels on 11.10.10.
//  Copyright 2010 Beilstein Institut. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class HandleView;

@protocol HandleViewDelegate

@optional
- (void)handleView:(HandleView*)handleView willChangePoint:(NSPoint)point;
- (void)handleView:(HandleView*)handleView didChangePoint:(NSPoint)point;

@end


@interface HandleView : NSView {
	NSPoint mPoint;
	id/*<HandleViewDelegate>*/ mDelegate;
}

@property (nonatomic, assign) NSPoint point;
@property (nonatomic, assign) id<HandleViewDelegate> delegate;

- (id)initWitPoint:(NSPoint)point;
+ (HandleView*)handleVewWitPoint:(NSPoint)point;

@end

@interface NSView (HandleViewAdditions)

- (void)bringSubviewToFront:(NSView *)subview;

@end

