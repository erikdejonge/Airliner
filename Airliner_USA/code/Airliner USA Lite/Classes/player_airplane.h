//
//  player_airplane.h
//  Tiletest
//
//  Created by rabshakeh on 11/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "m_worldclip.h"

#define NUM_SMOKE_TRAIL  60
#define SMOKETRAIL_TIME  0.03

@interface player_airplane : NSObject {
  CCSprite *airplane;
  float    current_heading_airplane,
           vector_x_delta,
           vector_y_delta;

  // smoke trail data
  CCSprite  *smoke_trail[NUM_SMOKE_TRAIL];
  CCFadeOut *smoke_trail_faders[NUM_SMOKE_TRAIL];

  int       smoke_trail_part_counter;
  float     smoke_trail_time_tracker;

  float     autopilot_time_tracker;
  int       autopilotwaitforcorrection;
  int       autopilotmisses;

  float     lastmapsteer;
}

@property  (readonly) float    vector_x_delta;
@property  (readonly) float    vector_y_delta;
@property  (readonly) CCSprite *airplane;

-(void)initAirplane          : (CCLayer *)world_layer;
-(void)changePlayerDirection : (CGPoint) touchLocation duration : (float)dur;
-(void)updatePlayer          : (ccTime)dt;

@end
