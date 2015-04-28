//
//  do_ListData_MM.m
//  DoExt_MM
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_ListData_MM.h"

#import "doScriptEngineHelper.h"
#import "doIScriptEngine.h"
#import "doInvokeResult.h"
#import "doJsonNode.h"
#import "doJsonValue.h"
#import "doTextHelper.h"

@implementation do_ListData_MM
{
@private
    NSMutableArray* array;
}
#pragma mark - 注册属性（--属性定义--）
/*
 [self RegistProperty:[[doProperty alloc]init:@"属性名" :属性类型 :@"默认值" : BOOL:是否支持代码修改属性]];
 */
-(void)OnInit
{
    [super OnInit];
    if(array==nil)
        array = [[NSMutableArray alloc]init];
    //注册属性
}

//销毁所有的全局对象
-(void)Dispose
{
    [array removeAllObjects];
    //自定义的全局属性
}
#pragma mark -
#pragma mark - doIDataSource implements
-(void) GetJsonData:(id<doGetJsonCallBack>) _callback
{
    [_callback doGetJsonCallBack:array];
}
#pragma mark -
#pragma mark - 同步异步方法的实现
/*
 1.参数节点
 doJsonNode *_dictParas = [parms objectAtIndex:0];
 a.在节点中，获取对应的参数
 NSString *title = [_dictParas GetOneText:@"title" :@"" ];
 说明：第一个参数为对象名，第二为默认值
 
 2.脚本运行时的引擎
 id<doIScriptEngine> _scritEngine = [parms objectAtIndex:1];
 
 同步：
 3.同步回调对象(有回调需要添加如下代码)
 doInvokeResult *_invokeResult = [parms objectAtIndex:2];
 回调信息
 如：（回调一个字符串信息）
 [_invokeResult SetResultText:((doUIModule *)_model).UniqueKey];
 异步：
 3.获取回调函数名(异步方法都有回调)
 NSString *_callbackName = [parms objectAtIndex:2];
 在合适的地方进行下面的代码，完成回调
 新建一个回调对象
 doInvokeResult *_invokeResult = [[doInvokeResult alloc] init];
 填入对应的信息
 如：（回调一个字符串）
 [_invokeResult SetResultText: @"异步方法完成"];
 [_scritEngine Callback:_callbackName :_invokeResult];
 */
//同步
- (void)addData:(NSArray *)parms
{
    doJsonNode *_dictParas = [parms objectAtIndex:0];
    //自己的代码实现
    NSArray* datas = [_dictParas GetOneArray:@"data"];
    int index = [_dictParas GetOneInteger:@"index" :(int)array.count];
    [array insertObjects:datas atIndexes:[NSIndexSet indexSetWithIndex:index]];
    
}
- (void)addOne:(NSArray *)parms
{
    doJsonNode *_dictParas = [parms objectAtIndex:0];
    //自己的代码实现
    doJsonValue* data = [_dictParas GetOneValue:@"data"];
    int index = [_dictParas GetOneInteger:@"index" :(int)array.count];
    [array insertObject:data atIndex:index];
    
}
- (void)getCount:(NSArray *)parms
{
    doInvokeResult *_invokeResult = [parms objectAtIndex:2];
    [_invokeResult SetResultInteger:(int)array.count];
    //自己的代码实现
}
- (void)getOne:(NSArray *)parms
{
    doJsonNode *_dictParas = [parms objectAtIndex:0];
    //自己的代码实现
    int index = [_dictParas GetOneInteger:@"index" : 0];
    doJsonValue* _jsonValue = array[index];
    doInvokeResult *_invokeResult = [parms objectAtIndex:2];
    [_invokeResult SetResultValue:_jsonValue];
}
- (void)getData:(NSArray *)parms
{
    doJsonNode *_dictParas = [parms objectAtIndex:0];
    //自己的代码实现
    NSArray* indexs = [_dictParas GetOneTextArray:@"indexs"];
    NSMutableArray* result = [[NSMutableArray alloc]initWithCapacity:indexs.count];
    for(NSString* index in indexs)
    {
        int _index = [[doTextHelper Instance] StrToInt:index :-1];
        if(_index<0)
            [result addObject:@""];
        else{
            doJsonValue* _jsonValue = array[_index];
            [result addObject:_jsonValue];
        }
    }
    doInvokeResult *_invokeResult = [parms objectAtIndex:2];
    [_invokeResult SetResultArray:result ];
}
- (void)getRange:(NSArray *)parms
{
    doJsonNode *_dictParas = [parms objectAtIndex:0];
    //自己的代码实现
    int index = [_dictParas GetOneInteger:@"startIndex" : 0];
    int length = [_dictParas GetOneInteger:@"length" : 0];
    int realLength = length;
    if(index+realLength>array.count)
        realLength = (int)array.count - index;
    if(realLength<0) realLength = 0;
    NSMutableArray* result = [[NSMutableArray alloc]initWithCapacity:realLength];
    for(int i =index ;i<index+realLength;i++)
    {
        doJsonValue* _jsonValue = array[i];
        [result addObject:_jsonValue];
    }
    doInvokeResult *_invokeResult = [parms objectAtIndex:2];
    [_invokeResult SetResultArray:result ];
}

- (void)removeAll:(NSArray *)parms
{
    //自己的代码实现
    [array removeAllObjects];
}
- (void)removeOne:(NSArray *)parms
{
    doJsonNode *_dictParas = [parms objectAtIndex:0];
    //自己的代码实现
    int index = [_dictParas GetOneInteger:@"index" : 0];
    [array removeObjectAtIndex:index];
}
- (void)removeData:(NSArray *)parms
{
    doJsonNode *_dictParas = [parms objectAtIndex:0];
    //自己的代码实现
    NSArray* indexs = [_dictParas GetOneTextArray:@"indexs"];
    NSMutableIndexSet* result = [[NSMutableIndexSet alloc]init];
    for(NSString* index in indexs)
    {
        int _index = [[doTextHelper Instance] StrToInt:index :-1];
        if(_index>0)
           [result addIndex:_index];
    }
    [array removeObjectsAtIndexes:result];
}
- (void)removeRange:(NSArray *)parms
{
    doJsonNode *_dictParas = [parms objectAtIndex:0];
    //自己的代码实现
    int index = [_dictParas GetOneInteger:@"startIndex" : 0];
    int length = [_dictParas GetOneInteger:@"length" : 0];
    NSRange range = NSMakeRange(index, length);
    [array removeObjectsInRange:range];
}
- (void)updateOne:(NSArray *)parms
{
    doJsonNode *_dictParas = [parms objectAtIndex:0];
    //自己的代码实现
    int index = [_dictParas GetOneInteger:@"index" : 0];
    doJsonValue* _jsonValue = [_dictParas GetOneValue:@"data"];
    array[index] = _jsonValue;
}
//异步

@end