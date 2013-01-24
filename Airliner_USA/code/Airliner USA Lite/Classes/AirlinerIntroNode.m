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
  [[CCDirector sharedDirector] replaceScene:[CCCrossFadeTransition transitionWithDuration:0.5 scene:[Game scene]]];
}

-(void) onEnter
{
  [super onEnter];
  LoadingBarNode *loader = (LoadingBarNode *)[self getChildByTag:kTagLoader];
  [CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGB565];
  [loader loadImagesWithArray:[self world] target:self selector:@selector(imagesLoaded:)];
}

@end
