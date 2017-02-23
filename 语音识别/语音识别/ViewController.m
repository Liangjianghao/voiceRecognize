//
//  ViewController.m
//  语音识别
//
//  Created by mac on 17/2/20.
//  Copyright © 2017年 calender. All rights reserved.
//

#import "ViewController.h"

#import "IATConfig.h"
#import "ISRDataHelper.h"
@interface ViewController ()
{
    UILabel *mylabel;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *mybutton=[UIButton buttonWithType:UIButtonTypeCustom];
    mybutton.frame=CGRectMake(100, 100, 100, 40);
    mybutton.clipsToBounds=YES;
    mybutton.layer.cornerRadius=10;
    [mybutton setTitle:[NSString stringWithFormat:@"录音"] forState:UIControlStateNormal];
    mybutton.backgroundColor=[UIColor blackColor];
    [mybutton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mybutton];
    
    
    UIButton *mybutton2=[UIButton buttonWithType:UIButtonTypeCustom];
    mybutton2.frame=CGRectMake(100, 200, 100, 40);
    mybutton2.clipsToBounds=YES;
    mybutton2.layer.cornerRadius=10;
    [mybutton2 setTitle:[NSString stringWithFormat:@"停止"] forState:UIControlStateNormal];
    mybutton2.backgroundColor=[UIColor blackColor];
    [mybutton2 addTarget:self action:@selector(btnClick2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mybutton2];
    
    
    mylabel=[[UILabel alloc]init];
    mylabel.frame=CGRectMake(100, 300, 100, 40);
    mylabel.backgroundColor=[UIColor blueColor];
    mylabel.text=@"yuyin";
    [self.view addSubview:mylabel];
    

    
}

- (void) onVolumeChanged: (int)volume
{

    
    NSString * vol = [NSString stringWithFormat:@"音量：%d",volume];
    NSLog(@"%@",vol);
    
}
-(void)initRecognizer
{
    //单例模式，无UI的实例
    if (_iFlySpeechRecognizer == nil) {
        _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
        
        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        //设置听写模式
        [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    }
    _iFlySpeechRecognizer.delegate = self;
    
    if (_iFlySpeechRecognizer != nil) {
        IATConfig *instance = [IATConfig sharedInstance];
        
        //设置最长录音时间
        [_iFlySpeechRecognizer setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点
        [_iFlySpeechRecognizer setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
        //设置前端点
        [_iFlySpeechRecognizer setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
        //网络等待时间
        [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        
        //设置采样率，推荐使用16K
        [_iFlySpeechRecognizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
        
        if ([instance.language isEqualToString:[IATConfig chinese]]) {
            //设置语言
            [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
            //设置方言
            [_iFlySpeechRecognizer setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
        }else if ([instance.language isEqualToString:[IATConfig english]]) {
            [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
        }
        //设置是否返回标点符号
        [_iFlySpeechRecognizer setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
        
    }
    
    //初始化录音器
    if (_pcmRecorder == nil)
    {
        _pcmRecorder = [IFlyPcmRecorder sharedInstance];
    }
    
    _pcmRecorder.delegate = self;
    
    [_pcmRecorder setSample:[IATConfig sharedInstance].sampleRate];
    
    [_pcmRecorder setSaveAudioPath:nil];    //不保存录音文件
}

-(void)btnClick:(UIButton *)btn
{
    NSLog(@"%s[IN]",__func__);
    
    


    
        if(_iFlySpeechRecognizer == nil)
        {
            [self initRecognizer];
        }
    
        [_iFlySpeechRecognizer cancel];
        
        //设置音频来源为麦克风
        [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
        
        //设置听写结果格式为json
        [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
        
        //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
        [_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
        
        [_iFlySpeechRecognizer setDelegate:self];
        
        BOOL ret = [_iFlySpeechRecognizer startListening];
        
        if (ret) {
            
            NSLog(@"开始录音");
        }else{
//            [_popUpView showText: @"启动识别服务失败，请稍后重试"];//可能是上次请求未结束，暂不支持多路并发
        }
    
//    else {
//        
//        if(_iflyRecognizerView == nil)
//        {
//            [self initRecognizer ];
//        }
//        
//        [_textView setText:@""];
//        [_textView resignFirstResponder];
//        
//        //设置音频来源为麦克风
//        [_iflyRecognizerView setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
//        
//        //设置听写结果格式为json
//        [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
//        
//        //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
//        [_iflyRecognizerView setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
//        
//        BOOL ret = [_iflyRecognizerView start];
//        if (ret) {
//            NSLog(@"开始录音");
//        }
//    }

}
-(void)btnClick2:(UIButton *)btn
{
//    if(self.isStreamRec && !self.isBeginOfSpeech){
        NSLog(@"%s,停止录音",__func__);
        [_pcmRecorder stop];
        //        [_popUpView showText: @"停止录音"];
//    }
    
    [_iFlySpeechRecognizer stopListening];


}

- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    NSString * resultFromJson =  [ISRDataHelper stringFromJson:resultString];

    NSLog(@"_result=%@",resultString);
    NSLog(@"resultFromJson=%@",resultFromJson);
    mylabel.text=resultFromJson;

}

#pragma mark - IFlyPcmRecorderDelegate

- (void) onIFlyRecorderBuffer: (const void *)buffer bufferSize:(int)size
{
    NSData *audioBuffer = [NSData dataWithBytes:buffer length:size];
    
    int ret = [self.iFlySpeechRecognizer writeAudio:audioBuffer];
    if (!ret)
    {
        [self.iFlySpeechRecognizer stopListening];

    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
