//
//  Airliner_USA_LiteAppDelegate.m
//  Airliner USA Lite
//
//  Created by rabshakeh on 2/1/10 - 3:49 PM.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "Airliner_USA_LiteAppDelegate.h"
#import "cocos2d.h"
#import "cocos2d.h"
#import "menu_main.h"
#import "menu_sound.h"
#import "GameScene.h"
#import "GameState.h"
#import "menu_highscores.h"

@implementation Airliner_USA_LiteAppDelegate

@synthesize window;

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
  srand(time(NULL));
  
  // Init the window
  window                                              = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  [UIApplication sharedApplication].idleTimerDisabled = YES;
  
  // cocos2d will inherit these values
  [window setUserInteractionEnabled:YES];
  [window setMultipleTouchEnabled:YES];
  
  // Try to use CADisplayLink director
  // if it fails (SDK < 3.1) use the default director
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
  if (NO ==[gs fastMachine]) {
    //    [[CCDirector sharedDirector] setAnimationInterval:1.0 / 6];
  }
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
  
  [gs createEditableCopyOfDatabaseIfNeeded];
  [gs initializeDatabase];
  
  // Run the intro Scene
  [[CCDirector sharedDirector] runWithScene:[MainMenu scene]];  
}


-(void) applicationWillResignActive: (UIApplication *) application
{
  [[CCDirector sharedDirector] pause];
}

-(void) applicationDidBecomeActive: (UIApplication *) application
{
  [[CCDirector sharedDirector] resume];
  GameState *gs = [GameState sharedInstance];
  [[SimpleAudioEngine sharedEngine] preloadEffect:@"menu_click1.wav"];
  [gs startBackgroundMusic];
}

-(void) applicationDidReceiveMemoryWarning: (UIApplication *) application
{
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
