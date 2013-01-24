
#import "m_target.h"
#import "player_airplane.h"
#import "GameState.h"

@implementation m_targets

#define MAXRANGEPLANE  5000                                                   // in pixels, hud update time 0.1, player speed 90

-(int) getNewUniqueRandomNumber: (int) max
{
  int rn      = abs(rand() % max);
  int cntnums = [random_target_numbers count];

  if (cntnums > max - 1) {
    [random_target_numbers removeAllObjects];
  }

  for (int i = 0; i <[random_target_numbers count]; i++) {
    if ([[random_target_numbers objectAtIndex:i] intValue] == rn) {
      return([self getNewUniqueRandomNumber:max]);
    }
  }
  [random_target_numbers addObject:[NSNumber numberWithInt:rn]];

  return(rn);
}

-(void) newTarget: (CCLayer *) world_layer mx: (float) mx my: (float) my
{
  GameState *gs = [GameState sharedInstance];

  NSString  *name;
  NSArray   *target_list;
  int       randomnumber;

  if (NO ==[gs getResuming]) {
    if ([gs getTargetsRequested] < 5) {
      randomnumber = [self getNewUniqueRandomNumber:48];
    }
    else {
      randomnumber = [self getNewUniqueRandomNumber:[target_data count]];
    }
  }
  else {
    randomnumber = [gs getCurrentDestination];
  }

  name        = [target_names objectAtIndex:randomnumber];
  target_list = [target_data objectForKey:name];

  [target_markers removeAllObjects];
  [orignal_pos_markers removeAllObjects];

  int longest_distance = 0;
  for (id targetpoint in target_list) {
    int flagnumber = randomnumber;
    if (flagnumber > 48) {
      flagnumber = 49;
    }
    CCSprite *sp = [[CCSprite spriteWithFile:[NSString stringWithFormat:@"flag-%d.png", flagnumber]] retain];
    CGPoint  cgp = CGPointFromString(targetpoint);

    sp.anchorPoint = ccp(0.0476190, 0.02564);
    cgp.y          = WORLD_HEIGHT - cgp.y;
    sp.position    = cgp;
    [orignal_pos_markers addObject:NSStringFromCGPoint(sp.position)];
    [gs setCurrentTarget:cgp];

    [world_layer addChild:sp z:1];

    [gs setCurrentDestination:randomnumber];
    [gs setDestinationstring:name];

    [target_markers addObject:sp];
    [sp release];

    float b = abs(mx) - cgp.x;
    float c = abs(my) - cgp.y;
    float a = sqrt((b * b) + (c * c));
    if (a > longest_distance) {
      longest_distance = a;
    }
  }

  if (NO ==[gs getResuming]) {
    // calculate fuel consumption
    float fuel_perc = longest_distance / (MAXRANGEPLANE / 100);
    fuel_perc = fuel_perc + ([gs getExtraFuelPercentage] * (fuel_perc / 100));
    if (longest_distance < 1000) {
      fuel_perc *= 3;
    }
    else{
      fuel_perc *= 2;
    }
    if (longest_distance > ((WORLD_WIDTH / 4) * 3)) {
      fuel_perc /= 1.5;
    }
    if (fuel_perc > 100) {
      fuel_perc = 100;
    }
    if ([gs getTargetsRequested] == 0) {
      fuel_perc = 100;
    }
    if (fuel_perc < 25) {
      fuel_perc = 25;
    }
    //fuel_perc = 3;
    [gs setPercentageFuel:fuel_perc];
  }
  else {
    [gs setPercentageFuel:[gs getPercentageFuel]];
  }

  [gs setTargetsRequested:[gs getTargetsRequested] + 1];
}

-(void) initTargetCCLayer: (CCLayer *) world_layer mx: (float) mx my: (float) my
{
  target_markers        = [[NSMutableArray alloc] initWithCapacity:10];
  orignal_pos_markers   = [[NSMutableArray alloc] initWithCapacity:10];
  random_target_numbers = [[NSMutableArray alloc] initWithCapacity:100];
  [self loadData];
  [self loadData2];
  [self newTarget:world_layer mx:mx my:my];
}

