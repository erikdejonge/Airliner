//
// cocos2d Hello World example
// http://www.cocos2d-iphone.org
//

// Import the interfaces
#import "GameScene.h"
#import "CJSONScanner.h"
#import "GameState.h"
#import "menu_main.h"

// Game implementation
@implementation Game

#define SCREENWIDTH   480
#define SCREENHEIGHT  320

+ (id)scene
{
  CCScene *scene = [CCScene node];
  Game    *layer = [Game node];
  [scene addChild: layer];
  return(scene);
}

-(id) init
{
  if ((self = [super init])) {
    self.isTouchEnabled = YES;
    GameState *gs = [GameState sharedInstance];

    world   = [m_worldclip alloc];
    player  = [player_airplane alloc];
    targets = [m_targets alloc];
    hud     = [player_hud alloc];

    [world initWorldMap:self];
    [CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];

    [targets initTargetCCLayer:self mx:[gs getMapX] my:[gs getMapY]];
    fast_machine = [gs fastMachine];
    if (YES == fast_machine) {
      low_clouds     = [m_low_clouds alloc];
      mid_clouds     = [m_mid_clouds alloc];
      high_clouds    = [m_high_clouds alloc];
      stratus_clouds = [m_stratus_clouds alloc];

      [low_clouds initCloudCCLayer:self];
      [mid_clouds initCloudCCLayer:self];
      [high_clouds initCloudCCLayer:self];
    }
    [player initAirplane:self];
    [stratus_clouds initCloudCCLayer:self];
    [hud initHud:self];
    [self schedule: @selector(tick:)];
    [gs setResuming:NO];
    for (int i = 0; i < NUMDOTS; i++) {
      dots[i]          = [[CCSprite spriteWithFile:@"dot.png"] retain];
      dots[i].position = ccp(rand() % SCREENWIDTH, rand() % SCREENHEIGHT);
      dots[i].visible  = NO;
      dot_fades[i]     = [[CCFadeOut actionWithDuration:1.3] retain];
      [self addChild:dots[i]];
    }
  }
  return(self);
}

-(void) registerWithTouchDispatcher
{
  [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan: (UITouch *) touch withEvent: (UIEvent *) event
{
  for (int i = 0; i < NUMDOTS; i++) {
    dots[i].visible = NO;
  }

  CGPoint touchLocation = [touch locationInView:[touch view]];
  touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];

  if (NO ==[hud possibleTurboTouch:touchLocation action:YES] &&
      NO ==[hud possiblePauseTouch:touchLocation action:YES] &&
      NO ==[hud possibleSkipTouch:touchLocation action:YES]) {
    GameState *gs = [GameState sharedInstance];
    if (FLYING ==[gs getPlayerState]) {
      [player changePlayerDirection:touchLocation duration:1];
      [gs setLineX:touchLocation.x];
      [gs setLineY:touchLocation.y];
    }
  }
  return(YES);
}

-(void) ccTouchEnded: (UITouch *) touch withEvent: (UIEvent *) event
{
  [hud turboBtnUp];
}

-(void) ccTouchCancelled: (UITouch *) touch withEvent: (UIEvent *) event
{
}

-(void) ccTouchMoved: (UITouch *) touch withEvent: (UIEvent *) event
{
  CGPoint touchLocation = [touch locationInView:[touch view]];

  touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];

  for (int i = 0; i < NUMDOTS; i++) {
    dots[i].visible = NO;
  }

  if (NO ==[hud possibleTurboTouch:touchLocation action:NO] &&
      NO ==[hud possiblePauseTouch:touchLocation action:NO] &&
      NO ==[hud possibleSkipTouch:touchLocation action:NO]) {
    GameState *gs = [GameState sharedInstance];
    if (FLYING ==[gs getPlayerState]) {
      [player changePlayerDirection:touchLocation duration:1];
      [gs setLineX:touchLocation.x];
      [gs setLineY:touchLocation.y];
    }
  }
}

-(void) updateDebugLabel
{
}

-(void) drawDashedLine: (CGPoint) origin dest: (CGPoint) destination leng: (float) dashLength
{
  float      dx   = destination.x - origin.x;
  float      dy   = destination.y - origin.y;
  float      dist = sqrtf(dx * dx + dy * dy);
  float      x    = dx / dist * dashLength;
  float      y    = dy / dist * dashLength;

  CGPoint    p1       = origin;
  NSUInteger segments = (int)(dist / dashLength);
  NSUInteger lines    = (int)((float)segments / 2.0);

  for (int i = 0; i < lines; i++) {
    p1 = CGPointMake(p1.x + x, p1.y + y);
    p1 = CGPointMake(p1.x + x, p1.y + y);

    if (i < NUMDOTS) {
      dots[i].position = p1;
      dots[i].visible  = YES;
      [dots[i] runAction:[CCFadeOut actionWithDuration:2]];
    }
  }
}


-(void) draw
{
  GameState *gs = [GameState sharedInstance];

  [self drawDashedLine: ccp(SCREENWIDTH / 2, SCREENHEIGHT / 2) dest:ccp([gs getLineX], [gs getLineY]) leng:5];
}

-(void) tick: (ccTime) dt
{
  GameState *gs = [GameState sharedInstance];

  [gs updateState:dt];
  [player updatePlayer:dt];
  [world moveWorldMapForPlayer:dt vector_x_delta:player.vector_x_delta vector_y_delta:player.vector_y_delta airplane_rotation:player.airplane.rotation targets:targets];
  [targets updateTargetsAndCollissions:self mx:[gs getMapX] my:[gs getMapY] player_airplane:player.airplane];
  if (YES == fast_machine) {
    [low_clouds updateCloudPositions:dt vector_x_delta:player.vector_x_delta vector_y_delta:player.vector_y_delta airplane_rotation:player.airplane.rotation];
    [mid_clouds updateCloudPositions:dt vector_x_delta:player.vector_x_delta vector_y_delta:player.vector_y_delta airplane_rotation:player.airplane.rotation];
    [high_clouds updateCloudPositions:dt vector_x_delta:player.vector_x_delta vector_y_delta:player.vector_y_delta airplane_rotation:player.airplane.rotation];
    [stratus_clouds updateCloudPositions:dt vector_x_delta:player.vector_x_delta vector_y_delta:player.vector_y_delta airplane_rotation:player.airplane.rotation];
  }
  [hud updateHud:self dt:dt mx:[gs getMapX] my:[gs getMapY] airplane_rotation:player.airplane.rotation];
}

-(void) dealloc
{
  // don't forget to call "super dealloc"
  [world release];
  if (YES == fast_machine) {
    [low_clouds release];
    [mid_clouds release];
    [high_clouds release];
    [stratus_clouds release];
  }
  [player release];
  [targets release];
  [hud release];
  [super dealloc];
}
@end


