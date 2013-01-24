//
//  LoadingBarNode.h
//  SapusTongue
//
//  Created by Ricardo Quesada on 28/07/09.
//  Copyright 2009 Sapus Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

//
// Useful node that loads textures asyncrhounusly
// While the textures are being loaded, it displays a "loading images"
// and when all the textures are loaded, it triggers the callback
@interface LoadingBarNode : CCNode {
  float total;
  float imagesLoaded;
  id    target;
  SEL   selector;
}

// laods the images with an array, and with a target/selector callback
-(void)loadImagesWithArray : (NSArray *)names target : (id) target selector : (SEL)selector;
@end
