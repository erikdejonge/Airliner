//
//  m_cloudlayer.m
//  Tiletest
//
//  Created by rabshakeh on 11/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "m_cloudlayer.h"
#import "m_worldclip.h"
#import "player_airplane.h"
#import "UIDeviceAirliner.h"

@implementation m_clouds

#define NUM_CLOUDS_IMAGES  15

-(void) preloadImages
{
  for (int i = 0; i < NUM_CLOUDS_IMAGES; i++)
  {
    [[TextureMgr sharedTextureMgr] addImage:[NSString stringWithFormat:@"cloud-%d.png", i]];
  }
}

-(void) initCloudLayer: (Layer *) world_layer cloud_multiplier: (int) cloud_multiplier numclouds: (int) numclouds
{
  clouds           = [[NSMutableArray alloc] initWithCapacity:NUM_CLOUDS_STRATUS];
  cloud_multiplier = 1;
  UIDeviceAirliner *uda = [UIDeviceAirliner alloc];
  if (NO ==[uda fastMachine])
  {
    fast_machine = NO;
    numclouds    = 1;
  }
  else
  {
    fast_machine = YES;
  }
  [uda release];

  for (int i = 0; i < numclouds; i++)
  {
    AtlasSprite *cloud  = [[Sprite spriteWithFile:[NSString stringWithFormat:@"cloud-%d.png", arc4random() % NUM_CLOUDS_IMAGES]] retain];
    int         cwidth  = cloud.contentSize.width;
    int         cheight = cloud.contentSize.height;

    //[name release];
    CGPoint cloud_pos = ccp((WORLD_WIDTH * cloud_multiplier) - (arc4random() % (WORLD_WIDTH * cloud_multiplier * 2)), (WORLD_HEIGHT * cloud_multiplier) - (arc4random() % (WORLD_HEIGHT * cloud_multiplier * 2)));
    cloud.visible = NO;
    if ((cloud_pos.x + (cwidth / 2) > 0 && cloud_pos.x - (cwidth / 2) < SCREENWIDTH) || (cloud_pos.y + (cheight / 2) > 0 && cloud_pos.y + (cheight / 2) < SCREENHEIGHT))
    {
      cloud.visible = YES;
    }
    cloud.position = cloud_pos;
    [world_layer addChild:cloud];
    [clouds addObject:cloud];
    [cloud release];
  }
}

-(void) updateCloudPositions: (ccTime) delta_time cloud_speed: (int) cloud_speed cloud_multiplier: (int) cloud_multiplier vector_x_delta: (float) vxd vector_y_delta: (float) vyd airplane_rotation: (float) a_rot
{
  if (!fast_machine)
  {
    return;
  }
  for (AtlasSprite *cloud in clouds)
  {
    CGPoint cloud_pos = cloud.position;
    int     cwidth    = cloud.contentSize.width;
    int     cheight   = cloud.contentSize.height;

    cloud_pos.x -= (vxd * cloud_speed) * delta_time;

    if (a_rot > 90 && a_rot < 270)
    {
      cloud_pos.y += (vyd * cloud_speed) * delta_time;
    }
    else
    {
      cloud_pos.y -= (vyd * cloud_speed) * delta_time;
    }

    cloud.visible = NO;
    if ((cloud_pos.x + (cwidth / 2) >= 0 && cloud_pos.x - (cwidth / 2) < SCREENWIDTH) || (cloud_pos.y + (cheight / 2) > 0 && cloud_pos.y + (cheight / 2) < SCREENHEIGHT))
    {
      cloud.visible = YES;
    }

    if (cloud_pos.x < -(WORLD_WIDTH * cloud_multiplier))
    {
      cloud_pos.x = SCREENWIDTH + cwidth;
    }
    if (cloud_pos.x > WORLD_WIDTH * cloud_multiplier)
    {
      cloud_pos.x = -(SCREENWIDTH - cwidth);
    }

    // scroll of top
    if (cloud_pos.y < -(WORLD_HEIGHT * cloud_multiplier))
    {
      cloud_pos.y = SCREENHEIGHT + cheight;
    }
    else if (cloud_pos.y > WORLD_HEIGHT * cloud_multiplier)
    {
      cloud_pos.y = -(SCREENHEIGHT + cheight);
    }

    cloud.position = cloud_pos;
  }
}

@end

@implementation m_low_clouds

-(void) initCloudLayer: (Layer *) world_layer
{
  [super initCloudLayer:world_layer cloud_multiplier:LOW_CLOUD_MULTIPLIER numclouds:NUM_CLOUDS_LOW];
}

-(void) updateCloudPositions: (ccTime) delta_time vector_x_delta: (float) vxd vector_y_delta: (float) vyd airplane_rotation: (float) a_rot
{
  [super updateCloudPositions:delta_time cloud_speed:LOW_CLOUD_SPEED cloud_multiplier:LOW_CLOUD_MULTIPLIER vector_x_delta:vxd vector_y_delta:vyd airplane_rotation:a_rot];
}

@end

@implementation m_mid_clouds

-(void) initCloudLayer: (Layer *) world_layer
{
  [super initCloudLayer:world_layer cloud_multiplier:MID_CLOUD_MULTIPLIER numclouds:NUM_CLOUDS_MID];
}

-(void) updateCloudPositions: (ccTime) delta_time vector_x_delta: (float) vxd vector_y_delta: (float) vyd airplane_rotation: (float) a_rot
{
  [super updateCloudPositions:delta_time cloud_speed:MID_CLOUD_SPEED cloud_multiplier:MID_CLOUD_MULTIPLIER vector_x_delta:vxd vector_y_delta:vyd airplane_rotation:a_rot];
}

@end


@implementation m_high_clouds

-(void) initCloudLayer: (Layer *) world_layer
{
  [super initCloudLayer:world_layer cloud_multiplier:HIGH_CLOUD_MULTIPLIER numclouds:NUM_CLOUDS_HIGH];
}

-(void) updateCloudPositions: (ccTime) delta_time vector_x_delta: (float) vxd vector_y_delta: (float) vyd airplane_rotation: (float) a_rot
{
  [super updateCloudPositions:delta_time cloud_speed:HIGH_CLOUD_SPEED cloud_multiplier:HIGH_CLOUD_MULTIPLIER vector_x_delta:vxd vector_y_delta:vyd airplane_rotation:a_rot];
}

@end

@implementation m_stratus_clouds

-(void) initCloudLayer: (Layer *) world_layer
{
  [super initCloudLayer:world_layer cloud_multiplier:STRATUS_CLOUD_MULTIPLIER numclouds:NUM_CLOUDS_STRATUS];
}

-(void) updateCloudPositions: (ccTime) delta_time vector_x_delta: (float) vxd vector_y_delta: (float) vyd airplane_rotation: (float) a_rot
{
  [super updateCloudPositions:delta_time cloud_speed:STRATUS_CLOUD_SPEED cloud_multiplier:STRATUS_CLOUD_MULTIPLIER vector_x_delta:vxd vector_y_delta:vyd airplane_rotation:a_rot];
}

@end
