//
//  CCButton.m
//  S_FlappyBird
//
//  Created by Suyuancheng on 14-10-19.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "CCButton.h"
#import "cocos2d.h"
@class HelloWorldLayer;
@implementation CCButton
@synthesize delegate;
- (id)initWithTitle:(NSString *)title size:(CGSize)size
{
    
    if(self = [super init])
    {
        _titleLabel = [CCLabelTTF labelWithString:title fontName:@"Marker Felt" fontSize:28];
        [self setContentSize:CGSizeMake([_titleLabel contentSize].width, [_titleLabel contentSize].height)];
        [self setTouchMode:kCCTouchesOneByOne];
        [self addChild:_titleLabel];
        _touched = NO;
        //[self ini]
       
      //  [self setContentSize: size];
     
    }
    return self;
}
- (void)setFontColor:(ccColor3B)RGB
{
    if(_titleLabel)
        [_titleLabel setColor:RGB];
}
#pragma mark- Touch event handle
- (void)setTounFunc:(_TouchFunc)func
{
    if(func)
    {
        _func = func;
    }
}

- (BOOL)isPointInArea:(CGPoint) point
{
    
//    CGRect Rect = CGRectMake(0, 0, [self contentSize].width, [self contentSize].height);
    //if(Rect.origin.x<point.x&&Rect.origin.y)
}
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{

    
    CGPoint touchPoint = [touch locationInView:[touch view]];//[self convertTouchToNodeSpace:touch];
    CGSize s = [self contentSize];
    NSLog(@"%f,%f",touchPoint.x,touchPoint.y);
    CGPoint point = [self position];
    CGPoint start;
    start.x = point.x-s.width/2;
    start.y = [[CCDirector sharedDirector]winSize].height-point.y-s.height/2;
    
    CGPoint end;
    end.x = point.x +s.width/2;
    end.y = [[CCDirector sharedDirector]winSize].height-point.y+s.height/2;
	
 
    if(touchPoint.x>start.x&&touchPoint.x<end.x)
        if(touchPoint.y>start.y&&touchPoint.y<end.y)
    {

        _touched = YES;
        [self doTouchAnimation:_titleLabel];
        [delegate onButtonClicked:self];
        
    }
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
//    if(_touched)
//    {
//        _end = YES;
//        [self doTouchAnimation:_titleLabel];
//        [delegate onButtonClicked];
//        _touched  = NO;
//    }
}
- (void)doTouchAnimation:(CCNode *)node
{
    if(node)
    {
        [node runAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.1 scaleX:1.1 scaleY:1.3],[CCScaleTo actionWithDuration:0.05 scaleX:1 scaleY:1], nil]];
    }
}
@end
