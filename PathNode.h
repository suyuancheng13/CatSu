//
//  PathNode.h
//  CatSU
//
//  Created by Suyuancheng on 14-10-31.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{NONE,CLOSED,OPEN}PATHSTATE;
@interface PathNode : NSObject
{
    PATHSTATE       _state;
    float           _f;
    float           _g;
    float           _h;
    int             _isBlanck;
    CGPoint         _position;
    id              _parent;
    NSMutableArray  *_child;
    
}
@property(nonatomic,assign)float    f;
@property(nonatomic,assign)float    h;
@property(nonatomic,assign)float    g;
@property(nonatomic,assign)int      isBlanck;
@property(nonatomic,assign)CGPoint position;
@property(nonatomic,retain)id       parent;
@property(nonatomic,retain)NSMutableArray *child;
- (id)initWithPosition:(CGPoint)position;
- (id)initWithPosition2:(CGPoint)position with:(NSInteger)isBlanck;

@end
