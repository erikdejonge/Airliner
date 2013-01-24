//
//  player_hud.m
//  Tiletest
//
//  Created by rabshakeh on 11/24/09 - 1:49 PM.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "player_hud.h"
#import "player_airplane.h"
#import "m_worldclip.h"
#import "GameState.h"
#import "menu_main.h"
#import "menu_highscores.h"
#import "GameScene.h"
#import "LocalScore.h"

#define IADBANNERHEIGHT  32
#define HUDMARGIN        5

@implementation player_hud
enum
{
  kGameMenu,
  kGameMenuBG
};

-(void) updateGauge
{
  GameState *gs             = [GameState sharedInstance];
  float     onepercentscale = fuelgauge.contentSize.width / 100;
  float     scalex          = [gs getPercentageFuel] * onepercentscale;

  if ([gs getPercentageFuel] > 50) {
    gauge_green.visible  = YES;
    gauge_red.visible    = NO;
    gauge_orange.visible = NO;
    gauge_green.scaleX   = scalex;
    gauge_green.position = ccp((scalex / 2) + HUDMARGIN, (SCREENHEIGHT - (fuelgauge.contentSize.height / 2)) - HUDMARGIN);
  }
  else if ([gs getPercentageFuel] > 25 &&[gs getPercentageFuel] <= 50) {
    gauge_green.visible   = NO;
    gauge_red.visible     = NO;
    gauge_orange.visible  = YES;
    gauge_orange.scaleX   = scalex;
    gauge_orange.position = ccp((scalex / 2) + HUDMARGIN, (SCREENHEIGHT - (fuelgauge.contentSize.height / 2)) - HUDMARGIN);
  }
  else if ([gs getPercentageFuel] <= 25) {
    gauge_green.visible  = NO;
    gauge_red.visible    = YES;
    gauge_orange.visible = NO;
    gauge_red.scaleX     = scalex;
    gauge_red.position   = ccp((scalex / 2) + HUDMARGIN, (SCREENHEIGHT - (fuelgauge.contentSize.height / 2)) - HUDMARGIN);
  }
}

-(void) menuNewGame: (id) sender
{
  GameState *gs = [GameState sharedInstance];

  [gs setRemoveMenuEnabled:YES];

  if ([gs getEffects]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"menu_click1.wav"];
  }
  [gs newGame];
  [[CCDirector sharedDirector] replaceScene:[Game scene]];
}

-(void) menuMenu: (id) sender
{
  GameState *gs = [GameState sharedInstance];

  if ([gs getEffects]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"menu_click1.wav"];
  }

  [[CCDirector sharedDirector] replaceScene:[CCCrossFadeTransition transitionWithDuration:TRANS_DURATION scene:[MainMenu scene]]];
}

-(void) submitLocalScoreWithName: (NSString *) playername
{
  GameState  *gs     = [GameState sharedInstance];
  LocalScore *lscore = [[LocalScore alloc] init];

  lscore.playername = playername;
  lscore.score      = [NSNumber numberWithInt:[gs getScore]];
  [lscore insertIntoDatabase:[gs database]];
  [lscore release];
  [gs loadScoresFromDB];
}

-(BOOL) textFieldShouldReturn: (UITextField *) tf
{
  GameState *gs = [GameState sharedInstance];

  name = tf.text;
  [name retain];
  [tf resignFirstResponder];
  [[CCTouchDispatcher sharedDispatcher] setDispatchEvents: YES];
  NSString *playername = nameField.text;
  if (playername == nil || ([playername length] == 0)) {
    playername = @"Anonymous";
  }
  else {
    [gs setPlayerSavedName:playername];
  }
  [self submitLocalScoreWithName: playername];
  [nameField removeFromSuperview];
  [[CCDirector sharedDirector] replaceScene:[CCCrossFadeTransition transitionWithDuration:TRANS_DURATION scene:[HighscoreMenu scene]]];
  return(NO);
}


-(UITextField *) newTextField_Rounded
{
  GameState   *gs              = [GameState sharedInstance];
  UITextField *returnTextField = [[UITextField alloc] initWithFrame:CGRectZero];

  returnTextField.borderStyle = UITextBorderStyleRoundedRect;
  returnTextField.textColor   = [UIColor blackColor];
  returnTextField.font        = [UIFont fontWithName:@"CourierNewPS-BoldMT" size:24];
  returnTextField.placeholder = @"your name";
  if ([[gs getPlayerSavedName] length] != 0) {
    returnTextField.text = [gs getPlayerSavedName];
  }
  returnTextField.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f];

  returnTextField.autocorrectionType = UITextAutocorrectionTypeNo;              // no auto correction support
  returnTextField.textAlignment      = UITextAlignmentCenter;

  returnTextField.keyboardType  = UIKeyboardTypeDefault;
  returnTextField.returnKeyType = UIReturnKeyDone;

  returnTextField.clearButtonMode = UITextFieldViewModeWhileEditing;            // has a clear 'x' button to the right

  returnTextField.delegate = self;
  return([returnTextField autorelease]);
}

