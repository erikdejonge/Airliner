//
//  GameState.h
//  Airliner
//
//  Created by rabshakeh on 11/30/09 - 5:14 PM.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import <sqlite3.h>

#define SCREENWIDTH                 480
#define SCREENHEIGHT                320
#define WORLD_WIDTH                 4096
#define WORLD_HEIGHT                1600
#define AIRPLANE_START_ORIENTATION  90
#define TRANS_DURATION              0.4f
#define LEFTTARGET                  480
#define RIGHTARGET                  480
#define TOPTARGET                   320
#define BOTTOMTARGET                320
#define TARGETWINDOW_SIZE_STEP      3
#define SPEEDSTEP                   0.05
#define MAXSPEED                    200
#define AIRPLANESPEED               60
#define MAXSPEEDAUTOPILOT           200
#define BREAKDISTANCE               300
#define STOPANDACCELLTIME           1
#define LINESHOWMAXTIME             0.25
#define NUMREDDOTS                  1

typedef enum
{
  FLYING,
  TARGETMISSED,
  AUTOFLYING,
  GAMEOVER,
  PAUSED
} player_state_t;

@interface GameState : NSObject {
  float          percentage_fuel;
  int            num_lives;
  player_state_t player_state;
  NSString       *destinationstring;
  CGPoint        nearest_target;
  CGPoint        current_target;
  int            current_destination;
  int            extra_fuel_percentage;
  int            score;
  float          mapx, mapy, prevmapx, prevmapy;
  float          airplane_rotation;
  int            music, effects;
  NSMutableArray *music_random_number_array;
  BOOL           textures_loaded;
  int            targets_requested;
  int            fast_machine;
  BOOL           resuming;
  float          airplane_speed;
  sqlite3        *database;
  NSMutableArray *scores;
  int            left_target, top_target, right_target, bottom_target;
  int            started_previously;
  NSString       *savedplayername;
  int            turnrequested;
  int            turbo;
  int            autopilotturbo;
  float          runningtime;
  float          turbolastrequest;
  float          autopilotturbolastrequest;
  float          pixelstraveled;
  float          pixelrangewiththistank;
  float          linex, liney, lineshowntime;
  CGPoint        random_target_numbers[NUMREDDOTS];
  BOOL           close_to_target;
  BOOL           remove_menu_enabled;
}

@property (nonatomic, retain) NSMutableArray *scores;
@property (readonly) sqlite3                 *database;
@property (nonatomic, retain) NSString       *destinationstring;
@property (nonatomic, retain) NSString       *savedplayername;

+(GameState *)sharedInstance;

-(CGPoint)getRandomPointForTarget : (int)index;

-(void)createEditableCopyOfDatabaseIfNeeded;
-(void)loadScoresFromDB;
-(void)initializeDatabase;
-(BOOL)fastMachine;

-(void)newGame;

-(void)setRemoveMenuEnabled : (BOOL)b;
-(BOOL)getRemoveMenuEnabled;

-(void)setCloseToTarget : (BOOL)b;
-(BOOL)getCloseToTarget;

-(void)setResuming : (BOOL)b;
-(BOOL)getResuming;

-(void)saveState;
-(void)loadState;

-(void)startBackgroundMusic;

-(void)setPercentageFuel : (float)perc;
-(float)getPercentageFuel;

-(int)getNumLives;
-(void)decreaseLive;

-(float)getAirplaneRotation;
-(void)setAirplaneRotation : (float)rot;

-(player_state_t)getPlayerState;
-(void)setPlayerState       : (player_state_t)new_state;

-(void)setdestinationString : (NSString *)str;
-(NSString *)getdestinationString;

-(void)setNearestTarget : (CGPoint)p;
-(CGPoint)getNearestTarget;

-(void)setCurrentTarget : (CGPoint)p;
-(CGPoint)getCurrentTarget;

-(void)setCurrentDestination : (int)dest;
-(int)getCurrentDestination;

-(void)setExtraFuelPercentage : (int)perc;
-(int)getExtraFuelPercentage;

-(void)addScorePoint;
-(int)getScore;

-(void)setMapX : (float)x;
-(float)getMapX;

-(void)setMapY : (float)y;
-(float)getMapY;

-(void)setMusic : (int)m;
-(int)getMusic;

-(void)setEffects : (int)e;
-(int)getEffects;

-(int)airplaneSpeed;

-(CGPoint)getMapPoint;

-(void)setTurbo : (int)t;
-(int)getTurbo;

-(void)setAutopilotTurbo : (int)t;
-(int)getAutopilotTurbo;

-(BOOL)getTexturesLoaded;
-(void)setTexturesLoaded   : (BOOL)b;

-(void)setTargetsRequested : (int)t;
-(int)getTargetsRequested;

-(int)returnNumSmokeTrails;

-(int)leftTarget;
-(int)rightTarget;
-(int)topTarget;
-(int)bottomTarget;

-(void)setPlayerSavedName : (NSString *)s;
-(NSString *)getPlayerSavedName;

-(NSString *)commaSeparateThousands : (int)number;

-(void)setTurnRequested             : (int)b;
-(int)getTurnRequested;

-(void)addRunningTime : (ccTime)dt;
-(float)getRunningTime;

-(float)getPixelsTraveled;

-(void)setLineX : (float)x;
-(float)getLineX;

-(void)setLineY : (float)y;
-(float)getLineY;

-(void)updateState : (ccTime)dt;

@end

