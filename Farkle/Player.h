//
//  Player.h
//  Farkle
//
//  Created by Francis Bato on 10/8/15.
//  Copyright © 2015 Francis Bato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject

@property NSString *name;
@property BOOL isPlaying;
@property NSInteger score;
@property BOOL isSelected;
@property BOOL firstRoll;
@property BOOL hasRolled;

- (instancetype) initWithName: (NSString *)name;

@end
