//
//  m_cloudlayer.h
//  Tiletest
//
//  Created by rabshakeh on 11/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

#define NUM_CLOUDS_LOW            10
#define NUM_CLOUDS_MID            10
#define NUM_CLOUDS_HIGH           10
#define NUM_CLOUDS_STRATUS        10

#define PICS_CLOUDS_LOW           10
#define PICS_CLOUDS_MID           10
#define PICS_CLOUDS_HIGH          10
#define PICS_CLOUDS_STRATUS       10

#define LOW_CLOUD_MULTIPLIER      1.5
#define MID_CLOUD_MULTIPLIER      2
#define HIGH_CLOUD_MULTIPLIER     2.5
#define STRATUS_CLOUD_MULTIPLIER  3

@interface m_clouds : NSObject {
  NSMutableArray *clouds;
  bool           fast_machine;
  NSString       *cloud_image_name_prefix;
}
-(void)initCloudCCLayer     : (CCLayer *)world_layer cloud_multiplier : (int)cloud_multiplier numclouds : (int)numclouds numpicsclouds : (int)numpicsclouds;
-(void)updateCloudPositions : (ccTime) delta_time cloud_speed : (int)cloud_speed cloud_multiplier : (int)cloud_multiplier vector_x_delta : (float)vxd vector_y_delta : (float)vyd airplane_rotation : (float)a_rot;
@end

@interface m_low_clouds : m_clouds {
}
-(void)initCloudCCLayer     : (CCLayer *)world_layer;
-(void)updateCloudPositions : (ccTime) delta_time vector_x_delta : (float)vxd vector_y_delta : (float)vyd airplane_rotation : (float)a_rot;
@end

@interface m_mid_clouds : m_clouds {
}
-(void)initCloudCCLayer     : (CCLayer *)world_layer;
-(void)updateCloudPositions : (ccTime) delta_time vector_x_delta : (float)vxd vector_y_delta : (float)vyd airplane_rotation : (float)a_rot;
@end

@interface m_high_clouds : m_clouds {
}
-(void)initCloudCCLayer     : (CCLayer *)world_layer;
-(void)updateCloudPositions : (ccTime) delta_time vector_x_delta : (float)vxd vector_y_delta : (float)vyd airplane_rotation : (float)a_rot;
@end

@interface m_stratus_clouds : m_clouds {
}
-(void)initCloudCCLayer     : (CCLayer *)world_layer;
-(void)updateCloudPositions : (ccTime) delta_time vector_x_delta : (float)vxd vector_y_delta : (float)vyd airplane_rotation : (float)a_rot;
@end
