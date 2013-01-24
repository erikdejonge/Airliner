//
//  GameState.m
//  Airliner
//
//  Created by rabshakeh on 11/30/09 - 5:14 PM.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"
#import "CocosDenshion.h"
#import "LocalScore.h"

#include <sys/types.h>
#include <sys/sysctl.h>
static GameState *sharedInstance = nil;

@implementation GameState

@synthesize scores, database, destinationstring, savedplayername;
#pragma mark -
#pragma mark class instance methods

+(GameState *) sharedInstance
{
  @synchronized(self)
  {
    if (sharedInstance == nil) {
      sharedInstance = [[GameState alloc] init];
    }
  }
  return(sharedInstance);
}

+(id) allocWithZone: (NSZone *) zone
{
  @synchronized(self)
  {
    if (sharedInstance == nil) {
      sharedInstance = [super allocWithZone:zone];
      return(sharedInstance);  // assignment and return on first allocation
    }
  }
  return(nil); // on subsequent allocation attempts return nil
}

-(NSString *) machine
{
  size_t size;

  // Set 'oldp' parameter to NULL to get the size of the data
  // returned so we can allocate appropriate amount of space
  sysctlbyname("hw.machine", NULL, &size, NULL, 0);

  // Allocate the space to store name
  char *name = malloc(size);

  // Get the platform name
  sysctlbyname("hw.machine", name, &size, NULL, 0);

  // Place name into a string
  NSString *machine = [NSString stringWithCString:name encoding:NSASCIIStringEncoding];

  // Done with this
  free(name);

  return(machine);
}

-(BOOL) fastMachine
{
  //fast_machine = 0;
  //return(NO);

  if (fast_machine == -1) {
    NSString *device = [self machine];

    if ([device compare:@"iPhone1,1"] == NSOrderedSame) {
      fast_machine = 0;
    }
    else if ([device compare:@"iPhone1,2"] == NSOrderedSame) {
      fast_machine = 0;
    }
    else if ([device compare:@"iPod1,1"] == NSOrderedSame) {
      fast_machine = 0;
    }
    else if ([device compare:@"iPod2,1"] == NSOrderedSame) {
      fast_machine = 0;
    }
    else{
      fast_machine = 1;
    }
  }
  else {
    if (fast_machine == 1) {
      return(YES);
    }
    else {
      return(NO);
    }
  }
  if (fast_machine == 1) {
    return(YES);
  }
  else {
    return(NO);
  }
}

-(void) saveState
{
  NSUserDefaults *sud = [NSUserDefaults standardUserDefaults];

  [sud setFloat:percentage_fuel forKey:@"percentage_fuel"];
  [sud setInteger:num_lives forKey:@"num_lives"];
  [sud setInteger:player_state forKey:@"player_state"];
  [sud setObject:destinationstring forKey:@"destinationstring"];
  [sud setInteger:current_destination forKey:@"current_destination"];
  [sud setInteger:extra_fuel_percentage forKey:@"extra_fuel_percentage"];
  [sud setInteger:score forKey:@"score"];
  [sud setInteger:music forKey:@"music"];
  [sud setInteger:effects forKey:@"effects"];
  [sud setFloat:mapx forKey:@"mapx"];
  [sud setFloat:mapy forKey:@"mapy"];
  [sud setFloat:prevmapx forKey:@"prevmapx"];
  [sud setFloat:prevmapy forKey:@"prevmapy"];
  [sud setInteger:targets_requested forKey:@"targets_requested"];
  [sud setFloat:airplane_rotation forKey:@"airplane_rotation"];
  [sud setInteger:turbo forKey:@"turbo"];
  [sud setInteger:left_target forKey:@"left_target"];
  [sud setInteger:top_target forKey:@"top_target"];
  [sud setInteger:right_target forKey:@"right_target"];
  [sud setInteger:bottom_target forKey:@"bottom_target"];
  [sud setInteger:airplane_speed forKey:@"airplane_speed"];
  [sud setInteger:1 forKey:@"started_previously"];
  [sud setObject:self.savedplayername forKey:@"savedplayername"];
  [sud setFloat:runningtime forKey:@"runningtime"];
  [sud setFloat:autopilotturbolastrequest forKey:@"autopilotturbolastrequest"];
  [sud setFloat:turbolastrequest forKey:@"turbolastrequest"];
  [sud setFloat:runningtime forKey:@"runningtime"];
  [sud setFloat:pixelstraveled forKey:@"pixelstraveled"];
  [sud setFloat:pixelrangewiththistank forKey:@"pixelrangewiththistank"];
  [sud synchronize];
}