-(void) menuSaveScores: (id) sender
{
  GameState *gs = [GameState sharedInstance];

  if ([gs getEffects]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"menu_click1.wav"];
  }

  [m_world_layer removeChild:menu_game_over cleanup:YES];
  [m_world_layer removeChild:gameovermenu cleanup:YES];

  menu_game_over          = [CCSprite spriteWithFile:@"menu-save-bg-overlay.png"];
  menu_game_over.position = ccp(SCREENWIDTH / 2, SCREENHEIGHT / 2);
  [m_world_layer addChild:menu_game_over z:10 tag:kGameMenuBG];

  nameField = [self newTextField_Rounded];
  CGRect frame = CGRectMake(130.0f, 230.0f, 200, 36);
  nameField.frame     = frame;
  nameField.transform = CGAffineTransformMakeRotation((float)M_PI / 2.0f);   // 180 degrees
  [[[CCDirector sharedDirector] openGLView] addSubview: nameField];
  [nameField becomeFirstResponder];
}

-(void) updateHud: (CCLayer *) world_layer dt: (ccTime) dt mx: (float) mx my: (float) my airplane_rotation: (float) arot
{
  GameState *gs = [GameState sharedInstance];

  m_dt = dt;

  if ([gs getRemoveMenuEnabled] == YES) {
    [world_layer removeChildByTag:kGameMenu cleanup:YES];
    [gs setRemoveMenuEnabled:NO];
  }
  if ([gs getPlayerState] == GAMEOVER) {
    if (NO == game_over_menu_drawn) {
      game_over_menu_drawn    = YES;
      menu_game_over          = [CCSprite spriteWithFile:@"menu-game-over-bg.png"];
      menu_game_over.position = ccp(SCREENWIDTH / 2, SCREENHEIGHT / 2);
      [world_layer addChild:menu_game_over z:10 tag:kGameMenuBG];
      m_world_layer = world_layer;
      CCMenuItemImage *newgamei = [CCMenuItemImage itemFromNormalImage:@"menu-game-over-btn-new.png" selectedImage:@"menu-game-over-btn-new-click.png" target:self selector:@selector(menuNewGame:)];
      CCMenuItemImage *savei    = [CCMenuItemImage itemFromNormalImage:@"menu-game-over-btn-save.png" selectedImage:@"menu-game-over-btn-save-click.png" target:self selector:@selector(menuSaveScores:)];
      CCMenuItemImage *menui    = [CCMenuItemImage itemFromNormalImage:@"menu-game-over-btn-menu.png" selectedImage:@"menu-game-over-btn-menu-click.png" target:self selector:@selector(menuMenu:)];

      gameovermenu = [CCMenu menuWithItems:newgamei, savei, menui, nil];
      [gameovermenu alignItemsVerticallyWithPadding:1];
      gameovermenu.position = ccp(SCREENWIDTH / 2, 140);
      [world_layer addChild: gameovermenu z:10 tag:kGameMenu];
    }
  }
  else{
    time_tracker          += dt;
    time_tracker_smallmap += dt;
    run_time              += dt;
    smallplane.rotation    = arot;
    if (time_tracker >= 0.1) {
      time_tracker = 0.0;
      GameState *gs = [GameState sharedInstance];

      if ([gs getPercentageFuel] <= 0) {
        [gs setPercentageFuel:0];
        GameState *gs = [GameState sharedInstance];
        if ([gs getPlayerState] == FLYING) {
          [gs decreaseLive];
          [self animationNewLive];
          [gs setPlayerState:TARGETMISSED];
          if ([gs getEffects]) {
            [[SimpleAudioEngine sharedEngine] playEffect:@"target_missed.wav"];
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
          }
        }
      }
      [self updateGauge];
    }

    NSString *displaystring;
    if (AUTOFLYING ==[gs getPlayerState]) {
      displaystring = [NSString stringWithFormat:@"Time is up: %@", [gs getdestinationString]];
    }
    else {
      displaystring = [NSString stringWithFormat:@"Fly to: %@", [gs getdestinationString]];
    }
    [destlabel setString:displaystring];
    //[destlabel setString:[NSString stringWithFormat:@"%@ %.2f", displaystring, [gs getPixelsTraveled]]];
    destlabel.position = ccp(HUDMARGIN + (destlabel.contentSize.width / 2), fuelgauge.position.y - destlabel.contentSize.height);

    //[score setString:[NSString stringWithFormat:@"%d", [gs getScore]]];
    [score setString:[gs commaSeparateThousands:[gs getScore]]];
    score.position = ccp((smallmap.position.x - (smallmap.contentSize.width / 2)) + (score.contentSize.width / 2) + HUDMARGIN, (smallmap.position.y - (smallmap.contentSize.height / 2)) + (score.contentSize.height / 2));

    // small map
    if (time_tracker_smallmap >= 0.5) {
      time_tracker_smallmap = 0.0;

      float   xperc               = (float)abs(mx) / (WORLD_WIDTH / 100);
      float   yperc               = (float)abs(my) / (WORLD_HEIGHT / 100);
      CGPoint smallplane_position = ccp((SCREENWIDTH - (smallmap.contentSize.width)) - HUDMARGIN, IADBANNERHEIGHT + HUDMARGIN);
      smallplane_position.x += (xperc * (smallmap.contentSize.width / 100)) + 5;
      smallplane_position.y += (yperc * (smallmap.contentSize.height / 100) + 5);
      // keep small airplane in the small map
      if ((smallplane_position.x - (smallplane.contentSize.width / 2) - HUDMARGIN) <= (smallmap.position.x - (smallmap.contentSize.width / 2))) {
        smallplane_position.x = smallmap.position.x - (smallmap.contentSize.width / 2) + (smallplane.contentSize.width / 2);
      }
      if ((smallplane_position.x + (smallplane.contentSize.width / 2)) >= (smallmap.position.x + (smallmap.contentSize.width / 2))) {
        smallplane_position.x = smallmap.position.x + (smallmap.contentSize.width / 2) - (smallplane.contentSize.width / 2);
      }
      if ((smallplane_position.y + (smallplane.contentSize.height / 2)) >= (smallmap.position.y + (smallmap.contentSize.height / 2))) {
        smallplane_position.y = (smallmap.position.y + (smallmap.contentSize.height / 2)) - (smallplane.contentSize.height / 2);
      }
      if ((smallplane_position.y - (smallplane.contentSize.height / 2)) <= (smallmap.position.y - (smallmap.contentSize.height / 2))) {
        smallplane_position.y = (smallmap.position.y - (smallmap.contentSize.height / 2)) + (smallplane.contentSize.height / 2);
      }
      [smallplane runAction:[CCMoveTo actionWithDuration:0.6 position:smallplane_position]];
    }
    if ([gs getTargetsRequested] < 4) {
      CGPoint nt     = [gs getCurrentTarget];
      float   xperc  = (float)abs(nt.x) / (WORLD_WIDTH / 100);
      float   yperc  = (float)abs(nt.y) / (WORLD_HEIGHT / 100);
      CGPoint dotpos = ccp((SCREENWIDTH - (smallmap.contentSize.width)) - HUDMARGIN, IADBANNERHEIGHT + HUDMARGIN);
      dotpos.x           += (xperc * (smallmap.contentSize.width / 100)) - 2;
      dotpos.y           += (yperc * (smallmap.contentSize.height / 100));
      reddots[0].position = dotpos;
      reddots[0].visible  = YES;
      /*
         int counter = 0;
         if ([gs getTargetsRequested] >= 3 &&[gs getTargetsRequested] < 5) {
         counter = 2;
         }
         else if ([gs getTargetsRequested] >= 5 &&[gs getTargetsRequested] < 10) {
         counter = 3;
         }
         else if ([gs getTargetsRequested] >= 10 &&[gs getTargetsRequested] < 30) {
         counter = NUMREDDOTS;
         }
         for (int i = 1; i < counter; i++) {
         CGPoint nt     = [gs getRandomPointForTarget:i];
         float   xperc  = (float)abs(nt.x) / (WORLD_WIDTH / 100);
         float   yperc  = (float)abs(nt.y) / (WORLD_HEIGHT / 100);
         CGPoint dotpos = ccp((SCREENWIDTH - (smallmap.contentSize.width)) - HUDMARGIN, IADBANNERHEIGHT + HUDMARGIN);
         dotpos.x           += (xperc * (smallmap.contentSize.width / 100));
         dotpos.y           += (yperc * (smallmap.contentSize.height / 100));
         reddots[i].position = dotpos;
         reddots[i].visible  = YES;
         }
       */
    }
    else {
      for (int i = 0; i < NUMREDDOTS; i++) {
        reddots[i].visible = NO;
      }
    }
  }

  turbotimetracker += dt;
  if (([gs getTurbo] == 1) && (turbotimetracker > 2) && (turbo_btn_down == NO)) {
    [gs setTurbo:0];
    turbo_on.visible = NO;
    turbo.visible    = YES;
    turbo_btn_down   = NO;
  }
}

