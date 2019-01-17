//
//  QiyuPluginModule.m
//  AFNetworking
//
//  Created by dmlzj on 2019/1/16.
//

#import <WeexPluginLoader/WeexPluginLoader.h>
#import "QiyuPluginModule.h"
#import <QYSDK.h>
#import <BMAppDelegate.h>

WX_PlUGIN_EXPORT_MODULE(qiyuPlugin, QiyuPluginModule)
@implementation QiyuPluginModule
@synthesize weexInstance;
WX_EXPORT_METHOD(@selector(chat:));

- (void)chat:(NSArray *)commands
{
    NSDictionary * infoArr = commands[0];
    //会话来源
    QYSource *source = [[QYSource alloc] init];
    NSDictionary * sourceDic = infoArr[@"init"][@"source"];
    source.title = sourceDic[@"title"];
    source.urlString = sourceDic[@"url"];
    
    //商品信息
    QYCommodityInfo * commodityInfo  = [[QYCommodityInfo alloc]init];
    NSDictionary * commodityDic = infoArr[@"commodity"];
    commodityInfo.title = commodityDic[@"title"];
    commodityInfo.note = commodityDic[@"note"];
    commodityInfo.desc = commodityDic[@"desc"];
    commodityInfo.pictureUrlString = commodityDic[@"pictureUrlString"];
    commodityInfo.urlString = commodityDic[@"urlString"];
    
    //个人信息
    QYUserInfo * userInfo = [[QYUserInfo alloc]init];
    NSDictionary * userDic = infoArr[@"user"];
    userInfo.userId = userDic[@"userId"];
    userInfo.data = userDic[@"data"];
    [[QYSDK sharedSDK] setUserInfo:userInfo];
    
    if (!_sessionViewController) {
        _sessionViewController =[[QYSDK sharedSDK] sessionViewController];
    }
    _sessionViewController.sessionTitle = infoArr[@"init"][@"title"];
    _sessionViewController.source = source;
    _sessionViewController.commodityInfo = commodityInfo;
    _sessionViewController.hidesBottomBarWhenPushed = YES;
    
    BMAppDelegate * appDelegate = (BMAppDelegate*)[UIApplication sharedApplication].delegate;
    
    UIViewController * controller = appDelegate.window.rootViewController;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_sessionViewController];
    [controller presentViewController:nav animated:YES completion:nil];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    [leftItem setTintColor:[UIColor blackColor]];
    _sessionViewController.navigationItem.leftBarButtonItem = leftItem;
}
- (void)onBack:(id)sender {
    
    [_sessionViewController dismissViewControllerAnimated:YES completion:nil];
}
// 用户退出app的时候必须注销会话
WX_EXPORT_METHOD(@selector(logout));
-(void)logout
{
 [[QYSDK sharedSDK] logout:^{}];
}
WX_EXPORT_METHOD(@selector(getCount:));
//获取未读数量
-(void)getCount:(WXModuleCallback)callback
{
    NSInteger num = [[[QYSDK sharedSDK] conversationManager] allUnreadCount];
    NSNumber * number = [NSNumber numberWithInteger:num];
    //[self toCallback:commands.arguments[0] withReslut:[NSString stringWithFormat:@"%d",num]];
//    [self handleResultWithValue:number command:commands];
    callback(number);
}

//获取最后一条数据
WX_EXPORT_METHOD(@selector(getLastMessage:));
-(void)getLastMessage:(WXModuleCallback)callback
{
    NSArray * array = [[[QYSDK sharedSDK] conversationManager] getSessionList];
    QYSessionInfo * sessionInfo =array.count?array.lastObject:nil;
    if (sessionInfo) {
        
        NSMutableDictionary * sessionDic = [[NSMutableDictionary alloc]init];
        [sessionDic setObject:sessionInfo.lastMessageText forKey:@"title"];
        [sessionDic setObject:[NSNumber numberWithInteger:sessionInfo.lastMessageTimeStamp] forKey:@"time"];
        [sessionDic setObject:[self getMessageTypeStringWithType:sessionInfo.lastMessageType] forKey:@"type"];
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
        [dic setObject:sessionDic forKey:@"message"];
        //[self toCallback:commands.arguments[0] withReslut:[self convertToJsonData:dic]];
//        [self handleResultWithValue:dic command:commands];
        callback(dic);
    }
}
//枚举转字符串
/*
 typedef NS_ENUM(NSInteger, QYMessageType) {
 QYMessageTypeText,      //文本
 QYMessageTypeImage,     //图片
 QYMessageTypeAudio,     //语音
 QYMessageTypeVideo,     //视频
 QYMessageTypeCustom     //自定义
 };
 */
-(NSString *)getMessageTypeStringWithType:(QYMessageType )type
{
    switch (type) {
        case QYMessageTypeText:
            return @"text";
            break;
        case QYMessageTypeImage:
            return @"image";
            break;
        case QYMessageTypeAudio:
            return @"audio";
            break;
        case QYMessageTypeVideo:
            return @"video";
            break;
        case QYMessageTypeCustom:
            return @"custom";
            break;
        default:
            return @"";
            break;
    }
}
@end

