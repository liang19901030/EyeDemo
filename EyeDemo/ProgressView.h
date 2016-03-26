//
//  PregressView.h
//  ProgressView
//
//  Created by yuelixing on 15/5/28.
//  Copyright (c) 2015年 yuelixing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDHeader.h"
/**
 *  视频录制中的进度条
 */
@interface ProgressView : UIView

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, assign) CGFloat totalTime;
@property (nonatomic, assign) CGFloat currentTime;

@end
