//
//  DiceLabel.m
//  Farkle
//
//  Created by Francis Bato on 10/8/15.
//  Copyright © 2015 Francis Bato. All rights reserved.
//

#import "DiceLabel.h"

@implementation DiceLabel


- (instancetype)initDice:(NSNumber *)index {
    self = [super init];

    if (self) {
        self.dieValue = @1;
        self.isSelected = YES;
        self.isDiscard = YES;
    }

    return self;
}

@end