-(void) loadState
{
  NSUserDefaults *sud = [NSUserDefaults standardUserDefaults];

  percentage_fuel           = [sud floatForKey:@"percentage_fuel"];
  num_lives                 = [sud integerForKey:@"num_lives"];
  player_state              = [sud integerForKey:@"player_state"];
  destinationstring         = [sud objectForKey:@"destinationstring"];
  current_destination       = [sud integerForKey:@"current_destination"];
  extra_fuel_percentage     = [sud integerForKey:@"extra_fuel_percentage"];
  score                     = [sud integerForKey:@"score"];
  music                     = [sud integerForKey:@"music"];
  effects                   = [sud integerForKey:@"effects"];
  mapx                      = [sud floatForKey:@"mapx"];
  mapy                      = [sud floatForKey:@"mapy"];
  prevmapx                  = [sud floatForKey:@"prevmapx"];
  prevmapy                  = [sud floatForKey:@"prevmapy"];
  targets_requested         = [sud integerForKey:@"targets_requested"];
  airplane_rotation         = [sud floatForKey:@"airplane_rotation"];
  turbo                     = [sud integerForKey:@"turbo"];
  left_target               = [sud integerForKey:@"left_target"];
  top_target                = [sud integerForKey:@"top_target"];
  right_target              = [sud integerForKey:@"right_target"];
  bottom_target             = [sud integerForKey:@"bottom_target"];
  airplane_speed            = [sud integerForKey:@"airplane_speed"];
  started_previously        = [sud integerForKey:@"started_previously"];
  savedplayername           = [sud objectForKey:@"savedplayername"];
  runningtime               = [sud floatForKey:@"runningtime"];
  turbolastrequest          = [sud floatForKey:@"turbolastrequest"];
  autopilotturbolastrequest = [sud floatForKey:@"autopilotturbolastrequest"];
  pixelstraveled            = [sud floatForKey:@"pixelstraveled"];
  pixelrangewiththistank    = [sud floatForKey:@"pixelrangewiththistank"];
  // first time after install
  if (started_previously == 0) {
    music   = 1;
    effects = 1;
  }
}


-(NSArray *) musicArray
{
  return([NSArray arrayWithObjects:@"01-Derty.mp3", @"05-Super-Fun.mp3", @"09-Outer-Space.mp3", @"01-Disorganized-Fun.mp3", @"05-Throwing-Fire.mp3",
          @"10-Gold-Spinners.mp3", @"02-Fifteen-Fifty.mp3", @"06-Minimal-MC.mp3", @"11-Remix-to-a-Remix.mp3", @"02-Neptune.mp3",
          @"07-Snap.mp3", @"12-Almost-Undamaged.mp3", @"03-Canon-In-D-Remix.mp3", @"07-Stay-Crunchy.mp3",
          @"03-Guitar-Sound.mp3", @"08-Inverted-Mean.mp3", @"04-Clutter.mp3", @"08-The-Sunfish-Song.mp3", @"04-Synth-One.mp3", @"09-Loui.mp3", nil]);
}

/*
   -(NSArray *) musicArray
   {
   return([NSArray arrayWithObjects:@"01-Derty.mp3", @"05-Super-Fun.mp3", nil]);
   //return([NSArray arrayWithObjects:@"target_hit_computer.wav", @"target_hit.wav", nil]);
   }

 */
