//
//  Canvas.h
//  HandleView
//

#import <Cocoa/Cocoa.h>
#import "HandleView.h"

@interface Canvas : NSView <HandleViewDelegate> {
	HandleView *handleView1;
	HandleView *handleView2;
}

@end
