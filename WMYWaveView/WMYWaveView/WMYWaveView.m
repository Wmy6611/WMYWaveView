//
//  WMYWaveView.m
//  WMYWaveView
//
//  Created by Wmy on 2016/12/19.
//  Copyright © 2016年 Wmy. All rights reserved.
//

#import "WMYWaveView.h"

#define kWaveColor1  [[UIColor whiteColor] colorWithAlphaComponent:0.68]
#define kWaveColor2  [UIColor whiteColor]

static CGFloat const kAngularSpeed = 2.f;
static CGFloat const kWaveSpeed    = 3.f;
static CGFloat const kWaveTime     = 6.f;

@interface WMYWaveView ()
@property (assign, nonatomic) CGFloat offsetX;
@property (strong, nonatomic) CADisplayLink *waveDisplayLink;
@property (strong, nonatomic) CAShapeLayer *waveShapeLayer;
@property (strong, nonatomic) CAShapeLayer *waveShapeLayer2;
@end

@implementation WMYWaveView

+ (instancetype)addToView:(UIView *)view withFrame:(CGRect)frame {
    WMYWaveView *waveView = [[self alloc] initWithFrame:frame];
    [view addSubview:waveView];
    return waveView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self basicSetup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self basicSetup];
    }
    return self;
}

- (void)basicSetup {
    _angularSpeed = kAngularSpeed;
    _waveSpeed = kWaveSpeed;
    _waveTime = kWaveTime;
    _waveColor1 = kWaveColor1;
    _waveColor2 = kWaveColor2;
}

- (void)stop {
    [UIView animateWithDuration:1.f animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.waveDisplayLink invalidate];
        self.waveDisplayLink = nil;
        self.waveShapeLayer.path = nil;
        self.waveShapeLayer2.path = nil;
        self.alpha = 1.f;
    }];
}

- (BOOL)wave {
    if (self.waveShapeLayer.path) {
        return NO;
    }
    
    self.waveShapeLayer = [CAShapeLayer layer];
    self.waveShapeLayer.fillColor = self.waveColor1.CGColor;
    [self.layer addSublayer:self.waveShapeLayer];
    
    self.waveShapeLayer2 = [CAShapeLayer layer];
    self.waveShapeLayer2.fillColor = self.waveColor2.CGColor;
    [self.layer addSublayer:self.waveShapeLayer2];
    
    
    self.waveDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(currentWave)];
    [self.waveDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    if (self.waveTime > 0.f) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.waveTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self stop];
        });
    }
    
    return YES;
}

- (void)currentWave {
    
    if (!self.superview) {
        [self stop];
        return;
    }
    
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    _offsetX -= (self.waveSpeed * self.superview.frame.size.width / 320);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0.5 * height);
    CGFloat y = 0.f;
    for (CGFloat x = 0.f; x <= width ; x++) {
        y = 0.5 * height + 0.5 * height * sin(0.012 * (1.2 * self.angularSpeed * x + _offsetX));
        CGPathAddLineToPoint(path, NULL, x, y);
    }
    if (_waveDirectionType == WaveDirectionTypeUp) {
        CGPathAddLineToPoint(path, NULL, width, height);
        CGPathAddLineToPoint(path, NULL, 0, height);
    }else {
        CGPathAddLineToPoint(path, NULL, width, 0);
        CGPathAddLineToPoint(path, NULL, 0, 0);
    }
    CGPathCloseSubpath(path);
    self.waveShapeLayer.path = path;
    CGPathRelease(path);
    
    
    CGMutablePathRef path2 = CGPathCreateMutable();
    CGPathMoveToPoint(path2, NULL, 0, 0.5 * height);
    CGFloat y2 = 0.f;
    for (CGFloat x = 0.f; x <= width ; x++) {
        y2 = 0.5 * height + 0.5 * 0.8 * height * (0.2 + sin(0.01 * (self.angularSpeed * x + _offsetX)));
        CGPathAddLineToPoint(path2, NULL, x, y2);
    }
    if (_waveDirectionType == WaveDirectionTypeUp) {
        CGPathAddLineToPoint(path2, NULL, width, height);
        CGPathAddLineToPoint(path2, NULL, 0, height);
    }else {
        CGPathAddLineToPoint(path2, NULL, width, 0);
        CGPathAddLineToPoint(path2, NULL, 0, 0);
    }
    CGPathCloseSubpath(path2);
    self.waveShapeLayer2.path = path2;
    CGPathRelease(path2);
    
}

@end

