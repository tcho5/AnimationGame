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
}

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

    
//    SKTexture* groundTexture = [SKTexture textureWithImageNamed:@"intense_background"];
//    groundTexture.filteringMode = SKTextureFilteringNearest;
//
//    SKAction* moveGroundSprite = [SKAction moveByX:-groundTexture.size.width*2 y:0 duration:0.02 * groundTexture.size.width*2];
//    SKAction* resetGroundSprite = [SKAction moveByX:groundTexture.size.width*2 y:0 duration:0];
//    SKAction* moveGroundSpritesForever = [SKAction repeatActionForever:[SKAction sequence:@[moveGroundSprite, resetGroundSprite]]];
//
//    for( int i = 0; i < 2 + self.frame.size.width / ( groundTexture.size.width * 2 ); ++i ) {
//        // Create the sprite
//        SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithTexture:groundTexture];
//        [sprite setScale:2.0];
//        sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height / 2);
//        [sprite runAction:moveGroundSpritesForever];
//        [self addChild:sprite];
//    }
//
    
//    SKNode* dummy = [SKNode node];
//    dummy.position = CGPointMake(0, groundTexture.size.height);
//    dummy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width, groundTexture.size.height * 2)];
//    dummy.physicsBody.dynamic = NO;
//    [self addChild:dummy];
    
//    SKTexture* background = [SKTexture textureWithImageNamed:@"intense_background"];
//    background.filteringMode = SKTextureFilteringNearest;
//    for( int i = 0; i < 2 + self.frame.size.width / ( background.size.width * 2 ); ++i ) {
//        SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithTexture:background];
//        [sprite setScale:2.0];
//        sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height / 2);
//        [self addChild:sprite];
//    }
    
    // Get label node from scene and store it for use later
    _label = (SKLabelNode *)[self childNodeWithName:@"//helloLabel"];
    
    _label.alpha = 0.0;
    [_label runAction:[SKAction fadeInWithDuration:2.0]];
    
    CGFloat w = (self.size.width + self.size.height) * 0.05;
    
    // Create shape node to use during mouse interaction
    _spinnyNode = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(w, w) cornerRadius:w * 0.3];
    _spinnyNode.lineWidth = 2.5;
    
    [_spinnyNode runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:M_PI duration:1]]];
    [_spinnyNode runAction:[SKAction sequence:@[
                                                [SKAction waitForDuration:0.5],
                                                [SKAction fadeOutWithDuration:0.5],
                                                [SKAction removeFromParent],
                                                ]]];
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
    [_ball.physicsBody applyImpulse:CGVectorMake(0, 400)];
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


-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
}

@end
