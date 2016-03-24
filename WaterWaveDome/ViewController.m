//
//  ViewController.m
//  WaterWaveDome
//
//  Created by 123 on 16/3/16.
//  Copyright © 2016年 YM. All rights reserved.
//

#import "ViewController.h"
#import "WaterWaveView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet WaterWaveView *waterWaveView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//   self.waterWaveView.shadowWareColor = [UIColor redColor];
//   self.waterWaveView.currentWaveColor = [UIColor orangeColor];
//   self.waterWaveView.waveAmplitude = 7.0f;
//   self.waterWaveView.waveSpeed =  5.0f;
    
    [self.waterWaveView wave];
}

#pragma mark - event response

- (IBAction)waveAction:(id)sender
{
    [self.waterWaveView wave];
}

- (IBAction)stopAction:(id)sender
{
    [self.waterWaveView stop];
}

@end
