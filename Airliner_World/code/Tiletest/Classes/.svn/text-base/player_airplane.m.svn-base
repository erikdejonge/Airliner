//
//  player_airplane.m
//  Tiletest
//
//  Created by rabshakeh on 11/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "player_airplane.h"
#import "UIDeviceAirliner.h"

@implementation player_airplane

@synthesize vector_x_delta;
@synthesize vector_y_delta;
@synthesize airplane;

-(void) initAirplane: (Layer *) world_layer
{
  UIDeviceAirliner *uda = [UIDeviceAirliner alloc];

  if (NO ==[uda fastMachine])
  {
    fast_machine = NO;
  }
  else
  {
    fast_machine             = YES;
    smoke_trail_part_counter = 0;
    smoke_trail_time_tracker = 0;
    for (int i = 0; i < NUM_SMOKE_TRAILS; i++)
    {
      smoke_trail[i]          = [[Sprite spriteWithFile:@"jetstream.png"] retain];
      smoke_trail[i].position = ccp(0, -10000);
      [world_layer addChild:smoke_trail[i]];
      smoke_trail_faders[i] = [[FadeOut actionWithDuration:(SMOKETRAIL_TIME * NUM_SMOKE_TRAILS) - SMOKETRAIL_TIME] retain];
    }
  }
  [uda release];

  airplane          = [[Sprite spriteWithFile:@"plane.png"] retain];
  airplane.position = ccp(SCREENWIDTH / 2, SCREENHEIGHT / 2);
  airplane.rotation = AIRPLANE_STARTORIENTATION;
  [world_layer addChild:airplane];
}

-(void) updateSmokeTrail: (ccTime) dt
{
  if (!fast_machine)
  {
    return;
  }

  float timed = 0.03;

  for (int i = 0; i < NUM_SMOKE_TRAILS; i++)
  {
    CGPoint particle_pos = smoke_trail[i].position;
    particle_pos.x -= (vector_x_delta * AIRPLANE_SPEED) * dt;
    if (airplane.rotation > 90 && airplane.rotation < 270)
    {
      particle_pos.y += (vector_y_delta * AIRPLANE_SPEED) * dt;
    }
    else
    {
      particle_pos.y -= (vector_y_delta * AIRPLANE_SPEED) * dt;
    }
    smoke_trail[i].position = particle_pos;
  }

  smoke_trail_time_tracker += dt;
  if (smoke_trail_time_tracker >= timed)
  {
    smoke_trail_time_tracker = 0;
    if (smoke_trail_part_counter == NUM_SMOKE_TRAILS)
    {
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
  if (deg > 360)
  {
    deg     -= 360;
    invert_y = YES;
  }
  if (deg < 0)
  {
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
  if (invert_y && (deg > 90 && deg < 270))
  {
    vector_y_delta = -vector_y_delta;
  }

  //normal_x = normal_y = 0;
}

-(void) changePlayerDirection: (UITouch *) touch
{
  CGPoint touchLocation = [touch locationInView:[touch view]];

  touchLocation = [[Director sharedDirector] convertToGL: touchLocation];

  // calculate angle
  float a   = touchLocation.y - airplane.position.y;
  float b   = touchLocation.x - airplane.position.x;
  float rad = atan(b / a);
  float deg = (180.0 / M_PI) * rad;
  if (a < 0)
  {
    deg += 180;
  }
  current_heading_airplane = deg;
  id rotateto = [RotateTo actionWithDuration:1  angle: deg];
  [airplane runAction: rotateto];
}

-(void) updatePlayer: (ccTime) dt
{
  [self calculateMovementVector];
  [self updateSmokeTrail:dt];
}

@end
