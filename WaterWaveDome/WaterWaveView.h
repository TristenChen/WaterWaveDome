//
//  WaterWaveView.h
//  WaterWave
//
//  Created by 123 on 16/3/15.
//  Copyright © 2016年 ym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaterWaveView : UIView

@property (nonatomic, strong) IBInspectable UIColor *currentWaveColor;
@property (nonatomic, strong) IBInspectable UIColor *shadowWareColor;
@property (nonatomic, assign) IBInspectable CGFloat waveSpeed; //波浪的速度
@property (nonatomic, assign) IBInspectable CGFloat waveAmplitude; // 波浪的震荡幅度

- (void)wave;

- (void)stop;

@end
