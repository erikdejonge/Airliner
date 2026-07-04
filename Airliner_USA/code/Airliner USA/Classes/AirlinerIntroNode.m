//
//  AirlinerIntroNode.m
//  AirlinerTongue
//
//  Created by Ricardo Quesada on 23/09/08.
//  Copyright 2008 Sapus Media. All rights reserved.
//

#import "AirlinerIntroNode.h"
#import "LoadingBarNode.h"
#import "GameScene.h"
#import "GameState.h"
#import "menu_main.h"

enum
{
  kTagLoader,
};
//
// Small scene that plays the background music and makes a transition to the Menu scene
//
@implementation AirlinerIntroNode
+(id) scene
{
  CCScene *s   = [CCScene node];
  id      node = [AirlinerIntroNode node];

  [s addChild:node];
  return(s);
}

-(id) init
{
  if ((self = [super init])) {
    CCSprite *back = [CCSprite spriteWithFile:@"bg-loading.png"];
    back.anchorPoint = ccp(0.0f, 0.0f);
    [self addChild:back];

    CGSize         s       = [[CCDirector sharedDirector] winSize];
    LoadingBarNode *loader = [LoadingBarNode node];

    [self addChild:loader z:1 tag:kTagLoader];
    [loader setPosition:ccp(s.width / 2, 118)];
  }
  return(self);
}

-(NSArray *) world
{
  return([NSArray arrayWithObjects:
          @"s0.png",
          @"s1.png",
          @"s2.png",
          @"s3.png",
          @"s4.png",
          @"s5.png",
          @"s6.png",
          @"s7.png",
          nil]);
}


-(void) imagesLoaded: (id) sender
{
  // Defer the scene switch to the next run-loop iteration. imagesLoaded: is
  // invoked synchronously from within onEnterTransitionDidFinish, which itself
  // runs inside the incoming transition's teardown in -[CCDirector setNextScene].
  // Replacing the scene there re-enters setNextScene and corrupts nextScene_,
  // so the Game scene would become the running scene WITHOUT ever receiving
  // onEnter (no touch handlers, no scheduled tick). Deferring guarantees the
  // transition has fully unwound first.
  [self performSelector:@selector(gotoGame) withObject:nil afterDelay:0.0f];
}

-(void) gotoGame
{
  [[CCDirector sharedDirector] replaceScene:[CCFadeTransition transitionWithDuration:1.0f scene:[Game scene]]];
}

-(void) onEnter
{
  [super onEnter];
  [CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGB565];
}

-(void) onEnterTransitionDidFinish
{
  [super onEnterTransitionDidFinish];

  // Start loading only after the incoming transition has fully finished. The
  // loader now runs synchronously, and replacing the scene from within onEnter
  // (while the intro transition is still active) would corrupt the director's
  // scene stack and freeze on the loading screen.
  LoadingBarNode *loader = (LoadingBarNode *)[self getChildByTag:kTagLoader];
  [loader loadImagesWithArray:[self world] target:self selector:@selector(imagesLoaded:)];
}

@end
