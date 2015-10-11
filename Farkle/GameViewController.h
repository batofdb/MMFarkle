//
//  GameViewController.h
//  Farkle
//
//  Created by Francis Bato on 10/8/15.
//  Copyright © 2015 Francis Bato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameManager.h"

@protocol DieLabelDelegate <NSObject>
- (void)diceLabelDidFinishRoll;
- (void)diceLabelDidTap:(id)dice;
@end


@interface GameViewController : UIViewController


@property NSMutableArray *availablePlayers;
@property GameManager *gameManager;
@property (nonatomic,assign) id <DieLabelDelegate> delegate;
@end
