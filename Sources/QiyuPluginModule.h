//
//  QiyuPluginModule.h
//  Pods
//
//  Created by dmlzj on 2019/1/16.
//
#import <Foundation/Foundation.h>
#import <QIYU_iOS_SDK/QYSessionViewController.h>
#import <WeexSDK/WeexSDK.h>
@interface QiyuPluginModule : NSObject <WXModuleProtocol>
@property (strong, nonatomic)  QYSessionViewController *sessionViewController;
- (void)chat:(NSArray *)commands;

- (void)getCount:(WXModuleCallback)callback;

- (void)getLastMessage:(WXModuleCallback)callback;

- (void)logout;
@end
