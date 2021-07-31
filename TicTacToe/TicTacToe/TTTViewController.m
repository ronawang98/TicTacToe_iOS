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

- (int)detectWin;
- (void)finishGame;

@end

@implementation TTTViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.positions = [[NSMutableArray alloc] initWithArray:@[@-1, @-1, @-1, @-1, @-1, @-1, @-1, @-1, @-1]];
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
                self.positions[linearPos] = @(self.currentPlayer);
                // Update current player: 1 -> abs(0) -> 0, 0 -> abs(-1) -> 1
                self.currentPlayer = ABS(self.currentPlayer - 1);
                int winner = [self detectWin];
                if (winner == 1 || winner == 0) {
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

- (int)detectWin
{
    // TODO: Find a more optimal way to detect win
    
    // Diagonal win
    int a = (int)[self.positions[0] integerValue];
    int b = (int)[self.positions[4] integerValue];
    int c = (int)[self.positions[8] integerValue];
    int d = (int)[self.positions[2] integerValue];
    int e = (int)[self.positions[6] integerValue];
    if (a != -1 && a == b && b == c) {
        NSLog(@"desc diagonal hasWon");
        NSLog(@"%d", a);
        return a;
    }
    if (d != -1 && b == d && d == e) {
        NSLog(@"desc diagonal hasWon");
        NSLog(@"%d", d);
        return d;
    }
    
    for (int i = 0; i < 3; i++) {
        // Horizontal win
        if ([self.positions[i*3] integerValue] != -1) {
            int a = (int)[self.positions[i*3] integerValue];
            int b = (int)[self.positions[i*3+1] integerValue];
            int c = (int)[self.positions[i*3+2] integerValue];
            if (a == b && b == c) {
                NSLog(@"horizontal hasWon");
                NSLog(@"%d", i);
                return a;
            }
        }
        
        // Vertical win
        if ([self.positions[i] integerValue] != -1) {
            int a = (int)[self.positions[i] integerValue];
            int b = (int)[self.positions[i+3] integerValue];
            int c = (int)[self.positions[i+6] integerValue];
            if (a == b && b == c) {
                NSLog(@"vertical hasWon");
                NSLog(@"%d", i);

                return a;
            }
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
    self.positions = [[NSMutableArray alloc] initWithArray:@[@-1, @-1, @-1, @-1, @-1, @-1, @-1, @-1, @-1]];
    self.currentPlayer = 0;
    self.gameOngoing = YES;
    self.numTurns = 0;
    [self.resetButton removeFromSuperview];
    
    // TODO: Reset view
    self.TTTView.playerPositions = self.positions;
    self.TTTView.result = NO_WIN;
    NSLog(@"player positions: %@", self.TTTView.playerPositions);
    [self.view setNeedsDisplay];
}


@end