-(int) getNewUniqueRandomNumber: (int) max
{
  int rn      = abs(rand() % max);
  int cntnums = [music_random_number_array count];

  if (cntnums >[[self musicArray] count] - 1) {
    [music_random_number_array removeAllObjects];
  }

  for (int i = 0; i <[music_random_number_array count]; i++) {
    if ([[music_random_number_array objectAtIndex:i] intValue] == rn) {
      return([self getNewUniqueRandomNumber:max]);
    }
  }
  [music_random_number_array addObject:[NSNumber numberWithInt:rn]];

  return(rn);
}

-(void) startBackgroundMusic
{
  //return;

  // de muziek loopt niet door na een nummerq
  music_random_number_array = [[NSMutableArray alloc] initWithCapacity:[[self musicArray] count]];
  int r = [self getNewUniqueRandomNumber:[[self musicArray] count]];
  if (started_previously == 0) {
    r = 1;
  }
  [[CDAudioManager sharedManager] preloadBackgroundMusic:[[self musicArray] objectAtIndex:r]];

  if ([[CDAudioManager sharedManager] willPlayBackgroundMusic]) {
    [CDAudioManager sharedManager].backgroundMusic.volume = 0.1f;
    [[CDAudioManager sharedManager] setBackgroundMusicCompletionListener:self selector:@selector(startBackgroundMusic)];
  }

  [[CDAudioManager sharedManager] resumeBackgroundMusic];
  if (0 ==[self getMusic]) {
    [[CDAudioManager sharedManager] pauseBackgroundMusic];
  }
}

-(id) copyWithZone: (NSZone *) zone
{
  return(self);
}

-(id) retain
{
  return(self);
}

-(unsigned) retainCount
{
  return(UINT_MAX);           // denotes an object that cannot be released
}

-(void) release
{
  //do nothing
}

-(GameState *) init
{
  [self loadState];
  [super init];
  turbo           = 0;
  textures_loaded = NO;
  fast_machine    = -1;
  resuming        = YES;    // still possible at this point
  turbo           = 0;
  autopilotturbo  = 0;
  linex           = SCREENWIDTH / 2;
  liney           = SCREENHEIGHT / 2;
  return(self);
}

-(id) autorelease
{
  return(self);
}

-(void) newGame
{
  srand(time(NULL));
  turnrequested         = NO;
  resuming              = NO;
  num_lives             = 3;
  destinationstring     = @"-";
  score                 = 0;
  extra_fuel_percentage = 50;
  player_state          = FLYING;
  turbo                 = 0;
  left_target           = LEFTTARGET;
  right_target          = RIGHTARGET;
  top_target            = TOPTARGET;
  bottom_target         = BOTTOMTARGET;
  airplane_speed        = AIRPLANESPEED;
  runningtime           = STOPANDACCELLTIME;
  turbolastrequest      = 0;
  close_to_target       = NO;

  //[self setMapX:-400];
  mapx = prevmapx = -(WORLD_WIDTH / 2) + 900;
  mapy = prevmapy = -(WORLD_HEIGHT / 2);

  targets_requested = 0;
  airplane_rotation = AIRPLANE_START_ORIENTATION;
  pixelstraveled    = 0;
}

-(void) setRemoveMenuEnabled: (BOOL) b;
{
  remove_menu_enabled = b;
}

-(BOOL) getRemoveMenuEnabled
{
  return(remove_menu_enabled);
}

-(void) setCloseToTarget: (BOOL) b
{
  close_to_target = b;
}

-(BOOL) getCloseToTarget
{
  return(close_to_target);
}

-(void) setResuming: (BOOL) b
{
  resuming = b;
}

-(float) getRunningTime
{
  return(runningtime);
}

-(void) addRunningTime: (ccTime) dt
{
  runningtime += dt;
}

-(BOOL) getResuming
{
  return(resuming);
}

-(void) setPercentageFuel: (float) perc
{
  percentage_fuel = perc;
  pixelstraveled  = 0;
  float maxdistance = sqrt((WORLD_WIDTH * WORLD_WIDTH) + (WORLD_HEIGHT * WORLD_HEIGHT));
  pixelrangewiththistank = (maxdistance / 100) * perc;
}

