//
//  DiceLabel.h
//  Farkle
//
//  Created by Francis Bato on 10/8/15.
//  Copyright © 2015 Francis Bato. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DiceLabel : UILabel

@property NSNumber *dieValue;
@property BOOL isSelected;
@property BOOL beforeRoll;


- (instancetype)initDice:(NSNumber *)index;





@end
