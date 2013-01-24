//
//  m_worldclip.m
//  Tiletest
//
//  Created by rabshakeh on 11/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "m_worldclip.h"
#import "player_airplane.h"
#import "TiletestAppDelegate.h"

@implementation m_worldclip

@synthesize mapx;
@synthesize mapy;

-(void) preloadImages
{
  for (int i = 0; i < NUM_LAYERS; i++)
  {
    [[TextureMgr sharedTextureMgr] addImage:[NSString stringWithFormat:@"s%d.png", i]];
  }
}

-(void) initWorldMap: (Layer *) world_layer
{
  [self preloadImages];

  background = [TMXTiledMap tiledMapWithTMXFile:@"background.tmx"];
  map        = [TMXTiledMap tiledMapWithTMXFile:@"airlinermainmapbigtiles.tmx"];
  map_helper = [TMXTiledMap tiledMapWithTMXFile:@"airlinermainmapbigtiles.tmx"];

  for (AtlasSpriteManager *child in[background children])
  {
    [[child texture] setAliasTexParameters];
  }
  for (AtlasSpriteManager *child in[map children])
  {
    [[child texture] setAliasTexParameters];
  }
  for (AtlasSpriteManager *child in[map_helper children])
  {
    [[child texture] setAliasTexParameters];
  }

  [world_layer addChild:background z:-3 tag:kTagBackground];
  [world_layer addChild:map_helper z:-2 tag:kTagTileMapX];
  [world_layer addChild:map z:-1 tag:kTagTileMap];

  CGPoint mpos;
  mpos.x = -(WORLD_WIDTH / 2) + 700;
  mpos.y = -(WORLD_HEIGHT / 2);
  //mpos   = ccp(-100, 0);

  map.position       = mpos;
  map_helper.visible = NO;
  /*
         a tilemap has multiple layers, calculate the offset for every tile in order to clip them
   */
  int layerid  = 0;        //start at the top row
  int numtiles = 0;

  for (TMXLayer *layer in[map children])
  {
    CGSize s = [layer layerSize];
    numtiles = 0;
    for (int x = 0; x < s.width; x++)
    {
      for (int y = 0; y < s.height; y++)
      {
        unsigned int tmpgid = [layer tileGIDAt:ccp(x, y)];
        if (tmpgid != 0)
        {
          CGPoint tp;
          tp.x                            = x * 32;
          tp.y                            = WORLD_HEIGHT - (y * 32);
          tileposlayer[layerid][numtiles] = tp;
          numtiles++;
        }
      }
    }
    layerid++;
  }
}

-(void) moveWorldMapForPlayer: (ccTime) delta_time vector_x_delta: (float) vxd vector_y_delta: (float) vyd airplane_rotation: (float) a_rot targets: (m_targets *) targets
{
  CGPoint map_position = [map position];

  map_position.x -= (vxd * AIRPLANE_SPEED) * delta_time;

  if (a_rot > 90 && a_rot < 270)
  {
    map_position.y += (vyd * AIRPLANE_SPEED) * delta_time;
  }
  else
  {
    map_position.y -= (vyd * AIRPLANE_SPEED) * delta_time;
  }

  CGPoint helper_map_position = map_position;

  // scroll of the right
  if (map_position.x > 0)
  {
    helper_map_position.y = map_position.y;
    helper_map_position.x = map_position.x - WORLD_WIDTH;
    map_helper.visible    = YES;
  }
  if (map_position.x > SCREENWIDTH)
  {
    map_position.x        = (-WORLD_WIDTH) + SCREENWIDTH;
    helper_map_position.x = SCREENWIDTH + 1;
    map_helper.visible    = NO;
  }

  // scroll off the left
  if (map_position.x < -(WORLD_WIDTH - SCREENWIDTH))
  {
    helper_map_position.x = map_position.x + WORLD_WIDTH;
    helper_map_position.y = map_position.y;
    map_helper.visible    = YES;
  }
  if (map_position.x + WORLD_WIDTH < 0)
  {
    map_helper.visible    = NO;
    helper_map_position.x = SCREENWIDTH + 1;
    map_position.x        = map_position.x + WORLD_WIDTH;
  }

  TiletestAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
  appDelegate.debugstring = [NSString stringWithFormat:@"%.1f", map_position.x];

  // reposition y map
  if (map_position.y < -(WORLD_HEIGHT))
  {
    map_position.y = SCREENHEIGHT;
  }
  else if (map_position.y > SCREENHEIGHT)
  {
    map_position.y = -WORLD_HEIGHT;
  }

  // determine if we need to show the background layer.
  if (map_position.y > 0 || map_position.y < -(WORLD_HEIGHT - SCREENHEIGHT))
  {
    background.visible = YES;
  }
  else
  {
    background.visible = NO;
  }

  map_helper.position = helper_map_position;
  map.position        = map_position;
  mapx                = map.position.x;
  mapy                = map.position.y;

  int lc = 0;
  for (TMXLayer *child in[map children])
  {
    child.visible = NO;
    for (int tc = 0; tc < NUM_TILES_PER_LAYER; tc++)
    {
      int tx = tileposlayer[lc][tc].x;
      int ty = tileposlayer[lc][tc].y;

      int tcx = tx + map_position.x;
      int tcy = ty + map_position.y;

      if ((tcx + TILESIZE > 0 && tcx < SCREENWIDTH) &&
          (tcy + TILESIZE > 0 && tcy < SCREENHEIGHT + TILESIZE))
      {
        child.visible = YES;
        break;
      }
    }
    lc++;
  }

  lc = 0;
  for (TMXLayer *child in[map_helper children])
  {
    child.visible = NO;
    for (int tc = 0; tc < NUM_TILES_PER_LAYER; tc++)
    {
      int tx = tileposlayer[lc][tc].x;
      int ty = tileposlayer[lc][tc].y;

      int tcx = tx + helper_map_position.x;
      int tcy = ty + helper_map_position.y;

      if ((tcx + TILESIZE > 0 && tcx < SCREENWIDTH) &&
          (tcy + TILESIZE > 0 && tcy < SCREENHEIGHT + TILESIZE))
      {
        child.visible = YES;
        break;
      }
    }
    lc++;
  }
}

@end