-(void) animationNewLive
{
  GameState *gs = [GameState sharedInstance];

  CCSprite  *as = [lifesleft objectAtIndex:[gs getNumLives]];
  CGPoint   np  = as.position;

  [[lifesleft objectAtIndex:[gs getNumLives]] runAction:[CCMoveTo actionWithDuration:1 position:ccp(np.x, np.y + 30)]];
}

-(void) turboBtnUp
{
  turbo_btn_down = NO;
}

-(BOOL) possibleTurboTouch: (CGPoint) tl action: (BOOL) ba
{
  float     x = turbo.position.x - ([turbo contentSize].width / 2);
  float     y = turbo.position.y - ([turbo contentSize].height / 2);
  float     h = turbo.contentSize.height;
  float     w = turbo.contentSize.width;

  CGRect    rect = CGRectMake(x, y, w, h);
  GameState *gs  = [GameState sharedInstance];

  if (FLYING !=[gs getPlayerState]) {
    return(YES);
  }
  if (CGRectContainsPoint(rect, tl)) {
    if (ba) {
      if ([gs getTurbo] == 1) {
        [gs setTurbo:0];
        turbo_on.visible = NO;
        turbo.visible    = YES;
      }
      else{
        if ([gs getEffects]) {
          [[SimpleAudioEngine sharedEngine] playEffect:@"snd-cabin.wav"];
        }
        [gs setTurbo:1];
        turbotimetracker = m_dt;
        turbo_on.visible = YES;
        turbo.visible    = NO;
        turbo_btn_down   = YES;
      }
    }
    return(YES);
  }

  return(NO);
}