-(float) getPercentageFuel
{
  if (pixelrangewiththistank == 0) {
    return(0);
  }
  float pixelpercused = pixelstraveled / (pixelrangewiththistank / 100);
  float retval        = percentage_fuel - (pixelpercused * (percentage_fuel / 100));
  //
  if (retval < 0) {
    retval = (retval);
  }
  return(retval);
}

-(void) decreaseLive
{
  if (player_state == FLYING) {
    //NSLog(@"== decreasing live DISABLED !!! (GameState:decreaseLive) == ");
    num_lives--;
    if (num_lives <= 0) {
      num_lives = 0;
    }
  }
}

-(int) getNumLives
{
  return(num_lives);
}

-(float) getAirplaneRotation
{
  return(airplane_rotation);
}

-(void) setAirplaneRotation: (float) rot
{
  airplane_rotation = rot;
}

-(player_state_t) getPlayerState
{
  return(player_state);
}

-(void) setPlayerState: (player_state_t) new_state
{
  player_state = new_state;
}

-(void) setdestinationString: (NSString *) str
{
  self.destinationstring = str;
}

-(NSString *) getdestinationString
{
  return(self.destinationstring);
}

-(void) setNearestTarget: (CGPoint) p
{
  nearest_target = p;
}

-(CGPoint) getNearestTarget
{
  return(nearest_target);
}

-(void) setCurrentTarget: (CGPoint) p
{
  current_target = p;
}

-(CGPoint) getCurrentTarget
{
  return(current_target);
}

-(void) setExtraFuelPercentage: (int) perc
{
  extra_fuel_percentage = perc;
}

-(int) getExtraFuelPercentage
{
  return(extra_fuel_percentage);
}

-(void) addScorePoint
{
  score += percentage_fuel;
  if (score > 250) {
    if (extra_fuel_percentage > 10) {
      if (score % 50 == 0) {
        extra_fuel_percentage--;
      }
    }
  }

  if (left_target >= 0) {
    left_target -= TARGETWINDOW_SIZE_STEP;
  }
  if (right_target >= 0) {
    right_target -= TARGETWINDOW_SIZE_STEP;
  }
  if (top_target >= 0) {
    top_target -= TARGETWINDOW_SIZE_STEP;
  }
  if (bottom_target >= 0) {
    bottom_target -= TARGETWINDOW_SIZE_STEP;
  }
}

-(int) getScore
{
  return(score);
}

-(void) setMapX: (float) x
{
  mapx = x;
  int temp = abs(mapx - prevmapx);
  if (temp < 1000) {
    pixelstraveled += temp;
  }
  prevmapx = mapx;
}

-(float) getMapX
{
  return(mapx);
}

-(void) setMapY: (float) y
{
  mapy = y;
  int temp = abs(mapy - prevmapy);
  if (temp < 1000) {
    pixelstraveled += temp;
  }
  prevmapy = mapy;
}

-(float) getMapY
{
  return(mapy);
}

-(CGPoint) getMapPoint;
{
  return(ccp(mapx, mapy));
}

-(int) airplaneSpeed
{
  if (AUTOFLYING ==[self getPlayerState]) {
    float timepassed = runningtime - autopilotturbolastrequest;
    if (timepassed > STOPANDACCELLTIME) {
      timepassed = STOPANDACCELLTIME;
    }
    if (autopilotturbo == 1) {
      airplane_speed = AIRPLANESPEED + (timepassed * (MAXSPEEDAUTOPILOT - AIRPLANESPEED));
    }
    else {
      airplane_speed = MAXSPEEDAUTOPILOT - (timepassed * (MAXSPEEDAUTOPILOT - AIRPLANESPEED));
    }
  }
  else{
    float timepassed = runningtime - turbolastrequest;
    if (timepassed > STOPANDACCELLTIME) {
      timepassed = STOPANDACCELLTIME;
    }
    if (turbo == 1) {
      airplane_speed = AIRPLANESPEED + (timepassed * (MAXSPEED - AIRPLANESPEED));
    }
    else{
      airplane_speed = MAXSPEED - (timepassed * (MAXSPEED - AIRPLANESPEED));
    }
  }
  return(airplane_speed);
}

