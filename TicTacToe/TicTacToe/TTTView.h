//
//  TTTView.h
//  TicTacToe
//
//  Created by Rona Wang on 30/7/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTTView : UIView

// Length: 9
// If element is 0, empty
// If element is 1, player 1
// If element is 2, player 2
@property (nonatomic, strong) NSArray* playerPositions;
@property (nonatomic) CGFloat length;
@property (nonatomic) int winner;

@end

NS_ASSUME_NONNULL_END
