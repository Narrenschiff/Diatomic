//
//  Diatom.h
//  Diatomic
//
//  Created by Richard Smith on 02/02/2014.
//  Copyright (c) 2014 Richard Smith. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Diatom : SKSpriteNode

@property NSUInteger kind;

/// Provides an impulse proportional to the radius of the Diatom
-(void)brownianKick;

/// Called on collision with another diatom
-(void)didCollide;

/// Called on separation with another diatom
-(void)didMoveApart;

/// Attempt to connect two diatoms at a contact point. Will fail silently if they cannot be connected due to game rules.
-(void)connectToDiatom:(Diatom *)d withContactPoint:(CGPoint)p;

/// Test for connection between this diatom and another
-(bool)isDirectlyConnectedToDiatom:(Diatom *)d;

/// Test if this diatom can be connected to another under game rules
-(bool)canConnectToDiatom:(Diatom *)d;

//TODO:make this private sometime
/// Connect to another diatom with joint
-(void)storeConnectionToDiatom:(Diatom *)d withJoint:(SKPhysicsJoint *)j;

/// Disconnect this diatom and another diatom and dispose of the joint;
-(void)severConnectionWithDiatom:(Diatom *)d;


@end
