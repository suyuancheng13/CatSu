//
//  GameLayer.m
//  CatSU
//
//  Created by Suyuancheng on 14-10-31.
//  Copyright 2014年 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"


@implementation GameLayer

+ (CCScene*)Scene
{
    CCScene *scene = [[CCScene alloc]init];
    GameLayer *game = [[GameLayer alloc]init];
    [game inInit];
    [scene addChild:game];
    return scene;
}
#pragma  mark - initial of the game
- (void)inInit
{
    _winSize = [[CCDirector sharedDirector]winSizeInPixels];
    _index = 0;
    _isMoving = NO;
    
    [self setTouchMode:kCCTouchesOneByOne];
    [self initRole];
    [self initMap];
//    _searchEngine = []
    /*
     ready to start
     */
    [self setCountDown:3];
}
#define BLANCK 0
#define BRICK 1
#define CAT 2
#define BONUES 3
- (void)initMap
{
    CCSprite *board = [CCSprite spriteWithFile:@"wood_board.jpg"];
    int boardCountW =ceil(_winSize.width/[board contentSize].width);
    int boardCountH = ceil(_winSize.height/[board contentSize].height);
    for (int i=0; i<=boardCountW; i++) {
        for (int j =0; j<=boardCountH; j++) {
            CCSprite *board = [CCSprite spriteWithFile:@"wood_board.jpg"];
            [board setPosition:CGPointMake(i*[board contentSize].width, j*[board contentSize].height)];
            [self addChild:board z:-1];
        }
    }
   
  //  [self addChild:board z:-1];
    CCSprite *brick = [CCSprite spriteWithFile:@"brick.jpg"];
    _unitW = [brick contentSize].width;
    _unitH = [brick contentSize].height;
    _map = [[NSMutableArray alloc]init];
    
    int count =0;
    int columns = _winSize.width / [brick contentSize].width;
    int rows  = _winSize.height/[brick contentSize].height;
    for (int i =1; i<=rows; i++) {
        for (int j =1; j<=columns; j++) {
            count++;
            if(j==columns/2&&i>3)
            {
                CCSprite *_brick = [CCSprite spriteWithFile:@"brick.jpg"];
                [_brick setPosition:CGPointMake(j*[_brick contentSize].width, i*[_brick contentSize].height)];
                [self addChild:_brick];
                [_map addObject:[[NSNumber alloc]initWithInt:BRICK]];
                
            }
            else if(j==3*columns/4&&i<rows-3)
            {
                CCSprite *_brick = [CCSprite spriteWithFile:@"brick.jpg"];
                [_brick setPosition:CGPointMake(j*[_brick contentSize].width, i*[_brick contentSize].height)];
                [self addChild:_brick];
                [_map addObject:[[NSNumber alloc]initWithInt:BRICK]];
                
            }
           else if(i==rows/2&&j>columns/2+1&&j<3*columns/4)
            {
                CCSprite *_brick = [CCSprite spriteWithFile:@"brick.jpg"];
                [_brick setPosition:CGPointMake(j*[_brick contentSize].width, i*[_brick contentSize].height)];
                [self addChild:_brick];
                [_map addObject:[[NSNumber alloc]initWithInt:BRICK]];
                
            }
           else if(i==3*rows/4&&j>columns/2&&j<3*columns/4-1)
           {
               CCSprite *_brick = [CCSprite spriteWithFile:@"brick.jpg"];
               [_brick setPosition:CGPointMake(j*[_brick contentSize].width, i*[_brick contentSize].height)];
               [self addChild:_brick];
               [_map addObject:[[NSNumber alloc]initWithInt:BRICK]];
               
           }
           else if(i==3&&j>columns/3&&j<3*columns/4-1)
           {
               CCSprite *_brick = [CCSprite spriteWithFile:@"brick.jpg"];
               [_brick setPosition:CGPointMake(j*[_brick contentSize].width, i*[_brick contentSize].height)];
               [self addChild:_brick];
               [_map addObject:[[NSNumber alloc]initWithInt:BRICK]];
               
           }

           else if(j == columns/3&&i == rows-8)
            {
                [_cat setPosition:CGPointMake(j*[brick contentSize].width, i*[brick contentSize].height)];
                [_map addObject:[[NSNumber alloc]initWithInt:BLANCK]];
                printf("\n\tcount:%d\n",count);
            }
            else if(j==columns/3&&i>2&&i<rows-8)
            {
                printf("\n\tcount:%d\n",count);

                CCSprite *_brick = [CCSprite spriteWithFile:@"brick.jpg"];
                [_brick setPosition:CGPointMake(j*[_brick contentSize].width, i*[_brick contentSize].height)];
                [self addChild:_brick];
                [_map addObject:[[NSNumber alloc]initWithInt:BRICK]];
                
            }
            else if(j==columns/3&&i>rows-8&&i<rows-2)
            {
                printf("\n\tcount:%d\n",count);
                
                CCSprite *_brick = [CCSprite spriteWithFile:@"brick.jpg"];
                [_brick setPosition:CGPointMake(j*[_brick contentSize].width, i*[_brick contentSize].height)];
                [self addChild:_brick];
                [_map addObject:[[NSNumber alloc]initWithInt:BRICK]];
                
            }

            else {
                [_map addObject:[[NSNumber alloc]initWithInt:BLANCK]];
            }
             
        }
    }
    _searchEngine = [[A_StartSearch alloc]initWithMap:_map rows:rows columns:columns];
    
}
- (void)initRole
{
    _cat = [CatRole spriteWithFile:@"cat.jpg"];
    [self addChild:_cat];
//    printf("%f,%f",[_cat contentSize].width,[_cat contentSize].height);
//    [_cat setPosition:CGPointMake(100, 200)];
}
#pragma mark - count down 
#define countTag 100
- (void)setCountDown:(NSInteger)seconds
{
    _countdownNum = seconds;
    CCLabelTTF *countLabel = [[CCLabelTTF alloc]initWithString:[NSString stringWithFormat:@"%d",_countdownNum] fontName:@"Helvetica-Bold" fontSize:40];
    [countLabel setColor:ccRED];
    [countLabel setTag:countTag];
    [countLabel setPosition:CGPointMake(_winSize.width/2,_winSize.height/2)];
    [self addChild: countLabel];
    [self CountdownAnimation:countLabel];
    [self schedule:@selector(beginCountDown) interval:1];
    
}
- (void)beginCountDown
{
    _countdownNum--;
    CCLabelTTF *label = (CCLabelTTF*)[self getChildByTag:countTag];
    if(label){
        if(_countdownNum<1)
        {
            [label removeFromParent];
            [self unschedule:@selector(beginCountDown)];
            [self doneCountDown];
        }
        else {
            
            [label setString:[NSString stringWithFormat:@"%d",_countdownNum]];
            [self CountdownAnimation:label];
            // [self schedule:@selector(beginCountDown) ];
            
        }
    }
}
/*
 *the entrance to the game
 */
