//
//  A-StartSearch.h
//  CatSU
//
//  Created by Suyuancheng on 14-10-31.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PathNode.h"
@interface A_StartSearch : NSObject
{
//    int  map[][]
    NSMutableArray      *_openTable;
    NSMutableArray      *_closedTable;
    NSInteger           _rows;
    NSInteger           _columns;
    NSArray             *_map;
}
//- (id)initWithMap:()map;
- (id)initWithMap:(NSArray*)map rows:(NSInteger)rows columns:(NSInteger)columns;
- (void)insertOpenTable:(PathNode*)node;
- (BOOL)isEqualPoint:(CGPoint)point1 point2:(CGPoint)point2;
- (BOOL)isCollision:(CGPoint)point;
//- (BOOL)isInOpenTable:(PathNode*)node;
- (int)isInOpenTable:(PathNode*)node;
- (int)isInClosedTable:(PathNode*)node;

- (NSArray*)getPath:(CGPoint)startPoint endPoint:(CGPoint)endPoint;
@end
