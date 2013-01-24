
#import "cocos2d.h"

#define NUM_MARKERS            30
#define NUM_TARGET_ANI_IMAGES  12



@interface m_targets : NSObject {
  NSMutableArray *target_markers, *orignal_pos_markers;
  //AtlasSprite         *target_marker[NUM_MARKERS];
  //CGPoint             original_positions[NUM_MARKERS];
  Animation           *target_animation;
  NSArray             *continent_names, *country_names;
  NSMutableDictionary *target_data_continents, *target_data_countries;
  int                 targets_requested;
}


-(void)preloadImages;
-(void)initTargetLayer       : (Layer *)world_layer;
-(void)updateTargetPositions : (float)mx my : (float)my;

-(void)loadData;

@end
