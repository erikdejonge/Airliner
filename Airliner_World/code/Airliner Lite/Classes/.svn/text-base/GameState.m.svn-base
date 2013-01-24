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
  return([NSArray arrayWithObjects:@"05-Super-Fun.mp3", nil]);
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
  [[CDAudioManager sharedManager] preloadBackgroundMusic:[[self musicArray] objectAtIndex:r]];

  if ([[CDAudioManager sharedManager] willPlayBackgroundMusic]) {
    [CDAudioManager sharedManager].backgroundMusic.volume = 0.1f;
    [[CDAudioManager sharedManager] setBackgroundMusicCompletionListener:self selector:@selector(startBackgroundMusic)];
  }

  [[CDAudioManager sharedManager] resumeBackgroundMusic];
  if (NO ==[self getMusic]) {
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

  //[self setMapX:-400];
  mapx = prevmapx = -(WORLD_WIDTH / 2) + 900;
  mapy = prevmapy = -(WORLD_HEIGHT / 2);

  targets_requested = 0;
  airplane_rotation = AIRPLANE_START_ORIENTATION;
  pixelstraveled    = 0;
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
  mapx            = x;
  pixelstraveled += abs(mapx - prevmapx);
  prevmapx        = mapx;
}

-(float) getMapX
{
  return(mapx);
}

-(void) setMapY: (float) y
{
  mapy            = y;
  pixelstraveled += abs(mapy - prevmapy);
  prevmapy        = mapy;
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
  current_destination = dest;
  NSArray *x = [NSArray arrayWithObjects:@"2062", @"2231", @"2078", @"2314", @"2029", @"2388", @"2173", @"1773", @"2240", @"2254", @"2551", @"1991", @"2533", @"2397", @"2166", @"2486", @"2508", @"2167", @"1868", @"2039", @"1916", @"1874", @"2476", @"2374", @"1948", @"2245", @"2579", @"2433", @"2028", @"1906", @"2706", @"2564", @"1963", @"2454", @"2236", @"2158", @"2136", @"2682", @"2389", @"2124", @"1875", @"2631", @"1914", @"2615", @"2312", @"2397", @"2401", @"2443", @"2063", @"2160", @"2419", @"2342", @"2380", @"2782", @"2625", @"3079", @"3083", @"3357", @"3236", @"3407", @"3347", @"2933", @"3205", @"2693", @"2552", @"2446", @"3673", @"2467", @"2787", @"3491", @"3504", @"2590", @"2903", @"3215", @"2457", @"3341", @"3211", @"2881", @"3220", @"3137", @"3015", @"2706", @"2833", @"2453", @"2453", @"2631", @"2558", @"3237", @"2968", @"2475", @"2859", @"3195", @"3485", @"2437", @"2688", @"2668", @"2787", @"3281", @"2578", @"2278", @"2065", @"2210", @"2393", @"2094", @"2241", @"2345", @"2219", @"2225", @"2164", @"2342", @"1971", @"2360", @"2069", @"2165", @"1986", @"2321", @"2020", @"2265", @"1834", @"1961", @"1998", @"2203", @"2025", @"2336", @"2161", @"2326", @"2113", @"2298", @"2213", @"2368", @"2128", @"2265", @"2105", @"2130", @"2266", @"1955", @"2327", @"2192", @"2283", @"2288", @"2215", @"2015", @"2211", @"2147", @"2411", @"2029", @"2189", @"2283", @"1332", @"1346", @"1252", @"1161", @"1372", @"1043", @"1312", @"1315", @"508", @"1124", @"1089", @"1153", @"1351", @"1247", @"1041", @"1581", @"1347", @"1349", @"1018", @"1223", @"1072", @"1168", @"1355", @"886", @"1341", @"1264", @"1083", @"1139", @"1288", @"1334", @"1335", @"1355", @"1353", @"1351", @"1232", @"252", @"1304", @"1326", @"1611", @"1258", @"1215", @"1145", @"1372", @"1447", @"1378", @"1386", @"1191", @"1415", @"1419", @"1283", @"90", @"3574", @"201", @"4077", @"393", @"3697", @"120", @"3974", @"3731", @"3949", @"4019", @"3961", @"3580", @"3710", @"87", @"3871", @"56", @"3949", nil];
  NSArray *y = [NSArray arrayWithObjects:@"628", @"1081", @"853", @"1215", @"815", @"1001", @"907", @"775", @"895", @"752", @"1102", @"874", @"827", @"662", @"938", @"782", @"855", @"973", @"811", @"872", @"843", @"830", @"972", @"1298", @"887", @"638", @"1182", @"1110", @"735", @"732", @"1192", @"1109", @"593", @"1171", @"1209", @"763", @"872", @"1202", @"983", @"959", @"799", @"1077", @"863", @"849", @"1310", @"799", @"1259", @"1019", @"872", @"558", @"942", @"1119", @"1177", @"579", @"664", @"700", @"651", @"906", @"813", @"479", @"709", @"834", @"961", @"596", @"583", @"601", @"466", @"617", @"411", @"507", @"549", @"625", @"488", @"741", @"574", @"710", @"914", @"958", @"404", @"738", @"641", @"716", @"631", @"597", @"825", @"671", @"685", @"951", @"875", @"559", @"519", @"793", @"1061", @"515", @"516", @"688", @"489", @"784", @"790", @"489", @"478", @"423", @"333", @"388", @"459", @"481", @"449", @"398", @"328", @"301", @"254", @"247", @"428", @"389", @"551", @"531", @"399", @"423", @"223", @"353", @"344", @"482", @"402", @"316", @"431", @"330", @"397", @"483", @"553", @"429", @"467", @"477", @"367", @"260", @"370", @"516", @"445", @"461", @"471", @"419", @"438", @"506", @"303", @"431", @"393", @"359", @"485", @"480", @"755", @"765", @"819", @"680", @"812", @"766", @"594", @"751", @"225", @"742", @"845", @"711", @"786", @"746", @"806", @"102", @"824", @"777", @"793", @"745", @"792", @"755", @"795", @"687", @"771", @"823", @"821", @"859", @"754", @"758", @"765", @"804", @"811", @"843", @"713", @"218", @"1397", @"1158", @"1048", @"1202", @"903", @"984", @"1549", @"905", @"893", @"1230", @"1080", @"903", @"1347", @"852", @"1118", @"1239", @"890", @"1160", @"1160", @"808", @"772", @"850", @"870", @"968", @"1437", @"1292", @"878", @"1039", @"1119", @"1071", @"1202", @"1136", nil];
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
    return(30);
  }
  return(15);
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

