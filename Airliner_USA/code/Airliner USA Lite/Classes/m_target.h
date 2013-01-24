
#import "cocos2d.h"
#import "player_hud.h"

#define NUM_MARKERS    30
#define CONTINENTSNUM  6
#define COUNTRIESNUM   220

@interface m_targets : NSObject {
  NSMutableArray      *target_markers, *orignal_pos_markers, *random_target_numbers;
  NSArray             *target_names;
  NSMutableDictionary *target_data;
  int                 target_counter;  
}

-(void)initTargetCCLayer           : (CCLayer *)world_layer mx : (float)mx my : (float)my;
-(void)newTarget                   : (CCLayer *)world_layer mx : (float)mx my : (float)my;
-(void)updateTargetsAndCollissions : (CCLayer *)world_layer mx : (float)mx my : (float)my player_airplane : (CCSprite *)player_airplane;
-(void)loadData;
-(void)loadData2;

@end
