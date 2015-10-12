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
@property (weak, nonatomic) IBOutlet UIButton *bankButtonLabel;
@property NSInteger currentScore;
@property NSArray *colorArray;
@property (weak, nonatomic) IBOutlet UIButton *rollButtonLabel;
@property UIDynamicAnimator *dynamicAnimator;
@property BOOL areDiceFanned;
@property NSInteger roundScore;
@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    self.diceLabels = [[NSArray alloc] initWithObjects:self.diceLabelOne, self.diceLabelTwo, self.diceLabelThree, self.diceLabelFour, self.diceLabelFive, self.diceLabelSix, nil];

    self.gameManager = [[GameManager alloc] initGameManager:self.availablePlayers];
    
    self.colorArray = [[NSArray alloc] initWithObjects:UIColorFromRGB(0x9E9E9E),UIColorFromRGB(0x795548),UIColorFromRGB(0xFF9800),UIColorFromRGB(0xCDDC39),UIColorFromRGB(0x009688),UIColorFromRGB(0x03A9F4),UIColorFromRGB(0x3F51B5),UIColorFromRGB(0xF44336),UIColorFromRGB(0x2196F3),UIColorFromRGB(0xFF9800), nil];

    int r = arc4random() % 10;
    self.view.backgroundColor = self.colorArray[r];

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

    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    UIView *view = sender.view;
    DiceLabel *selectedDice = [self.diceLabels objectAtIndex:view.tag];

    if (![self.gameManager firstRoll] && !selectedDice.isDiscard){
        if (sender.state == UIGestureRecognizerStateEnded)
        {
            [self onTappedDice:selectedDice];

            if (selectedDice.isSelected) {
                selectedDice.backgroundColor = UIColorFromRGB(0xE0E0E0);
            } else
                selectedDice.backgroundColor = [UIColor whiteColor];

            if ([self.gameManager.hand count]>0)
                self.bankButtonLabel.enabled = YES;
            else
                self.bankButtonLabel.enabled = NO;

            NSLog(@"log");
        }
    }
}
- (IBAction)onRollButtonPressed:(UIButton *)sender {
    //[self fanButton:sender];
    [self rollDice];
    self.currentPlayer.hasRolled = YES;
    [self updateGameBoard];
}

- (void)updateGameBoard {
    self.currentPlayer = [self.gameManager whichPlayerIsNext];
    self.currentPlayer.isPlaying = YES;

    self.currentPlayerLabel.text = self.currentPlayer.name;

    if (self.gameManager.firstRoll)
        self.bankButtonLabel.enabled = NO;

    [self updateDice];
    [self updateScore];
}



- (void)rollDice {
    [self.delegate diceLabelDidFinishRoll];
    self.gameManager.firstRoll = NO;
    self.gameManager.activePlayer.firstRoll = NO;
    self.currentPlayer.hasRolled = YES;
    [self updateGameBoard];
}

- (void)onTappedDice:(id)dice {

    DiceLabel *curDice = dice;
    curDice.isSelected ^= YES;

    [self.delegate diceLabelDidTap:curDice];
    //[self updateGameBoard];
    [self updateScore];
}

-(void)updateDice {
    int count = 0;
    for (DiceLabel *diceLabel in self.gameManager.dice) {
        if (diceLabel.isSelected || !self.gameManager.firstRoll) {
            DiceLabel *updateDice = self.diceLabels[diceLabel.tag];
            updateDice.text  = [NSString stringWithFormat:@"%@",diceLabel.dieValue];

        }
        count++;
    }

    count = 0;
    for (DiceLabel *diceInHand in self.gameManager.hand){
        DiceLabel *updateDice = self.diceLabels[diceInHand.dieID];
        updateDice.isDiscard = YES;

        count++;
    }
}

-(void)initDice {
    int count = 0;
    for (DiceLabel *dice in self.diceLabels) {
        dice.isSelected = NO;
        dice.dieValue = @1;
        dice.isDiscard = NO;
        dice.dieID = count;
        count++;
        dice.backgroundColor = [UIColor whiteColor];
    }

    [self.gameManager resetDice];
}



- (IBAction)onBankButtonTapped:(UIButton *)sender {
    [self updateDice];
    NSInteger tempScore = [self.gameManager calculateScoreWithHand];

    if (tempScore == 0) {
        [self farkleAlert];
    }

    self.gameManager.activePlayer.score += tempScore;
    self.gameManager.activePlayer.roundScore +=tempScore;
    if (self.gameManager.allDiceUsed){
        [self initDice];
        [self.gameManager startPlayersTurn:self.currentPlayer withDice:self.diceLabels];
        self.gameManager.firstRoll = YES;
    }
    
    [self updateScore];
    [self.gameManager discardDice];
    self.gameManager.firstRoll = YES;
    self.bankButtonLabel.enabled = NO;
}

