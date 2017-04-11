//
//  DependencyGraph.m
//  ALayout
//
//  Created by splendourbell on 2017/4/11.
//  Copyright © 2017年 ajja.sdjkf.sd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+FindView.h"
#import "RelativeLayoutLayoutParams.h"
#import "DependencyGraph.h"

@interface Node : NSObject

@property (nonatomic) UIView* view;
@property (nonatomic) NSMutableArray<Node*>* dependents;
@property (nonatomic) NSMutableDictionary<NSString*, Node*>* dependencies;

@end

@implementation Node

- (instancetype)initWithView:(UIView*)view
{
    if(self = [super init])
    {
        _view = view;
    }
    return self;
}

@end


@implementation DependencyGraph
{
    NSMutableArray<Node*>* mNodes;
    NSMutableDictionary<NSString*, Node*>* mKeyNodes;
    NSMutableArray<Node*>* mRoots;
}

- (instancetype)init
{
    if(self = [super init])
    {
        mNodes = [NSMutableArray new];
        mKeyNodes = [NSMutableDictionary new];
        mRoots = [NSMutableArray new];
    }
    return self;
}

- (void)clear
{
    NSMutableArray<Node*>* nodes = mNodes;
    int count = (int)nodes.count;
    
    for(int i = 0; i < count; i++)
    {
        // [nodes[i] release];
    }
    [nodes removeAllObjects];
    [mKeyNodes removeAllObjects];
    [mRoots removeAllObjects];
}

- (void)add:(UIView*)view
{
    NSString* strTag = view.strTag;
    Node* node = [[Node alloc] initWithView:view];
    if(strTag)
    {
        mKeyNodes[strTag] = node;
    }
    [mNodes addObject:node];
}

- (void)getSortedViews:(NSMutableArray<UIView*>*)sorted rules:(const int*)rules count:(const int)rulesCount
{
    NSMutableArray<Node*>* roots = [self findRoots:rules count:rulesCount];
    
    Node* node;
    while ((node = roots.lastObject))
    {
        [roots removeLastObject];
        
        UIView* view = node.view;
        NSString* key = view.strTag;
        
        [sorted addObject:view];
        
        NSMutableArray<Node*>* dependents = node.dependents;
        int count = (int)dependents.count;
        for (int i = 0; i < count; i++)
        {
            Node* dependent = dependents[i];
            NSMutableDictionary<NSString*, Node*>* dependencies = dependent.dependencies;
            
            [dependencies removeObjectForKey:key];
            if (0 == dependencies.count)
            {
                [roots addObject:dependent];
            }
        }
    }
}

- (NSMutableArray<Node*>*)findRoots:(const int*)rulesFilter count:(const int)filterCount
{
    NSMutableDictionary<NSString*, Node*>* keyNodes = mKeyNodes;
    NSMutableArray<Node*>* nodes = mNodes;
    
    const int count = (int)nodes.count;
    
    for (int i = 0; i < count; i++)
    {
        Node* node = nodes[i];
        [node.dependents removeAllObjects];
        [node.dependencies removeAllObjects];
    }
    
    for (int i = 0; i < count; i++)
    {
        Node* node = nodes[i];
        
        RelativeLayoutLayoutParams* layoutParams = (RelativeLayoutLayoutParams*)node.view.layoutParams;
        NSDictionary<NSNumber*, NSString*>* rules = layoutParams.rules;
        
        for (int j = 0; j < filterCount; j++)
        {
            NSString* rule = rules[@(rulesFilter[j])];
            if (rule)
            {
                Node* dependency = keyNodes[rule];
                if (dependency && dependency != node)
                {
                    [dependency.dependents addObject:node];
                    node.dependencies[rule] = dependency;
                }
            }
        }
    }
    
    NSMutableArray<Node*>* roots = mRoots;
    [roots removeAllObjects];
    
    for (int i = 0; i < count; i++)
    {
        Node* node = nodes[i];
        if (node.dependencies.count == 0)
        {
            [roots addObject:node];
        }
    }
    return roots;
}


@end
