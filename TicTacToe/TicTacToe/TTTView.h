//
//  TTTView.h
//  TicTacToe
//
//  Created by Rona Wang on 30/7/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum ResultType {
    NO_WIN = -1,
    PLAYER_1 = 0,
    PLAYER_2 = 1,
    TIE = 2
} ResultType;

@interface TTTView : UIView

// Length: 9
// If element is 0, empty
// If element is 1, player 1
// If element is 2, player 2
@property (nonatomic, strong) NSArray* playerPositions;
@property (nonatomic) CGFloat length;
@property (nonatomic) ResultType result;

@end

NS_ASSUME_NONNULL_END
