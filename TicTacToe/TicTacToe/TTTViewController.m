//
//  TTTViewController.m
//  TicTacToe
//
//  Created by Rona Wang on 30/7/21.
//

#import "TTTViewController.h"
#import "TTTView.h"

@interface TTTViewController ()

@property (nonatomic, strong) NSMutableArray* positions;
@property (nonatomic) int currentPlayer;
@property (nonatomic) CGFloat length;
@property (nonatomic, strong) TTTView* TTTView;
@property (nonatomic) bool gameOngoing;
@property (nonatomic, strong) UIButton* resetButton;
@property (nonatomic) int numTurns;

- (int)detectWinWithLastPosition:(int)linearPos;
- (void)finishGame;

@end

@implementation TTTViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.positions = [NSMutableArray array];
        for (int i = 0; i < 9; i++) {
            [self.positions addObject:@-1];
        }
        self.currentPlayer = 0;
        self.gameOngoing = YES;
        self.numTurns = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadView {
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self.length = MIN(bounds.size.width, bounds.size.height) * 0.5;
    TTTView *view = [[TTTView alloc] initWithFrame:bounds];
    [view setPlayerPositions:self.positions];
    view.length = self.length;
    self.view = view;
    self.TTTView = view;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.gameOngoing) {
        return;
    }
    CGPoint point = [[[touches allObjects] firstObject] locationInView:self.view];
    CGFloat halfLength = self.length/2;
    CGFloat smallBoxLength = self.length/3;
    CGPoint center = self.view.center;
    
    CGPoint start = CGPointMake(center.x - halfLength, center.y - halfLength);
    for (int i = 0; i < 3; i++) {
        CGFloat x = start.x + smallBoxLength * i;
        if (point.x < x) {
            return;
        }
        for (int j = 0; j < 3; j++) {
            CGFloat y = start.y + smallBoxLength * j;
            CGRect currRect = CGRectMake(x, y, smallBoxLength, smallBoxLength);

            if (CGRectContainsPoint(currRect, point)) {
                // Convert 2D coordinates to linear position
                int linearPos = i + (j * 3);
                // If a piece is already in square
                if ([self.positions[linearPos] integerValue] != -1) {
                    return;
                }
                self.numTurns++;
                if (self.numTurns == 9) {
                    self.TTTView.result = TIE;
                    [self finishGame];
                }
                self.positions[linearPos] = [NSNumber numberWithInt:self.currentPlayer];
                // Update current player: 1 -> abs(0) -> 0, 0 -> abs(-1) -> 1
                self.currentPlayer = ABS(self.currentPlayer - 1);
                ResultType winner = [self detectWinWithLastPosition:linearPos];
                if (winner == PLAYER_1 || winner == PLAYER_2) {
                    self.TTTView.result = winner;
                    [self finishGame];
                }
                NSLog(@"WINNER: %d", winner);
                [self.view setNeedsDisplay];
                return;
            }
        }
    }
}

- (int)detectWinWithLastPosition:(int)linearPos
{
    // TODO: Find a more optimal way to detect win: "building" towards wins?
    
    
    // TODO: Fix this bug - review difference between NSInteger, NSNumber, int?
    if (![self.positions[linearPos] isEqual:@0] && ![self.positions[linearPos] isEqual:@1]) {
        return -1;
    }
    // Horizontal check
    int h = floor(linearPos/3);
    if (self.positions[h] == self.positions[h+1] && self.positions[h] == self.positions[h+2]) {
        NSLog(@"horizontal win for player %@", self.positions[h]);
        return (int)[self.positions[h] integerValue];
    }
    
    // Vertical check
    int v = linearPos % 3;
    if (self.positions[v] == self.positions[v+3] && self.positions[v] == self.positions[v+6]) {
        NSLog(@"horizontal win for player %@", self.positions[v]);
        return (int)[self.positions[v] integerValue];
    }
    
    // Descending diagonal (0, 4, 8)
    if (linearPos % 4 == 0 && self.positions[0] == self.positions[4] && self.positions[0] == self.positions[8]) {
        NSLog(@"descending diagonal win for player %@", self.positions[0]);
        return (int)[self.positions[0] integerValue];
    }
    
    // Ascending diagonal (2, 4, 6)
    if (linearPos % 2 == 0 && linearPos % 8 != 0) {
        if (self.positions[2] == self.positions[4] && self.positions[4] == self.positions[6]) {
            NSLog(@"ascending diagonal win for player %@", self.positions[0]);
            return (int)[self.positions[2] integerValue];
        }
    }
    
    return -1;
}

- (void)finishGame
{
    self.gameOngoing = NO;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(resetGame) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Play again" forState:UIControlStateNormal];
    button.frame = CGRectMake(100, self.view.center.y, 200, 200);
    self.resetButton = button;
    [self.view addSubview:button];
}

- (void)resetGame
{
    [self.positions removeAllObjects];
    for (int i = 0; i < 9; i++) {
        [self.positions addObject:@-1];
    }
    self.currentPlayer = 0;
    self.gameOngoing = YES;
    self.numTurns = 0;
    [self.resetButton removeFromSuperview];
    
    self.TTTView.playerPositions = self.positions;
    self.TTTView.result = NO_WIN;
    NSLog(@"player positions: %@", self.TTTView.playerPositions);
    [self.view setNeedsDisplay];
}


@end
