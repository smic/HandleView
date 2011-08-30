//
//  Canvas.m
//  HandleView
//

#import "Canvas.h"
#import "HandleView.h"
#import "Ellipse.h"
#import "EllipseView.h"


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
	
	Ellipse *graphic = [Ellipse ellipseGraphicWithCenter:CGPointMake(200, 200) size:CGSizeMake(100, 100)];
	[mGraphics addObject:graphic];
	
	EllipseView *graphicView = [[EllipseView alloc] initWithGraphic:graphic];
	[self addSubview:graphicView];
	[graphicView release];
}

- (void)handleView:(HandleView*)handleView didBeginMoving:(CGPoint)position {
	// make handles visible again
	[handleView1 setHidden:YES];
	[handleView2 setHidden:YES];
}

- (CGPoint)handleView:(HandleView*)handleView willChangePosition:(CGPoint)position {
	
	
    if (handleView1 == handleView) {
        CGPoint center = NSMakePoint(100, 100);
        CGFloat dx = position.x - center.x;
        CGFloat dy = position.y - center.y;
        CGFloat length = hypotf(dx, dy);
        if (length == 0) {
            return NSMakePoint(150, 100);
        }
        CGFloat radius = 50;
        return NSMakePoint(center.x + dx * radius / length, center.y + dy * radius / length);
    } else if (handleView2 == handleView) {
        CGRect rect = self.bounds;
        return NSMakePoint(CGFloatClamp(position.x, CGRectGetMinX(rect), CGRectGetMaxX(rect)), 
                           CGFloatClamp(position.y, CGRectGetMinY(rect), CGRectGetMaxY(rect)));
    }
	return position;
}

- (void)handleView:(HandleView*)handleView didChangePosition:(CGPoint)position {
	[self setNeedsDisplay:YES];
}

- (void)handleView:(HandleView*)handleView didEndMoving:(CGPoint)position {
	// show handles on move
	[handleView1 setHidden:NO];
	[handleView2 setHidden:NO];
}

- (void)drawRect:(NSRect)rect {
    // Drawing code here.
	CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
	
	CGContextSaveGState(context);
	
	CGContextSetGrayFillColor(context, 0.7f, 1.0f);
	CGContextFillRect(context, self.bounds);
	
	CGContextSetGrayStrokeColor(context, 0.0f, 1.0f);
	CGContextStrokeEllipseInRect(context, CGRectMake(50, 50, 100, 100));
	
	CGPoint points[] = {handleView1.position, handleView2.position};
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
