//
//  menu_instructions.m
//  Airliner
//
//  Created by rabshakeh on 12/29/09 - 10:10 AM.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "menu_highscores.h"
#import "menu_main.h"
#import "LocalScore.h"
#import "AirlinerIntroNode.h"
#import "GameScene.h"

@implementation HighscoreMenu

+(id) scene
{
  CCScene       *s    = [CCScene node];
  HighscoreMenu *node = [HighscoreMenu node];

  [s addChild:node];
  return(s);
}

-(void) mainMenu: (id) sender
{
  GameState *gs = [GameState sharedInstance];

  if ([gs getEffects]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"menu_click1.wav"];
  }
  [[CCDirector sharedDirector] replaceScene:[CCCrossFadeTransition transitionWithDuration:TRANS_DURATION scene:[MainMenu scene]]];
}

-(void) newGame: (id) sender
{
  GameState *gs = [GameState sharedInstance];

  [gs newGame];

  if ([gs getTexturesLoaded] == NO) {
    [[CCDirector sharedDirector] replaceScene:[CCCrossFadeTransition transitionWithDuration:TRANS_DURATION scene:[AirlinerIntroNode scene]]];
    [gs setTexturesLoaded:YES];
  }
  else {
    [[CCDirector sharedDirector] replaceScene:[CCCrossFadeTransition transitionWithDuration:TRANS_DURATION scene:[Game scene]]];
  }
}

-(id) init
{
  [CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGB565];
  [super init];
  GameState *gs = [GameState sharedInstance];

  [gs loadScoresFromDB];

  CCSprite *background = [CCSprite spriteWithFile:@"menu-bg.png"];
  background.anchorPoint = ccp(0, 0);
  [self addChild:background z:-1];

  CCSprite *scoregrid = [CCSprite spriteWithFile:@"menu-score-bg.png"];
  scoregrid.position = ccp(SCREENWIDTH / 2, (SCREENHEIGHT / 2) - 41);
  [self addChild:scoregrid z:1];

  CCMenuItemImage *mainmenu     = [CCMenuItemImage itemFromNormalImage:@"menu-score-btn-main-menu.png" selectedImage:@"menu-score-btn-main-menu-click.png" target:self selector:@selector(mainMenu:)];
  CCMenu          *menumainmenu = [CCMenu menuWithItems:mainmenu, nil];
  menumainmenu.position = ccp(60, 208);
  [self addChild:menumainmenu z:2];

  CCMenuItemImage *playagain     = [CCMenuItemImage itemFromNormalImage:@"menu-score-btn-new-game.png" selectedImage:@"menu-score-btn-new-game-click.png" target:self selector:@selector(newGame:)];
  CCMenu          *menuplayagain = [CCMenu menuWithItems:playagain, nil];
  menuplayagain.position = ccp(420, 208);
  [self addChild:menuplayagain z:2];

  [CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];
  CCBitmapFontAtlas *names[10];
  CCBitmapFontAtlas *scores[10];

  for (int i = 0; i < 10; i++) {
    if ([[gs scores] count] > i) {
      LocalScore *s     = [[gs scores] objectAtIndex: i];
      NSString   *name  = [NSString stringWithFormat:@"%d. %@", i + 1, s.playername];
      NSString   *score = [gs commaSeparateThousands:[s.score intValue]];
      //NSString   *score = [s.score stringValue];

      names[i]  = [CCBitmapFontAtlas bitmapFontAtlasWithString:name fntFile:@"OCRAStd.fnt"];
      scores[i] = [CCBitmapFontAtlas bitmapFontAtlasWithString:score fntFile:@"OCRAStd.fnt"];

      names[i].anchorPoint = ccp(0, 0);

      names[i].position  = ccp(20, 168 - (i * 16));
      scores[i].position = ccp(450 - (scores[i].contentSize.width / 2), (168 - (i * 16)) + (scores[i].contentSize.height / 2));

      names[i].opacity  = 255 - (i * 16);
      scores[i].opacity = 255 - (i * 16);

      [self addChild:names[i] z:6];
      [self addChild:scores[i] z:6];
    }
  }
  return(self);
}

-(void) dealloc
{
  [super dealloc];
}

@end