-(void) setCurrentDestination: (int) dest
{
  return;

  current_destination = dest;

  NSArray *x = [NSArray arrayWithObjects:@"2572", @"1326", @"1074", @"2230", @"738", @"596", @"465", @"1450", @"3416", @"3248", @"2878", @"2772", @"2376", @"890", @"2426", @"2606", @"2162", @"1866", @"2676", @"2226", @"3624", @"3173", @"3453", @"2695", @"2041", @"2193", @"2100", @"2404", @"2398", @"2194", @"2251", @"1030", @"1339", @"1636", @"1862", @"830", @"715", @"3477", @"3296", @"1329", @"1513", @"1513", @"1329", @"3122", @"3293", @"3370", @"2795", @"2974", @"3127", @"1639", @"1851", @"2814", @"2049", @"1844", @"438", @"644", @"3026", @"3190", @"3478", @"2922", @"1639", @"1851", @"2495", @"2697", @"1686", @"1573", @"1791", @"2031", @"1869", @"1024", @"1104", @"3411", @"3099", @"2847", @"667", @"465", @"3154", @"2922", @"3343", @"680", @"2513", @"2050", @"1052", @"3264", @"1866", @"1971", @"747", @"460", @"2272", @"432", @"2872", @"2607", @"1909", @"2798", @"1935", @"2930", @"2379", @"3180", @"3508", @"1407", @"2499", @"1483", @"440", @"2568", @"3155", @"882", @"427", @"2634", @"1925", @"1124", @"2709", @"1379", @"2109", @"587", @"488", @"687", @"1040", @"2017", @"2875", @"3211", @"2959", @"445", @"3048", @"2016", @"2179", @"1491", @"1949", @"1940", @"2361", @"2824", @"706", @"707", @"2704", @"621", @"1483", @"2386", @"2976", @"739", @"2761", @"497", @"1931", @"2708", @"2188", @"3326", @"3044", @"1975", @"878", @"1978", @"2665", @"1048", @"2992", @"1023", @"2813", @"3327", @"1069", @"3197", @"2413", @"2886", @"2564", @"2307", @"3041", @"1813", @"1665", @"3195", @"757", @"1976", @"2963", @"874", @"595", @"1074", @"2957", @"3147", @"2884", @"713", @"3118", @"804", @"512", @"458", @"2597", @"732", @"3125", @"3343", @"1962", @"2139", @"740", @"433", @"684", @"2160", @"2851", @"2637", @"703", @"2490", @"754", @"2235", @"1670", @"2684", @"628", @"731", @"2747", @"2964", @"3465", @"1067", @"3183", @"2579", @"1065", @"1930", @"3048", @"2362", @"2718", @"2476", @"723", @"3485", @"2092", @"722", @"2661", @"740", @"667", @"704", @"427", @"1961", @"1042", @"2431", @"2854", @"2176", @"419", @"1977", @"2949", @"2723", @"398", @"711", nil];
  NSArray *y = [NSArray arrayWithObjects:@"1366", @"760", @"1278", @"1246", @"1238", @"1130", @"947", @"1000", @"844", @"1015", @"1658", @"1374", @"660", @"698", @"934", @"950", @"822", @"1034", @"1088", @"1494", @"616", @"982", @"800", @"731", @"467", @"501", @"644", @"1308", @"1426", @"975", @"1086", @"514", @"518", @"818", @"856", @"1041", @"903", @"734", @"951", @"1196", @"1196", @"1359", @"1359", @"781", @"715", @"890", @"1215", @"1194", @"1217", @"498", @"498", @"925", @"1223", @"1197", @"698", @"698", @"888", @"888", @"839", @"1307", @"677", @"677", @"1193", @"1186", @"1236", @"1491", @"1423", @"1422", @"1630", @"933", @"1035", @"700", @"1077", @"1123", @"493", @"500", @"1006", @"1029", @"893", @"1303", @"825", @"1548", @"1327", @"943", @"1572", @"1373", @"1369", @"1099", @"820", @"1072", @"1518", @"945", @"1522", @"940", @"1377", @"1227", @"1234", @"1000", @"799", @"1430", @"765", @"972", @"482", @"1168", @"1006", @"1172", @"615", @"1055", @"1214", @"1408", @"1315", @"1235", @"990", @"1132", @"1029", @"1308", @"1349", @"865", @"851", @"1130", @"1789", @"1073", @"1191", @"1173", @"645", @"1014", @"1378", @"1080", @"1024", @"1660", @"1313", @"1306", @"992", @"1219", @"962", @"1530", @"910", @"1302", @"841", @"1064", @"1675", @"1058", @"646", @"894", @"767", @"1356", @"1177", @"895", @"877", @"1326", @"1176", @"1385", @"1668", @"901", @"1321", @"1124", @"758", @"1625", @"1328", @"1511", @"1179", @"1683", @"1330", @"1137", @"1378", @"1369", @"1177", @"1161", @"973", @"1342", @"1778", @"1018", @"876", @"1318", @"749", @"725", @"1082", @"1087", @"1399", @"483", @"1087", @"882", @"1370", @"1389", @"1287", @"504", @"1286", @"848", @"1337", @"762", @"1317", @"1492", @"1306", @"1259", @"1218", @"1387", @"1285", @"1295", @"1177", @"1761", @"805", @"897", @"1111", @"1258", @"1337", @"1781", @"1240", @"1399", @"1511", @"834", @"1299", @"836", @"1009", @"1292", @"1237", @"1347", @"1274", @"1313", @"600", @"1382", @"1312", @"806", @"1733", @"1113", @"1034", @"729", @"1696", @"953", @"645", @"1297", nil];

  for (int i = 0; i < NUMREDDOTS; i++) {
    int r = rand() %[x count];
    random_target_numbers[i] = ccp([[x objectAtIndex:r] intValue], WORLD_HEIGHT -[[y objectAtIndex:r] intValue]);
  }
}

