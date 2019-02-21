//
//  GameScene.m
//  AnimationGame
//
//  Created by Taehyun Cho on 2/15/19.
//  Copyright © 2019 Taehyun Cho. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene {
    SKShapeNode *_spinnyNode;
    SKLabelNode *_label;
    SKSpriteNode *_ball;
    SKColor * _backgroundColor;
    SKTexture* _blockerTexture1;
    SKTexture* _blockerTexture2;
    SKAction* _moveAndRemoveBlocks;
}
static NSInteger const kVerticalBlockerGap = 300;

- (void)didMoveToView:(SKView *)view {
   // self.view.backgroundColor = [UIColor blackColor];
    // Setup your scene here
    
    //_backgroundColor = [SKColor SK_ColorBLACK = SkColorSetARGB(0xFF, 0x00, 0x00, 0x00)];
    //[self setBackgroundColor:_backgroundColor];
    self.physicsWorld.gravity = CGVectorMake( 0.0, -5.0 );
    
    SKTexture* ballTexture = [SKTexture textureWithImageNamed:@"basketball1"];
    ballTexture.filteringMode = SKTextureFilteringNearest;
    _ball = [SKSpriteNode spriteNodeWithTexture:ballTexture];
    [_ball setScale:1.0];
    _ball.position = CGPointMake(self.frame.size.width / 20, CGRectGetMidY(self.frame));
    
    _ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:_ball.size.height / 2];
    _ball.physicsBody.dynamic = YES;
    _ball.physicsBody.allowsRotation = NO;
    
    [self addChild:_ball];

    SKNode* dummy = [SKNode node];
    dummy.position = CGPointMake(0, -800);
    dummy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width,  200)];
    dummy.physicsBody.dynamic = NO;
    [self addChild:dummy];
    
    SKNode* dummy2 = [SKNode node];
    dummy2.position = CGPointMake(0, 800);
    dummy2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width,  200)];
    dummy2.physicsBody.dynamic = NO;
    [self addChild:dummy2];
    

    SKAction* spawn = [SKAction performSelector:@selector(spawnBlockers) onTarget:self];
    SKAction* delay = [SKAction waitForDuration:3.0];
    SKAction* spawnThenDelay = [SKAction sequence:@[spawn, delay]];
    SKAction* spawnThenDelayForever = [SKAction repeatActionForever:spawnThenDelay];
    [self runAction:spawnThenDelayForever];
    
    
    //[_label runAction:[SKAction actionNamed:@"Pulse"] withKey:@"fadeInOut"];
