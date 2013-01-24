//
//  AirlinerAppDelegate.m
//  Airliner
//
//  Created by rabshakeh on 12/24/09 - 10:12 AM.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "AirlinerAppDelegate.h"
#import "cocos2d.h"
#import "menu_main.h"
#import "menu_sound.h"
#import "GameScene.h"
#import "GameState.h"
#import "menu_highscores.h"

@implementation AirlinerAppDelegate

@synthesize window;

-(void) applicationDidFinishLaunching: (UIApplication *) application
{
  srand(time(NULL));

  // Init the window
  window                                              = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  [UIApplication sharedApplication].idleTimerDisabled = YES;

  // cocos2d will inherit these values
  //[window setUserInteractionEnabled:YES];
  //[window setMultipleTouchEnabled:YES];

  // Try to use CADisplayLink director
  // if it fails (SDK < 3.1) use the default director
  /*
     if (![CCDirector setDirectorType:CCDirectorTypeDisplayLink]) {
     [CCDirector setDirectorType:CCDirectorTypeDefault];
     }

     // Use RGBA_8888 buffers
     // Default is: RGB_565 buffers
     [[CCDirector sharedDirector] setPixelFormat:kTexture2DPixelFormat_RGBA4444];
     //[[CCDirector sharedDirector] setPixelFormat:kRGBA8]; // Default is RGB565

     // Create a depth buffer of 16 bits
     // Enable it if you are going to use 3D transitions or 3d objects
     //	[[CCDirector sharedDirector] setDepthBufferFormat:kDepthBuffer16];

     // Default texture format for PNG/BMP/TIFF/JPEG/GIF images
     // It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
     // You can change anytime.
     GameState *gs = [GameState sharedInstance];
     [CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGB565];

     // before creating any layer, set the landscape mode
     [[CCDirector sharedDirector] setDeviceOrientation:CCDeviceOrientationLandscapeLeft];
     [[CCDirector sharedDirector] setProjection:CCDirectorProjection2D];
     //[[CCDirector sharedDirector] setDisplayFPS:YES];

     // create an openGL view inside a window
     [[CCDirector sharedDirector] attachInView:window];
     [window makeKeyAndVisible];

     // prevent flicker
     CCSprite *sprite = [[CCSprite spriteWithFile:@"Default.png"] retain];
     sprite.anchorPoint = CGPointZero;
     [sprite draw];
     [[[CCDirector sharedDirector] openGLView] swapBuffers];
     [sprite release];
   */
  GameState *gs = [GameState sharedInstance];
  [gs createEditableCopyOfDatabaseIfNeeded];
  [gs initializeDatabase];

  CC_DIRECTOR_INIT();

  CCDirector *director = [CCDirector sharedDirector];

  // Set device in landscape mode
  [director setDeviceOrientation: kCCDeviceOrientationLandscapeLeft];

  // turn this feature On when testing the speed
  //	[director setDisplayFPS:YES];

  // TIP:
  // Sapus Tongue uses almost all of the images with gradients.
  // They look good in 32 bit mode (RGBA8888) but the consume lot of memory.
  // If your game doesn't need such precision in the images, use 16-bit textures.
  // RGBA4444 or RGB5_A1
  [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

  // Run the intro Scene
  // Run the intro Scene
  [director runWithScene:[MainMenu scene]];

  //[[CCDirector sharedDirector] runWithScene:[MainMenu scene]];

  [[SimpleAudioEngine sharedEngine] preloadEffect:@"menu_click1.wav"];
  [gs startBackgroundMusic];
}

-(void) applicationDidEnterBackground: (UIApplication *) application
{
  GameState *gs = [GameState sharedInstance];

  [gs saveState];
  [[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground: (UIApplication *) application
{
  [[CCDirector sharedDirector] startAnimation];
}

-(void) applicationWillResignActive: (UIApplication *) application
{
  GameState *gs = [GameState sharedInstance];

  [[CDAudioManager sharedManager] pauseBackgroundMusic];
  [[CCDirector sharedDirector] pause];
  [gs saveState];
}

-(void) applicationDidBecomeActive: (UIApplication *) application
{
  [[CCDirector sharedDirector] resume];
}

-(void) applicationDidReceiveMemoryWarning: (UIApplication *) application
{
  GameState *gs = [GameState sharedInstance];

  [gs saveState];
  [[CCTextureCache sharedTextureCache] removeUnusedTextures];
  //[[SimpleAudioEngine sharedEngine] playEffect:@"target_hit_computer.wav"];
}

-(void) applicationWillTerminate: (UIApplication *) application
{
  // save state of the game
  GameState *gs = [GameState sharedInstance];

  [gs saveState];
  [[CCDirector sharedDirector] end];
}

-(void) applicationSignificantTimeChange: (UIApplication *) application
{
  [[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

-(void) dealloc
{
  [window release];
  [super dealloc];
}

@end
