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
    SKNode* _moving;
    SKNode* _blocker;
    BOOL _canRestart;
    SKLabelNode* _scoreLabelNode;
    NSInteger _score;
    SKLabelNode* _highScoreLabelNode;
    NSInteger _highScore;
    SKAudioNode* bounceSound;
    SKAudioNode* blockSound;
    SKAudioNode* crowdSound;

}
static NSInteger const kVerticalBlockerGap = 300;
static const uint32_t ballCategory = 1 << 0;
static const uint32_t worldCategory = 1 << 1;
static const uint32_t blockerCategory = 1 << 2;
static const uint32_t scoreCategory = 1 << 3;


- (void)didMoveToView:(SKView *)view {
    self.backgroundColor = UIColor.blackColor;
   // self.view.backgroundColor = [UIColor blackColor];
    // Setup your scene here
    bounceSound = [[SKAudioNode alloc] initWithFileNamed:@"BOUNCE.wav"];
    bounceSound.autoplayLooped = false;
    [self addChild:bounceSound];
    blockSound = [[SKAudioNode alloc] initWithFileNamed:@"BlockSound.wav"];
    blockSound.autoplayLooped = false;
    [self addChild:blockSound];
    crowdSound = [[SKAudioNode alloc] initWithFileNamed:@"crowd.wav"];
    crowdSound.autoplayLooped = true;
    [self addChild:crowdSound];
    
    
    _canRestart = NO;
    _score = 0;
    _scoreLabelNode = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Wide"];
    _scoreLabelNode.position = CGPointMake(self.frame.size.width/20, CGRectGetMidY(self.frame));
    _scoreLabelNode.zPosition = 100;
    _scoreLabelNode.text = [NSString stringWithFormat:@"Score: %ld", _score];
    [self addChild:_scoreLabelNode];
    
    _highScore = 0;
    _highScoreLabelNode = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Wide"];
    _highScoreLabelNode.position = CGPointMake(self.frame.size.width/20, CGRectGetMidY(self.frame) - 30);
    _highScoreLabelNode.zPosition = 100;
    _highScoreLabelNode.text = [NSString stringWithFormat:@"High Score: %ld", _score];
    [self addChild:_highScoreLabelNode];
    
    
    self.physicsWorld.gravity = CGVectorMake( 0.0, -5.0 );
    self.physicsWorld.contactDelegate = self;
    
    
    SKTexture* ballTexture = [SKTexture textureWithImageNamed:@"basketball1"];
    ballTexture.filteringMode = SKTextureFilteringNearest;
    _ball = [SKSpriteNode spriteNodeWithTexture:ballTexture];
    [_ball setScale:1.0];
    _ball.position = CGPointMake(self.frame.size.width / 20, CGRectGetMidY(self.frame));
    
    _ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:_ball.size.height / 2];
    _ball.physicsBody.dynamic = YES;
    _ball.physicsBody.allowsRotation = NO;
    _ball.physicsBody.categoryBitMask = ballCategory;
    _ball.physicsBody.collisionBitMask = worldCategory | blockerCategory;
    _ball.physicsBody.contactTestBitMask = worldCategory | blockerCategory;
    _moving = [SKNode node];
    _blocker = [SKNode node];
    [_moving addChild:_blocker];
    [self addChild:_moving];
    [self addChild:_ball];

    SKNode* dummy = [SKNode node];
    dummy.position = CGPointMake(0, -800);
    dummy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width,  200)];
    dummy.physicsBody.dynamic = NO;
    dummy.physicsBody.categoryBitMask = worldCategory;
    [self addChild:dummy];
    
    SKNode* dummy2 = [SKNode node];
    dummy2.position = CGPointMake(0, 800);
    dummy2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width,  200)];
    dummy2.physicsBody.dynamic = NO;
    [self addChild:dummy2];
    
