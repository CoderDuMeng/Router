//
//  Router.h
//  test
//
//  Created by 杜蒙 
//  Copyright © 2017年 杜蒙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>    
@protocol actionControllerProtocol <NSObject>
- (void)actionModel:(id)model;
- (void)actionCallBack:(id)model;
@end

typedef NS_ENUM(NSInteger,RouterType){
    RouterPush,
    RouterPresent
};
/* 
 示例 
 
 只有当  routerType 为RouterPresent   action 这个字段才可以这么写 因为Present的时候有时候会包装一下导航控制器  
 如果你没这么写 就直接Present
 
 NSDictionary *json = @{@"action":@"UINavigationController/ViewController1",
 @"model":@{
 @"key" :@"value"
 }
 };
 NSLog(@"%@",[json stringValue]);
 [[Router router] routerAction:self RouterType:1 withJson:json]; 
 
 
 
 NSDictionary *json = @{@"action":@"ViewController1",
 @"model":@{
 @"key" :@"value"
 }
 };
 NSLog(@"%@",[json stringValue]);
 [[Router router] routerAction:self RouterType:1 withJson:json]; 
 
 整个参数里面必须写的就是action字段 其他的自己随便 你写了就在那个接收控制器自己接收
 

*/
@interface Router : NSObject
/** 
    并是单利对象 只是为了创建对象方便 
 
 */
+(Router *)router;
/*
   @param className className
   
   @return 返回创建好的对象
 
*/
-(id)createControllerFromClassName:(NSString *)className;

/*
  @param action 谁要跳转就传入谁
  @param routerType 跳转的类型
  @param json    传的参数
   默认执行的方法  - (void)actionModel:(id)model;
 */
-(void)routerAction:(id)action  RouterType:(RouterType)routerType withJson:(id)json;
/*
  @param action 谁要跳转就传入谁 
  @param routerType 跳转的类型 
  @param selector  自定义传参数函数 
  @param json    传的参数
 
*/
- (void)routerAction:(id)action RouterType:(RouterType)routerType performSelector:(SEL)selector withJson:(id)json;
/*
  @param Rjson    是接收回来的参数在传回去 因为路由里面在参数里面默认添加了 root字段 里面保存了 root控制器
  @param selector 自定义回来的时候动态的调用的函数传参数 
  @param json     是传回来的参数
*/
-(void)routerToRouterJson:(id)Rjson performBackSelectorBack:(SEL)selector withJson:(id)json;
/*
 @param  Rjson  是接收回来的参数在传回去 因为路由里面在参数里面默认添加了 root字段 里面保存了 root控制器
 @param  json   是传回来的参数
 
 默认执行的方法   - (void)actionCallBack:(id)model;
*/
-(void)routerToRouterJson:(id)Rjson withJson:(id)json;



@end
