//
//  RootViewController.m
//  Farkle
//
//  Created by Francis Bato on 10/8/15.
//  Copyright © 2015 Francis Bato. All rights reserved.
//

#import "RootViewController.h"
#import "GameViewController.h"
#import "DiceLabel.h"
#import "Player.h"

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *addPlayerTextField;
@property NSMutableArray *players;
@property (weak, nonatomic) IBOutlet UITableView *playerTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *playButton;
@property NSInteger playerCount;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.playerCount = 0;
    self.playButton.enabled = NO;
    
    self.players = [[NSMutableArray alloc] init];
    self.addPlayerTextField.delegate = self;
    self.playerTableView.allowsMultipleSelection = YES;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.players count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    cell.textLabel.text = [[self.players objectAtIndex:indexPath.row] name];
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [self addPlayerWithName:textField.text];
    self.addPlayerTextField.text = @"";
    [self.view   endEditing:YES];
    [self.playerTableView reloadData];
    return YES;
}

- (void)addPlayerWithName:(NSString *)name {
    Player *player = [[Player alloc] initWithName:name];
    [self.players addObject:player];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    GameViewController *vc = [segue destinationViewController];

    NSArray *indices = [self.playerTableView indexPathsForSelectedRows];
    NSMutableArray *selectedPlayers = [[NSMutableArray alloc] init];



    for (NSIndexPath *index in indices) {
        for (int i=0;i<[self.players count];i++) {
            if (index.row == i) {
                [selectedPlayers addObject:self.players[i]];
            }
        }
    }

    //GameManager *gameManager = [[GameManager alloc] initGameManager:selectedPlayers];

    
    vc.availablePlayers = selectedPlayers;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.playerCount++;
    [self checkPlayerCount];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.playerCount--;
    [self checkPlayerCount];
}

- (void)checkPlayerCount {
    if (self.playerCount >= 2)
        self.playButton.enabled = YES;
    else
        self.playButton.enabled = NO;
}




@end
