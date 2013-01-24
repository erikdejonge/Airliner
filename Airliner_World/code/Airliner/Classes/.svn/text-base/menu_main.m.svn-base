
#import "menu_main.h"
#import "SimpleAudioEngine.h"
#import "GameScene.h"
#import "AirlinerIntroNode.h"
#import "menu_sound.h"
#import "menu_about.h"
#import "menu_instructions.h"
#import "menu_highscores.h"

@implementation SoundMenuItem
-(void) selected
{
  [super selected];
  GameState *gs = [GameState sharedInstance];
  if ([gs getEffects]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"menu_click1.wav"];
  }
}
@end

@implementation MainMenu

+(id) scene
{
  CCScene  *s    = [CCScene node];
  MainMenu *node = [MainMenu node];

  [s addChild:node];
  return(s);
}

-(void) resumeGame: (id) sender
{
  GameState *gs = [GameState sharedInstance];

  [[SimpleAudioEngine sharedEngine] preloadEffect:@"target_hit.wav"];
  [[SimpleAudioEngine sharedEngine] preloadEffect:@"target_missed.wav"];
  [[SimpleAudioEngine sharedEngine] preloadEffect:@"Cabin.wav"];

  // ignore crappy loader for now
  // [[CCDirector sharedDirector] replaceScene:[CCCrossFadeTransition transitionWithDuration:TRANS_DURATION scene:[Game scene]]];
  // return;

  if ([gs getTexturesLoaded] == NO) {
    [[CCDirector sharedDirector] replaceScene:[CCCrossFadeTransition transitionWithDuration:TRANS_DURATION scene:[AirlinerIntroNode scene]]];
    [gs setTexturesLoaded:YES];
  }
  else {
    [[CCDirector sharedDirector] replaceScene:[CCCrossFadeTransition transitionWithDuration:TRANS_DURATION scene:[Game scene]]];
  }
}

-(void) instructions: (id) sender
{
  [[CCDirector sharedDirector] replaceScene:[CCCrossFadeTransition transitionWithDuration:TRANS_DURATION scene:[InstructionsMenu scene]]];
}

-(void) newGame: (id) sender
{
  GameState *gs = [GameState sharedInstance];

  [gs newGame];
  [[SimpleAudioEngine sharedEngine] preloadEffect:@"target_hit.wav"];
  [[SimpleAudioEngine sharedEngine] preloadEffect:@"target_missed.wav"];
  [[SimpleAudioEngine sharedEngine] preloadEffect:@"Cabin.wav"];

  //[[CCDirector sharedDirector] replaceScene:[CCCrossFadeTransition transitionWithDuration:TRANS_DURATION scene:[Game scene]]];
  // ignore crappy loader for now
  //return;

  if ([gs getTexturesLoaded] == NO) {
    [[CCDirector sharedDirector] replaceScene:[CCCrossFadeTransition transitionWithDuration:TRANS_DURATION scene:[AirlinerIntroNode scene]]];
    [gs setTexturesLoaded:YES];
  }
  else {
    [[CCDirector sharedDirector] replaceScene:[CCCrossFadeTransition transitionWithDuration:TRANS_DURATION scene:[Game scene]]];
  }
}

-(void) highScores: (id) sender
{
  [[CCDirector sharedDirector] replaceScene:[CCCrossFadeTransition transitionWithDuration:TRANS_DURATION scene:[HighscoreMenu scene]]];
}

-(void) sound: (id) sender
{
  [[CCDirector sharedDirector] replaceScene:[CCCrossFadeTransition transitionWithDuration:TRANS_DURATION scene:[SoundMenu scene]]];
}

-(void) about: (id) sender
{
  [[CCDirector sharedDirector] replaceScene:[CCCrossFadeTransition transitionWithDuration:TRANS_DURATION scene:[AboutMenu scene]]];
}

-(void) imageLoaded: (CCTexture2D *) image
{
}

-(id) init
{
  if ((self = [super init])) {
    [CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGB565];

    GameState *gs         = [GameState sharedInstance];
    CCSprite  *background = [CCSprite spriteWithFile:@"menu-bg.png"];
    background.anchorPoint = ccp(0, 0);
    [self addChild:background z:-1];

    // Menu Items
    CCMenuItemImage *resume       = [SoundMenuItem itemFromNormalImage:@"menu-btn-resume.png" selectedImage:@"menu-btn-resume-click.png" disabledImage:@"menu-btn-resume-disabled.png" target:self selector:@selector(resumeGame:)];
    CCMenuItemImage *instructions = [SoundMenuItem itemFromNormalImage:@"menu-btn-instructions.png" selectedImage:@"menu-btn-instructions-click.png" target:self selector:@selector(instructions:)];
    CCMenuItemImage *newgame      = [SoundMenuItem itemFromNormalImage:@"menu-btn-newgame.png" selectedImage:@"menu-btn-newgame-click.png" target:self selector:@selector(newGame:)];
    CCMenuItemImage *highscores   = [SoundMenuItem itemFromNormalImage:@"menu-btn-highscores.png" selectedImage:@"menu-btn-highscores-click.png" target:self selector:@selector(highScores:)];
    CCMenuItemImage *sound        = [SoundMenuItem itemFromNormalImage:@"menu-btn-sounds.png" selectedImage:@"menu-btn-sounds-click.png" target:self selector:@selector(sound:)];
    CCMenuItemImage *about        = [SoundMenuItem itemFromNormalImage:@"menu-btn-about.png" selectedImage:@"menu-btn-about-click.png" target:self selector:@selector(about:)];

    CCMenu          *menu_resume       = [CCMenu menuWithItems: resume, nil];
    CCMenu          *menu_instructions = [CCMenu menuWithItems: instructions, nil];
    CCMenu          *menu_newgame      = [CCMenu menuWithItems: newgame, nil];
    CCMenu          *menu_highscores   = [CCMenu menuWithItems: highscores, nil];
    CCMenu          *menu_sound        = [CCMenu menuWithItems: sound, nil];
    CCMenu          *menu_about        = [CCMenu menuWithItems: about, nil];

    if ([gs getNumLives] == 0) {
      [resume setIsEnabled:NO];
    }

    menu_resume.position       = ccp(126, 189);
    menu_instructions.position = ccp(354, 189);
    menu_newgame.position      = ccp(menu_resume.position.x, menu_resume.position.y - resume.contentSize.height + 2);
    menu_highscores.position   = ccp(menu_resume.position.x + resume.contentSize.width - 1, menu_resume.position.y - resume.contentSize.height + 2);
    menu_sound.position        = ccp(menu_newgame.position.x, menu_highscores.position.y - highscores.contentSize.height - 2);
    menu_about.position        = ccp(menu_newgame.position.x + highscores.contentSize.width - 1, menu_highscores.position.y - highscores.contentSize.height - 2);

    [self addChild: menu_resume z:2];
    [self addChild: menu_instructions z:2];
    [self addChild: menu_newgame z:2];
    [self addChild: menu_highscores z:2];
    [self addChild: menu_sound z:2];
    [self addChild: menu_about z:2];
  }

  return(self);
}


@end
