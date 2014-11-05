//
//  GameLayer.h
//  CatSU
//
//  Created by Suyuancheng on 14-10-31.
//  Copyright 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CatRole.h"
#import "A-StartSearch.h"
#import "PathNode.h"
@interface GameLayer : CCLayer {
    int             _countdownNum;
    int             _unitW;
    int             _unitH;
    int             _pathNodeCount;
    int             _index;
    CGSize          _winSize;
    CatRole         *_cat;
    NSArray         *_path;
    A_StartSearch   *_searchEngine;
    NSMutableArray  *_map;
    BOOL            _isMoving;
   
}
+(CCScene*)Scene;
/*
 initial the game 
 */
- (void)inInit;
- (void)initRole;
- (void)initMap;

/*
 count down action
 */
- (void)setCountDown:(NSInteger)seconds;
- (void)beginCountDown;
- (void)doneCountDown;
- (void)CountdownAnimation:(CCNode*)node;

/*
 game state
 */
- (void)gameOver;
- (void)gameRusme;
/*
 the main loop of this game
 */
- (void)mainLoop;
/*
 update game
 */
- (void)updateRole;

@end
