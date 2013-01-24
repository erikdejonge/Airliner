
#import "m_target.h"
#import "player_airplane.h"
#import "Airliner_LiteAppDelegate.h"
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

  target_counter++;

  if (target_counter > 3) {
    [gs setPlayerState:GAMEOVER];
  }

  if (NO ==[gs getResuming]) {
    randomnumber = [self getNewUniqueRandomNumber:5]; //[target_data count] - 1];
    /*
       if ([gs getTargetsRequested] < 2) {
       randomnumber = [self getNewUniqueRandomNumber:6];
       }
       else {
       randomnumber  = [self getNewUniqueRandomNumber:[target_data count] - 6];
       randomnumber += 6;
       }
     */
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
    CCSprite *sp = [[CCSprite spriteWithFile:[NSString stringWithFormat:@"flag-%d.png", randomnumber]] retain];
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
      // TODO: dynamisch range zichtveld beperken.
//      int      cwidth        = targetsprite.contentSize.width;
//      int      cheight       = targetsprite.contentSize.height;
      //if ((targetsprite.position.x + (cwidth / 2) >= 0 && targetsprite.position.x - (cwidth / 2) < SCREENWIDTH) ||
      //    (targetsprite.position.y + (cheight / 2) > 0 && targetsprite.position.y + (cheight / 2) < SCREENHEIGHT)) {
      if ((targetsprite.position.x > (160 -[gs leftTarget]) && targetsprite.position.x < (320 +[gs rightTarget])) &&
          (targetsprite.position.y > (106 -[gs bottomTarget]) && targetsprite.position.y < (212 +[gs topTarget]))) {
        targetsprite.visible = YES;
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
  target_data  = [[NSMutableDictionary alloc] initWithCapacity:230];
  target_names = [[NSArray alloc] initWithObjects:@"Algeria", @"Cuba", @"Australia", @"France", @"Germany", @"Africa", @"Asia", @"Europe", @"North America", @"South America", @"Oceania", @"Angola", @"Benin", @"Botswana", @"Burkina Faso", @"Burundi", @"Cameroon", @"Cape Verde", @"Central African Republic", @"Chad", @"Comoros", @"Ivory Coast", @"Djibouti", @"Egypt", @"Equatorial Guinea", @"Eritrea", @"Ethiopia", @"Gabon", @"Gambia", @"Ghana", @"Guinea", @"Guinea-Bissau", @"Kenya", @"Lesotho", @"Liberia", @"Libya", @"Madagascar", @"Malawi", @"Mali", @"Mauritania", @"Mauritius", @"Mayotte", @"Morocco", @"Mozambique", @"Namibia", @"Niger", @"Nigeria", @"Reunion", @"Rwanda", @"Sao Tome and Principe", @"Senegal", @"Seychelles", @"Sierra Leone", @"Somalia", @"South Africa", @"Sudan", @"Swaziland", @"Tanzania", @"Togo", @"Tunisia", @"Uganda", @"Zambia", @"Zimbabwe", @"Afghanistan", @"Bahrain", @"Bangladesh", @"Bhutan", @"Brunei", @"Cambodia", @"China", @"Hong Kong", @"India", @"Indonesia", @"Iran", @"Iraq", @"Israel", @"Japan", @"Jordan", @"Kazakhstan", @"North Korea", @"South Korea", @"Kuwait", @"Kyrgyzstan", @"Laos", @"Lebanon", @"Macau", @"Malaysia", @"Maldives", @"Mongolia", @"Myanmar (Burma)", @"Nepal", @"Oman", @"Pakistan", @"Palestinian territories", @"Philippines", @"Qatar", @"Saudi Arabia", @"Singapore", @"Sri Lanka", @"Syria", @"Tajikistan", @"Thailand", @"Timor-Leste (East Timor)", @"Turkey", @"Turkmenistan", @"United Arab Emirates", @"Uzbekistan", @"Vietnam", @"Yemen", @"Albania", @"Andorra", @"Austria", @"Belarus", @"Belgium", @"Bosnia and Herzegovina", @"Bulgaria", @"Croatia", @"Czech Republic", @"Denmark", @"Estonia", @"Faroe Islands", @"Finland", @"Gibraltar", @"Greece", @"Guernsey", @"Hungary", @"Iceland", @"Ireland", @"Isle of Man", @"Italy", @"Jersey", @"Latvia", @"Liechtenstein", @"Lithuania", @"Luxembourg", @"Macedonia", @"Malta", @"Moldova", @"Monaco", @"Montenegro", @"Netherlands", @"Norway", @"Poland", @"Portugal", @"Romania", @"San Marino", @"Serbia", @"Slovakia", @"Slovenia", @"Spain", @"Sweden", @"Switzerland", @"Ukraine", @"United Kingdom", @"Vatican City", @"Kosovo", @"Anguilla", @"Antigua and Barbuda", @"Aruba", @"Bahamas", @"Barbados", @"Belize", @"Bermuda", @"British Virgin Islands", @"Canada", @"Cayman Islands", @"Costa Rica", @"Dominica", @"Dominican Republic", @"El Salvador", @"Greenland", @"Grenada", @"Guadeloupe", @"Guatemala", @"Haiti", @"Honduras", @"Jamaica", @"Martinique", @"Mexico", @"Montserrat", @"Netherlands Antilles", @"Nicaragua", @"Panama", @"Puerto Rico", @"Saint Barthelemy", @"Saint Kitts and Nevis", @"Saint Lucia", @"Saint Vincent and the Grenadines", @"Trinidad and Tobago", @"Turks and Caicos Islands", @"United States", @"Argentina", @"Bolivia", @"Brazil", @"Chile", @"Colombia", @"Ecuador", @"Falkland Islands", @"French Guiana", @"Guyana", @"Paraguay", @"Peru", @"Suriname", @"Uruguay", @"Venezuela", @"American Samoa", @"Baker Island", @"Fiji", @"French Polynesia", @"Guam", @"Johnston Atoll", @"Marshall Islands", @"Micronesia", @"Nauru", @"New Zealand", @"Norfolk Island", @"Palau", @"Papua New Guinea", @"Samoa", @"Solomon Islands", @"Tonga", @"Vanuatu", nil];


  NSArray *pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2062, 628)), nil];
  [target_data setObject:pointlist forKey:@"Algeria"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2231, 1081)), nil];
  [target_data setObject:pointlist forKey:@"Angola"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2078, 853)), nil];
  [target_data setObject:pointlist forKey:@"Benin"];
}

