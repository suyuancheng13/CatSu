//
//  A-StartSearch.m
//  CatSU
//
//  Created by Suyuancheng on 14-10-31.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "A-StartSearch.h"

@implementation A_StartSearch
//- (id)initWithMap:(id)map
//{
//    if(self = [super init])
//    {
//    }
//    return self;
//}
- (id)initWithMap:(NSArray *)map rows:(NSInteger)rows columns:(NSInteger)columns
{
    if(self = [super init])
    {
        _rows  = rows;
        _columns = columns;
        
        _map = map;
        _openTable = [[NSMutableArray alloc]init];
        _closedTable = [[NSMutableArray alloc]init];
    }
    return  self;
}
- (NSArray*)getPath:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    NSMutableArray   *tempPath = [[NSMutableArray alloc]init];
    /*
     add the start point to open talbe;
     */
    PathNode    *pathEnd;
    PathNode    *sNode = [[PathNode alloc]initWithPosition:startPoint];
    sNode.h = fabs(endPoint.x-startPoint.x)+fabs(endPoint.y-startPoint.y);
    sNode.f = sNode.h*1.5;
    [_openTable addObject:sNode];
    while (1) {
        if(0 == [_openTable count])
        {
            [_closedTable removeAllObjects];
            return nil;//present failure
        }
        /*
         *step 1: choose the bestnode and add it to closed table present that it has extend
         */
        PathNode *bestNode = [_openTable objectAtIndex:0];
        printf("location:x=%f,y=%f\n",bestNode.position.x,bestNode.position.y);
        [_openTable removeObjectAtIndex:0];
        [_closedTable addObject:bestNode];
        /*
         *step 2:jude whether reach the end point
         */
        if([self isEqualPoint:bestNode.position point2:endPoint])
        {
            pathEnd = bestNode;
            break;
            
        }
        /*
         *step 3:extend successor of bestnode: four director of the point
         */
        CGPoint _successorPoint;
        for (int i=0; i<4; i++) {
            switch (i) {
                case 0://horizen left
                    _successorPoint.x = bestNode.position.x+1;
                    _successorPoint.y = bestNode.position.y;
                    break;
                case 1://up
                    _successorPoint.x = bestNode.position.x;
                    _successorPoint.y = bestNode.position.y+1;
                    break;
                case 2://horizen riht
                    _successorPoint.x = bestNode.position.x-1;
                    _successorPoint.y = bestNode.position.y;
                    break;
                case 3://down
                    _successorPoint.x = bestNode.position.x;
                    _successorPoint.y = bestNode.position.y-1;
                    break;
                default:
                    break;
            }
            if(![self isCollision:_successorPoint])
            {
                PathNode *successor = [[PathNode alloc]initWithPosition:_successorPoint];
                /*
                 *step 3.1 parent pointer point to the best node
                 */
                successor.parent = bestNode;
                successor.g = bestNode.g + 1;
                successor.h = fabs(endPoint.x-successor.position.x)+fabs(endPoint.y - successor.position.y);
                successor.f  = successor.g +successor.h*1.5;
                int openIndex = [self isInOpenTable:successor];
                if(NSNotFound==openIndex)                {
                    int closeIndex = [self isInClosedTable:successor];
                    if(NSNotFound== closeIndex)
                    {
                        /*
                         *step 3.2 add the successor point to open table
                         */
                        [self insertOpenTable:successor];//add to open table
                    
                        [bestNode.child addObject:successor];//add to the successor talbe of bestnode
                       
                    }
                    else {//in close table
                        /*
                         *step 3.3 update the value of the successor if it in close table
                         */
                        PathNode *old = [_closedTable objectAtIndex:closeIndex];
                        if(successor.g<old.g)
                        {
                            old.parent = bestNode;
                            old.g = successor.g;
                            old.f = old.g + old.h;
                        }
                    }
                }
                else {//in open table
                    /*
                     *step3,4 update the value of the successor if it in open table
                     */
                   PathNode *old = [_openTable objectAtIndex:openIndex];
                    if(successor.g<old.g)
                    {
                        old.parent = bestNode;
                        old.g = successor.g;
                        old.f = old.g + old.h;
                    }
                }
                 
            }
        }
        
            
    }
    PathNode *tempNode = pathEnd;
    while (tempNode) {
        [tempPath insertObject:tempNode atIndex:0];
        tempNode = tempNode.parent;
    }
    
    NSArray *path = [NSArray arrayWithArray:tempPath];
//    int count = [path count];
//    for (int i =0; i<count; i++) {
//        PathNode *obj = [path objectAtIndex:i];
//        printf("\tx=%f,y=%f",obj.position.x,obj.position.y);
//    }
    /*
     *clear the tables
     */
    [_openTable removeAllObjects];
    [_closedTable removeAllObjects];
    return path;
    
}
-(void)printTable
{
    int count = [_openTable count];
    for(int i=0;i<count;i++)
    {
        PathNode *obj = [_openTable objectAtIndex:i];
        printf("f:%f--point:%f,%f\n",obj.f,obj.position.x,obj.position.y);
    }
}
/*
 use heap sort hold the open table
 */
- (void)insertOpenTable:(PathNode*)node
{
    [_openTable addObject:node];
    [_openTable sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if(((PathNode*)obj1).f<((PathNode*)obj2).f)
            return NSOrderedAscending;
        if(((PathNode*)obj1).f>((PathNode*)obj2).f)
            return NSOrderedDescending;
        return NSOrderedSame;
    }];
}

#pragma mark- jude function
- (BOOL)isEqualPoint:(CGPoint)point1 point2:(CGPoint)point2
{
    if(point1.x == point2.x && point1.y == point2.y)
        return YES;
    return NO;
}
- (BOOL)isCollision:(CGPoint)point
{
    if(point.x<0||point.x>=_columns)
        return YES;
    if(point.y<0||point.y>=_rows)
        return YES;
    
    int index = (int)(point.y*_columns+point.x);
    
    NSNumber *num = [_map objectAtIndex:index];
    if(0 == [num intValue])
        return NO;
    else {
        return YES;
    }
}
- (int)isInOpenTable:(PathNode*)node
{
    int count = [_openTable count];
   
    for(int i=0;i<count;i++)
    {
        
         PathNode *obj= [_openTable objectAtIndex:i];
        if(node.position.x==obj.position.x&&node.position.y==obj.position.y)
            return i;
    }
    return NSNotFound;
}
- (int)isInClosedTable:(PathNode*)node
{
    int count = [_closedTable count];
    
    for(int i=0;i<count;i++)
    {
        
        PathNode *obj= [_closedTable objectAtIndex:i];
        if(node.position.x==obj.position.x&&node.position.y==obj.position.y)
            return i;
    }
    return NSNotFound;
}
@end