-(CGRect) makeRect: (CCSprite *) sp
{
  float x = sp.position.x;         //-[sp contentSize].width / 2;
  float y = sp.position.y;         //-[sp contentSize].height / 2;
  float h = sp.contentSize.height;
  float w = sp.contentSize.width;

  return(CGRectMake(x, y, w, h));
}

-(void) updateTargetsAndCollissions: (CCLayer *) world_layer mx: (float) mx my: (float) my player_airplane: (CCSprite *) player_airplane
{
  NSMutableArray *possible_targets = [[NSMutableArray alloc] initWithCapacity:10];
  float          distance          = 10000;
  int            target            = -1, cnt = 0;
  BOOL           target_hit        = NO;

  for (CCSprite *targetpoint in target_markers) {
    CGPoint target_position    = [targetpoint position];
    CGPoint original_positions = CGPointFromString([orignal_pos_markers objectAtIndex:cnt]);
    if (mx < SCREENWIDTH && mx > 0 && original_positions.x > (WORLD_WIDTH / 2)) {
      target_position.x = (WORLD_WIDTH - (original_positions.x - mx)) - ((WORLD_WIDTH - original_positions.x) * 2);
    }
    else {
      target_position.x = original_positions.x + mx;
    }
    target_position.y    = original_positions.y + my;
    targetpoint.position = target_position;

    targetpoint.visible = NO;
    float b = (SCREENWIDTH / 2) - target_position.x;
    float c = (SCREENHEIGHT / 2) - target_position.y;
    float a = sqrt((b * b) + (c * c));
    if (a < distance) {
      distance = a;
      target   = cnt;
    }
    [possible_targets addObject:targetpoint];
    cnt++;

    if (CGRectIntersectsRect([self makeRect:targetpoint], [self makeRect:player_airplane])) {
      target_hit = YES;
    }
  }
  if (target_hit) {
    GameState *gs = [GameState sharedInstance];
    if (AUTOFLYING ==[gs getPlayerState]) {
      if ([gs getNumLives] <= 0) {
        [gs setPlayerState:GAMEOVER];
        if ([gs getEffects]) {
          [[SimpleAudioEngine sharedEngine] playEffect:@"snd-game-over.wav"];
        }
        [gs setdestinationString:@"Game Over"];
      }
      else {
        if ([gs getEffects]) {
          [[SimpleAudioEngine sharedEngine] playEffect:@"target_hit_computer.wav"];
        }
        [gs setPlayerState:FLYING];
        [self newTarget:world_layer mx:mx my:my];
      }
    }
    else if (FLYING ==[gs getPlayerState]) {
      [gs addScorePoint];
      if ([gs getEffects]) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"target_hit.wav"];
      }
      [self newTarget:world_layer mx:mx my:my];
    }
  }
  else {
    if (target != -1) {
      GameState *gs           = [GameState sharedInstance];
      CCSprite  *targetsprite = [possible_targets objectAtIndex:target];
      [gs setCloseToTarget:NO];
      // TODO: dynamisch range zichtveld beperken.
//      int      cwidth        = targetsprite.contentSize.width;
//      int      cheight       = targetsprite.contentSize.height;
      //if ((targetsprite.position.x + (cwidth / 2) >= 0 && targetsprite.position.x - (cwidth / 2) < SCREENWIDTH) ||
      //    (targetsprite.position.y + (cheight / 2) > 0 && targetsprite.position.y + (cheight / 2) < SCREENHEIGHT)) {
      if ((targetsprite.position.x > (160 -[gs leftTarget]) && targetsprite.position.x < (320 +[gs rightTarget])) &&
          (targetsprite.position.y > (106 -[gs bottomTarget]) && targetsprite.position.y < (212 +[gs topTarget]))) {
        targetsprite.visible = YES;
      }
      if ((targetsprite.position.x > (160 - ([gs leftTarget] / 3)) && targetsprite.position.x < (320 + ([gs rightTarget] / 3))) &&
          (targetsprite.position.y > (106 - ([gs bottomTarget] / 3)) && targetsprite.position.y < (212 + ([gs topTarget] / 3)))) {
        [gs setCloseToTarget:YES];
      }
      [gs setNearestTarget:targetsprite.position];
    }
  }
  [possible_targets release];
}

