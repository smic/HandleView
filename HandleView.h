//
//  HandleView.h
//  HandleView
//

#import <Cocoa/Cocoa.h>

@class HandleView;

@protocol HandleViewDelegate <NSObject>

@optional
- (void)handleView:(HandleView*)handleView didBeginMoving:(CGPoint)position;
- (BOOL)handleView:(HandleView*)handleView shouldChangePosition:(CGPoint)position;
- (CGPoint)handleView:(HandleView*)handleView willChangePosition:(CGPoint)position;
- (void)handleView:(HandleView*)handleView didChangePosition:(CGPoint)position;
- (void)handleView:(HandleView*)handleView didEndMoving:(CGPoint)position;

@end

typedef enum _HandleType {
	kHandleTypeNormal = 0,
	kHandleTypeSpecial = 1
} HandleType;

@interface HandleView : NSView {
	CGPoint mPosition;
	HandleType mType;
	NSColor *mColor;
	id<HandleViewDelegate> mDelegate;
}

@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) HandleType type;
@property (nonatomic, assign) NSColor *color;
@property (nonatomic, assign) id<HandleViewDelegate> delegate;

- (id)initWithPosition:(CGPoint)point;
+ (HandleView*)handleViewWithPosition:(CGPoint)point;

@end
