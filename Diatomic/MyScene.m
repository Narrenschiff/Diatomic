//
//  MyScene.m
//  Diatomic
//
//  Created by Richard Smith on 02/02/2014.
//  Copyright (c) 2014 Richard Smith. All rights reserved.
//

#import "MyScene.h"
#import "Diatom.h"

static const CGFloat paddingRatio = 0.0;

@implementation MyScene{
    SKNode *diatoms;
    NSMutableArray *dragTouches;
    NSMutableArray *dragDiatoms;
    NSUInteger countdownToNextSpawn;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        NSLog(@"Size %f %f", size.width, size.height);
        
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
        
        
        //edge
        CGRect edges = CGRectMake(-self.size.width * paddingRatio, -self.size.height * paddingRatio, self.size.width * (1 + 2 * paddingRatio), self.size.height * (1 + paddingRatio));
        SKNode *edge = [[SKNode alloc] init];
        edge.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:edges];
        edge.physicsBody.restitution = 1.0;
        edge.physicsBody.categoryBitMask = borderCollisonMask;
        [self addChild:edge];
        
        
        //Background
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"Background"];
        background.anchorPoint = CGPointMake(0.5, 0.5);
        background.zPosition = -100;
        background.xScale = 1.1;
        background.yScale = 1.1;
        [background runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:2 * M_PI duration:40]]];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
        
        //diatom root node
        diatoms = [[SKNode alloc] init];
        [self addChild:diatoms];
        
        self.physicsWorld.contactDelegate = self;
        
        dragTouches = [[NSMutableArray alloc] init];
        dragDiatoms = [[NSMutableArray alloc] init];
        
        countdownToNextSpawn = spawnCountDown;

    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        Diatom *touchedDiatom = (Diatom *)[diatoms nodeAtPoint:location];

        // if you haven't touched an existing diatom, add a new one
        if (touchedDiatom == diatoms){
            Diatom *di = [[Diatom alloc] init];
            di.position = location;
            [diatoms addChild:di];
        }else{
            [dragTouches addObject:touch];
            [dragDiatoms addObject:touchedDiatom];
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint positionInScene = [touch locationInNode:self];
        
        NSUInteger index = [dragTouches indexOfObject:touch];
        if (index != NSNotFound) {
            ((Diatom* )dragDiatoms[index]).position = positionInScene;
        }else{
            if (countdownToNextSpawn == 0) {
            Diatom *di = [[Diatom alloc] init];
            di.position = positionInScene;
            [diatoms addChild:di];
                countdownToNextSpawn = spawnCountDown;
            }else{
                countdownToNextSpawn--;
            }

        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        NSUInteger index = [dragTouches indexOfObject:touch];
        if (index != NSNotFound) {
            [dragTouches removeObjectAtIndex:index];
            [dragDiatoms removeObjectAtIndex:index];
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    for (Diatom *d in diatoms.children) {
        [d brownianKick];
    }
}

#pragma mark Contact Delegate
-(void)didBeginContact:(SKPhysicsContact *)contact
{
    Diatom *diatomA = (Diatom *)contact.bodyA.node;
    Diatom *diatomB = (Diatom *)contact.bodyB.node;
    [diatomA didCollide];
    [diatomB didCollide];
    [diatomA connectToDiatom:diatomB withContactPoint:contact.contactPoint];
}

-(void)didEndContact:(SKPhysicsContact *)contact
{
    [(Diatom *)contact.bodyA.node didMoveApart];
    [(Diatom *)contact.bodyB.node didMoveApart];
}

@end
