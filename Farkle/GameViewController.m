//
//  GameViewController.m
//  Farkle
//
//  Created by Francis Bato on 10/8/15.
//  Copyright © 2015 Francis Bato. All rights reserved.
//

#import "GameViewController.h"
#import "DiceLabel.h"
#import "Player.h"
#import "RootViewController.h"
#import "GameManager.h"

@interface GameViewController ()
@property (weak, nonatomic) IBOutlet DiceLabel *diceLabelOne;
@property (weak, nonatomic) IBOutlet DiceLabel *diceLabelTwo;
@property (weak, nonatomic) IBOutlet DiceLabel *diceLabelThree;
@property (weak, nonatomic) IBOutlet DiceLabel *diceLabelFour;
@property (weak, nonatomic) IBOutlet DiceLabel *diceLabelFive;
@property (weak, nonatomic) IBOutlet DiceLabel *diceLabelSix;
@property Player *currentPlayer;
@property (weak, nonatomic) IBOutlet UILabel *currentPlayerLabel;
@property NSArray *diceLabels;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property NSMutableArray *dice;
@property NSInteger currentScore;
@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.diceLabels = [[NSArray alloc] initWithObjects:self.diceLabelOne, self.diceLabelTwo, self.diceLabelThree, self.diceLabelFour, self.diceLabelFive, self.diceLabelSix, nil];

    self.gameManager = [[GameManager alloc] initGameManager:self.availablePlayers];

    [self initDice];
    //Funk type casting to force types to match, custom class
    //may not be recognized correctly as an ID type, must
    //force.
    self.delegate = (id<DieLabelDelegate>)self.gameManager;

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.diceLabelOne addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.diceLabelTwo addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.diceLabelThree addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.diceLabelFour addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.diceLabelFive addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.diceLabelSix addGestureRecognizer:tapGestureRecognizer];

    self.diceLabelOne.userInteractionEnabled = YES;
    self.diceLabelTwo.userInteractionEnabled = YES;
    self.diceLabelThree.userInteractionEnabled = YES;
    self.diceLabelFour.userInteractionEnabled = YES;
    self.diceLabelFive.userInteractionEnabled = YES;
    self.diceLabelSix.userInteractionEnabled = YES;

    //Do logic to set player order
    //Added for now
    [self.gameManager setPlayerOrder];


    self.currentPlayer = [self.gameManager whichPlayerIsNext];
    [self.gameManager startPlayersTurn:self.currentPlayer withDice:self.diceLabels];
    [self updateGameBoard];
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    UIView *view = sender.view;
    DiceLabel *selectedDice = [self.diceLabels objectAtIndex:view.tag];

    if (![self.gameManager firstRoll]){
        if (sender.state == UIGestureRecognizerStateEnded)
        {
            [self onTappedDice:selectedDice];

            if (selectedDice.isSelected)
                selectedDice.backgroundColor = [UIColor redColor];
            else
                selectedDice.backgroundColor = [UIColor greenColor];

            NSLog(@"log");
        }
    }
}
- (IBAction)onRollButtonPressed:(UIButton *)sender {

    self.gameManager.firstRoll = NO;
    for (DiceLabel *dice in [self.gameManager dice]) {
        if (dice.isSelected) {
            dice.beforeRoll = NO;
            [self rollDice];
        }
    }

    [self.gameManager endPlayersTurn:self.currentPlayer];
    [self updateGameBoard];
}

- (void)updateGameBoard {
    if (!self.currentPlayer.isPlaying) {
        self.currentPlayer = [self.gameManager whichPlayerIsNext];
        self.currentPlayer.isPlaying = YES;
    }
    self.currentPlayerLabel.text = self.currentPlayer.name;
    [self updateDice];
}



- (void)rollDice {
    [self.delegate diceLabelDidFinishRoll];
}

- (void)onTappedDice:(id)dice {

    DiceLabel *curDice = dice;
    curDice.isSelected ^= YES;

    if (!curDice.isSelected) {
        [self.delegate diceLabelDidTap:curDice];
        NSInteger tempScore = [self.gameManager calculateScoreWithHand];
        self.currentScore += tempScore;
    } else {
        NSInteger tempScore = [self.gameManager calculateScoreWithHand];
        //Its removing From array before it can account for score, must fix logic
        if (tempScore>0) {
            self.currentScore -= tempScore;
        } else {
            self.currentScore = 0;
        }
        [self.delegate diceLabelDidTap:curDice];
    }
    [self updateScore];
}

-(void)updateDice {
    for (DiceLabel *diceLabel in self.gameManager.dice) {
        if (diceLabel.isSelected) {
            DiceLabel *updateDice = self.diceLabels[diceLabel.tag];
            updateDice.text  = [NSString stringWithFormat:@"%@",diceLabel.dieValue];
        }
    }
}

-(void)initDice {
    for (DiceLabel *dice in self.diceLabels) {
        dice.isSelected = YES;
        dice.dieValue = @1;
        dice.beforeRoll = YES;
    }
}

- (IBAction)onScoreButtonTapped:(UIButton *)sender {

}

- (void)updateScore{
    self.scoreLabel.text = [NSString stringWithFormat:@"%li",(long)self.currentScore];
}

@end