//
//    CGFloat distanceToMove = self.frame.size.width + 3 * _blockerTexture1.size.width;
//    moveBlockers = [SKAction moveByX:-distanceToMove y:0 duration:0.01 * distanceToMove];
//    SKAction* removeBlockers = [SKAction removeFromParent];
//    _moveAndRemoveBlocks = [SKAction sequence:@[moveBlockers, removeBlockers]];
//
//    //[_label runAction:[SKAction fadeInWithDuration:2.0]];
//
//    SKAction* spawn = [SKAction performSelector:@selector(spawnBlockers) onTarget:self];
//    SKAction* delay = [SKAction waitForDuration:1.0];
//    SKAction* spawnThenDelay = [SKAction sequence:@[spawn, delay]];
//    SKAction* spawnThenDelayForever = [SKAction repeatActionForever:spawnThenDelay];
//    [self runAction:spawnThenDelayForever];
//
//    // Get label node from scene and store it for use later
//    _label.alpha = 0.0;
//
//    CGFloat w = (self.size.width + self.size.height) * 0.05;
//
//    // Create shape node to use during mouse interaction
//    _spinnyNode = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(w, w) cornerRadius:w * 0.3];
//    _spinnyNode.lineWidth = 2.5;
//
//    [_spinnyNode runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:M_PI duration:1]]];
//    [_spinnyNode runAction:[SKAction sequence:@[
//                                                [SKAction waitForDuration:0.5],
//                                                [SKAction fadeOutWithDuration:0.5],
//                                                [SKAction removeFromParent],
//                                                ]]];
}
-(void)spawnBlockers {
    SKTexture* _blockerTexture1 = [SKTexture textureWithImageNamed:@"GiannisBlock"];
    _blockerTexture1.filteringMode = SKTextureFilteringNearest;
    SKTexture* _blockerTexture2 = [SKTexture textureWithImageNamed:@"giannis3"];
    _blockerTexture2.filteringMode = SKTextureFilteringNearest;
    
    SKNode* blockerPair = [SKNode node];
    blockerPair.position = CGPointMake(450,-500);// self.frame.size.width + _blockerTexture1.size.width * 2, 0 );
    blockerPair.zPosition = -10;
    
    CGFloat y = arc4random() % (NSInteger)( self.frame.size.height / 10 );
    
    SKSpriteNode* blocker1 = [SKSpriteNode spriteNodeWithTexture:_blockerTexture1];
    [blocker1 setScale:1];
    blocker1.position = CGPointMake( 0, y );
    blocker1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:blocker1.size];
    blocker1.physicsBody.dynamic = NO;
    [blockerPair addChild:blocker1];
    
    
    SKSpriteNode* blocker2 = [SKSpriteNode spriteNodeWithTexture:_blockerTexture2];
    [blocker2 setScale:2.2];
    blocker2.position = CGPointMake( 0, y + blocker1.size.height + kVerticalBlockerGap );
    blocker2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:blocker2.size];
    blocker2.physicsBody.dynamic = NO;
    [blockerPair addChild:blocker2];
    
    //Change speed of blocker
    
    SKAction* moveBlockers = [SKAction repeatActionForever:[SKAction moveByX:-4 y:0 duration:0.02]];
    
    [blockerPair runAction:moveBlockers];
    
    [self addChild:blockerPair];
}


- (void)touchDownAtPoint:(CGPoint)pos {
//    SKShapeNode *n = [_spinnyNode copy];
//    n.position = pos;
//    n.strokeColor = [SKColor greenColor];
//    [self addChild:n];
}

- (void)touchMovedToPoint:(CGPoint)pos {
//    SKShapeNode *n = [_spinnyNode copy];
//    n.position = pos;
//    n.strokeColor = [SKColor blueColor];
//    [self addChild:n];
}

- (void)touchUpAtPoint:(CGPoint)pos {
//    SKShapeNode *n = [_spinnyNode copy];
//    n.position = pos;
//    n.strokeColor = [SKColor redColor];
//    [self addChild:n];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    _ball.physicsBody.velocity = CGVectorMake(0, 0);
    [_ball.physicsBody applyImpulse:CGVectorMake(0, 175)];
    //[_label runAction:[SKAction actionNamed:@"Pulse"] withKey:@"fadeInOut"];

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    // Run 'Pulse' action from 'Actions.sks'
//    //[_ball.physicsBody applyImpulse:CGVectorMake(0, 15)];
//    //[_label runAction:[SKAction actionNamed:@"Pulse"] withKey:@"fadeInOut"];
//    //for (UITouch *t in touches) {[self touchDownAtPoint:[t locationInNode:self]];}
//}
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *t in touches) {[self touchMovedToPoint:[t locationInNode:self]];}
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}

CGFloat clamp(CGFloat min, CGFloat max, CGFloat value) {
    if( value > max ) {
        return max;
    } else if( value < min ) {
        return min;
    } else {
        return value;
    }
}
-(void)update:(CFTimeInterval)currentTime {
    _ball.zRotation = clamp( -1, 1, _ball.physicsBody.velocity.dy * ( _ball.physicsBody.velocity.dy < 0 ? 0.003 : 0.001 ) );

    // Called before each frame is rendered
}

@end
