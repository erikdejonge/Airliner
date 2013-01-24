//
//  LoadingBarNode.m
//  SapusTongue
//
//  Created by Ricardo Quesada on 28/07/09.
//  Copyright 2009 Sapus Media. All rights reserved.
//

// LoadingBar:
// A helpful class that loads and shows the images asynchronously
// When the images finish loading, the callback will be called.
//
// Feel free to reuse the code as well as the loading_bar.png image
//

#import "LoadingBarNode.h"

enum
{
  kTagSpriteManager,
};

enum
{
  kTagSpriteBack,
  kTagSpriteBar,
};

@implementation LoadingBarNode

-(id) init
{
  if ((self = [super init])) {
    CCSpriteSheet *sheet = [CCSpriteSheet spriteSheetWithFile:@"loading_bar.png" capacity:2];

    [self addChild:sheet z:0 tag:kTagSpriteManager];

#define LOADING_BAR_X  424
#define LOADING_BAR_Y  12

    target       = nil;
    selector     = nil;
    total        = 0;
    imagesLoaded = 0;

    [self setContentSize:CGSizeMake(LOADING_BAR_X, LOADING_BAR_Y)];

    CCSprite *back       = [CCSprite spriteWithSpriteSheet:sheet rect:CGRectMake(0, 0, LOADING_BAR_X, LOADING_BAR_Y)];
    CCSprite *loadingBar = [CCSprite spriteWithSpriteSheet:sheet rect:CGRectMake(0, LOADING_BAR_Y * 1, 0, LOADING_BAR_Y)];

//    CCSprite *back       = [sheet createSpriteWithRect:CGRectMake(0, 0, LOADING_BAR_X, LOADING_BAR_Y)];
//    CCSprite *loadingBar = [sheet createSpriteWithRect:CGRectMake(0, LOADING_BAR_Y * 1, 0, LOADING_BAR_Y)];

    // [back setAnchorPoint:CGPointZero];
    [loadingBar setAnchorPoint:ccp(0, 0.5f)];
    [loadingBar setPosition:ccp(-LOADING_BAR_X / 2, 0)];

    [sheet addChild:back z:0 tag:kTagSpriteBack];
    [sheet addChild:loadingBar z:1 tag:kTagSpriteBar];
  }
  return(self);
}

-(void) loadImagesWithArray: (NSArray *) names target: (id) t selector: (SEL) sel
{
  target   = t;
  selector = sel;

  total        = [names count];
  imagesLoaded = 0;

  for (id name in names) {
    [[CCTextureCache sharedTextureCache] addImageAsync:name target:self selector:@selector(imageLoaded:)];
  }
}

-(void) dealloc
{
  [super dealloc];
}

-(void) imageLoaded: (CCTexture2D *) image
{
  CCSpriteSheet *sheet = (CCSpriteSheet *)[self getChildByTag:kTagSpriteManager];
  CCSprite      *bar   = (CCSprite *)[sheet getChildByTag:kTagSpriteBar];

  imagesLoaded++;
  CGRect rect = [bar textureRect];
  rect.size.width = LOADING_BAR_X * (imagesLoaded / total);
  //NSLog(@"width: %f", rect.size.width);

  [bar setTextureRect:rect];

  if (total == imagesLoaded) {
    [target performSelector:selector withObject:self];
  }
}
@end
