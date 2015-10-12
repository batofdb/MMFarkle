//
//  GameManager.m
//  Farkle
//
//  Created by Francis Bato on 10/9/15.
//  Copyright © 2015 Francis Bato. All rights reserved.
//

#import "GameManager.h"
#import "Player.h"
#import "DiceLabel.h"
#import "GameViewController.h"


//remember to create an interface section for custom classes
@interface GameManager () <DieLabelDelegate>
@end


@implementation GameManager

- (instancetype)initGameManager:(NSMutableArray *)players {
    self = [super init];
    if (self) {
        self.availablePlayers = [[NSMutableArray alloc] initWithArray:players];
        self.isGameInProgress = NO;
        self.activePlayer = players.firstObject;
        self.currentScore = 0;
        self.isOrderSet = NO;
        self.firstRoll = YES;
        self.dice = [[NSMutableArray alloc] init];
        self.hand = [[NSMutableArray alloc] init];
        self.discard = [[NSMutableArray alloc] init];
}

    return self;
}

- (void)addScoreToPlayer:(Player *)player scoreToAdd:(NSInteger)score {
    Player *currentPlayer = [self.availablePlayers objectAtIndex:[self findIndexUsingPlayerName:player]];
    currentPlayer.score += score;
}

- (Player *)whichPlayerIsNext {
    if (self.isOrderSet) {
        for(int i=0;i<[self.availablePlayers count];i++) {
            if ([self.activePlayer.name isEqualToString:[self.availablePlayers[i] name]]) {
                if (!self.activePlayer.isPlaying) {
                    if ((i+1 == [self.availablePlayers count])) {
                        self.activePlayer = self.availablePlayers.firstObject;
                        break;
                    } else {
                        self.activePlayer = self.availablePlayers[i+1];
                        break;
                    }
                }
            }
        }
    }
    return self.activePlayer;
}

- (void)loadAvailablePlayersWithArray:(NSMutableArray *)selectedPlayers {
    self.availablePlayers = selectedPlayers;
}

- (void)resetDice {
    [self.dice removeAllObjects];
    [self.hand removeAllObjects];
}

- (void)endPlayersTurn:(Player *)player {
    player.isPlaying = NO;
    player.firstRoll = YES;
    //Will need first roll for each player
    self.firstRoll = YES;
    [self resetDice];
}

- (void)startPlayersTurn:(Player *)player withDice:(NSArray *)dice{
    player.isPlaying = YES;
    player.firstRoll = YES;
    [self.dice addObjectsFromArray:dice];

}

- (NSInteger)findIndexUsingPlayerName:(Player *)player {
    return [self.availablePlayers indexOfObject:player];
}

- (void) setPlayerOrder {
    self.isOrderSet ^=YES;
}




#pragma mark - Custom Delegation
- (void)diceLabelDidFinishRoll{

    for(DiceLabel *dice in self.dice)
    {
        //if(!dice.isSelected) {
            int r = 1+ arc4random() % 6;
            dice.dieValue = [NSNumber numberWithInt:r];
            //if (!self.firstRoll)
            //    [self.discard addObject:dice];
        //}
    }

    //[self discardDice];

}


- (void)discardDice {
    for(DiceLabel *dice in self.dice) {
        if (!self.firstRoll && dice.isSelected)
            dice.isDiscard = YES;
    }

    [self.hand removeAllObjects];
}

//No objects are being added to the array
- (void)diceLabelDidTap:(DiceLabel *)dice {
    if (dice.isSelected) {
        [self.hand addObject:dice];
        [self.dice removeObject:dice];
    } else {
        [self.hand removeObject:dice];
        [self.dice addObject:dice];
    }
}

#pragma mark - Scoring Logic
- (NSInteger)calculateScoreWithHand {

    NSMutableArray *temp = [[NSMutableArray alloc] init];
    NSMutableArray *tempHand = [[NSMutableArray alloc] initWithArray:self.hand];

    for (DiceLabel *dice in tempHand) {
        [temp addObject:dice.dieValue];
    }

    if ([temp count] == 6)
        self.allDiceUsed = YES;

    NSCountedSet *set = [[NSCountedSet alloc] initWithArray:temp];
    self.hasScored = NO;
    self.currentScore = 0;

    if ([set countForObject:@1] == 6){
        self.currentScore = 3000;
    }  else if ([set countForObject:@2] == 6){
        self.currentScore = 3000;
    }  else if ([set countForObject:@3] == 6){
        self.currentScore = 3000;
    }  else if ([set countForObject:@4] == 6){
        self.currentScore = 3000;
    } else if ([set countForObject:@5] == 6){
        self.currentScore = 3000;
    }  else if ([set countForObject:@6] == 6){
        self.currentScore = 3000;
    }  else if (([set countForObject:@1] == 1)&&([set countForObject:@2] == 1)&&([set countForObject:@3] == 1)&&([set countForObject:@4] == 1)&&([set countForObject:@5] == 1)&&([set countForObject:@6] == 1)){
        self.currentScore = 1500;
    }   else if ([set countForObject:@1] == 6){
        self.currentScore = 3000;
    }  else if ([set countForObject:@2] == 6){
        self.currentScore = 3000;
    }  else if ([set countForObject:@3] == 6){
        self.currentScore = 3000;
    }  else if ([set countForObject:@4] == 6){
        self.currentScore = 3000;
    } else if ([set countForObject:@5] == 6){
        self.currentScore = 3000;
    }  else if ([set countForObject:@6] == 6){
        self.currentScore = 3000;
    }    else if ([set countForObject:@1] == 5){
        self.currentScore = 2000;
    }  else if ([set countForObject:@2] == 5){
        self.currentScore = 2000;
    }  else if ([set countForObject:@3] == 5){
        self.currentScore = 2000;
    }  else if ([set countForObject:@4] == 5){
        self.currentScore = 2000;
    } else if ([set countForObject:@5] == 5){
        self.currentScore = 2000;
    }  else if ([set countForObject:@6] == 5){
        self.currentScore = 2000;
    }  else if ([set countForObject:@1] == 4){
            self.currentScore = 1000;
        }  else if ([set countForObject:@2] == 4){
            self.currentScore = 1000;
        }  else if ([set countForObject:@3] == 4){
            self.currentScore = 1000;
        }  else if ([set countForObject:@4] == 4){
            self.currentScore = 1000;
        } else if ([set countForObject:@5] == 4){
            self.currentScore = 1000;
        }  else if ([set countForObject:@6] == 4){
            self.currentScore = 1000;
        }  else if ([set countForObject:@1] == 3){
            self.currentScore += 300;
        } else if ([set countForObject:@2] == 3){
            self.currentScore += 200;
        }  else if ([set countForObject:@3] == 3){
            self.currentScore += 300;
        }  else if ([set countForObject:@4] == 3){
            self.currentScore += 400;
        } else if ([set countForObject:@5] == 3){
            self.currentScore += 500;
        } else if ([set countForObject:@6] == 3){
            self.currentScore += 600;
        }  else if ([set countForObject:@1] == 1){
            self.currentScore += 100;
        } else if ([set countForObject:@5] == 1){
            self.currentScore += 50;
        } else {
        self.currentScore = 0;
    }

    return self.currentScore;
}




@end
