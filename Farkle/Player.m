//
//  Player.m
//  Farkle
//
//  Created by Francis Bato on 10/8/15.
//  Copyright © 2015 Francis Bato. All rights reserved.
//

#import "Player.h"

@implementation Player

- (instancetype) initWithName: (NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
        self.score = 0;
        self.isPlaying = NO;
    }

    return self;
}


@end
