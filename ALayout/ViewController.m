//
//  ViewController.m
//  RMLayout
//
//  Created by splendourbell on 2017/4/6.
//  Copyright © 2017年 ajja.sdjkf.sd. All rights reserved.
//

#import "ViewController.h"

#import "GDataXMLNode.h"

#import "UIView+ALayout.h"

@interface ViewController ()

@end

@implementation ViewController

NSMutableString* string = nil;
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIView* aa = [UIView CreateView];
//    
//    UIView* bb = [UILabel CreateView];
    
    NSData* data = [NSData dataWithContentsOfFile:@"/Users/bell/myspace/androidsrc/src/frameworks/base/packages/Keyguard/test/res/layout/keyguard_test_activity.xml"];
    
    
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
    
    GDataXMLElement *root = [doc rootElement];
    
    NSLog(@"doc description=%@", [doc description]);
    
    string = [NSMutableString new];
    
    [self print:root];
    
    NSLog(@"%@", string);
}

- (void)print:(GDataXMLNode*)node
{
    NSLog(@"kind = %lu", node.kind);
    
    
    if(node.kind == GDataXMLElementKind)
    {
        GDataXMLElement* elem = (GDataXMLElement*)node;
        NSArray<GDataXMLNode*>* array = [elem attributes];
        [string appendString:@"{"];
        [string appendFormat:@"\"class\":\"%@\",",elem.name];
        for(int i=0; i<array.count; i++)
        {
            [string appendFormat:@"\"%@\":\"%@\"", array[i].name, array[i].stringValue];
            if(i < array.count-1)
            {
                [string appendString:@","];
            }
        }
        
        NSArray* children = node.children;
        if(children.count)
        {
            if(array.count) [string appendString:@","];
            [string appendString:@"\"children\":["];
        }
        for(int i=0; i<children.count; i++)
        {
            [self print:children[i]];
            if(i < children.count -1)
            {
                [string appendString:@","];
            }
        }
        if(children.count)
        {
            [string appendString:@"]"];
        }
        
        [string appendString:@"}"];
    }
//    else
//    {
//        NSArray* children = node.children;
//        if(children.count)
//        {
//            [string appendString:@"\"children\":["];
//        }
//        for(int i=0; i<children.count; i++)
//        {
//            [self print:children[i]];
//        }
//        if(children.count)
//        {
//            [string appendString:@"]"];
//        }
//    }
    

//    NSLog(@"node namespaces=%@", [node namespaces]);
//    NSLog(@"node attributes=%@", [node attributes]);
//    NSLog(@"node child=[[");
//    NSArray* children = node.children;
//    for(int i=0; i<children.count; i++)
//    {
//        [self print:children[i]];
//    }
//    NSLog(@"]]");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
