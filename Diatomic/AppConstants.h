//
//  AppConstants.h
//  Diatomic
//
//  Created by Richard Smith on 02/02/2014.
//  Copyright (c) 2014 Richard Smith. All rights reserved.
//

#ifndef Diatomic_AppConstants_h
#define Diatomic_AppConstants_h

// Bitmasks for collision detection
static const NSUInteger borderCollisonMask = 1;
static const NSUInteger diatomCollisonMask = 2;
static const NSUInteger deadDiatomCollisonMask = 4;

// Lambda for exp distribution that decides dissociation times of chains
static const float dissociationConstant = 1 / 200.0;

// Refractory periods during which cells can't interact
static const CGFloat refractoryPeriod = 0.2;
static const CGFloat refractoryAfterSplitting = 5.0;

// Delay for finger swipes dropping new cells onto the screen
static const NSUInteger spawnCountDown = 10;

static const NSUInteger maxChain = 5;
static const CGFloat nukeDuration = 0.8;

// Color cells for debugging
//#define DEBUG_COLORING

#endif
