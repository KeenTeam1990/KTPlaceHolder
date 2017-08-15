//
//  UITextView+KTPlaceHolder.h
//  KTPlaceHolder
//
//  Created by KT on 2017/8/15.
//  Copyright © 2017年 KEENTEAM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (KTPlaceHolder)

/** placeHolder*/
@property (nonatomic, copy) NSString *kt_placeHolder;
/** placeHolderColor*/
@property (nonatomic, strong) UIColor *kt_placeHolderColor;
/** placeHolderLabel*/
@property (nonatomic, readonly) UILabel *kt_placeHolderLabel;

@end
