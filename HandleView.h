//
//  HandleView.h
//  HandleView
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

typedef enum _HandleType {
	kHandleTypeNormal = 0,
	kHandleTypeSpecial = 1
} HandleType;

@interface HandleView : NSView {
	NSPoint mPosition;
	HandleType mType;
	NSColor *mColor;
	id<HandleViewDelegate> mDelegate;
}

@property (nonatomic, assign) NSPoint position;
@property (nonatomic, assign) HandleType type;
@property (nonatomic, assign) NSColor *color;
@property (nonatomic, assign) id<HandleViewDelegate> delegate;

- (id)initWithPosition:(NSPoint)point;
+ (HandleView*)handleViewWithPosition:(NSPoint)point;

@end