-(BOOL) possiblePauseTouch: (CGPoint) tl action: (BOOL) ba
{
  float  x = pause_btn.position.x - ([pause_btn contentSize].width / 2);
  float  y = pause_btn.position.y - ([pause_btn contentSize].height / 2);
  float  h = pause_btn.contentSize.height;
  float  w = pause_btn.contentSize.width;

  CGRect rect = CGRectMake(x, y, w, h);

  if (CGRectContainsPoint(rect, tl)) {
    if (ba) {
      GameState *gs = [GameState sharedInstance];
      [gs setResuming:YES];
      [gs saveState];
      [[CCDirector sharedDirector] replaceScene:[CCCrossFadeTransition transitionWithDuration:TRANS_DURATION scene:[MainMenu scene]]];
      if ([gs getEffects]) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"menu_click1.wav"];
      }
    }
    return(YES);
  }
  return(NO);
}


-(BOOL) possibleSkipTouch: (CGPoint) tl action: (BOOL) ba
{
  float  x = 440; //destlabel.position.x - ([pause_btn contentSize].width / 2);
  float  y = 280; //destlabel.position.y - ([pause_btn contentSize].height / 2);
  float  h = 40;  //destlabel.contentSize.height;
  float  w = 40;  //destlabel.contentSize.width;

  CGRect rect = CGRectMake(x, y, w, h);

  if (CGRectContainsPoint(rect, tl)) {
    if (ba) {
      GameState *gs = [GameState sharedInstance];
      [gs setPercentageFuel:0];
    }
    return(YES);
  }
  return(NO);
}

