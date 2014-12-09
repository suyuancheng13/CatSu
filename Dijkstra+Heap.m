//
//  Dijkstra.m
//  CatSU
//
//  Created by Suyuancheng on 14-12-3.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "Dijkstra+Heap.h"

@implementation Dijkstra

- (id)initWithMap:(NSArray*)map rows:(NSInteger)rows columns:(NSInteger)columns
{
    if(self = [super init])
    {
        _rows  = rows;
        _columns = columns;
        _map = map;
    }
    return  self;

}
- (NSArray*)getPath:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{

    /*
     step 1: initial
     
     step 1.1 translate vectices matrix to adjacent table
     */

    _Vertices = [[NSMutableArray alloc]init];
       for (int i=0; i<_rows; i++) {
        for (int j=0; j<_columns; j++) {
            NSNumber *num = [_map objectAtIndex:i*_columns+j];
           
            [_Vertices addObject:[[PathNode alloc]initWithPosition2:CGPointMake(j, i) with:[num intValue]]];
        }
    }
    for (int j=0; j<_rows; j++) {
        for (int i=0; i<_columns; i++) {
           
            PathNode *node = [_Vertices objectAtIndex:j*_columns+i];
            if(j+1<_columns)
                [node.child addObject:[_Vertices objectAtIndex:(j+1)*_columns+i]];
            if(j-1>=0)
                [node.child addObject:[_Vertices objectAtIndex:(j-1)*_columns+i]];
            if(i+1<_rows)
                [node.child addObject:[_Vertices objectAtIndex:j*_columns+i+1]];
            if(i-1>=0)
                [node.child addObject:[_Vertices objectAtIndex:j*_columns+i-1]];
        }
    }
    
    /*
     set start point
     */
    int index = (int)(startPoint.y*_columns+startPoint.x);
    int endIndex = (int)(endPoint.y*_columns+endPoint.x);
    NSNumber *num = [_map objectAtIndex:index];
    if( 0 == [ num intValue])
    {
        PathNode *node1;
        PathNode *object = [_Vertices objectAtIndex:index];
        object.f = 1;
        object.h = 0;
        @try {
            node1 = [_Vertices objectAtIndex:index-1];
            if(0==node1.isBlanck){
//            node1.f = 1;
            node1.h = 1;
            }
        }
        @catch (NSException *exception) {
            NSLog(@"左边：%@",[exception description]);
        }
       
        @try {
            node1 = [_Vertices objectAtIndex:index+1];
            
//            node1.f = 1;
            node1.h = 1;
        }
        @catch (NSException *exception) {
            NSLog(@"右边：%@",[exception description]);
        }
      

        @try {
            node1 = [_Vertices objectAtIndex:index-_columns];
//            node1.f = 1;
            node1.h = 1;
        }
        @catch (NSException *exception) {
            NSLog(@"下方：%@",[exception description]);
        }
       

        @try {
           node1 = [_Vertices objectAtIndex:index+_columns];
//            node1.f = 1;
            node1.h = 1;
        }
        @catch (NSException *exception) {
            NSLog(@"上方：%@",[exception description]);
        }
       

    }

    /*
     step 2: Dijkstra main loop
   
     step 2.1: initial min heap
     */
    [self creatMinHeap];
    int countt = [_Vertices count];
    for (int i=0; i<countt; i++) {
        PathNode *no = [_Vertices objectAtIndex:i];
        if(1==no.h)
        NSLog(@"x:%f,y:%f,value:%f",no.position.x,no.position.y,no.h);
    }
    while (0 != [_Heap count]) {
        /*
         step 2.2: extract min
         */
        PathNode * node = [self extractMin];
        if(node.isBlanck)
            continue;
        node.f = 1;//union to s set
        int tindex = (int)(node.position.y*_columns+node.position.x);
        if(tindex == endIndex)
        {  
            break;//找到终点
        }
        /*
         step 2.3: relax distance of each edge
         */
//        if((tindex -1)/_columns == tindex/_columns)
//            [self relaxDistance:tindex-1 pre:node];
//        if((tindex +1)/_columns == tindex/_columns)
//            [self relaxDistance:tindex+1 pre:node];
//        [self relaxDistance:tindex-_columns pre:node];
//        [self relaxDistance:tindex+_columns pre:node];
        int ncount = [node.child count];
        for (int i=0; i<ncount; i++) {
            PathNode *child = [node.child objectAtIndex:i];
            [self relaxDistance:child pre:node];
        }
        
    }
    /*
      return result 
     */
    PathNode *end = [_Vertices objectAtIndex:endIndex];
    PathNode *temp =end;
    NSMutableArray *result = [[NSMutableArray alloc]init];
    while(temp)
    {
        [result insertObject:temp atIndex:0];
        temp = temp.parent;

    }
    return result;
    

}
#pragma mark - Heap design
- (void) creatMinHeap
{
    _Heap = [[NSMutableArray alloc]initWithArray:_Vertices];
    int iterator = (int)ceil(([_Heap count]-1)/2.0);
    int count = [_Heap count];
    while (iterator>0) {
        [self siftDown:iterator count:count];
        iterator--;
    }
}
/*
 parameter start: not the index of array
 */
- (void)siftDown:(NSInteger)start count:(NSInteger)count
{
    int i = start*2-1;//i is the left child's index in array
    int _start = start-1;//start point's position in array
//   if(_start ==0)
//       NSLog(@"hehe");
    PathNode *sNode = [_Heap objectAtIndex:_start];
    for (; i<count; i = i*2) {
        if(i+1<count)
        {
            PathNode *iNode = [_Heap objectAtIndex:i];//left child
            PathNode *jNode = [_Heap objectAtIndex:i+1];//right child
            if(iNode.h>jNode.h)
            {
                if(sNode.h<=jNode.h)
                    break;
                else {
                    [_Heap replaceObjectAtIndex:_start withObject:jNode];
                    _start = i+1;
                }
                
            }
            else {
                if(sNode.h<=iNode.h)
                    break;
                else {
                    [_Heap replaceObjectAtIndex:_start withObject:iNode];
                    _start = i;
                }

            }
        }
        else {
            PathNode *iNode = [_Heap objectAtIndex:i];
            if(sNode.h<=iNode.h)
                break;
            else {
                [_Heap replaceObjectAtIndex:_start withObject:iNode];
                _start = i-1;
            }

        }
    }
    [_Heap replaceObjectAtIndex:_start withObject:sNode];
    
}
- (PathNode*) extractMin
{
    [_Heap exchangeObjectAtIndex:0 withObjectAtIndex:[_Heap count]-1];
    PathNode *min = [_Heap objectAtIndex:[_Heap count]-1];
    [_Heap removeObjectAtIndex:[_Heap count]-1];
    [self siftDown:1 count:[_Heap count]];
    return min;
}
- (void) relaxDistance:(PathNode*)node pre:(PathNode *)pre
{
    //        NSNumber *num = [_map objectAtIndex:index];
    if( 0 == node.isBlanck && 1 != node.f)
    {
                
        if (node.h > pre.h + 1) {
            node.h = pre.h + 1;
            node.parent = pre;
            int current = [_Heap indexOfObject:node];
            if(NSNotFound != current)
            {
                for (int i=current+1; i>0; i--) {
                    [self siftDown:i count:[_Heap count]];

                }
            }
            else {
                NSLog(@"not found!");
            }
        }
        
        
    }
    
}
@end