-(CGPoint) getRandomPointForTarget: (int) index
{
  return(random_target_numbers[index]);
}

-(int) getCurrentDestination
{
  return(current_destination);
}

-(void) setMusic: (int) m
{
  music = m;
}

-(int) getMusic
{
  return(music);
}

-(void) setEffects: (int) e
{
  effects = e;
}

-(int) getEffects
{
  return(effects);
}

-(void) setAutopilotTurbo: (int) t
{
  autopilotturbolastrequest = runningtime;
  autopilotturbo            = t;
}

-(int) getAutopilotTurbo
{
  return(autopilotturbo);
}

-(void) setTurbo: (int) t
{
  turbolastrequest = runningtime;
  turbo            = t;
}

-(int) getTurbo;
{
  return(turbo);
}

-(BOOL) getTexturesLoaded
{
  return(textures_loaded);
}

-(void) setTexturesLoaded: (BOOL) b
{
  textures_loaded = b;
}

-(void) setTargetsRequested: (int) t
{
  targets_requested = t;
}

-(int) getTargetsRequested
{
  return(targets_requested);
}

-(int) returnNumSmokeTrails
{
  if ([self fastMachine]) {
    return(20);
  }
  return(10);
}

#pragma mark Database Stuff
// Creates a writable copy of the bundled default database in the application Documents directory.
-(void) createEditableCopyOfDatabaseIfNeeded
{
  // First, test for existence.
  BOOL          success;
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSError       *error;
  NSArray       *paths              = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString      *documentsDirectory = [paths objectAtIndex:0];
  NSString      *writableDBPath     = [documentsDirectory stringByAppendingPathComponent:@"scores.sqlite"];

  success = [fileManager fileExistsAtPath:writableDBPath];
  if (success) {
    return;
  }

  // The writable database does not exist, so copy the default to the appropriate location.
  NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"scores.sqlite"];
  success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
  if (!success) {
    NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
  }
}

