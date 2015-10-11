//
//  GameManager.h
//  Farkle
//
//  Created by Francis Bato on 10/9/15.
//  Copyright © 2015 Francis Bato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"
#import "DiceLabel.h"


@interface GameManager : NSObject

@property BOOL isGameInProgress;
@property NSMutableArray *availablePlayers;
@property Player *activePlayer;
@property NSInteger currentScore;
@property BOOL isOrderSet;
@property BOOL firstRoll;
@property NSMutableArray *dice;
@property NSMutableArray *hand;
@property BOOL hasScored;
@property NSMutableArray *discard;



- (Player *)whichPlayerIsNext;
- (void)addScoreToPlayer:(Player *)player scoreToAdd:(NSInteger)score;
- (void)loadAvailablePlayersWithArray:(NSMutableArray *)selectedPlayers;
- (instancetype) initGameManager:(NSMutableArray *)players;
- (void)endPlayersTurn:(Player *)player;
- (void)startPlayersTurn:(Player *)player withDice:(NSArray *)dice;
- (NSInteger)findIndexUsingPlayerName:(Player *)player;
- (void)setPlayerOrder;
- (NSInteger)calculateScoreWithHand;



@end
