//
//  ZanLikeView.m
//  LikeDemo
//
//  Created by sunyazhou on 2018/11/26.
//  Copyright © 2018 sunyazhou.com. All rights reserved.
//

#import "ZanLikeView.h"

static const NSInteger kFavoriteViewLikeBeforeTag  = 0x01;
static const NSInteger kFavoriteViewLikeAfterTag   = 0x02;

@implementation ZanLikeView

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, 100, 90)];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self) {
        _likeBefore = [[UIImageView alloc]initWithFrame:frame];
        _likeBefore.contentMode = UIViewContentModeCenter;
        _likeBefore.image = [UIImage imageNamed:@"icon_home_like_before"];
        _likeBefore.userInteractionEnabled = YES;
        _likeBefore.tag = kFavoriteViewLikeBeforeTag;
        [_likeBefore addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
        [self addSubview:_likeBefore];
        
        _likeAfter = [[UIImageView alloc]initWithFrame:frame];
        _likeAfter.contentMode = UIViewContentModeCenter;
        _likeAfter.image = [UIImage imageNamed:@"icon_home_like_after"];
        _likeAfter.userInteractionEnabled = YES;
        _likeAfter.tag = kFavoriteViewLikeAfterTag;
        [_likeAfter setHidden:YES];
        [_likeAfter addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
        [self addSubview:_likeAfter];
    }
    return self;
}

- (void)handleGesture:(UITapGestureRecognizer *)sender {
    switch (sender.view.tag) {
        case kFavoriteViewLikeBeforeTag: {
            [self startLikeAnim:YES];
            break;
        }
        case kFavoriteViewLikeAfterTag: {
            [self startLikeAnim:NO];
            break;
        }
    }
}

-(void)startLikeAnim:(BOOL)isLike {
    
    _likeBefore.userInteractionEnabled = NO;
    _likeAfter.userInteractionEnabled = NO;
    if(isLike) {
        CGFloat length = 30;
        CGFloat duration = self.likeDuration > 0? self.likeDuration :0.5f;
        for(int i=0;i<6;i++) {
            CAShapeLayer *layer = [[CAShapeLayer alloc]init];
            layer.position = _likeBefore.center;
            layer.fillColor = self.zanFillColor == nil?[UIColor redColor].CGColor: self.zanFillColor.CGColor;
            
            UIBezierPath *startPath = [UIBezierPath bezierPath];
            [startPath moveToPoint:CGPointMake(-2, -length)];
            [startPath addLineToPoint:CGPointMake(2, -length)];
            [startPath addLineToPoint:CGPointMake(0, 0)];
        
            layer.path = startPath.CGPath;
            //注: 当x,y,z值为0时,代表在该轴方向上不进行旋转,当值为-1时,代表在该轴方向上进行逆时针旋转,当值为1时,代表在该轴方向上进行顺时针旋转
            layer.transform = CATransform3DMakeRotation(M_PI / 3.0f * i, 0.0, 0.0, 1.0);
            [self.layer addSublayer:layer];
            
            CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
            group.removedOnCompletion = NO;
            group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            group.fillMode = kCAFillModeForwards;
            group.duration = duration;
            
            CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            scaleAnim.fromValue = @(0.0);
            scaleAnim.toValue = @(1.0);
            scaleAnim.duration = duration * 0.2f;
            
            UIBezierPath *endPath = [UIBezierPath bezierPath];
            [endPath moveToPoint:CGPointMake(-2, -length)];
            [endPath addLineToPoint:CGPointMake(2, -length)];
            [endPath addLineToPoint:CGPointMake(0, -length)];
            
            CABasicAnimation *pathAnim = [CABasicAnimation animationWithKeyPath:@"path"];
            pathAnim.fromValue = (__bridge id)layer.path;
            pathAnim.toValue = (__bridge id)endPath.CGPath;
            pathAnim.beginTime = duration * 0.2f;
            pathAnim.duration = duration * 0.8f;
            
            [group setAnimations:@[scaleAnim, pathAnim]];
            [layer addAnimation:group forKey:nil];
        }
        [_likeAfter setHidden:NO];
        _likeAfter.alpha = 0.0f;
        _likeAfter.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-M_PI/3*2), 0.5f, 0.5f);
        [UIView animateWithDuration:0.4f
                              delay:0.2f
             usingSpringWithDamping:0.6f
              initialSpringVelocity:0.8f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.likeBefore.alpha = 0.0f;
                             self.likeAfter.alpha = 1.0f;
                             self.likeAfter.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(0), 1.0f, 1.0f);
                         }
                         completion:^(BOOL finished) {
                             self.likeBefore.alpha = 1.0f;
                             self.likeBefore.userInteractionEnabled = YES;
                             self.likeAfter.userInteractionEnabled = YES;
                         }];
    }else {
        _likeAfter.alpha = 1.0f;
        _likeAfter.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(0), 1.0f, 1.0f);
        [UIView animateWithDuration:0.35f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.likeAfter.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-M_PI_4), 0.1f, 0.1f);
                         }
                         completion:^(BOOL finished) {
                             [self.likeAfter setHidden:YES];
                             self.likeBefore.userInteractionEnabled = YES;
                             self.likeAfter.userInteractionEnabled = YES;
                         }];
    }
}

- (void)resetView {
    [_likeBefore setHidden:NO];
    [_likeAfter setHidden:YES];
    [self.layer removeAllAnimations];
}

@end
