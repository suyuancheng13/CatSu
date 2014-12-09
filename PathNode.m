//
//  PathNode.m
//  CatSU
//
//  Created by Suyuancheng on 14-10-31.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "PathNode.h"

@implementation PathNode
@synthesize parent = _parent;
@synthesize f = _f;
@synthesize h = _h;
@synthesize g = _g;
@synthesize position = _position;
@synthesize child = _child;
@synthesize isBlanck = _isBlanck;
- (id)initWithPosition:(CGPoint)position
{
    if(self = [super init])
    {
        _position = position;
        _parent = nil;
        _g = 0 ;
        _h = 0 ;
        _f = 0;
        _child = [[NSMutableArray alloc]init];
    }
    return self;
}
- (id)initWithPosition2:(CGPoint)position with:(NSInteger)isBlanck
{
    if(self = [super init])
    {
        _parent = nil;
        _h = FLT_MAX ;
        _f = 0;
        _isBlanck = isBlanck;
        _position = position;
        _child = [[NSMutableArray alloc]init];
    }
    return self;
}
@end
