

#import "menu_main.h"
#import "menu_about.h"

@implementation AboutMenu

-(void) menuActive8: (id) sender
{
  GameState *gs = [GameState sharedInstance];

  if ([gs getEffects]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"menu_click1.wav"];
  }
  shouldOpenActive8 = YES;
  UIAlertView *alertTest = [[UIAlertView alloc]
                            initWithTitle:@"Airliner"
                            message:[NSString stringWithFormat:@"Close Airliner and go to the Active8 website?"]
                            delegate:self
                            cancelButtonTitle:@"Cancel"
                            otherButtonTitles:nil];
  [alertTest addButtonWithTitle:@"OK"];
  [alertTest show];
  [alertTest autorelease];
}

-(void) menuJenkees: (id) sender
{
  GameState *gs = [GameState sharedInstance];

  if ([gs getEffects]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"menu_click1.wav"];
  }
  shouldOpenJenkees = YES;
  UIAlertView *alertTest = [[UIAlertView alloc]
                            initWithTitle:@"Airliner"
                            message:[NSString stringWithFormat:@"Close Airliner and go to the Ronald Jenkees iTunes page?"]
                            delegate:self
                            cancelButtonTitle:@"Cancel"
                            otherButtonTitles:nil];
  [alertTest addButtonWithTitle:@"OK"];
  [alertTest show];
  [alertTest autorelease];
}


-(void) menuNasa: (id) sender
{
  GameState *gs = [GameState sharedInstance];

  if ([gs getEffects]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"menu_click1.wav"];
  }
  shouldOpenNasa = YES;
  UIAlertView *alertTest = [[UIAlertView alloc]
                            initWithTitle:@"Airliner"
                            message:[NSString stringWithFormat:@"Close Airliner and go to the NASA visible earth website?"]
                            delegate:self
                            cancelButtonTitle:@"Cancel"
                            otherButtonTitles:nil];
  [alertTest addButtonWithTitle:@"OK"];
  [alertTest show];
  [alertTest autorelease];
}

-(void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex
{
  if (buttonIndex == 1) {
    if (shouldOpenActive8 == YES) {
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.active8.com"]];
    }
    if (shouldOpenJenkees == YES) {
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/nl/artist/ronald-jenkees/id261992090"]];
    }
    if (shouldOpenNasa == YES) {
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://visibleearth.nasa.gov/"]];
    }
  }
  shouldOpenActive8 = NO;
  shouldOpenJenkees = NO;
  shouldOpenNasa    = NO;
}

-(void) mainMenu: (id) sender
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
  AboutMenu *node = [AboutMenu node];

  [s addChild:node];
  return(s);
}

-(id) init
{
  [CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGB565];
  shouldOpenActive8 = NO;
  shouldOpenJenkees = NO;
  shouldOpenNasa    = NO;

  [super init];
  CCSprite *background = [CCSprite spriteWithFile:@"menu-bg.png"];
  background.anchorPoint = ccp(0, 0);
  [self addChild:background z:-1];

  active8 = [CCMenuItemImage itemFromNormalImage:@"menu-abt-active8.png" selectedImage:@"menu-abt-active8-click.png" target:self selector:@selector(menuActive8:)];
  CCMenu *active8menu = [CCMenu menuWithItems:active8, nil];
  active8menu.position = ccp(240, 189);
  [self addChild: active8menu z:2];

  jenkees = [CCMenuItemImage itemFromNormalImage:@"menu-abt-ronaldjenkees.png" selectedImage:@"menu-abt-ronaldjenkees-click.png" target:self selector:@selector(menuJenkees:)];
  CCMenu *jenkeesmenu = [CCMenu menuWithItems:jenkees, nil];
  jenkeesmenu.position = ccp(354, 118);
  [self addChild: jenkeesmenu z:2];

  nasa = [CCMenuItemImage itemFromNormalImage:@"menu-abt-nasa.png" selectedImage:@"menu-abt-nasa-click.png" target:self selector:@selector(menuNasa:)];
  CCMenu *nasamenu = [CCMenu menuWithItems:nasa, nil];
  nasamenu.position = ccp(126, 118);
  [self addChild: nasamenu z:2];

  menusave = [CCMenuItemImage itemFromNormalImage:@"menu-abt-backtomenu.png" selectedImage:@"menu-abt-backtomenu-click.png" target:self selector:@selector(mainMenu:)];
  CCMenu *menusavemenu = [CCMenu menuWithItems:menusave, nil];
  menusavemenu.position = ccp(240, 49);
  [self addChild: menusavemenu z:2];

  return(self);
}

-(void) dealloc
{
  [super dealloc];
}

@end
