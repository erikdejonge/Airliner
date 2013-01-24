//
//  player_hud.m
//  Tiletest
//
//  Created by rabshakeh on 11/24/09 - 1:49 PM.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "player_hud.h"
#import "m_worldclip.h"
#import "TiletestAppDelegate.h"

#define HUDMARGIN  2

@implementation player_hud

-(void) updateGauge
{
  float onepercentscale = fuelgauge.contentSize.width / 100;
  float scalex          = gauge_percentage * onepercentscale;

  if (gauge_percentage > 50)
  {
    gauge_green.visible  = YES;
    gauge_red.visible    = NO;
    gauge_orange.visible = NO;
    gauge_green.scaleX   = scalex;
    gauge_green.position = ccp((scalex / 2) + HUDMARGIN, SCREENHEIGHT - 10);
  }
  if (gauge_percentage > 25 && gauge_percentage <= 50)
  {
    gauge_green.visible   = NO;
    gauge_red.visible     = NO;
    gauge_orange.visible  = YES;
    gauge_orange.scaleX   = scalex;
    gauge_orange.position = ccp((scalex / 2) + HUDMARGIN, SCREENHEIGHT - 10);
  }
  if (gauge_percentage <= 25)
  {
    gauge_green.visible  = NO;
    gauge_red.visible    = YES;
    gauge_orange.visible = NO;
    gauge_red.scaleX     = scalex;
    gauge_red.position   = ccp((scalex / 2) + HUDMARGIN, SCREENHEIGHT - 10);
  }
}

-(void) updateHud: (ccTime) dt
{
  time_tracker += dt;
  run_time     += dt;
  if (time_tracker >= 0.1)
  {
    time_tracker = 0.0;
    TiletestAppDelegate *appDelegate   = [[UIApplication sharedApplication] delegate];
    NSString            *displaystring = [NSString stringWithFormat:@"%@", appDelegate.debugstring];
    [debug setString:displaystring];
    displaystring = [NSString stringWithFormat:@"%@", appDelegate.displaystring];
    [destlabel setString:displaystring];
    gauge_percentage -= dt * 10;
    if (gauge_percentage <= 0)
    {
      gauge_percentage = 100;
    }
    [self updateGauge];
  }
}

-(void) initHud: (Layer *) world_layer
{
  fuelgauge          = [[Sprite spriteWithFile:@"time-left-bg.png"] retain];
  fuelgauge.position = ccp((fuelgauge.contentSize.width / 2) + HUDMARGIN, SCREENHEIGHT - 10);
  [world_layer addChild:fuelgauge];

  gauge_red    = [[Sprite spriteWithFile:@"time-left-red.png"] retain];
  gauge_orange = [[Sprite spriteWithFile:@"time-left-orange.png"] retain];
  gauge_green  = [[Sprite spriteWithFile:@"time-left-green.png"] retain];

  gauge_percentage = 100;
  [self updateGauge];
  [world_layer addChild:gauge_red];
  [world_layer addChild:gauge_orange];
  [world_layer addChild:gauge_green];

  debug          = [Label labelWithString:@"" dimensions:CGSizeMake(180, 20) alignment: UITextAlignmentLeft fontName:@"OCRAStd.ttf" fontSize:12];
  debug.position = ccp(HUDMARGIN + (debug.contentSize.width / 2), 30);
  [world_layer addChild:debug];

  destlabel          = [Label labelWithString:@"" dimensions:CGSizeMake(fuelgauge.contentSize.width, 20) alignment: UITextAlignmentLeft fontName:@"OCRAStd.ttf" fontSize:14];
  destlabel.position = ccp(HUDMARGIN + (destlabel.contentSize.width / 2), fuelgauge.position.y - destlabel.contentSize.height);
  [world_layer addChild: destlabel];
  time_tracker = run_time = 0.0;
}
@end
