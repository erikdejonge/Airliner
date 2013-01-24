
// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "m_worldclip.h"
#import "m_target.h"
#import "m_cloudlayer.h"
#import "player_airplane.h"
#import "player_hud.h"
#import <iAd/iAd.h>

#define NUMDOTS  30

// Game CCLayer
@interface Game : CCLayer<ADBannerViewDelegate> {
  player_airplane  *player;
  player_hud       *hud;
  m_worldclip      *world;
  m_low_clouds     *low_clouds;
  m_mid_clouds     *mid_clouds;
  m_high_clouds    *high_clouds;
  m_stratus_clouds *stratus_clouds;
  m_targets        *targets;
  BOOL             fast_machine;
  CCSprite         *dots[NUMDOTS];
  CCFadeOut        *dot_fades[NUM_SMOKE_TRAIL];
  UIViewController *adController;
  ADBannerView     *adView;
}

// returns a CCScene that contains the Game as the only child
+(id)scene;
-(void)drawDashedLine : (CGPoint) origin dest : (CGPoint) destination leng : (float)dashLength;

@end
