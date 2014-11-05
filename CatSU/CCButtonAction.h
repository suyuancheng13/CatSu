//
//  CCButtonAction.h
//  S_FlappyBird
//
//  Created by Suyuancheng on 14-10-20.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@protocol CCButtonAction <NSObject>
@required
- (void)onButtonClicked:(CCNode*)sender;
@end
