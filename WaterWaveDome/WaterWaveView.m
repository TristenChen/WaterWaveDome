//
//  WaterWaveView.m
//  WaterWave
//
//  Created by 123 on 16/3/15.
//  Copyright © 2016年 ym. All rights reserved.
//

#import "WaterWaveView.h"

@interface WaterWaveView()

@property (nonatomic, assign) CGFloat waterWaveTop;
@property (nonatomic, assign) CGFloat waterWaveWidth;
@property (nonatomic, assign) CGFloat offsetX;

@property (nonatomic, strong) CADisplayLink *waveDisplaylink;
@property (nonatomic, strong) CAShapeLayer  *waveLayer;
@property (nonatomic, strong) CAShapeLayer  *shadowWaveLayer;

@property (nonatomic, assign) BOOL stopRiseForWave;
@property (nonatomic, assign) BOOL stopRiseForShadoWave;

@end

@implementation WaterWaveView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    [self initialize];

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;
    
    [self initialize];
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.waterWaveWidth  = frame.size.width;
}

#pragma mark - public methods 

- (void)wave
{
    if (_waveDisplaylink == nil) {        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.waveDisplaylink = [CADisplayLink displayLinkWithTarget:self
                                                               selector:@selector(getCurrentWave:)];
            
            //添加到循环并启动
            [self.waveDisplaylink addToRunLoop:[NSRunLoop mainRunLoop]
                                       forMode:NSRunLoopCommonModes];
        });
    }
}

- (void)stop
{
    [self.waveDisplaylink removeFromRunLoop:[NSRunLoop mainRunLoop]
                                    forMode:NSRunLoopCommonModes];
    [self.waveDisplaylink invalidate];
    self.waveDisplaylink = nil;
}


#pragma mark - private methods

- (void)initialize
{
    self.backgroundColor = [UIColor clearColor];
    self.layer.masksToBounds  = YES;
    self.waveSpeed = 8.0;
    self.waveAmplitude = 2.0f;
    self.stopRiseForWave = NO;
    self.stopRiseForShadoWave = NO;
    
    [self.layer addSublayer:self.shadowWaveLayer];
    [self.layer addSublayer:self.waveLayer];
}

- (void)getCurrentWave:(CADisplayLink *)displayLink
{
    self.offsetX +=  self.waveSpeed;
    
    [self drawCurrentWavePath];
    [self drawCurrentShadowWavePath];
}

- (void)drawCurrentShadowWavePath
{
    CGMutablePathRef path = (CGMutablePathRef)CFAutorelease(CGPathCreateMutable());
    CGPathMoveToPoint(path, nil, 0, self.waterWaveTop);
    CGFloat y = 0.0f;
    for (float x = 0.0f; x <=  self.waterWaveWidth ; x += 0.1) {
        if (!self.stopRiseForShadoWave) {
             //涨潮效果
            //cosf(360 / self.waterWaveWidth) 在指定范围内部绘画360°的曲线
            // 1度 = M_PI / 180 弧度
            //waveAmplitude 震荡幅度
            // 通过改变self.offsetX 的值来达到波纹移动效果
            y = self.waveAmplitude * cosf((360/self.waterWaveWidth) * (x - self.offsetX) * M_PI / 180) + self.self.bounds.size.height - self.offsetX / 5;
        }
        else {
            //波浪流动效果
            y = self.waveAmplitude * cosf((360/self.waterWaveWidth) * (x - self.offsetX) * M_PI / 180) + self.waterWaveTop + self.waveAmplitude;
        }
        
        if(y <= self.waterWaveTop + self.waveAmplitude && !self.stopRiseForShadoWave) {
            self.stopRiseForShadoWave = YES;
        }
        
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, self.waterWaveWidth, self.self.bounds.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.self.bounds.size.height);
    CGPathCloseSubpath(path);

    self.shadowWaveLayer.path = path;
}

- (void)drawCurrentWavePath
{
    CGMutablePathRef wavePath = (CGMutablePathRef)CFAutorelease(CGPathCreateMutable());
    CGPathMoveToPoint(wavePath, nil, 0, self.waterWaveTop);
    CGFloat y = 0.0f;

    for (float x = 0.0f; x <=  self.waterWaveWidth ; x += 0.1) {
        if (!self.stopRiseForWave) {
            y = self.waveAmplitude * sinf((360/self.waterWaveWidth) * (x - self.offsetX) * M_PI / 180) + self.self.bounds.size.height - self.offsetX / 5;
        }
        else {
            y = self.waveAmplitude * sinf((360/self.waterWaveWidth) *(x - self.offsetX) * M_PI / 180) + self.waterWaveTop + self.waveAmplitude;
        }
        
        if(x == 0.0 && y <= self.waterWaveTop + self.waveAmplitude && !self.stopRiseForWave) {
            self.stopRiseForWave = YES;
        }
        
        CGPathAddLineToPoint(wavePath, nil, x, y);
    }
    
    CGPathAddLineToPoint(wavePath, nil, self.waterWaveWidth, self.self.bounds.size.height);
    CGPathAddLineToPoint(wavePath, nil, 0, self.self.bounds.size.height);
    CGPathCloseSubpath(wavePath);
    self.waveLayer.path = wavePath;
}

#pragma mark - getters and setters 


- (CAShapeLayer *)waveLayer
{
    if (_waveLayer == nil) {
        _waveLayer = [CAShapeLayer layer];
    }
    
    return _waveLayer;
}

- (CAShapeLayer *)shadowWaveLayer
{
    if (_shadowWaveLayer == nil) {
        _shadowWaveLayer = [CAShapeLayer layer];
    }
    
    return _shadowWaveLayer;
}

- (void)setCurrentWaveColor:(UIColor *)currentWaveColor
{
    _currentWaveColor = currentWaveColor;
    self.waveLayer.fillColor = currentWaveColor.CGColor;
}

- (void)setShadowWareColor:(UIColor *)shadowWareColor
{
    _shadowWareColor = shadowWareColor;
    self.shadowWaveLayer.fillColor = shadowWareColor.CGColor;
}

@end
