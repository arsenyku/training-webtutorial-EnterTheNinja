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
#import "CCTouch.h"
// -----------------------------------------------------------------------

@interface HelloWorldScene() <CCPhysicsCollisionDelegate>
@property (nonatomic, strong) CCSprite *player;
@property (nonatomic, strong) CCPhysicsNode *physicsWorld;
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
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor lightGrayColor]];
    [self addChild:background];
    
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,0);
    _physicsWorld.debugDraw = YES;
    _physicsWorld.collisionDelegate = self;
    [self addChild:_physicsWorld];
    
    // 5
    _player = [CCSprite spriteWithImageNamed:@"player.png"];
    _player.position  = ccp(self.contentSize.width/8,self.contentSize.height/2);

    _player.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _player.contentSize} cornerRadius:0]; // 1
    _player.physicsBody.collisionGroup = @"playerGroup"; // 2
    [_physicsWorld addChild:_player];
  
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
    
    monster.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, monster.contentSize} cornerRadius:0]; // 1
    monster.physicsBody.collisionGroup = @"monsterGroup"; // 2
    monster.physicsBody.collisionType  = @"monsterCollision";
    [_physicsWorld addChild:monster];
    
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


- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    // 1

    CGPoint touchLocation = [(CCTouch*)touch locationInNode:self];
    
    // 2
    CGPoint offset    = ccpSub(touchLocation, _player.position);
    float   ratio     = offset.y/offset.x;
    int     targetX   = _player.contentSize.width/2 + self.contentSize.width;
    int     targetY   = (targetX*ratio) + _player.position.y;
    CGPoint targetPosition = ccp(targetX,targetY);
    
    // 3
    CCSprite *projectile = [CCSprite spriteWithImageNamed:@"projectile.png"];
    projectile.position = _player.position;
    
    projectile.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, projectile.contentSize} cornerRadius:0]; // 1
    projectile.physicsBody.collisionGroup = @"playerGroup"; // 2
    projectile.physicsBody.collisionType  = @"projectileCollision";
    [_physicsWorld addChild:projectile];

    
    // 4
    CCActionMoveTo *actionMove   = [CCActionMoveTo actionWithDuration:1.5f position:targetPosition];
    CCActionRemove *actionRemove = [CCActionRemove action];
    [projectile runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
}


// -----------------------------------------------------------------------

@end























// why not add a few extra lines, so we dont have to sit and edit at the bottom of the screen ...