-(void) loadScoresFromDB
{
  [scores removeAllObjects];

  //
  // Load only the best 50 scores
  //
  const char   *sql = "SELECT pk FROM scores ORDER BY score DESC LIMIT 50";
  sqlite3_stmt *statement;
  // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
  // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.
  if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
    // We "step" through the results - once for each row.
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
      // The second parameter indicates the column index into the result set.
      int primaryKey = sqlite3_column_int(statement, 0);
      // We avoid the alloc-init-autorelease pattern here because we are in a tight loop and
      // autorelease is slightly more expensive than release. This design choice has nothing to do with
      // actual memory management - at the end of this block of code, all the book objects allocated
      // here will be in memory regardless of whether we use autorelease or release, because they are
      // retained by the books array.
      LocalScore *lscore = [[LocalScore alloc] initWithPrimaryKey:primaryKey database:database];
      [scores addObject:lscore];
      [lscore release];
    }
    // "Finalize" the statement - releases the resources associated with the statement.
    sqlite3_finalize(statement);
  }
}

// Open the database connection and retrieve minimal information for all objects.
-(void) initializeDatabase
{
  NSMutableArray *scoresArray = [[NSMutableArray alloc] init];

  self.scores = scoresArray;
  [scoresArray release];
  // The database is stored in the application bundle.
  NSArray  *paths              = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *path               = [documentsDirectory stringByAppendingPathComponent:@"scores.sqlite"];
  // Open the database. The database was prepared outside the application.


  if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
    [self loadScoresFromDB];
  }
  else {
    // Even though the open failed, call close to properly clean up resources.
    sqlite3_close(database);
    NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
    // Additional error handling, as appropriate...
  }
}

-(int) leftTarget
{
  if (player_state == AUTOFLYING) {
    return(LEFTTARGET);
  }
  return(left_target);
}

-(int) rightTarget
{
  if (player_state == AUTOFLYING) {
    return(RIGHTARGET);
  }
  return(right_target);
}

-(int) topTarget
{
  if (player_state == AUTOFLYING) {
    return(TOPTARGET);
  }
  return(top_target);
}

-(int) bottomTarget
{
  if (player_state == AUTOFLYING) {
    return(BOTTOMTARGET);
  }
  return(bottom_target);
}

-(void) setPlayerSavedName: (NSString *) s
{
  self.savedplayername = s;
}

-(NSString *) getPlayerSavedName
{
  return(self.savedplayername);
}

-(NSString *) commaSeparateThousands: (int) number
{
  NSString *result = @"";

  if (number == 0) {
    result = [NSString stringWithFormat:@"%d", number];
  }
  else {
    while (number > 0)
    {
      int removedDigits = number % 1000;
      if (result != nil &&[result length] > 0) {
        if (number > 999) {
          result = [NSString stringWithFormat:@"%.3i.%@", removedDigits, result];
        }
        else{
          result = [NSString stringWithFormat:@"%i.%@", removedDigits, result];
        }
      }
      else{
        if (number > 999) {
          result = [NSString stringWithFormat:@"%.3i", removedDigits];
        }
        else{
          result = [NSString stringWithFormat:@"%i", removedDigits];
        }
      }
      number = number / 1000;
    }
  }
  return(result);
}

-(void) setTurnRequested: (int) b
{
  turnrequested = b;
}

-(int) getTurnRequested
{
  return(turnrequested);
}

-(float) getPixelsTraveled
{
  return(pixelstraveled);
}

-(void) setLineX: (float) x
{
  linex         = x;
  lineshowntime = runningtime;
}

-(float) getLineX
{
  return(linex);
}

-(void) setLineY: (float) y
{
  liney         = y;
  lineshowntime = runningtime;
}

-(float) getLineY
{
  return(liney);
}

-(void) updateState: (ccTime) dt
{
  [self addRunningTime:dt];
  if ((runningtime - lineshowntime) > LINESHOWMAXTIME) {
    linex = SCREENWIDTH / 2;
    liney = SCREENHEIGHT / 2;
  }
}

@end

