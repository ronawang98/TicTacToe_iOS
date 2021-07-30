//
//  TTTView.m
//  TicTacToe
//
//  Created by Rona Wang on 30/7/21.
//

#import "TTTView.h"

@interface TTTView()

- (void)drawScore;
- (void)drawPlayerPieces;
- (void)drawCrossWithCenter:(CGPoint)center;
- (void)drawCircleWithCenter:(CGPoint)center;
- (void)drawWinner;
- (CGPoint)getPointAtPosition:(int)position;

@end

@implementation TTTView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.winner = -1;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self drawScore];
    [self drawPlayerPieces];
    if (self.winner == 0 || self.winner == 1) {
        [self drawWinner];
    }
}

- (void)drawWinner
{
    CGFloat width = 200;
    CGRect textRect = CGRectMake(self.center.x - self.length/2, self.center.y - width/2, self.length, width);
    NSMutableParagraphStyle *textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
    textStyle.alignment = NSTextAlignmentCenter;

    NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica" size: 36], NSForegroundColorAttributeName: UIColor.redColor, NSParagraphStyleAttributeName: textStyle};
    NSString* message = [NSString stringWithFormat:@"Player %d wins!", self.winner+1];
    [message drawInRect:textRect withAttributes: textFontAttributes];
}

- (CGPoint)getPointAtPosition:(int)position
{
    CGPoint center = self.center;
    CGFloat smallBoxLength = self.length/3;
    
    int xMult = position % 3 - 1;
    int yMult = floor(position / 3) - 1;
    
    return CGPointMake(center.x + (smallBoxLength * xMult), center.y + (smallBoxLength * yMult));
}

- (void)drawPlayerPieces
{
    for (int i = 0; i < 9; i++) {
        switch ([self.playerPositions[i] integerValue]) {
            case 0:
                [self drawCircleWithCenter:[self getPointAtPosition:i]];
                break;
            case 1:
                [self drawCrossWithCenter:[self getPointAtPosition:i]];
                break;
        }
    }
}

- (void)drawCrossWithCenter:(CGPoint)center
{
    CGFloat radius = (self.length/3 * 0.75)/2;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(center.x - radius, center.y - radius)];
    [path addLineToPoint:CGPointMake(center.x + radius, center.y + radius)];
    
    [path moveToPoint:CGPointMake(center.x - radius, center.y + radius)];
    [path addLineToPoint:CGPointMake(center.x + radius, center.y - radius)];
    
    path.lineWidth = 5;
    [[UIColor blueColor] setStroke];
    [path stroke];
}

-(void)drawCircleWithCenter:(CGPoint)center
{
    CGFloat radius = (self.length/3 * 0.75)/2;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    [path moveToPoint:CGPointMake(center.x + radius, center.y)];
    [path addArcWithCenter:center
                    radius:radius
                startAngle:0.0
                  endAngle:M_PI * 2.0
                 clockwise:YES];
    
    path.lineWidth = 5;
    [[UIColor greenColor] setStroke];
    [path stroke];
}

- (void)drawScore
{
    UIBezierPath *path = [[UIBezierPath alloc] init];

    CGFloat increment = self.length/3;

    // 2 lines each way
    for (int i = 1; i <= 2; i++) {
        // Vertical line
        CGFloat x = self.center.x - (self.length/2) + (increment*i);
        [path moveToPoint:CGPointMake(x, self.center.y-(self.length/2))];
        [path addLineToPoint:CGPointMake(x, self.center.y+(self.length/2))];

        // Horizontal line
        CGFloat y = self.center.y - (self.length/2) + (increment*i);
        [path moveToPoint:CGPointMake(self.center.x-(self.length/2), y)];
        [path addLineToPoint:CGPointMake(self.center.x+(self.length/2), y)];
    }

    path.lineWidth = 5;

    [[UIColor redColor] setStroke];

    [path stroke];
}

@end
