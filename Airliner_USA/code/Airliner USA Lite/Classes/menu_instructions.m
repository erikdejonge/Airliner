//
//  menu_instructions.m
//  Airliner
//
//  Created by rabshakeh on 12/29/09 - 10:10 AM.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "menu_instructions.h"
#import "menu_main.h"

@implementation InstructionsMenu

@synthesize slide;

+(id) scene
{
  CCScene          *s    = [CCScene node];
  InstructionsMenu *node = [InstructionsMenu node];

  [s addChild:node];
  return(s);
}

-(void) setSlide
{
  CCTexture2D *x = [[CCTexture2D alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"menu-instructions-slide-%d.png", slide]]];

  [x setAliasTexParameters];
  [img setTexture:x];
  [x release];
}

-(void) nextSel: (id) sender
{
  GameState *gs = [GameState sharedInstance];

  if ([gs getEffects]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"menu_click1.wav"];
  }
  slide++;
  if (slide > 7) {
    [[CCDirector sharedDirector] replaceScene:[CCCrossFadeTransition transitionWithDuration:TRANS_DURATION scene:[MainMenu scene]]];
    return;
  }
  [self setSlide];
}

-(void) previousSel: (id) sender
{
  GameState *gs = [GameState sharedInstance];

  if ([gs getEffects]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"menu_click1.wav"];
  }
  slide--;
  if (slide < 1) {
    [[CCDirector sharedDirector] replaceScene:[CCCrossFadeTransition transitionWithDuration:TRANS_DURATION scene:[MainMenu scene]]];
    return;
  }
  [self setSlide];
}

-(id) init
{
  [CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGB565];

  [super init];
  CCSprite *background = [CCSprite spriteWithFile:@"menu-bg.png"];
  background.anchorPoint = ccp(0, 0);
  [self addChild:background z:-1];
  slide = 1;

  CCSprite *left = [[CCSprite spriteWithFile:@"menu-instructions-btn-left.png"] retain];
  [[left texture] setAliasTexParameters];
  CCSprite *clickleft = [[CCSprite spriteWithFile:@"menu-instructions-btn-left-click.png"] retain];
  [[clickleft texture] setAliasTexParameters];
  prev = [CCMenuItemSprite itemFromNormalSprite:left selectedSprite:clickleft target:self selector:@selector(previousSel:)];
  CCMenu *menuprev = [CCMenu menuWithItems:prev, nil];
  menuprev.position = ccp(21, 119);
  [self addChild: menuprev z:2];
  [clickleft release];
  [left release];
  img          = [CCSprite spriteWithFile:@"menu-instructions-slide-1.png"];
  img.position = ccp(SCREENWIDTH / 2, 119);
  [self addChild:img z:2];

  next = [CCMenuItemImage itemFromNormalImage:@"menu-instructions-btn-right.png" selectedImage:@"menu-instructions-btn-right-click.png" target:self selector:@selector(nextSel:)];
  CCMenu *menunext = [CCMenu menuWithItems:next, nil];
  menunext.position = ccp(459, 119);
  [self addChild: menunext z:2];

  return(self);
}

-(void) dealloc
{
  [super dealloc];
}

@end