-(void) dealloc
{
  [target_markers release];
  [orignal_pos_markers release];
  [target_names release];
  [target_data release];
  [super dealloc];
}

-(void) loadData
{
  target_data = [[NSMutableDictionary alloc] initWithCapacity:50];

  target_names = [[NSArray alloc] initWithObjects:@"Alabama", @"Wyoming", @"Arizona", @"Arkansas", @"California", @"Colorado", @"Connecticut", @"Delaware", @"Florida", @"Georgia", @"Wisconsin", @"Idaho", @"Illinois", @"Indiana", @"Iowa", @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland", @"Massachusetts", @"Michigan", @"Minnesota", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"Nevada", @"New Hampshire", @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Ohio", @"Oklahoma", @"Oregon", @"Pennsylvania", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee", @"Texas", @"Utah", @"Vermont", @"Virginia", @"Washington", @"Washington, D.C.", @"West Virginia", @"New York", @"Los Angeles", @"Chicago", @"Houston", @"Phoenix", @"Philadelphia", @"San Antonio", @"Dallas", @"San Diego", @"San Jose", @"Detroit", @"San Francisco", @"Jacksonville", @"Indianapolis", @"Austin", @"Columbus", @"Fort Worth", @"Charlotte", @"Memphis", @"Baltimore", @"Boston", @"El Paso", @"Milwaukee", @"Denver", @"Seattle", @"Nashville", @"Washington", @"Las Vegas", @"Portland", @"Louisville", @"Oklahoma City", @"Tucson", @"Atlanta", @"Albuquerque", @"Kansas City", @"Fresno", @"Sacramento", @"Long Beach", @"Mesa", @"Omaha", @"Cleveland", @"Virginia Beach", @"Miami", @"Oakland", @"Raleigh", @"Tulsa", @"Minneapolis", @"Colorado Springs", @"Arlington", @"Wichita", @"St. Louis", @"Tampa", @"Santa Ana", @"Anaheim", @"Cincinnati", @"Bakersfield", @"Aurora", @"New Orleans", @"Pittsburgh", @"Riverside", @"Toledo", @"Stockton", @"Corpus Christi", @"Lexington", @"St. Paul", @"Newark", @"Buffalo", @"Plano", @"Henderson", @"Lincoln", @"Fort Wayne", @"Glendale", @"Greensboro", @"Chandler", @"St. Petersburg", @"Jersey City", @"Scottsdale", @"Norfolk", @"Madison", @"Orlando", @"Birmingham", @"Baton Rouge", @"Durham", @"Laredo", @"Lubbock", @"Chesapeake", @"Chula Vista", @"Garland", @"Winston-Salem", @"North Las Vegas", @"Reno", @"Gilbert", @"Hialeah", @"Arlington", @"Akron", @"Irvine", @"Rochester", @"Boise", @"Modesto", @"Fremont", @"Montgomery", @"Spokane", @"Richmond", @"Yonkers", @"Irving", @"Shreveport", @"San Bernardino", @"Tacoma", @"Glendale", @"Des Moines", @"Augusta", @"Grand Rapids", @"Huntington Beach", @"Mobile", @"Moreno Valley", @"Little Rock", @"Amarillo", @"Columbus", @"Oxnard", @"Fontana", @"Knoxville", @"Fort Lauderdale", @"Worcester", @"Salt Lake City", @"Newport News", @"Huntsville", @"Tempe", @"Brownsville", @"Fayetteville", @"Jackson", @"Tallahassee", @"Aurora", @"Ontario", @"Providence", @"Overland Park", @"Rancho Cucamonga", @"Chattanooga", @"Oceanside", @"Santa Clarita", @"Garden Grove", @"Vancouver", @"Grand Prairie", @"Peoria", @"Rockford", @"Cape Coral", @"Springfield", @"Santa Rosa", @"Sioux Falls", @"Port St. Lucie", @"Dayton", @"Salem", @"Pomona", nil];

  NSArray *pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2572, 1366)), nil];
  [target_data setObject:pointlist forKey:@"Alabama"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1326, 760)), nil];
  [target_data setObject:pointlist forKey:@"Wyoming"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1074, 1278)), nil];
  [target_data setObject:pointlist forKey:@"Arizona"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2230, 1246)), nil];
  [target_data setObject:pointlist forKey:@"Arkansas"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(738, 1238)), NSStringFromCGPoint(ccp(596, 1130)), NSStringFromCGPoint(ccp(465, 947)), nil];
  [target_data setObject:pointlist forKey:@"California"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1450, 1000)), nil];
  [target_data setObject:pointlist forKey:@"Colorado"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3416, 844)), nil];
  [target_data setObject:pointlist forKey:@"Connecticut"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3248, 1015)), nil];
  [target_data setObject:pointlist forKey:@"Delaware"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2878, 1658)), nil];
  [target_data setObject:pointlist forKey:@"Florida"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2772, 1374)), nil];
  [target_data setObject:pointlist forKey:@"Georgia"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2376, 660)), nil];
  [target_data setObject:pointlist forKey:@"Wisconsin"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(890, 698)), nil];
  [target_data setObject:pointlist forKey:@"Idaho"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2426, 934)), nil];
  [target_data setObject:pointlist forKey:@"Illinois"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2606, 950)), nil];
  [target_data setObject:pointlist forKey:@"Indiana"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2162, 822)), nil];
  [target_data setObject:pointlist forKey:@"Iowa"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1866, 1034)), nil];
  [target_data setObject:pointlist forKey:@"Kansas"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2676, 1088)), nil];
  [target_data setObject:pointlist forKey:@"Kentucky"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2226, 1494)), nil];
  [target_data setObject:pointlist forKey:@"Louisiana"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3624, 616)), nil];
  [target_data setObject:pointlist forKey:@"Maine"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3173, 982)), nil];
  [target_data setObject:pointlist forKey:@"Maryland"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3453, 800)), nil];
  [target_data setObject:pointlist forKey:@"Massachusetts"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2695, 731)), nil];
  [target_data setObject:pointlist forKey:@"Michigan"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2041, 467)), NSStringFromCGPoint(ccp(2193, 501)), NSStringFromCGPoint(ccp(2100, 644)), nil];
  [target_data setObject:pointlist forKey:@"Minnesota"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2404, 1308)), NSStringFromCGPoint(ccp(2398, 1426)), nil];
  [target_data setObject:pointlist forKey:@"Mississippi"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2194, 975)), NSStringFromCGPoint(ccp(2251, 1086)), nil];
  [target_data setObject:pointlist forKey:@"Missouri"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1030, 514)), NSStringFromCGPoint(ccp(1339, 518)), nil];
  [target_data setObject:pointlist forKey:@"Montana"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1636, 818)), NSStringFromCGPoint(ccp(1862, 856)), nil];
  [target_data setObject:pointlist forKey:@"Nebraska"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(830, 1041)), NSStringFromCGPoint(ccp(715, 903)), nil];
  [target_data setObject:pointlist forKey:@"Nevada"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3477, 734)), nil];
  [target_data setObject:pointlist forKey:@"New Hampshire"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3296, 951)), nil];
  [target_data setObject:pointlist forKey:@"New Jersey"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1329, 1196)), NSStringFromCGPoint(ccp(1513, 1196)), NSStringFromCGPoint(ccp(1513, 1359)), NSStringFromCGPoint(ccp(1329, 1359)), nil];
  [target_data setObject:pointlist forKey:@"New Mexico"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3122, 781)), NSStringFromCGPoint(ccp(3293, 715)), NSStringFromCGPoint(ccp(3370, 890)), nil];
  [target_data setObject:pointlist forKey:@"New York"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2795, 1215)), NSStringFromCGPoint(ccp(2974, 1194)), NSStringFromCGPoint(ccp(3127, 1217)), nil];
  [target_data setObject:pointlist forKey:@"North Carolina"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1639, 498)), NSStringFromCGPoint(ccp(1851, 498)), nil];
  [target_data setObject:pointlist forKey:@"North Dakota"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2814, 925)), nil];
  [target_data setObject:pointlist forKey:@"Ohio"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2049, 1223)), NSStringFromCGPoint(ccp(1844, 1197)), nil];
  [target_data setObject:pointlist forKey:@"Oklahoma"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(438, 698)), NSStringFromCGPoint(ccp(644, 698)), nil];
  [target_data setObject:pointlist forKey:@"Oregon"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3026, 888)), NSStringFromCGPoint(ccp(3190, 888)), nil];
  [target_data setObject:pointlist forKey:@"Pennsylvania"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3478, 839)), nil];
  [target_data setObject:pointlist forKey:@"Rhode Island"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2922, 1307)), nil];
  [target_data setObject:pointlist forKey:@"South Carolina"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1639, 677)), NSStringFromCGPoint(ccp(1851, 677)), nil];
  [target_data setObject:pointlist forKey:@"South Dakota"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2495, 1193)), NSStringFromCGPoint(ccp(2697, 1186)), nil];
  [target_data setObject:pointlist forKey:@"Tennessee"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1686, 1236)), NSStringFromCGPoint(ccp(1573, 1491)), NSStringFromCGPoint(ccp(1791, 1423)), NSStringFromCGPoint(ccp(2031, 1422)), NSStringFromCGPoint(ccp(1869, 1630)), nil];
  [target_data setObject:pointlist forKey:@"Texas"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1024, 933)), NSStringFromCGPoint(ccp(1104, 1035)), nil];
  [target_data setObject:pointlist forKey:@"Utah"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3411, 700)), nil];
  [target_data setObject:pointlist forKey:@"Vermont"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3099, 1077)), NSStringFromCGPoint(ccp(2847, 1123)), nil];
  [target_data setObject:pointlist forKey:@"Virginia"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(667, 493)), NSStringFromCGPoint(ccp(465, 500)), nil];
  [target_data setObject:pointlist forKey:@"Washington"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3154, 1006)), nil];
  [target_data setObject:pointlist forKey:@"Washington, D.C."];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2922, 1029)), nil];
  [target_data setObject:pointlist forKey:@"West Virginia"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3343, 893)), nil];
  [target_data setObject:pointlist forKey:@"New York"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(680, 1303)), nil];
  [target_data setObject:pointlist forKey:@"Los Angeles"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2513, 825)), nil];
  [target_data setObject:pointlist forKey:@"Chicago"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2050, 1548)), nil];
  [target_data setObject:pointlist forKey:@"Houston"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1052, 1327)), nil];
  [target_data setObject:pointlist forKey:@"Phoenix"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3264, 943)), nil];
  [target_data setObject:pointlist forKey:@"Philadelphia"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1866, 1572)), nil];
  [target_data setObject:pointlist forKey:@"San Antonio"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1971, 1373)), nil];
  [target_data setObject:pointlist forKey:@"Dallas"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(747, 1369)), nil];
  [target_data setObject:pointlist forKey:@"San Diego"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(460, 1099)), nil];
  [target_data setObject:pointlist forKey:@"San Jose"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2272, 820)), nil];
  [target_data setObject:pointlist forKey:@"Detroit"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(432, 1072)), nil];
  [target_data setObject:pointlist forKey:@"San Francisco"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2872, 1518)), nil];
  [target_data setObject:pointlist forKey:@"Jacksonville"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2607, 945)), nil];
  [target_data setObject:pointlist forKey:@"Indianapolis"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1909, 1522)), nil];
  [target_data setObject:pointlist forKey:@"Austin"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2798, 940)), nil];
  [target_data setObject:pointlist forKey:@"Columbus"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1935, 1377)), nil];
  [target_data setObject:pointlist forKey:@"Fort Worth"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2930, 1227)), nil];
  [target_data setObject:pointlist forKey:@"Charlotte"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2379, 1234)), nil];
  [target_data setObject:pointlist forKey:@"Memphis"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3180, 1000)), nil];
  [target_data setObject:pointlist forKey:@"Baltimore"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3508, 799)), nil];
  [target_data setObject:pointlist forKey:@"Boston"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1407, 1430)), nil];
  [target_data setObject:pointlist forKey:@"El Paso"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2499, 765)), nil];
  [target_data setObject:pointlist forKey:@"Milwaukee"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1483, 972)), nil];
  [target_data setObject:pointlist forKey:@"Denver"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(440, 482)), nil];
  [target_data setObject:pointlist forKey:@"Seattle"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2568, 1168)), nil];
  [target_data setObject:pointlist forKey:@"Nashville"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3155, 1006)), nil];
  [target_data setObject:pointlist forKey:@"Washington"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(882, 1172)), nil];
  [target_data setObject:pointlist forKey:@"Las Vegas"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(427, 615)), nil];
  [target_data setObject:pointlist forKey:@"Portland"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2634, 1055)), nil];
  [target_data setObject:pointlist forKey:@"Louisville"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1925, 1214)), nil];
  [target_data setObject:pointlist forKey:@"Oklahoma City"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1124, 1408)), nil];
  [target_data setObject:pointlist forKey:@"Tucson"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2709, 1315)), nil];
  [target_data setObject:pointlist forKey:@"Atlanta"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1379, 1235)), nil];
  [target_data setObject:pointlist forKey:@"Albuquerque"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2109, 990)), nil];
  [target_data setObject:pointlist forKey:@"Kansas City"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(587, 1132)), nil];
  [target_data setObject:pointlist forKey:@"Fresno"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(488, 1029)), nil];
  [target_data setObject:pointlist forKey:@"Sacramento"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(687, 1308)), nil];
  [target_data setObject:pointlist forKey:@"Long Beach"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1040, 1349)), nil];
  [target_data setObject:pointlist forKey:@"Mesa"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2017, 865)), nil];
  [target_data setObject:pointlist forKey:@"Omaha"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2875, 851)), nil];
  [target_data setObject:pointlist forKey:@"Cleveland"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3211, 1130)), nil];
  [target_data setObject:pointlist forKey:@"Virginia Beach"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2959, 1789)), nil];
  [target_data setObject:pointlist forKey:@"Miami"];
}