-(void) initHud: (CCLayer *) world_layer
{
  GameState *gs = [GameState sharedInstance];

  turbo_btn_down       = NO;
  game_over_menu_drawn = NO;
  fuelgauge            = [[CCSprite spriteWithFile:@"time-left-bg.png"] retain];
  fuelgauge.position   = ccp((fuelgauge.contentSize.width / 2) + HUDMARGIN, (SCREENHEIGHT - (fuelgauge.contentSize.height / 2)) - HUDMARGIN);
  [world_layer addChild:fuelgauge z:6];

  [CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGB565];
  for (int i = 0; i < NUMREDDOTS; i++) {
    reddots[i] = [[CCSprite spriteWithFile:@"reddot.png"] retain];
    [[reddots[i] texture]  setAliasTexParameters];
    reddots[i].visible = NO;
    [world_layer addChild:reddots[i] z:7];
  }
  [CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];

  gauge_red    = [[CCSprite spriteWithFile:@"time-left-red.png"] retain];
  gauge_orange = [[CCSprite spriteWithFile:@"time-left-orange.png"] retain];
  gauge_green  = [[CCSprite spriteWithFile:@"time-left-green.png"] retain];

  [self updateGauge];
  [world_layer addChild:gauge_red z:6];
  [world_layer addChild:gauge_orange z:6];
  [world_layer addChild:gauge_green z:6];

  //destlabel          = [Label labelWithString:@"" dimensions:CGSizeMake(fuelgauge.contentSize.width, 20) alignment: UITextAlignmentLeft fontName:@"OCRAStd.ttf" fontSize:14];
  destlabel = [CCBitmapFontAtlas bitmapFontAtlasWithString:@"Destination:" fntFile:@"OCRAStd.fnt"];
  [[destlabel texture]  setAliasTexParameters];
  destlabel.position = ccp(HUDMARGIN + (destlabel.contentSize.width / 2), fuelgauge.position.y - destlabel.contentSize.height);
  [world_layer addChild: destlabel z:6];

  if (NO ==[gs fastMachine]) {
    [CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGB565];
  }
  smallmap          = [[CCSprite spriteWithFile:@"world-small-map.png"] retain];
  smallmap.position = ccp((SCREENWIDTH - (smallmap.contentSize.width / 2)) - HUDMARGIN, IADBANNERHEIGHT + HUDMARGIN + (smallmap.contentSize.height / 2));
  [[smallmap texture]  setAliasTexParameters];
  [world_layer addChild:smallmap z:6];
  if (NO ==[gs fastMachine]) {
    [CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];
  }

  smallplane          = [[CCSprite spriteWithFile:@"world-small-plane.png"] retain];
  smallplane.rotation = AIRPLANE_START_ORIENTATION;
  smallplane.position = smallmap.position;
  [world_layer addChild:smallplane z:8];

  score          = [CCBitmapFontAtlas bitmapFontAtlasWithString:@"0" fntFile:@"OCRAStd.fnt"];
  score.position = ccp((smallmap.position.x - (smallmap.contentSize.width / 2)) + (score.contentSize.width / 2) + HUDMARGIN, (smallmap.position.y - (smallmap.contentSize.height / 2)) + (score.contentSize.height / 2));
  [world_layer addChild: score z:6];

  lifesleft = [[NSMutableArray alloc] initWithCapacity:[gs getNumLives]];
  for (int i = 0; i <[gs getNumLives]; i++) {
    [lifesleft addObject:[CCSprite spriteWithFile:@"life-left.png"]];
    CCSprite *as         = [lifesleft objectAtIndex:i];
    CGPoint  as_position = as.position;
    as_position.x = fuelgauge.position.x + (fuelgauge.contentSize.width / 2) + 12 + i * (as.contentSize.width + 1);
    as_position.y = fuelgauge.position.y -[gs getNumLives];
    as.position   = as_position;
    [world_layer addChild:as];
  }

  time_tracker_smallmap = time_tracker = run_time = 0.0;

  turbo = [[CCSprite spriteWithFile:@"hud-btn-turbo.png"] retain];
  [[turbo texture] setAliasTexParameters];
  turbo_on = [[CCSprite spriteWithFile:@"hud-btn-turbo-engaged.png"] retain];
  [[turbo_on texture] setAliasTexParameters];
  turbo.position    = ccp(HUDMARGIN + (turbo.contentSize.width / 2), IADBANNERHEIGHT * 2 + HUDMARGIN + (turbo.contentSize.height / 2));
  turbo_on.position = ccp(HUDMARGIN + (turbo.contentSize.width / 2), IADBANNERHEIGHT * 2 + HUDMARGIN + (turbo.contentSize.height / 2));
  [world_layer addChild:turbo z:6];
  [world_layer addChild:turbo_on z:6];
  turbo_on.visible = NO;

  pause_btn          = [[CCSprite spriteWithFile:@"world-small-pause.png"] retain];
  pause_btn.position = ccp(smallmap.position.x + (smallmap.contentSize.width / 2) - HUDMARGIN * 2, smallmap.position.y - (smallmap.contentSize.height / 2) + (HUDMARGIN * 2));
  [world_layer addChild:pause_btn z:7];
  [[pause_btn texture] setAliasTexParameters];
}

@end

