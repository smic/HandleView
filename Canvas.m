//
//  Canvas.m
//  HandleView
//

#import "Canvas.h"
#import "HandleView.h"
#import "EllipseGraphic.h"
#import "EllipseGraphicView.h"


CGFloat CGFloatClamp(CGFloat value, CGFloat min, CGFloat max) {
	if (value > max)
		return max;
	else if (value < min)
		return min;
		
	return value;
}

@implementation Canvas

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib {
	handleView1 = [[HandleView handleViewWithPosition:NSMakePoint(100, 50)] retain];
	handleView1.delegate = self;
	[self addSubview:handleView1];
	
	handleView2 = [[HandleView handleViewWithPosition:NSMakePoint(300, 150)] retain];
	handleView2.delegate = self;
	[self addSubview:handleView2];
	
	mGraphics = [[NSMutableArray alloc] init];
	
	EllipseGraphic *graphic = [EllipseGraphic ellipseGraphicWithCenter:CGPointMake(200, 200) size:CGSizeMake(100, 100)];
	[mGraphics addObject:graphic];
	
	EllipseGraphicView *graphicView = [[EllipseGraphicView alloc] initWithGraphic:graphic];
	[self addSubview:graphicView];
	[graphicView release];
}

- (void)handleView:(HandleView*)handleView didBeginMoving:(NSPoint)position {
	// make handles visible again
	[handleView1 setHidden:YES];
	[handleView2 setHidden:YES];
}

- (NSPoint)handleView:(HandleView*)handleView willChangePosition:(NSPoint)position {
	
	
    if (handleView1 == handleView) {
        NSPoint center = NSMakePoint(100, 100);
        CGFloat dx = position.x - center.x;
        CGFloat dy = position.y - center.y;
        CGFloat length = hypotf(dx, dy);
        if (length == 0) {
            return NSMakePoint(150, 100);
        }
        CGFloat radius = 50;
        return NSMakePoint(center.x + dx * radius / length, center.y + dy * radius / length);
    } else if (handleView2 == handleView) {
        CGRect rect = NSRectToCGRect(self.bounds);
        return NSMakePoint(CGFloatClamp(position.x, CGRectGetMinX(rect), CGRectGetMaxX(rect)), 
                           CGFloatClamp(position.y, CGRectGetMinY(rect), CGRectGetMaxY(rect)));
    }
	return position;
}

- (void)handleView:(HandleView*)handleView didChangePosition:(NSPoint)position {
	[self setNeedsDisplay:YES];
}

- (void)handleView:(HandleView*)handleView didEndMoving:(NSPoint)position {
	// show handles on move
	[handleView1 setHidden:NO];
	[handleView2 setHidden:NO];
}

- (void)drawRect:(NSRect)rect {
    // Drawing code here.
	CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
	
	CGContextSaveGState(context);
	
	CGContextSetGrayFillColor(context, 0.7f, 1.0f);
	CGContextFillRect(context, NSRectToCGRect(self.bounds));
	
	CGContextSetGrayStrokeColor(context, 0.0f, 1.0f);
	CGContextStrokeEllipseInRect(context, CGRectMake(50, 50, 100, 100));
	
	CGPoint points[] = {NSPointToCGPoint(handleView1.position), NSPointToCGPoint(handleView2.position)};
	CGContextStrokeLineSegments(context, points, 2);
	
	CGContextRestoreGState(context);
}

- (void)dealloc {
	[handleView1 release];
	[handleView2 release];
	
	[mGraphics release];
	
	[super dealloc];
}

@end
