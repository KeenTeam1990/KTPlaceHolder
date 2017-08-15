//
//  UITextView+KTLimitCounter.h
//  KTPlaceHolder
//
//  Created by KT on 2017/8/15.
//  Copyright © 2017年 KEENTEAM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (KTLimitCounter)
/** 限制字数*/
@property (nonatomic, assign) NSInteger kt_limitCount;
/** lab的右边距(默认10)*/
@property (nonatomic, assign) CGFloat kt_labMargin;
/** lab的高度(默认20)*/
@property (nonatomic, assign) CGFloat kt_labHeight;
/** 统计限制字数Label*/
@property (nonatomic, readonly) UILabel *kt_inputLimitLabel;
@end
