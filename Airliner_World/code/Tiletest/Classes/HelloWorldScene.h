
// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "m_worldclip.h"
#import "m_target.h"
#import "m_cloudlayer.h"
#import "player_airplane.h"
#import "player_hud.h"

// HelloWorld Layer
@interface HelloWorld : Layer
{
  player_airplane  *player;
  player_hud       *hud;
  m_worldclip      *world;
  m_low_clouds     *low_clouds;
  m_mid_clouds     *mid_clouds;
  m_high_clouds    *high_clouds;
  m_stratus_clouds *stratus_clouds;
  m_targets        *targets;
}

// returns a Scene that contains the HelloWorld as the only child
+(id)scene;

@end
