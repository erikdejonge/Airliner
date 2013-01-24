//
//  player_airplane.h
//  Tiletest
//
//  Created by rabshakeh on 11/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "m_worldclip.h"

#define AIRPLANE_SPEED             90
#define NUM_SMOKE_TRAILS           60
#define AIRPLANE_STARTORIENTATION  90
#define SMOKETRAIL_TIME            0.03
#define MAXRANGEPLANE              5584                                       // in pixels, hud update time 0.1, player speed 90

@interface player_airplane : NSObject {
  AtlasSprite *airplane;
  float       current_heading_airplane,
              vector_x_delta,
              vector_y_delta;

  // smoke trail data
  AtlasSprite *smoke_trail[NUM_SMOKE_TRAILS];
  FadeOut     *smoke_trail_faders[NUM_SMOKE_TRAILS];

  int         smoke_trail_part_counter;
  float       smoke_trail_time_tracker;
  bool        fast_machine;
}

@property  (readonly) float       vector_x_delta;
@property  (readonly) float       vector_y_delta;
@property  (readonly) AtlasSprite *airplane;

-(void)initAirplane          : (Layer *)world_layer;
-(void)changePlayerDirection : (UITouch *)touch;
-(void)updatePlayer          : (ccTime)dt;

@end
