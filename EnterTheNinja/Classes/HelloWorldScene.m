//
//  HelloWorldScene.m
//
//  Created by : asu
//  Project    : EnterTheNinja
//  Date       : 2015-10-05
//
//  Copyright (c) 2015 asu.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "HelloWorldScene.h"

// -----------------------------------------------------------------------

@interface HelloWorldScene()
@property (nonatomic, strong) CCSprite *player;
@end


@implementation HelloWorldScene

// -----------------------------------------------------------------------

- (id)init
{
    // 2
    self = [super init];
    if (!self) return(nil);
    
    // 3
    self.userInteractionEnabled = YES;
    
    // 4
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor lightGrayColor]];     //    [CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    // 5
    _player = [CCSprite spriteWithImageNamed:@"player.png"];
    _player.position  = ccp(self.contentSize.width/2,self.contentSize.height/2);
    [self addChild:_player];
    
    // 6
    CCActionRotateBy* actionSpin = [CCActionRotateBy actionWithDuration:1.5f angle:360];
    [_player runAction:[CCActionRepeatForever actionWithAction:actionSpin]];
    
    // 7
    CCButton *backButton = [CCButton buttonWithTitle:@"[ Menu ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.85f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    
    [self addMonster:1];
    
    return self;
    


}


- (void)addMonster:(CCTime)dt {
    
    CCSprite *monster = [CCSprite spriteWithImageNamed:@"monster.png"];
    
    // 1
    int minY = monster.contentSize.height / 2;
    int maxY = self.contentSize.height - monster.contentSize.height / 2;
    int rangeY = maxY - minY;
    int randomY = (arc4random() % rangeY) + minY;
    
    // 2
    monster.position = CGPointMake(self.contentSize.width + monster.contentSize.width/2, randomY);
    [self addChild:monster];
    
    // 3
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int randomDuration = (arc4random() % rangeDuration) + minDuration;
    
    // 4
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(-monster.contentSize.width/2, randomY)];
    CCAction *actionRemove = [CCActionRemove action];
    [monster runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
}

-(void)onEnter{
    [super onEnter];
    [self schedule:@selector(addMonster:) interval:1.5];
}

// -----------------------------------------------------------------------

@end























// why not add a few extra lines, so we dont have to sit and edit at the bottom of the screen ...