-(void) loadData2
{
  NSArray *pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(445, 1073)), nil];

  [target_data setObject:pointlist forKey:@"Oakland"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3048, 1191)), nil];
  [target_data setObject:pointlist forKey:@"Raleigh"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2016, 1173)), nil];
  [target_data setObject:pointlist forKey:@"Tulsa"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2179, 645)), nil];
  [target_data setObject:pointlist forKey:@"Minneapolis"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1491, 1014)), nil];
  [target_data setObject:pointlist forKey:@"Colorado Springs"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1949, 1378)), nil];
  [target_data setObject:pointlist forKey:@"Arlington"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1940, 1080)), nil];
  [target_data setObject:pointlist forKey:@"Wichita"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2361, 1024)), nil];
  [target_data setObject:pointlist forKey:@"St. Louis"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2824, 1660)), nil];
  [target_data setObject:pointlist forKey:@"Tampa"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(706, 1313)), nil];
  [target_data setObject:pointlist forKey:@"Santa Ana"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(707, 1306)), nil];
  [target_data setObject:pointlist forKey:@"Anaheim"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2704, 992)), nil];
  [target_data setObject:pointlist forKey:@"Cincinnati"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(621, 1219)), nil];
  [target_data setObject:pointlist forKey:@"Bakersfield"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1483, 962)), nil];
  [target_data setObject:pointlist forKey:@"Aurora"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2386, 1530)), nil];
  [target_data setObject:pointlist forKey:@"New Orleans"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2976, 910)), nil];
  [target_data setObject:pointlist forKey:@"Pittsburgh"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(739, 1302)), nil];
  [target_data setObject:pointlist forKey:@"Riverside"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2761, 841)), nil];
  [target_data setObject:pointlist forKey:@"Toledo"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(497, 1064)), nil];
  [target_data setObject:pointlist forKey:@"Stockton"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1931, 1675)), nil];
  [target_data setObject:pointlist forKey:@"Corpus Christi"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2708, 1058)), nil];
  [target_data setObject:pointlist forKey:@"Lexington"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2188, 646)), nil];
  [target_data setObject:pointlist forKey:@"St. Paul"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3326, 894)), nil];
  [target_data setObject:pointlist forKey:@"Newark"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3044, 767)), nil];
  [target_data setObject:pointlist forKey:@"Buffalo"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1975, 1356)), nil];
  [target_data setObject:pointlist forKey:@"Plano"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(878, 1177)), nil];
  [target_data setObject:pointlist forKey:@"Henderson"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1978, 895)), nil];
  [target_data setObject:pointlist forKey:@"Lincoln"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2665, 877)), nil];
  [target_data setObject:pointlist forKey:@"Fort Wayne"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1048, 1326)), nil];
  [target_data setObject:pointlist forKey:@"Glendale"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2992, 1176)), nil];
  [target_data setObject:pointlist forKey:@"Greensboro"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1023, 1385)), nil];
  [target_data setObject:pointlist forKey:@"Chandler"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2813, 1668)), nil];
  [target_data setObject:pointlist forKey:@"St. Petersburg"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3327, 901)), nil];
  [target_data setObject:pointlist forKey:@"Jersey City"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1069, 1321)), nil];
  [target_data setObject:pointlist forKey:@"Scottsdale"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3197, 1124)), nil];
  [target_data setObject:pointlist forKey:@"Norfolk"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2413, 758)), nil];
  [target_data setObject:pointlist forKey:@"Madison"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2886, 1625)), nil];
  [target_data setObject:pointlist forKey:@"Orlando"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2564, 1328)), nil];
  [target_data setObject:pointlist forKey:@"Birmingham"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2307, 1511)), nil];
  [target_data setObject:pointlist forKey:@"Baton Rouge"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3041, 1179)), nil];
  [target_data setObject:pointlist forKey:@"Durham"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1813, 1683)), nil];
  [target_data setObject:pointlist forKey:@"Laredo"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1665, 1330)), nil];
  [target_data setObject:pointlist forKey:@"Lubbock"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3195, 1137)), nil];
  [target_data setObject:pointlist forKey:@"Chesapeake"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(757, 1378)), nil];
  [target_data setObject:pointlist forKey:@"Chula Vista"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1976, 1369)), nil];
  [target_data setObject:pointlist forKey:@"Garland"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2963, 1177)), nil];
  [target_data setObject:pointlist forKey:@"Winston-Salem"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(874, 1161)), nil];
  [target_data setObject:pointlist forKey:@"North Las Vegas"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(595, 973)), nil];
  [target_data setObject:pointlist forKey:@"Reno"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1074, 1342)), nil];
  [target_data setObject:pointlist forKey:@"Gilbert"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2957, 1778)), nil];
  [target_data setObject:pointlist forKey:@"Hialeah"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3147, 1018)), nil];
  [target_data setObject:pointlist forKey:@"Arlington"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2884, 876)), nil];
  [target_data setObject:pointlist forKey:@"Akron"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(713, 1318)), nil];
  [target_data setObject:pointlist forKey:@"Irvine"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3118, 749)), nil];
  [target_data setObject:pointlist forKey:@"Rochester"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(804, 725)), nil];
  [target_data setObject:pointlist forKey:@"Boise"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(512, 1082)), nil];
  [target_data setObject:pointlist forKey:@"Modesto"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(458, 1087)), nil];
  [target_data setObject:pointlist forKey:@"Fremont"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2597, 1399)), nil];
  [target_data setObject:pointlist forKey:@"Montgomery"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(732, 483)), nil];
  [target_data setObject:pointlist forKey:@"Spokane"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3125, 1087)), nil];
  [target_data setObject:pointlist forKey:@"Richmond"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3343, 882)), nil];
  [target_data setObject:pointlist forKey:@"Yonkers"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1962, 1370)), nil];
  [target_data setObject:pointlist forKey:@"Irving"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2139, 1389)), nil];
  [target_data setObject:pointlist forKey:@"Shreveport"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(740, 1287)), nil];
  [target_data setObject:pointlist forKey:@"San Bernardino"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(433, 504)), nil];
  [target_data setObject:pointlist forKey:@"Tacoma"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(684, 1286)), nil];
  [target_data setObject:pointlist forKey:@"Glendale"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2160, 848)), nil];
  [target_data setObject:pointlist forKey:@"Des Moines"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2851, 1337)), nil];
  [target_data setObject:pointlist forKey:@"Augusta"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2637, 762)), nil];
  [target_data setObject:pointlist forKey:@"Grand Rapids"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(703, 1317)), nil];
  [target_data setObject:pointlist forKey:@"Huntington Beach"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2490, 1492)), nil];
  [target_data setObject:pointlist forKey:@"Mobile"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(754, 1306)), nil];
  [target_data setObject:pointlist forKey:@"Moreno Valley"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2235, 1259)), nil];
  [target_data setObject:pointlist forKey:@"Little Rock"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1670, 1218)), nil];
  [target_data setObject:pointlist forKey:@"Amarillo"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2684, 1387)), nil];
  [target_data setObject:pointlist forKey:@"Columbus"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(628, 1285)), nil];
  [target_data setObject:pointlist forKey:@"Oxnard"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(731, 1295)), nil];
  [target_data setObject:pointlist forKey:@"Fontana"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2747, 1177)), nil];
  [target_data setObject:pointlist forKey:@"Knoxville"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2964, 1761)), nil];
  [target_data setObject:pointlist forKey:@"Fort Lauderdale"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3465, 805)), nil];
  [target_data setObject:pointlist forKey:@"Worcester"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1067, 897)), nil];
  [target_data setObject:pointlist forKey:@"Salt Lake City"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3183, 1111)), nil];
  [target_data setObject:pointlist forKey:@"Newport News"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2579, 1258)), nil];
  [target_data setObject:pointlist forKey:@"Huntsville"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1065, 1337)), nil];
  [target_data setObject:pointlist forKey:@"Tempe"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1930, 1781)), nil];
  [target_data setObject:pointlist forKey:@"Brownsville"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3048, 1240)), nil];
  [target_data setObject:pointlist forKey:@"Fayetteville"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2362, 1399)), nil];
  [target_data setObject:pointlist forKey:@"Jackson"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2718, 1511)), nil];
  [target_data setObject:pointlist forKey:@"Tallahassee"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2476, 834)), nil];
  [target_data setObject:pointlist forKey:@"Aurora"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(723, 1299)), nil];
  [target_data setObject:pointlist forKey:@"Ontario"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3485, 836)), nil];
  [target_data setObject:pointlist forKey:@"Providence"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2092, 1009)), nil];
  [target_data setObject:pointlist forKey:@"Overland Park"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(722, 1292)), nil];
  [target_data setObject:pointlist forKey:@"Rancho Cucamonga"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2661, 1237)), nil];
  [target_data setObject:pointlist forKey:@"Chattanooga"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(740, 1347)), nil];
  [target_data setObject:pointlist forKey:@"Oceanside"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(667, 1274)), nil];
  [target_data setObject:pointlist forKey:@"Santa Clarita"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(704, 1313)), nil];
  [target_data setObject:pointlist forKey:@"Garden Grove"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(427, 600)), nil];
  [target_data setObject:pointlist forKey:@"Vancouver"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1961, 1382)), nil];
  [target_data setObject:pointlist forKey:@"Grand Prairie"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1042, 1312)), nil];
  [target_data setObject:pointlist forKey:@"Peoria"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2431, 806)), nil];
  [target_data setObject:pointlist forKey:@"Rockford"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2854, 1733)), nil];
  [target_data setObject:pointlist forKey:@"Cape Coral"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2176, 1113)), nil];
  [target_data setObject:pointlist forKey:@"Springfield"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(419, 1034)), nil];
  [target_data setObject:pointlist forKey:@"Santa Rosa"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1977, 729)), nil];
  [target_data setObject:pointlist forKey:@"Sioux Falls"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2949, 1696)), nil];
  [target_data setObject:pointlist forKey:@"Port St. Lucie"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2723, 953)), nil];
  [target_data setObject:pointlist forKey:@"Dayton"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(398, 645)), nil];
  [target_data setObject:pointlist forKey:@"Salem"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(711, 1297)), nil];
  [target_data setObject:pointlist forKey:@"Pomona"];
}

@end
