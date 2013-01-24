
#import "menu_sound.h"
#import "menu_main.h"

@implementation SoundMenu

-(void) menuCallbackMusic: (id) sender
{
  GameState *gs = [GameState sharedInstance];

  if ([gs getEffects]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"menu_click1.wav"];
  }
  if ([gs getMusic] == 1) {
    [[CDAudioManager sharedManager] pauseBackgroundMusic];
    [gs setMusic:0];
    [menumusic setNormalImage:[CCSprite spriteWithFile:@"menu-snd-bgmusic-off.png"]];
  }
  else{
    [[CDAudioManager sharedManager] resumeBackgroundMusic];
    [gs setMusic:1];
    [menumusic setNormalImage:[CCSprite spriteWithFile:@"menu-snd-bgmusic-on.png"]];
  }
  [gs saveState];
}

-(void) menuCallbackSound: (id) sender
{
  GameState *gs = [GameState sharedInstance];

  if ([gs getEffects]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"menu_click1.wav"];
  }
  if ([gs getEffects] == 1) {
    [gs setEffects:0];
    [menueffects setNormalImage:[CCSprite spriteWithFile:@"menu-snd-fx-off.png"]];
  }
  else{
    [gs setEffects:1];
    [menueffects setNormalImage:[CCSprite spriteWithFile:@"menu-snd-fx-on.png"]];
  }
  [gs saveState];
}

-(void) menuCallbackSoundSave: (id) sender
{
  GameState *gs = [GameState sharedInstance];

  if ([gs getEffects]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"menu_click1.wav"];
  }
  [[CCDirector sharedDirector] replaceScene:[CCCrossFadeTransition transitionWithDuration:TRANS_DURATION scene:[MainMenu scene]]];
}

+(id) scene
{
  CCScene   *s    = [CCScene node];
  SoundMenu *node = [SoundMenu node];

  [s addChild:node];
  return(s);
}
-(void) imageLoaded: (CCTexture2D *) image
{
}

-(id) init
{
  [CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGB565];
  GameState *gs = [GameState sharedInstance];

  [super init];
  CCSprite *background = [CCSprite spriteWithFile:@"menu-bg.png"];
  background.anchorPoint = ccp(0, 0);
  [self addChild:background z:-1];

  if ([gs getMusic] == 1) {
    menumusic = [CCMenuItemImage itemFromNormalImage:@"menu-snd-bgmusic-on.png" selectedImage:@"menu-snd-bgmusic-click.png" target:self selector:@selector(menuCallbackMusic:)];
  }
  else{
    menumusic = [CCMenuItemImage itemFromNormalImage:@"menu-snd-bgmusic-off.png" selectedImage:@"menu-snd-bgmusic-click.png" target:self selector:@selector(menuCallbackMusic:)];
  }

  if ([gs getEffects] == 1) {
    menueffects = [CCMenuItemImage itemFromNormalImage:@"menu-snd-fx-on.png" selectedImage:@"menu-snd-fx-click.png" target:self selector:@selector(menuCallbackSound:)];
  }
  else{
    menueffects = [CCMenuItemImage itemFromNormalImage:@"menu-snd-fx-off.png" selectedImage:@"menu-snd-fx-click.png" target:self selector:@selector(menuCallbackSound:)];
  }

  menusave = [CCMenuItemImage itemFromNormalImage:@"menu-snd-save.png" selectedImage:@"menu-snd-save-click.png" target:self selector:@selector(menuCallbackSoundSave:)];

  CCMenu *menu = [CCMenu menuWithItems:menumusic, nil];
  menu.position = ccp(240, 189);
  [self addChild: menu z:2];

  CCMenu *menu2 = [CCMenu menuWithItems:menueffects, nil];
  menu2.position = ccp(240, 119);
  [self addChild: menu2 z:2];

  CCMenu *menu3 = [CCMenu menuWithItems:menusave, nil];
  menu3.position = ccp(240, 47);
  [self addChild: menu3 z:2];

  return(self);
}

-(void) dealloc
{
  [super dealloc];
}

@end
