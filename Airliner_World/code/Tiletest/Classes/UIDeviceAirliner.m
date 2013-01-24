//
//  UIDeviceAirliner.m
//  Tiletest
//
//  Created by rabshakeh on 11/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UIDeviceAirliner.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation UIDeviceAirliner

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
  NSString *device = [self machine];

  // return(NO);

  if ([device compare:@"iPhone1,1"] == NSOrderedSame)
  {
    return(NO);
  }
  else if ([device compare:@"iPhone1,2"] == NSOrderedSame)
  {
    return(NO);
  }
  else if ([device compare:@"iPod1,1"] == NSOrderedSame)
  {
    return(NO);
  }
  return(YES);
}

@end