//    SKTexture* groundTexture = [SKTexture textureWithImageNamed:@"IntroPicBasketball"];
//    groundTexture.filteringMode = SKTextureFilteringNearest;
//    SKAction* moveGroundSprite = [SKAction moveByX:-groundTexture.size.width*2 y:0 duration:0.02 * groundTexture.size.width*2];
//    SKAction* resetGroundSprite = [SKAction moveByX:groundTexture.size.width*2 y:0 duration:0];
//    SKAction* moveGroundSpritesForever = [SKAction repeatActionForever:[SKAction sequence:@[moveGroundSprite, resetGroundSprite]]];
//
//    for( int i = 0; i < 2 + self.frame.size.width / ( groundTexture.size.width * 2 ); ++i ) {
//        SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithTexture:groundTexture];
//        [sprite setScale:2.0];
//        sprite.position = CGPointMake(i * sprite.size.width, -400);
//        [sprite runAction:moveGroundSpritesForever];
//        [self addChild:sprite];
//    }
    
    SKAction* spawn = [SKAction performSelector:@selector(spawnBlockers) onTarget:self];
    SKAction* delay = [SKAction waitForDuration:3.0];
    SKAction* spawnThenDelay = [SKAction sequence:@[spawn, delay]];
    SKAction* spawnThenDelayForever = [SKAction repeatActionForever:spawnThenDelay];
    [self runAction:spawnThenDelayForever];
    
    
    
    
}
-(void)spawnBlockers {
    SKTexture* _blockerTexture1 = [SKTexture textureWithImageNamed:@"GiannisBlock"];
    _blockerTexture1.filteringMode = SKTextureFilteringNearest;
    SKTexture* _blockerTexture2 = [SKTexture textureWithImageNamed:@"giannis3"];
    _blockerTexture2.filteringMode = SKTextureFilteringNearest;
    
    SKNode* blockerPair = [SKNode node];
    blockerPair.position = CGPointMake(450,-500);// self.frame.size.width + _blockerTexture1.size.width * 2, 0 );
    blockerPair.zPosition = -10;
    
    CGFloat y = arc4random() % (NSInteger)(500);
    
    SKSpriteNode* blocker1 = [SKSpriteNode spriteNodeWithTexture:_blockerTexture1];
    [blocker1 setScale:1];
    blocker1.position = CGPointMake( 0, y );
    blocker1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:blocker1.size];
    blocker1.physicsBody.dynamic = NO;
    blocker1.physicsBody.categoryBitMask = blockerCategory;
    blocker1.physicsBody.contactTestBitMask = ballCategory;
    [blockerPair addChild:blocker1];
    
    
    SKSpriteNode* blocker2 = [SKSpriteNode spriteNodeWithTexture:_blockerTexture2];
    [blocker2 setScale:2.2];
    blocker2.position = CGPointMake( 0, y + blocker1.size.height + kVerticalBlockerGap );
    blocker2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:blocker2.size];
    blocker2.physicsBody.dynamic = NO;
    blocker2.physicsBody.categoryBitMask = blockerCategory;
    blocker2.physicsBody.contactTestBitMask = ballCategory;
    [blockerPair addChild:blocker2];
    
    SKNode* contactNode = [SKNode node];
    contactNode.position = CGPointMake( blocker1.size.width + _ball.size.width / 2, CGRectGetMidY( self.frame ) );
    contactNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake( blocker2.size.width, self.frame.size.height )];
    contactNode.physicsBody.dynamic = NO;
    contactNode.physicsBody.categoryBitMask = scoreCategory;
    contactNode.physicsBody.contactTestBitMask = ballCategory;
    [blockerPair addChild:contactNode];
    
    //Change speed of blocker
    SKAction* moveBlockers = [SKAction repeatActionForever:[SKAction moveByX:-4 y:0 duration:0.02]];
    
    [blockerPair runAction:moveBlockers];
    [_blocker addChild:blockerPair];

}
- (void)didBeginContact:(SKPhysicsContact *)contact {
    if(_moving.speed > 0){
        if( ( contact.bodyA.categoryBitMask & scoreCategory ) == scoreCategory || ( contact.bodyB.categoryBitMask & scoreCategory ) == scoreCategory ) {
            // Ball has contact with score entity
            
            _score++;
            _scoreLabelNode.text = [NSString stringWithFormat:@"Score: %ld", _score];
            if(_score > _highScore){
                _highScore = _score;
                _highScoreLabelNode.text = [NSString stringWithFormat:@"High Score: %ld", _score];
            }
            //_highScoreLabelNode.text = [NSString stringWithFormat:@"Score: %ld", _score];
        } else {
            // Ball has been blocked
            _moving.speed = 0;
            _canRestart = YES;
            [blockSound runAction:[SKAction changeVolumeTo:10 duration:5.0]];
            [blockSound runAction:[SKAction play]];
                    }
    }
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
    if( _moving.speed > 0 ) {
        _ball.physicsBody.velocity = CGVectorMake(0, 0);
        [_ball.physicsBody applyImpulse:CGVectorMake(0, 175)];
        [bounceSound runAction:[SKAction play]];
    }
    else if( _canRestart ) {
        [self resetScene];
    }

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
    if( _moving.speed > 0 ) {
        _ball.zRotation = clamp( -1, 0.5, _ball.physicsBody.velocity.dy * ( _ball.physicsBody.velocity.dy < 0 ? 0.003 : 0.001 ) );
    }

    // Called before each frame is rendered
}

-(void)resetScene {
    // Move bird to original position and reset velocity
    _ball.position = CGPointMake(self.frame.size.width / 20, CGRectGetMidY(self.frame));
    _ball.physicsBody.velocity = CGVectorMake( 0, 0 );
    _ball.physicsBody.collisionBitMask = worldCategory | blockerCategory;
    _ball.speed = 1.0;
    _ball.zRotation = 0.0;
    
    // Remove all existing pipes
    [_blocker removeAllChildren];
    
    // Reset _canRestart
    _canRestart = NO;
    
    // Restart animation
    _moving.speed = 1;
    
    _score = 0;
    _scoreLabelNode.text = [NSString stringWithFormat:@"Score: %ld", _score];

}
@end
