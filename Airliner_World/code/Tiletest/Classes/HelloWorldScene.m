//
// cocos2d Hello World example
// http://www.cocos2d-iphone.org
//

// Import the interfaces
#import "HelloWorldScene.h"
#import "CJSONScanner.h"

// HelloWorld implementation
@implementation HelloWorld

#define SCREENWIDTH   480
#define SCREENHEIGHT  320

+(id) scene
{
  Scene      *scene = [Scene node];
  HelloWorld *layer = [HelloWorld node];

  [scene addChild: layer];
  return(scene);
}


-(id) init
{
  if ((self = [super init]))
  {
		self.isTouchEnabled = YES;
		world = [m_worldclip alloc];
		player = [player_airplane alloc];
		low_clouds = [m_low_clouds alloc];
		mid_clouds = [m_mid_clouds alloc];    
		high_clouds = [m_high_clouds alloc];
		stratus_clouds = [m_stratus_clouds alloc];
    targets = [m_targets alloc];
    hud = [player_hud alloc];
    
		[world initWorldMap:self];		
    [targets preloadImages];
    [targets initTargetLayer:self];
    [low_clouds preloadImages];
		[low_clouds initCloudLayer:self];
    [mid_clouds initCloudLayer:self];    
    [high_clouds initCloudLayer:self];    
		[player initAirplane:self];		
		[stratus_clouds initCloudLayer:self];		
    [hud initHud:self];
    
		[self schedule: @selector(tick:)];		
		
  }
  return(self);
}


-(void) registerWithTouchDispatcher
{
  [[TouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan: (UITouch *) touch withEvent: (UIEvent *) event
{
	[ player changePlayerDirection:touch];
  return(YES);
}

-(void) ccTouchEnded: (UITouch *) touch withEvent: (UIEvent *) event
{
}

-(void) ccTouchCancelled: (UITouch *) touch withEvent: (UIEvent *) event
{
}

-(void) ccTouchMoved: (UITouch *) touch withEvent: (UIEvent *) event
{
	[ player changePlayerDirection:touch];
}


-(void) updateDebugLabel
{
}

-(void) tick: (ccTime) dt
{
	[ player updatePlayer:dt];
	[ world moveWorldMapForPlayer    :dt vector_x_delta:player.vector_x_delta vector_y_delta:player.vector_y_delta airplane_rotation:player.airplane.rotation targets:targets ];
  [ targets updateTargetPositions:world.mapx my:world.mapy];  
	[ low_clouds updateCloudPositions:dt vector_x_delta:player.vector_x_delta vector_y_delta:player.vector_y_delta airplane_rotation:player.airplane.rotation];
	[ mid_clouds updateCloudPositions:dt vector_x_delta:player.vector_x_delta vector_y_delta:player.vector_y_delta airplane_rotation:player.airplane.rotation ];  
	[ high_clouds updateCloudPositions:dt vector_x_delta:player.vector_x_delta vector_y_delta:player.vector_y_delta airplane_rotation:player.airplane.rotation];
	[ stratus_clouds updateCloudPositions:dt vector_x_delta:player.vector_x_delta vector_y_delta:player.vector_y_delta airplane_rotation:player.airplane.rotation];  
  [ hud updateHud:dt];
}

-(void) dealloc
{
  // don't forget to call "super dealloc"
	[world release];
	[low_clouds release];
	[mid_clouds release];  
	[high_clouds release];
	[stratus_clouds release];  
	[player release];
  [targets release];
  [hud release];
  [super dealloc];
}
@end


