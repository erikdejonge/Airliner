//
//  player_hud.h
//  Tiletest
//
//  Created by rabshakeh on 11/24/09 - 1:49 PM.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface player_hud : NSObject {
  LabelAtlas  *destlabel, *debug;
  float       time_tracker, run_time;
  AtlasSprite *fuelgauge, *gauge_green, *gauge_orange, *gauge_red;
  float       gauge_percentage;
}

-(void)initHud   : (Layer *)world_layer;
-(void)updateHud : (ccTime)dt;

@end
