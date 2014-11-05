//
//  CCButton.h
//  S_FlappyBird
//
//  Created by Suyuancheng on 14-10-19.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "CCButtonAction.h"
typedef void(*_TouchFunc)(int);
@interface CCButton : CCLayer
{
    CCLabelTTF  *_titleLabel;
    _TouchFunc  _func;
    BOOL        _end;
    BOOL        _touched;
    
}

@property(nonatomic,retain)id<CCButtonAction>   delegate;

- (id)initWithTitle:(NSString *)title size:(CGSize)size;
- (void)setTounFunc:(_TouchFunc)func;
- (void)doTouchAnimation:(CCNode*)node ;
- (BOOL)isPointInArea:(CGPoint) point;
- (void)setFontColor:(ccColor3B)RGB;

@end