- (void)farkleAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"You've farkled!" message:[NSString stringWithFormat:@"%@ has farkled.",self.self.currentPlayer.name] preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self endPlayerAction];
    }];

    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)onDoneButtonTapped:(UIButton *)sender {
    self.roundScore = self.gameManager.activePlayer.roundScore;
    [self scoreAlertWithCurrentScore:self.gameManager.currentScore];
    self.roundScore = 0;
    self.gameManager.activePlayer.roundScore = 0;
}

- (void)endPlayerAction {
    [self.gameManager endPlayersTurn:self.currentPlayer];
    self.currentPlayer = [self.gameManager whichPlayerIsNext];
    [self initDice];
    [self.gameManager startPlayersTurn:self.currentPlayer withDice:self.diceLabels];

    int r = arc4random() % 10;
    self.view.backgroundColor = self.colorArray[r];

    [self updateGameBoard];
}

- (void)updateScore{
    self.currentPlayer.score = self.gameManager.activePlayer.score;
    self.scoreLabel.text = [NSString stringWithFormat:@"%li",(long)self.currentPlayer.score];
}

- (void)scoreAlertWithCurrentScore:(NSInteger)currentScore {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"This Round" message:[NSString stringWithFormat:@"You score %li this round. Total Score: %li",self.roundScore, self.currentPlayer.score] preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self endPlayerAction];
    }];

    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - animation

- (void) fanIn {
    UISnapBehavior *snapBehavior;
    snapBehavior = [[UISnapBehavior alloc] initWithItem:self.diceLabelOne snapToPoint:self.rollButtonLabel.center];
    [self.dynamicAnimator addBehavior:snapBehavior];

    snapBehavior = [[UISnapBehavior alloc] initWithItem:self.diceLabelTwo snapToPoint:self.rollButtonLabel.center];
    [self.dynamicAnimator addBehavior:snapBehavior];

    snapBehavior = [[UISnapBehavior alloc] initWithItem:self.diceLabelThree snapToPoint:self.rollButtonLabel.center];
    [self.dynamicAnimator addBehavior:snapBehavior];

    snapBehavior = [[UISnapBehavior alloc] initWithItem:self.diceLabelFour snapToPoint:self.rollButtonLabel.center];
    [self.dynamicAnimator addBehavior:snapBehavior];

    snapBehavior = [[UISnapBehavior alloc] initWithItem:self.diceLabelFive snapToPoint:self.rollButtonLabel.center];
    [self.dynamicAnimator addBehavior:snapBehavior];

    snapBehavior = [[UISnapBehavior alloc] initWithItem:self.diceLabelSix snapToPoint:self.rollButtonLabel.center];
    [self.dynamicAnimator addBehavior:snapBehavior];

}

- (void) fanOut {

    CGPoint point;
    UISnapBehavior *snapBehavior;
    point = CGPointMake(self.rollButtonLabel.center.x - 80, self.rollButtonLabel.center.y - (self.view.frame.size.height/2)-20);
    snapBehavior = [[UISnapBehavior alloc] initWithItem:self.diceLabelOne snapToPoint:point];
    [self.dynamicAnimator addBehavior:snapBehavior];


    point = CGPointMake(self.rollButtonLabel.center.x, self.rollButtonLabel.center.y - (self.view.frame.size.height/2)-20);
    snapBehavior = [[UISnapBehavior alloc] initWithItem:self.diceLabelTwo snapToPoint:point];
    [self.dynamicAnimator addBehavior:snapBehavior];

    point = CGPointMake(self.rollButtonLabel.center.x + 80,  self.rollButtonLabel.center.y - (self.view.frame.size.height/2)-20);
    snapBehavior = [[UISnapBehavior alloc] initWithItem:self.diceLabelThree snapToPoint:point];
    [self.dynamicAnimator addBehavior:snapBehavior];

    point = CGPointMake(self.rollButtonLabel.center.x - 80, self.rollButtonLabel.center.y - (self.view.frame.size.height/2)+45);
    snapBehavior = [[UISnapBehavior alloc] initWithItem:self.diceLabelFour snapToPoint:point];
    [self.dynamicAnimator addBehavior:snapBehavior];


    point = CGPointMake(self.rollButtonLabel.center.x, self.rollButtonLabel.center.y - (self.view.frame.size.height/2)+45);
    snapBehavior = [[UISnapBehavior alloc] initWithItem:self.diceLabelFive snapToPoint:point];
    [self.dynamicAnimator addBehavior:snapBehavior];

    point = CGPointMake(self.rollButtonLabel.center.x + 80, self.rollButtonLabel.center.y - (self.view.frame.size.height/2)+45);
    snapBehavior = [[UISnapBehavior alloc] initWithItem:self.diceLabelSix snapToPoint:point];
    [self.dynamicAnimator addBehavior:snapBehavior];
}

- (void) fanButton:(id)sender {

    [self.dynamicAnimator removeAllBehaviors];

    if (self.areDiceFanned)
        [self fanIn];
    else
        [self fanOut];

    self.areDiceFanned ^= YES;
    
}


@end
