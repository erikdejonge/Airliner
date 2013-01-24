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

  if (myTableView) {
    [myTableView removeFromSuperview];
    [myTableView release];
    myTableView = nil;
  }
  [[CCDirector sharedDirector] replaceScene:[CCCrossFadeTransition transitionWithDuration:TRANS_DURATION scene:[MainMenu scene]]];
}

-(id) init
{
  [super init];
  GameState *gs = [GameState sharedInstance];

  [gs loadScoresFromDB];

  CCSprite *background = [CCSprite spriteWithFile:@"menu-bg.png"];
  background.anchorPoint = ccp(0, 0);
  [self addChild:background z:-1];


  menusave = [CCMenuItemImage itemFromNormalImage:@"menu-abt-backtomenu.png" selectedImage:@"menu-abt-backtomenu-click.png" target:self selector:@selector(mainMenu:)];
  CCMenu *menusavemenu = [CCMenu menuWithItems:menusave, nil];
  menusavemenu.position = ccp(240, 49);
  [self addChild: menusavemenu z:2];

  return(self);
}


-(void) dealloc
{
  [myTableView release];
  [super dealloc];
}

// table view
-(UITableView *) newTableView
{
  UITableView *tv = [[UITableView alloc] initWithFrame:CGRectZero];

  tv.delegate   = self;
  tv.dataSource = self;

  tv.opaque = YES;

  tv.transform = CGAffineTransformMakeRotation((float)M_PI / 2.0f);       // 180 degrees
#define Xoffset  60
#define Yoffset  80
  tv.frame           = CGRectMake(Yoffset, Xoffset, 120, 360);
  tv.backgroundColor = [UIColor clearColor];
  tv.separatorColor  = [UIColor clearColor];
  return(tv);
}


-(void) onEnterTransitionDidFinish
{
  // activity indicator
  // table
  if (!myTableView) {
    myTableView = [self newTableView];
  }
  [[[CCDirector sharedDirector] openGLView] addSubview: myTableView];
  [myTableView reloadData];
}


#define kCellHeight        (30)
#define kMaxScoresToFetch  (50)

#pragma mark UITableView Delegate
-(NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  return(1);
}

-(CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  return(kCellHeight);
}

-(NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section
{
  GameState *gs = [GameState sharedInstance];

  return([[gs scores] count]);
}

-(UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  GameState       *gs           = [GameState sharedInstance];
  static NSString *MyIdentifier = @"HighScoreCell";

  UILabel         *name, *score;

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];

  if (cell == nil) {
    cell        = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
    cell.opaque = YES;

    // Name
    name     = [[UILabel alloc] initWithFrame:CGRectMake(65.0f, 0.0f, 150, kCellHeight - 2)];
    name.tag = 1;

    name.font                      = [UIFont fontWithName:@"Arial-BoldMT" size:22.0f];
    name.adjustsFontSizeToFitWidth = YES;
    name.textAlignment             = UITextAlignmentLeft;

    name.textColor        = [UIColor colorWithRed:255 / 255.0  green:255 / 255.0  blue:240 / 255.0 alpha:1];
    name.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    name.backgroundColor  = [UIColor clearColor];
    [cell.contentView addSubview:name];
    [name release];

    // Score
    score                           = [[UILabel alloc] initWithFrame:CGRectMake(200, 0.0f, 70.0f, kCellHeight - 2)];
    score.tag                       = 2;
    score.font                      = [UIFont systemFontOfSize:22.0f];
    score.textColor                 = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:240 / 255.0 alpha:1];
    score.adjustsFontSizeToFitWidth = YES;
    score.textAlignment             = UITextAlignmentRight;
    score.autoresizingMask          = UIViewAutoresizingFlexibleRightMargin;
    score.backgroundColor           = [UIColor clearColor];
    [cell.contentView addSubview:score];
    [score release];
  }
  else {
    name  = (UILabel *)[cell.contentView viewWithTag:1];
    score = (UILabel *)[cell.contentView viewWithTag:2];
  }

  int        i = indexPath.row;

  LocalScore *s = [[gs scores] objectAtIndex: i];
  name.text  = [NSString stringWithFormat:@"%d. %@", i + 1, s.playername];
  score.text = [s.score stringValue];

  return(cell);
}

#pragma mark UIAlertView Delegate

-(void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex
{
}

@end