-(void) loadData2
{
  NSArray *pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3673, 466)), NSStringFromCGPoint(ccp(3620, 551)), nil];

  [target_data setObject:pointlist forKey:@"Japan"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2467, 617)), nil];
  [target_data setObject:pointlist forKey:@"Jordan"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2787, 411)), nil];
  [target_data setObject:pointlist forKey:@"Kazakhstan"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3491, 507)), nil];
  [target_data setObject:pointlist forKey:@"North Korea"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3504, 549)), nil];
  [target_data setObject:pointlist forKey:@"South Korea"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2590, 625)), nil];
  [target_data setObject:pointlist forKey:@"Kuwait"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2903, 488)), nil];
  [target_data setObject:pointlist forKey:@"Kyrgyzstan"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3215, 741)), nil];
  [target_data setObject:pointlist forKey:@"Laos"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2457, 574)), nil];
  [target_data setObject:pointlist forKey:@"Lebanon"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3341, 710)), nil];
  [target_data setObject:pointlist forKey:@"Macau"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3211, 914)), NSStringFromCGPoint(ccp(3339, 930)), nil];
  [target_data setObject:pointlist forKey:@"Malaysia"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2881, 958)), nil];
  [target_data setObject:pointlist forKey:@"Maldives"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3220, 404)), nil];
  [target_data setObject:pointlist forKey:@"Mongolia"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3137, 738)), nil];
  [target_data setObject:pointlist forKey:@"Myanmar (Burma)"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3015, 641)), nil];
  [target_data setObject:pointlist forKey:@"Nepal"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2706, 716)), nil];
  [target_data setObject:pointlist forKey:@"Oman"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2833, 631)), nil];
  [target_data setObject:pointlist forKey:@"Pakistan"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2453, 597)), nil];
  [target_data setObject:pointlist forKey:@"Palestinian territories"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3441, 829)), nil];
  [target_data setObject:pointlist forKey:@"Philippines"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2631, 671)), nil];
  [target_data setObject:pointlist forKey:@"Qatar"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2558, 685)), nil];
  [target_data setObject:pointlist forKey:@"Saudi Arabia"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3237, 951)), nil];
  [target_data setObject:pointlist forKey:@"Singapore"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2968, 875)), nil];
  [target_data setObject:pointlist forKey:@"Sri Lanka"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2475, 559)), nil];
  [target_data setObject:pointlist forKey:@"Syria"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2859, 519)), nil];
  [target_data setObject:pointlist forKey:@"Tajikistan"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3195, 793)), nil];
  [target_data setObject:pointlist forKey:@"Thailand"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3485, 1061)), nil];
  [target_data setObject:pointlist forKey:@"Timor-Leste (East Timor)"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2437, 515)), nil];
  [target_data setObject:pointlist forKey:@"Turkey"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2688, 516)), nil];
  [target_data setObject:pointlist forKey:@"Turkmenistan"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2668, 688)), nil];
  [target_data setObject:pointlist forKey:@"United Arab Emirates"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2787, 489)), nil];
  [target_data setObject:pointlist forKey:@"Uzbekistan"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3281, 784)), nil];
  [target_data setObject:pointlist forKey:@"Vietnam"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2578, 790)), nil];
  [target_data setObject:pointlist forKey:@"Yemen"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2278, 489)), nil];
  [target_data setObject:pointlist forKey:@"Albania"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2065, 478)), nil];
  [target_data setObject:pointlist forKey:@"Andorra"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2210, 423)), nil];
  [target_data setObject:pointlist forKey:@"Austria"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2393, 333)), nil];
  [target_data setObject:pointlist forKey:@"Belarus"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2102, 381)), nil];
  [target_data setObject:pointlist forKey:@"Belgium"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2241, 459)), nil];
  [target_data setObject:pointlist forKey:@"Bosnia and Herzegovina"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2345, 481)), nil];
  [target_data setObject:pointlist forKey:@"Bulgaria"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2219, 449)), nil];
  [target_data setObject:pointlist forKey:@"Croatia"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2225, 398)), nil];
  [target_data setObject:pointlist forKey:@"Czech Republic"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2164, 328)), nil];
  [target_data setObject:pointlist forKey:@"Denmark"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2342, 301)), nil];
  [target_data setObject:pointlist forKey:@"Estonia"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1971, 254)), nil];
  [target_data setObject:pointlist forKey:@"Faroe Islands"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2360, 247)), nil];
  [target_data setObject:pointlist forKey:@"Finland"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2069, 428)), nil];
  [target_data setObject:pointlist forKey:@"France"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2165, 389)), nil];
  [target_data setObject:pointlist forKey:@"Germany"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1986, 551)), nil];
  [target_data setObject:pointlist forKey:@"Gibraltar"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2321, 531)), nil];
  [target_data setObject:pointlist forKey:@"Greece"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2020, 399)), nil];
  [target_data setObject:pointlist forKey:@"Guernsey"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2265, 423)), nil];
  [target_data setObject:pointlist forKey:@"Hungary"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1834, 223)), nil];
  [target_data setObject:pointlist forKey:@"Iceland"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1961, 353)), nil];
  [target_data setObject:pointlist forKey:@"Ireland"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1998, 344)), nil];
  [target_data setObject:pointlist forKey:@"Isle of Man"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2203, 482)), nil];
  [target_data setObject:pointlist forKey:@"Italy"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2025, 402)), nil];
  [target_data setObject:pointlist forKey:@"Jersey"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2336, 316)), nil];
  [target_data setObject:pointlist forKey:@"Latvia"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2161, 431)), nil];
  [target_data setObject:pointlist forKey:@"Liechtenstein"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2326, 330)), nil];
  [target_data setObject:pointlist forKey:@"Lithuania"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2113, 397)), nil];
  [target_data setObject:pointlist forKey:@"Luxembourg"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2298, 483)), nil];
  [target_data setObject:pointlist forKey:@"Macedonia"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2213, 553)), nil];
  [target_data setObject:pointlist forKey:@"Malta"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2375, 420)), nil];
  [target_data setObject:pointlist forKey:@"Moldova"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2128, 467)), nil];
  [target_data setObject:pointlist forKey:@"Monaco"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2265, 477)), nil];
  [target_data setObject:pointlist forKey:@"Montenegro"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2105, 367)), nil];
  [target_data setObject:pointlist forKey:@"Netherlands"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2130, 260)), NSStringFromCGPoint(ccp(2327, 158)), nil];
  [target_data setObject:pointlist forKey:@"Norway"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2266, 370)), nil];
  [target_data setObject:pointlist forKey:@"Poland"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1955, 516)), nil];
  [target_data setObject:pointlist forKey:@"Portugal"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2327, 445)), nil];
  [target_data setObject:pointlist forKey:@"Romania"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2192, 461)), nil];
  [target_data setObject:pointlist forKey:@"San Marino"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2283, 471)), nil];
  [target_data setObject:pointlist forKey:@"Serbia"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2288, 419)), nil];
  [target_data setObject:pointlist forKey:@"Slovakia"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2215, 438)), nil];
  [target_data setObject:pointlist forKey:@"Slovenia"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2015, 506)), nil];
  [target_data setObject:pointlist forKey:@"Spain"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2211, 303)), NSStringFromCGPoint(ccp(2289, 199)), nil];
  [target_data setObject:pointlist forKey:@"Sweden"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2147, 431)), nil];
  [target_data setObject:pointlist forKey:@"Switzerland"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2411, 393)), nil];
  [target_data setObject:pointlist forKey:@"Ukraine"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2029, 359)), nil];
  [target_data setObject:pointlist forKey:@"United Kingdom"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2189, 485)), nil];
  [target_data setObject:pointlist forKey:@"Vatican City"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2283, 480)), nil];
  [target_data setObject:pointlist forKey:@"Kosovo"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1332, 755)), nil];
  [target_data setObject:pointlist forKey:@"Anguilla"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1346, 765)), nil];
  [target_data setObject:pointlist forKey:@"Antigua and Barbuda"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1252, 819)), nil];
  [target_data setObject:pointlist forKey:@"Aruba"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1161, 680)), nil];
  [target_data setObject:pointlist forKey:@"Bahamas"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1372, 812)), nil];
  [target_data setObject:pointlist forKey:@"Barbados"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1043, 766)), nil];
  [target_data setObject:pointlist forKey:@"Belize"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1312, 594)), nil];
  [target_data setObject:pointlist forKey:@"Bermuda"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1315, 751)), nil];
  [target_data setObject:pointlist forKey:@"British Virgin Islands"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(508, 225)), NSStringFromCGPoint(ccp(655, 369)), NSStringFromCGPoint(ccp(925, 368)), NSStringFromCGPoint(ccp(1254, 349)), NSStringFromCGPoint(ccp(1077, 64)), NSStringFromCGPoint(ccp(748, 97)), nil];
  [target_data setObject:pointlist forKey:@"Canada"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1124, 742)), nil];
  [target_data setObject:pointlist forKey:@"Cayman Islands"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1089, 845)), nil];
  [target_data setObject:pointlist forKey:@"Costa Rica"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1153, 711)), nil];
  [target_data setObject:pointlist forKey:@"Cuba"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1351, 786)), nil];
  [target_data setObject:pointlist forKey:@"Dominica"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1247, 746)), nil];
  [target_data setObject:pointlist forKey:@"Dominican Republic"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1041, 806)), nil];
  [target_data setObject:pointlist forKey:@"El Salvador"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1581, 102)), nil];
  [target_data setObject:pointlist forKey:@"Greenland"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1347, 824)), nil];
  [target_data setObject:pointlist forKey:@"Grenada"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1349, 777)), nil];
  [target_data setObject:pointlist forKey:@"Guadeloupe"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1018, 793)), nil];
  [target_data setObject:pointlist forKey:@"Guatemala"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1223, 745)), nil];
  [target_data setObject:pointlist forKey:@"Haiti"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1072, 792)), nil];
  [target_data setObject:pointlist forKey:@"Honduras"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1168, 755)), nil];
  [target_data setObject:pointlist forKey:@"Jamaica"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1355, 795)), nil];
  [target_data setObject:pointlist forKey:@"Martinique"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(886, 687)), nil];
  [target_data setObject:pointlist forKey:@"Mexico"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1341, 771)), nil];
  [target_data setObject:pointlist forKey:@"Montserrat"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1264, 823)), nil];
  [target_data setObject:pointlist forKey:@"Netherlands Antilles"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1083, 821)), nil];
  [target_data setObject:pointlist forKey:@"Nicaragua"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1139, 859)), nil];
  [target_data setObject:pointlist forKey:@"Panama"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1288, 754)), nil];
  [target_data setObject:pointlist forKey:@"Puerto Rico"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1334, 758)), nil];
  [target_data setObject:pointlist forKey:@"Saint Barthelemy"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1335, 765)), nil];
  [target_data setObject:pointlist forKey:@"Saint Kitts and Nevis"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1355, 804)), nil];
  [target_data setObject:pointlist forKey:@"Saint Lucia"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1353, 811)), nil];
  [target_data setObject:pointlist forKey:@"Saint Vincent and the Grenadines"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1351, 843)), nil];
  [target_data setObject:pointlist forKey:@"Trinidad and Tobago"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1232, 713)), nil];
  [target_data setObject:pointlist forKey:@"Turks and Caicos Islands"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(252, 218)), NSStringFromCGPoint(ccp(674, 444)), NSStringFromCGPoint(ccp(754, 555)), NSStringFromCGPoint(ccp(950, 612)), NSStringFromCGPoint(ccp(1124, 652)), NSStringFromCGPoint(ccp(1199, 486)), NSStringFromCGPoint(ccp(974, 435)), NSStringFromCGPoint(ccp(279, 738)), nil];
  [target_data setObject:pointlist forKey:@"United States"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1304, 1397)), nil];
  [target_data setObject:pointlist forKey:@"Argentina"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1326, 1158)), nil];
  [target_data setObject:pointlist forKey:@"Bolivia"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1611, 1048)), NSStringFromCGPoint(ccp(1445, 1305)), NSStringFromCGPoint(ccp(1314, 985)), nil];
  [target_data setObject:pointlist forKey:@"Brazil"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1258, 1202)), NSStringFromCGPoint(ccp(1201, 1543)), nil];
  [target_data setObject:pointlist forKey:@"Chile"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1215, 903)), nil];
  [target_data setObject:pointlist forKey:@"Colombia"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1145, 984)), nil];
  [target_data setObject:pointlist forKey:@"Ecuador"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1372, 1549)), nil];
  [target_data setObject:pointlist forKey:@"Falkland Islands"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1447, 905)), nil];
  [target_data setObject:pointlist forKey:@"French Guiana"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1378, 893)), nil];
  [target_data setObject:pointlist forKey:@"Guyana"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1386, 1230)), nil];
  [target_data setObject:pointlist forKey:@"Paraguay"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1191, 1080)), nil];
  [target_data setObject:pointlist forKey:@"Peru"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1415, 903)), nil];
  [target_data setObject:pointlist forKey:@"Suriname"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1419, 1347)), nil];
  [target_data setObject:pointlist forKey:@"Uruguay"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1283, 852)), nil];
  [target_data setObject:pointlist forKey:@"Venezuela"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(90, 1118)), nil];
  [target_data setObject:pointlist forKey:@"American Samoa"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3574, 1239)), nil];
  [target_data setObject:pointlist forKey:@"Australia"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(201, 890)), nil];
  [target_data setObject:pointlist forKey:@"Baker Island"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(4077, 1160)), nil];
  [target_data setObject:pointlist forKey:@"Fiji"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(393, 1160)), nil];
  [target_data setObject:pointlist forKey:@"French Polynesia"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3697, 808)), nil];
  [target_data setObject:pointlist forKey:@"Guam"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(120, 772)), nil];
  [target_data setObject:pointlist forKey:@"Johnston Atoll"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3974, 850)), nil];
  [target_data setObject:pointlist forKey:@"Marshall Islands"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3731, 870)), nil];
  [target_data setObject:pointlist forKey:@"Micronesia"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3949, 968)), nil];
  [target_data setObject:pointlist forKey:@"Nauru"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(4019, 1437)), nil];
  [target_data setObject:pointlist forKey:@"New Zealand"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3961, 1292)), nil];
  [target_data setObject:pointlist forKey:@"Norfolk Island"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3580, 878)), nil];
  [target_data setObject:pointlist forKey:@"Palau"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3710, 1039)), nil];
  [target_data setObject:pointlist forKey:@"Papua New Guinea"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(87, 1119)), nil];
  [target_data setObject:pointlist forKey:@"Samoa"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3871, 1071)), nil];
  [target_data setObject:pointlist forKey:@"Solomon Islands"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(56, 1202)), nil];
  [target_data setObject:pointlist forKey:@"Tonga"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3949, 1136)), nil];
  [target_data setObject:pointlist forKey:@"Vanuatu"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2314, 1215)), nil];
  [target_data setObject:pointlist forKey:@"Botswana"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2029, 815)), nil];
  [target_data setObject:pointlist forKey:@"Burkina Faso"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2388, 1001)), nil];
  [target_data setObject:pointlist forKey:@"Burundi"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2173, 907)), nil];
  [target_data setObject:pointlist forKey:@"Cameroon"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1773, 775)), nil];
  [target_data setObject:pointlist forKey:@"Cape Verde"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2240, 895)), nil];
  [target_data setObject:pointlist forKey:@"Central African Republic"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2254, 752)), nil];
  [target_data setObject:pointlist forKey:@"Chad"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2551, 1102)), nil];
  [target_data setObject:pointlist forKey:@"Comoros"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1991, 874)), nil];
  [target_data setObject:pointlist forKey:@"Ivory Coast"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2533, 827)), nil];
  [target_data setObject:pointlist forKey:@"Djibouti"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2397, 662)), nil];
  [target_data setObject:pointlist forKey:@"Egypt"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2166, 938)), nil];
  [target_data setObject:pointlist forKey:@"Equatorial Guinea"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2486, 782)), nil];
  [target_data setObject:pointlist forKey:@"Eritrea"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2508, 855)), nil];
  [target_data setObject:pointlist forKey:@"Ethiopia"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2167, 973)), nil];
  [target_data setObject:pointlist forKey:@"Gabon"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1868, 811)), nil];
  [target_data setObject:pointlist forKey:@"Gambia"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2039, 872)), nil];
  [target_data setObject:pointlist forKey:@"Ghana"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1916, 843)), nil];
  [target_data setObject:pointlist forKey:@"Guinea"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1874, 830)), nil];
  [target_data setObject:pointlist forKey:@"Guinea-Bissau"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2476, 972)), nil];
  [target_data setObject:pointlist forKey:@"Kenya"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2374, 1298)), nil];
  [target_data setObject:pointlist forKey:@"Lesotho"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1948, 887)), nil];
  [target_data setObject:pointlist forKey:@"Liberia"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2245, 638)), nil];
  [target_data setObject:pointlist forKey:@"Libya"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2579, 1182)), nil];
  [target_data setObject:pointlist forKey:@"Madagascar"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2433, 1110)), nil];
  [target_data setObject:pointlist forKey:@"Malawi"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2028, 735)), nil];
  [target_data setObject:pointlist forKey:@"Mali"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1906, 732)), nil];
  [target_data setObject:pointlist forKey:@"Mauritania"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2706, 1192)), nil];
  [target_data setObject:pointlist forKey:@"Mauritius"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2564, 1109)), nil];
  [target_data setObject:pointlist forKey:@"Mayotte"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1963, 593)), nil];
  [target_data setObject:pointlist forKey:@"Morocco"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2454, 1171)), nil];
  [target_data setObject:pointlist forKey:@"Mozambique"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2236, 1209)), nil];
  [target_data setObject:pointlist forKey:@"Namibia"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2158, 763)), nil];
  [target_data setObject:pointlist forKey:@"Niger"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2136, 872)), nil];
  [target_data setObject:pointlist forKey:@"Nigeria"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2682, 1202)), nil];
  [target_data setObject:pointlist forKey:@"Reunion"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2389, 983)), nil];
  [target_data setObject:pointlist forKey:@"Rwanda"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2124, 959)), nil];
  [target_data setObject:pointlist forKey:@"Sao Tome and Principe"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1875, 799)), nil];
  [target_data setObject:pointlist forKey:@"Senegal"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2631, 1077)), nil];
  [target_data setObject:pointlist forKey:@"Seychelles"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(1914, 863)), nil];
  [target_data setObject:pointlist forKey:@"Sierra Leone"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2615, 849)), nil];
  [target_data setObject:pointlist forKey:@"Somalia"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2312, 1310)), nil];
  [target_data setObject:pointlist forKey:@"South Africa"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2397, 799)), nil];
  [target_data setObject:pointlist forKey:@"Sudan"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2408, 1260)), nil];
  [target_data setObject:pointlist forKey:@"Swaziland"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2443, 1019)), nil];
  [target_data setObject:pointlist forKey:@"Tanzania"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2063, 872)), nil];
  [target_data setObject:pointlist forKey:@"Togo"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2160, 558)), nil];
  [target_data setObject:pointlist forKey:@"Tunisia"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2419, 942)), nil];
  [target_data setObject:pointlist forKey:@"Uganda"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2342, 1119)), nil];
  [target_data setObject:pointlist forKey:@"Zambia"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2380, 1177)), nil];
  [target_data setObject:pointlist forKey:@"Zimbabwe"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2782, 579)), nil];
  [target_data setObject:pointlist forKey:@"Afghanistan"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2625, 664)), nil];
  [target_data setObject:pointlist forKey:@"Bahrain"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3079, 700)), nil];
  [target_data setObject:pointlist forKey:@"Bangladesh"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3083, 651)), nil];
  [target_data setObject:pointlist forKey:@"Bhutan"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3357, 906)), nil];
  [target_data setObject:pointlist forKey:@"Brunei"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3236, 813)), nil];
  [target_data setObject:pointlist forKey:@"Cambodia"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3407, 479)), NSStringFromCGPoint(ccp(3300, 693)), NSStringFromCGPoint(ccp(2983, 522)), nil];
  [target_data setObject:pointlist forKey:@"China"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3347, 709)), nil];
  [target_data setObject:pointlist forKey:@"Hong Kong"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2933, 834)), NSStringFromCGPoint(ccp(2850, 690)), NSStringFromCGPoint(ccp(2914, 628)), NSStringFromCGPoint(ccp(3036, 688)), nil];
  [target_data setObject:pointlist forKey:@"India"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(3205, 961)), NSStringFromCGPoint(ccp(3348, 976)), NSStringFromCGPoint(ccp(3317, 1048)), NSStringFromCGPoint(ccp(3626, 1008)), nil];
  [target_data setObject:pointlist forKey:@"Indonesia"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2693, 596)), nil];
  [target_data setObject:pointlist forKey:@"Iran"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2552, 583)), nil];
  [target_data setObject:pointlist forKey:@"Iraq"];
  pointlist = [NSArray arrayWithObjects: NSStringFromCGPoint(ccp(2446, 601)), nil];
  [target_data setObject:pointlist forKey:@"Israel"];
}

@end