- (void)doneCountDown
{
   
    [self setTouchEnabled:YES];
    //[self schedule:@selector(mainLoop)];
    [self mainLoop];
   
    
}
- (void)CountdownAnimation:(CCNode *)node
{
    [node runAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.5 scaleX:2 scaleY:2], [CCScaleTo actionWithDuration:0.05 scaleX:0.8 scaleY:0.9],nil]];
   
}
/*
 main game loop
 */
- (void)mainLoop
{
   
    [self schedule:@selector( updateRole) interval:0.3];
}
/*
 updat the cat position
 */
- (void) updateRole
{

   _pathNodeCount = [_path count];
    if(0!= _pathNodeCount)
    {
        
       // for(;_index<_pathNodeCount;_index++)
        if(_index<_pathNodeCount)
        {
            CGPoint point;
            PathNode *node = [_path objectAtIndex:_index];
            point.x = node.position.x*_unitW;
            point.y = node.position.y*_unitH;
            [_cat setPosition:point];
           // [self schedule:@selector(updateRole)interval:0.5];
//            [NSThread sleepForTimeInterval:0.5];
            _index++;
            _isMoving = YES;
        }
        else {
              _isMoving = NO;
        }
      
       
    }
}

/*
 touch event
 */
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if(_isMoving)
        return NO;
    _index = 0;
    
    CGPoint catPosition = [_cat position];
    catPosition.x = floor (catPosition.x/_unitW);
    catPosition.y = floor (catPosition.y/_unitH);
    CGPoint endPoint = [touch locationInView:[touch view]];
    endPoint.y = _winSize.height - endPoint.y;
    endPoint.x = floor(endPoint.x/_unitW);
    endPoint.y = floor(endPoint.y/_unitH);
   
    _path = [_searchEngine getPath:catPosition endPoint:endPoint];
    return  YES;
}
@end
