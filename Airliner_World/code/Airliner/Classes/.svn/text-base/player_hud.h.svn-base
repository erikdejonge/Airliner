//
//  player_hud.h
//  Tiletest
//
//  Created by rabshakeh on 11/24/09 - 1:49 PM.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "GameState.h"

@interface player_hud : NSObject<UIAlertViewDelegate, UITextFieldDelegate> {
  CCBitmapFontAtlas *destlabel, *score;
  float             time_tracker, run_time, time_tracker_smallmap;
  CCSprite          *fuelgauge, *gauge_green, *gauge_orange, *gauge_red, *smallmap, *smallplane, *turbo, *turbo_on, *pause_btn;
  NSMutableArray    *lifesleft;
  BOOL              game_over_menu_drawn, turbo_btn_down;
  UITextField       *nameField;
  UIToolbar         *toolbar;
  NSString          *name;
  CCLayer           *m_world_layer;
  CCMenu            *gameovermenu;
  CCSprite          *menu_game_over;
  CCSprite          *reddots[NUMREDDOTS];
  ccTime            turbotimetracker;
  ccTime            m_dt;
}

-(BOOL)possibleTurboTouch : (CGPoint) tl action : (BOOL)ba;
-(BOOL)possiblePauseTouch : (CGPoint) tl action : (BOOL)ba;
-(BOOL)possibleSkipTouch  : (CGPoint) tl action : (BOOL)ba;
-(void)initHud            : (CCLayer *)world_layer;
-(void)updateHud          :  (CCLayer *)world_layer dt : (ccTime) dt mx : (float)mx my : (float)my airplane_rotation : (float)arot;
-(void)animationNewLive;
-(void)turboBtnUp;

@end
