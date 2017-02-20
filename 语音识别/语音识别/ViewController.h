//
//  ViewController.h
//  语音识别
//
//  Created by mac on 17/2/20.
//  Copyright © 2017年 calender. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iflyMSC/iflyMSC.h>

@class IFlyPcmRecorder;


@interface ViewController : UIViewController<IFlySpeechRecognizerDelegate>

@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;//不带界面的识别对象

@property (nonatomic,strong) IFlyPcmRecorder *pcmRecorder;//录音器，用于音频流识别的数据传入

@end

