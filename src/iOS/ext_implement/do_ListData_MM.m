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
#import "doJsonHelper.h"
#import "doTextHelper.h"

@implementation do_ListData_MM
{
@private
    NSMutableArray* array;
}
#pragma mark - doIListData
-(int) GetCount
{
    return (int)array.count;
}
-(id) GetData:(int) index
{
    return array[index];
}
-(void) SetData:(int) index :(id) data
{
    array[index] = data;
}
-(NSString*) Serialize
{
    return [doJsonHelper ExportToText:array:YES];
}
-(id) UnSerialize:(NSString*) str
{
    array = [doJsonHelper LoadDataFromText:str];
    return self;
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
-(id) GetJsonData;
{
    return array;
}
#pragma mark -
#pragma mark - 同步异步方法的实现
/*
 1.参数节点
 NSDictionary *_dictParas = [parms objectAtIndex:0];
 a.在节点中，获取对应的参数
 NSString *title = [doJsonHelper GetOneText: _dictParas :@"title" :@"" ];
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
    NSDictionary *_dictParas = [parms objectAtIndex:0];
    //自己的代码实现
    NSArray* datas =[doJsonHelper GetOneArray:_dictParas :@"data"];
    int index = [doJsonHelper GetOneInteger:_dictParas :@"index" :(int)array.count];
    for(id data in datas){
        [array insertObject:data atIndex:index];
        index++;
    }
}
- (void)addOne:(NSArray *)parms
{
    NSDictionary *_dictParas = [parms objectAtIndex:0];
    //自己的代码实现
    id data =[doJsonHelper GetOneValue:_dictParas :@"data"];
    int index = [doJsonHelper GetOneInteger:_dictParas :@"index" :(int)array.count];
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
    NSDictionary *_dictParas = [parms objectAtIndex:0];
    //自己的代码实现
    int index = [doJsonHelper GetOneInteger:_dictParas :@"index" : 0];
    id _jsonValue = array[index];
    doInvokeResult *_invokeResult = [parms objectAtIndex:2];
    [_invokeResult SetResultValue:_jsonValue];
}
- (void)getData:(NSArray *)parms
{
    NSDictionary *_dictParas = [parms objectAtIndex:0];
    //自己的代码实现
    NSArray* indexs = [doJsonHelper GetOneArray:_dictParas :@"indexs"];
    NSMutableArray* result = [[NSMutableArray alloc]init];
    for(id index in indexs)
    {
        int _index;
        if([index isKindOfClass:[NSString class]])
            _index=[[doTextHelper Instance] StrToInt:index :-1];
        else if([index isKindOfClass:[NSNumber class]])
            _index = ((NSNumber*)index).intValue;
        int temp = (int)array.count-1;
        if(temp>=_index){
            [result addObject:array[_index]];
        }
    }
    doInvokeResult *_invokeResult = [parms objectAtIndex:2];
    [_invokeResult SetResultArray:result ];
}
- (void)getRange:(NSArray *)parms
{
    NSDictionary *_dictParas = [parms objectAtIndex:0];
    //自己的代码实现
    int index = [doJsonHelper GetOneInteger:_dictParas :@"startIndex" : 0];
    int length = [doJsonHelper GetOneInteger:_dictParas :@"length" : 0];
    int realLength = length;
    if(index+realLength>array.count)
        realLength = (int)array.count - index;
    if(realLength<0) realLength = 0;
    NSMutableArray* result = [[NSMutableArray alloc]initWithCapacity:realLength];
    for(int i =index ;i<index+realLength;i++)
    {
        [result addObject:array[i]];
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
    NSDictionary *_dictParas = [parms objectAtIndex:0];
    //自己的代码实现
    int index = [doJsonHelper GetOneInteger:_dictParas :@"index" : 0];
    [array removeObjectAtIndex:index];
}
- (void)removeData:(NSArray *)parms
{
    NSDictionary *_dictParas = [parms objectAtIndex:0];
    //自己的代码实现
    NSArray* indexs = [doJsonHelper GetOneArray:_dictParas :@"indexs"];
    NSMutableIndexSet* result = [[NSMutableIndexSet alloc]init];
    for(id index in indexs)
    {
        int _index;
        if([index isKindOfClass:[NSString class]])
            _index=[[doTextHelper Instance] StrToInt:index :-1];
        else if([index isKindOfClass:[NSNumber class]])
            _index = ((NSNumber*)index).intValue;
        else continue;
        if(_index>=0)
           [result addIndex:_index];
    }
    [array removeObjectsAtIndexes:result];
}
- (void)removeRange:(NSArray *)parms
{
    NSDictionary *_dictParas = [parms objectAtIndex:0];
    //自己的代码实现
    int index = [doJsonHelper GetOneInteger:_dictParas :@"startIndex" : 0];
    int length = [doJsonHelper GetOneInteger:_dictParas :@"length" : 0];
    if(length>array.count)length=(int)array.count;
    NSRange range = NSMakeRange(index, length);
    [array removeObjectsInRange:range];
}
- (void)updateOne:(NSArray *)parms
{
    NSDictionary *_dictParas = [parms objectAtIndex:0];
    //自己的代码实现
    int index = [doJsonHelper GetOneInteger:_dictParas :@"index" : 0];
    id _jsonValue = [doJsonHelper GetOneValue:_dictParas :@"data"];
    array[index] = _jsonValue;
}
//异步

@end