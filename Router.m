//
//  Router.m
//  test
//
//  Created by 杜蒙 
//  Copyright © 2017年 杜蒙. All rights reserved.
//

#import "Router.h"  
@implementation Router
- (Class )className:(NSString *)classname
{
    Class cl = NSClassFromString(classname);
    return cl; 
}
+(Router *)router
{
    return [[self alloc] init];
}
-(id)createControllerFromClassName:(NSString *)className
{
    Class cl = [self className:className];
    if (cl) {
        return [[cl alloc] init];
    }
    return nil;
}
#pragma mark - push
- (void)action:(id)action  target:(id)target  selector:(SEL)selector withOjbc:(id)objc{
    if ([target respondsToSelector:selector] && objc) {
        if ([objc isKindOfClass:[NSDictionary class]]) {
            objc = [objc mutableCopy];
            objc[@"root"]= action;
        }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:selector withObject:objc];
#pragma clang diagnostic pop
    }
}
- (void)routerAction:(UIViewController *)action routerType:(RouterType)routerType performClass:(NSString *)performClass  performSelector:(SEL)performSelector withObject:(id)object
{
    if (![action isKindOfClass:[UIViewController class]])return;
    NSString *performClassName = performClass;
    if (performClassName == nil) {
        performClassName = object[@"action"];
    }
    id routerController = nil;
    if (routerType== RouterPresent) {
        NSArray *cls = [performClassName  componentsSeparatedByString:@"/"];
        performClassName = cls.lastObject;
        routerController = [self createControllerFromClassName:performClassName];
        if (cls.count>1) {
            UINavigationController * naviController = [self createControllerFromClassName:cls.firstObject];
            if (routerController && naviController) {
                [self action:action target:routerController selector:performSelector withOjbc:object];
                [naviController pushViewController:routerController animated:NO];
                [action presentViewController:naviController animated:NO completion:nil];
            } else {
                NSLog(@"present error class 类型错误");
            }
        } else {
            if (routerController) {
                [self action:action target:routerController selector:performSelector withOjbc:object];
                [action presentViewController:routerController animated:NO completion:nil];
            } else {
                NSLog(@"present error class 类型错误");
            }
        }
    } else {
        routerController = [self createControllerFromClassName:performClassName];
        if (routerController) {
          [self action:action target:routerController selector:performSelector withOjbc:object];
          [((UIViewController *)(action)).navigationController pushViewController:routerController animated:YES];
        } else {
            NSLog(@"push error  class 类型错误");
        }
    }
}

-(void)routerAction:(id)action RouterType:(RouterType)routerType performSelector:(SEL)selector withJson:(id)json
{

    [self routerAction:action routerType:routerType performClass:nil performSelector:selector withObject:json];

}
-(void)routerAction:(id)action RouterType:(RouterType)routerType withJson:(id)json
{
  
    [self routerAction:action  routerType:routerType  performClass:nil  performSelector:@selector(actionModel:) withObject:json];
}

#pragma mark - callBack
-(void)routerToRouterJson:(id)Rjson performBackSelectorBack:(SEL)selector withJson:(id)json
{
    id  root = Rjson[@"root"];
    if (!root)return;
    if ([root respondsToSelector:@selector(actionCallBack:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [root performSelector:selector withObject:json];
#pragma clang diagnostic pop
    }
}
-(void)routerToRouterJson:(id)Rjson withJson:(id)json
{
    [self routerToRouterJson:Rjson performBackSelectorBack:@selector(actionCallBack:) withJson:json];
}

@end
