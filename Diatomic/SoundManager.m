//
//  SoundManager.m
//  Laser Quantum Game
//
//  Created by Richard Smith on 09/01/2014.
//  Copyright (c) 2014 Play. All rights reserved.
//

#import "SoundManager.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

static const NSUInteger maxSounds = 1;
static const NSUInteger maxNotes = 5;

@implementation SoundManager{
    NSMutableArray *notes;
    NSUInteger *nextOffset;
}

+ (id)theSoundManager
{
    static SoundManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

-(id) init
{
    if (self = [super init]) {
        notes = [[NSMutableArray alloc] init];
        //nextOffset = calloc(maxSounds, sizeof(NSUInteger));
        
        for (NSUInteger i = 1; i <=maxNotes; i++) {
            NSString *resource = [NSString stringWithFormat:@"Note%d",i];
            NSURL *noteURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:resource ofType:@"wav"]];
            NSError *error;
            
            // Add maxSounds players to the bank
            for (NSUInteger j = 0; j < maxSounds; j++) {
                AVAudioPlayer *note = [[AVAudioPlayer alloc] initWithContentsOfURL:noteURL error:&error];
                [notes addObject:note];
            }
            // Set initial offset to 0
            //nextOffset[i-1] = 0;
            
        }
    }
    return self;
}

-(void) playNote:(NSUInteger)n
{
    //[(AVAudioPlayer *)notes[n + nextOffset[n]] play];
    [(AVAudioPlayer *)notes[n] play];
    //nextOffset[n] = (nextOffset[n] + 1) % maxSounds;
}

@end
