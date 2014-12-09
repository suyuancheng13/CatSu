//
//  Dijkstra.h
//  CatSU
//
//  Created by Suyuancheng on 14-12-3.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PathNode.h"
@interface Dijkstra : NSObject
{
    NSInteger           _rows;
    NSInteger           _columns;
    NSArray             *_map;
    NSMutableArray      *_Vertices;
    NSMutableArray      *_Heap;
}
- (id)initWithMap:(NSArray*)map rows:(NSInteger)rows columns:(NSInteger)columns;
- (NSArray*)getPath:(CGPoint)startPoint endPoint:(CGPoint)endPoint;
- (void) creatMinHeap;
/*
 parameter start: not the index of array
 */
- (void) siftDown:(NSInteger)start count:(NSInteger) count;
- (PathNode*) extractMin;
- (void) relaxDistance:(PathNode*)node pre:(PathNode*)pre;
@end
