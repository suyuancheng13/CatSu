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
    _mapOffsetX =0;
    _mapOffsetY =0;
    
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
    _tiledMap = [[CCTMXTiledMap alloc]initWithTMXFile:@"Tiled.tmx"];
    [self addChild:_tiledMap z:-1];
    _meta = [_tiledMap layerNamed:@"meta"];
    _forground = [_tiledMap layerNamed:@"forground"];
    [_meta setVisible:NO];
    
    _unitW = [_tiledMap tileSize].width;
    _unitH = [_tiledMap tileSize].height;
    _map = [[NSMutableArray alloc]init];
 
//    [_cat setPosition:CGPointMake(8*_unitW+_unitW/2, 8*_unitH+_unitH/2)];
    CCTMXObjectGroup *objects = [_tiledMap objectGroupNamed:@"objects"];
    if(objects)
    {
        NSDictionary *statPoint = [objects objectNamed:@"startPoint"];
        NSString *positionX = (NSString*) [statPoint valueForKey:@"x"];
        NSString  *positionY = (NSString*)[statPoint valueForKey:@"y"];
        [_cat setPosition:CGPointMake([positionX intValue]+_unitW/2, [positionY intValue]+_unitH/2)];
    }
    else {
        [_cat setPosition:CGPointMake(8*_unitW+_unitW/2, 8*_unitH+_unitH/2)];

    }
    for(int i =[_tiledMap mapSize].height-1;i>=0;i--)
        for(int j=0;j<[_tiledMap mapSize].width;j++)
        {
            int tileGID = 0;
            tileGID = [_meta tileGIDAt:CGPointMake(j, i)];
            if(0!=tileGID)
            {
                NSDictionary *properities = [_tiledMap propertiesForGID:tileGID];
                if(properities)
                {
                    NSString *collidable = [properities valueForKey:@"Collidable"];
                    if(collidable&&[collidable isEqualToString:@"True"])
                    {
                        [_map addObject:[[NSNumber alloc]initWithInt:BRICK]];
                        printf("brick:%d,%d\n",j,i);
                    }
                    else {
                        [_map addObject:[[NSNumber alloc]initWithInt:BLANCK] ];
                    }
                    
                }
                else
                [_map addObject:[[NSNumber alloc]initWithInt:BLANCK]];
            }
            else
           [_map addObject:[[NSNumber alloc]initWithInt:BLANCK]];
        }
   
//    _searchEngine = [[A_StartSearch alloc]initWithMap:_map rows:[_tiledMap mapSize].height columns:[_tiledMap mapSize].width];
        _searchEngine = [[Dijkstra alloc]initWithMap:_map rows:[_tiledMap mapSize].height columns:[_tiledMap mapSize].width];
    
//    
}
- (void)initRole
{
    _cat = [CatRole spriteWithFile:@"cat.jpg"];
    _cat.Score = 0;
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
            if( [self updateMap:node.position]);
            printf("mapoffsetY:%d\n",_mapOffsetY);
            point.y = (node.position.y-_mapOffsetY)*_unitH+_unitH/2;
            point.x = (node.position.x- _mapOffsetX)*_unitW+_unitW/2;
            printf("path:x=%f,y=%f\n",node.position.x,node.position.y);
            int tileGID = 0;
            tileGID = [_meta tileGIDAt:CGPointMake(node.position.x, [_tiledMap mapSize].height-node.position.y-1)];
            if(0!=tileGID){
                NSDictionary *properties = [_tiledMap propertiesForGID:tileGID];
                if(properties){
                    NSString *collectable = [properties valueForKey:@"Collectable"];
                    if(collectable&&[collectable isEqualToString:@"True"])
                    {
                        [_meta removeTileAt:CGPointMake(node.position.x, [_tiledMap mapSize].height-node.position.y-1)];
                        [_forground removeTileAt:CGPointMake(node.position.x, [_tiledMap mapSize].height-node.position.y-1)];
                        _cat.Score++;
                        printf("score:%d\n",_cat.Score);
                    }
                }
            }
            [_cat setPosition:point];

          _index++;
          _isMoving = YES;
        }
        else {
              _isMoving = NO;
        }
      
       
    }
}
- (BOOL)updateMap:(CGPoint)position
{
    int screenHeight = _winSize.height/_unitH;
    int screenWidth = _winSize.width/_unitW;
    
    if(position.y>_mapOffsetY+screenHeight-4)
    {
       
       if(_mapOffsetY<[_tiledMap mapSize].height)
       {
            [_tiledMap setPosition:CGPointMake([_tiledMap position].x, [_tiledMap position].y-_unitH)];
           _mapOffsetY++;
       }
        return YES;
    }
    else
        if(position.y<_mapOffsetY+4)
    {
       
        if(_mapOffsetY>0)
        {
             [_tiledMap setPosition:CGPointMake([_tiledMap position].x, [_tiledMap position].y+_unitH)];
            _mapOffsetY--;
        }
        
        return YES;
    }
    if(position.x>_mapOffsetX+screenWidth-4)
    {
       
        if(_mapOffsetX<[_tiledMap mapSize].width)
        {
             [_tiledMap setPosition:CGPointMake([_tiledMap position].x-_unitW, [_tiledMap position].y)];
            _mapOffsetX++;
        }
        return YES;
    }
    else
        if(position.x<_mapOffsetX+4)
        {
            
            if(_mapOffsetX>0)
            {
                [_tiledMap setPosition:CGPointMake([_tiledMap position].x+_unitW, [_tiledMap position].y)];
            _mapOffsetX--;
            }
            return YES;
        }

    return NO;
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
    catPosition.x = floor (catPosition.x/_unitW)+_mapOffsetX;
    catPosition.y = floor (catPosition.y/_unitH)+_mapOffsetY;
    CGPoint endPoint = [touch locationInView:[touch view]];
    endPoint.y = _winSize.height - endPoint.y;
    endPoint.x = floor(endPoint.x/_unitW)+_mapOffsetX;
    endPoint.y = floor(endPoint.y/_unitH)+_mapOffsetY;
   
    _path = [_searchEngine getPath:catPosition endPoint:endPoint];
    return  YES;
}
@end
