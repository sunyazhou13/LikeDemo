//
//  ZanLikeView.h
//  LikeDemo
//
//  Created by sunyazhou on 2018/11/26.
//  Copyright © 2018 sunyazhou.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZanLikeView : UIView

@property (nonatomic, strong) UIImageView *likeBefore;
@property (nonatomic, strong) UIImageView *likeAfter;
@property (nonatomic, assign) CGFloat     likeDuration;
@property (nonatomic, strong) UIColor     *zanFillColor;

- (void)resetView;
@end

NS_ASSUME_NONNULL_END
