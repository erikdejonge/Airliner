//
//  player_airplane.m
//  Tiletest
//[gs airplaneSpeed]
//  Created by rabshakeh on 11/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "player_airplane.h"
#import "GameState.h"

@implementation player_airplane

@synthesize vector_x_delta;
@synthesize vector_y_delta;
@synthesize airplane;

-(void) initAirplane: (CCLayer *) world_layer
{
  //autospeed = MAXSPEEDAUTOPILOT;
  GameState *gs = [GameState sharedInstance];

  smoke_trail_part_counter = 0;
  smoke_trail_time_tracker = 0;
  for (int i = 0; i <[gs returnNumSmokeTrails]; i++) {
    smoke_trail[i]          = [[CCSprite spriteWithFile:@"jetstream.png"] retain];
    smoke_trail[i].position = ccp(0, -10000);
    [world_layer addChild:smoke_trail[i]];
    smoke_trail_faders[i] = [[CCFadeOut actionWithDuration:(SMOKETRAIL_TIME *[gs returnNumSmokeTrails]) - SMOKETRAIL_TIME] retain];
  }

  airplane          = [[CCSprite spriteWithFile:@"plane.png"] retain];
  airplane.position = ccp(SCREENWIDTH / 2, SCREENHEIGHT / 2);

  airplane.rotation = [gs getAirplaneRotation];
  [world_layer addChild:airplane z:4];
}

-(void) updateSmokeTrail: (ccTime) dt
{
  GameState *gs   = [GameState sharedInstance];
  float     timed = 0.03;

  for (int i = 0; i <[gs returnNumSmokeTrails]; i++) {
    CGPoint particle_pos = smoke_trail[i].position;
    particle_pos.x -= (vector_x_delta *[gs airplaneSpeed]) * dt;
    if (airplane.rotation > 90 && airplane.rotation < 270) {
      particle_pos.y += (vector_y_delta *[gs airplaneSpeed]) * dt;
    }
    else {
      particle_pos.y -= (vector_y_delta *[gs airplaneSpeed]) * dt;
    }
    smoke_trail[i].position = particle_pos;
  }

  smoke_trail_time_tracker += dt;
  if (smoke_trail_time_tracker >= timed) {
    smoke_trail_time_tracker = 0;
    if (smoke_trail_part_counter ==[gs returnNumSmokeTrails]) {
      smoke_trail_part_counter = 0;
    }
    CGPoint particle_pos;
    particle_pos.x                                 = SCREENWIDTH / 2;
    particle_pos.y                                 = SCREENHEIGHT / 2;
    smoke_trail[smoke_trail_part_counter].position = particle_pos;
    smoke_trail[smoke_trail_part_counter].rotation = airplane.rotation;
    [smoke_trail[smoke_trail_part_counter] runAction:smoke_trail_faders[smoke_trail_part_counter]];
    smoke_trail_part_counter++;
  }
}

-(void) calculateMovementVector
{
  float opposite,
        hypothenusa = 1,
        adjacent;
  float deg      = airplane.rotation;
  BOOL  invert_y = NO;

  //hack overrotation of cocos2d sprite
  if (deg > 360) {
    deg     -= 360;
    invert_y = YES;
  }
  if (deg < 0) {
    deg     += 360;
    invert_y = YES;
  }
  opposite = sin(deg * M_PI / 180) * hypothenusa;
  adjacent = sqrt((hypothenusa * hypothenusa) - (opposite * opposite));

  // y direction is opposite, x direction is adja
  // normalize vector divide by length (hypo)
  float vector_x = opposite,
        vector_y = adjacent;
  vector_x_delta = vector_x / hypothenusa;
  vector_y_delta = vector_y / hypothenusa;

  // more hacking
  if (invert_y && (deg > 90 && deg < 270)) {
    vector_y_delta = -vector_y_delta;
  }

  GameState *gs = [GameState sharedInstance];

  if ([gs getPlayerState] == GAMEOVER) {
    vector_x_delta = vector_y_delta = 0;
  }
}

-(void) calculateMovementVectorAutoPilot
{
  GameState *gs       = [GameState sharedInstance];
  CGPoint   targetloc = [gs getNearestTarget];
  // calculate angle
  float     a   = targetloc.y - airplane.position.y;
  float     b   = targetloc.x - airplane.position.x;
  float     rad = atan(b / a);
  float     deg = (180.0 / M_PI) * rad;

  if (a < 0) {
    deg += 180;
  }
  current_heading_airplane = deg;
  id rotateto = [CCRotateTo actionWithDuration:1  angle: deg];
  [airplane runAction: rotateto];
  [gs setAirplaneRotation:deg];
  autopilotmisses++;
}

-(void) changePlayerDirection: (CGPoint) touchLocation duration: (float) dur
{
  GameState *gs = [GameState sharedInstance];

  if (GAMEOVER ==[gs getPlayerState]) {
    return;
  }

  // calculate angle
  float a   = touchLocation.y - airplane.position.y;
  float b   = touchLocation.x - airplane.position.x;
  float rad = atan(b / a);
  float deg = (180.0 / M_PI) * rad;
  if (a < 0) {
    deg += 180;
  }
  current_heading_airplane = deg;
  id rotateto = [CCRotateTo actionWithDuration:dur angle: deg];
  [airplane runAction: rotateto];
  [gs setAirplaneRotation:deg];
}

-(void) updatePlayer: (ccTime) dt
{
  GameState *gs = [GameState sharedInstance];

  lastmapsteer += dt;
  if ([gs getTurnRequested] != 0 && lastmapsteer > 2) {
    lastmapsteer = 0;

    int deg = 0;
    if ([gs getTurnRequested] == 1) {
      deg = 90;
    }
    else if ([gs getTurnRequested] == 2) {
      deg = 180;
    }
    else if ([gs getTurnRequested] == 3) {
      deg = 0;
    }
    else if ([gs getTurnRequested] == 4) {
      deg = -90;
    }
    id rotateto = [CCRotateTo actionWithDuration:1  angle: deg];
    [airplane runAction: rotateto];
    [gs setAirplaneRotation:deg];
    [gs setTurnRequested:0];
  }

  if (TARGETMISSED ==[gs getPlayerState]) {
    [self calculateMovementVectorAutoPilot];
    [gs setPlayerState:AUTOFLYING];
    [gs setAutopilotTurbo:1];
    autopilot_time_tracker     = 0;
    autopilotwaitforcorrection = 1;
    autopilotmisses            = 0;
  }
  else if (AUTOFLYING ==[gs getPlayerState]) {
    CGPoint targetloc = [gs getNearestTarget];
    float   a         = targetloc.y - airplane.position.y;
    float   b         = targetloc.x - airplane.position.x;
    float   c         = sqrt((a * a) + (b * b));
    if (c < BREAKDISTANCE &&[gs getAutopilotTurbo] == 1) {
      [gs setAutopilotTurbo:0];
    }
    else {
      // autospeed = MAXSPEEDAUTOPILOT;
    }
    autopilot_time_tracker += dt;
    if (autopilotmisses > 4) {
      if (autopilot_time_tracker > autopilotwaitforcorrection) {
        autopilotwaitforcorrection = 4 + (arc4random() % 3);
        [self calculateMovementVectorAutoPilot];
        autopilot_time_tracker = 0;
      }
    }
    else {
      if (autopilot_time_tracker > 0.5) {
        [self calculateMovementVectorAutoPilot];
        autopilot_time_tracker = 0;
      }
    }
    if (autopilotmisses > 5) {
      autopilotmisses = 0;
    }
  }
  [self calculateMovementVector];
  [self updateSmokeTrail:dt];
}

@end
