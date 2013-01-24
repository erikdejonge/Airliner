//
//  m_worldclip.h
//  Tiletest
//
//  Created by rabshakeh on 11/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "cocos2d.h"
#import "m_target.h"

#define NUM_TILES_PER_LAYER  1024
#define NUM_LAYERS           8
#define TILESIZE             32

enum
{
  kTagTileMap=1,
  kTagTileMapX,
  kTagBackground,
};

@interface m_worldclip : NSObject {
  CGPoint       tileposlayer[NUM_LAYERS][NUM_TILES_PER_LAYER];
  CCTMXTiledMap *background, *map;
}

-(void)initWorldMap          : (CCLayer *)world_layer;
-(void)moveWorldMapForPlayer : (ccTime) delta_time vector_x_delta : (float)vxd vector_y_delta : (float)vyd airplane_rotation : (float)a_rot targets : (m_targets *)targets;

@end
