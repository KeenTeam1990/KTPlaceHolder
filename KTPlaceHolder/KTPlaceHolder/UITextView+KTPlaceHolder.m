//
//  UITextView+KTPlaceHolder.m
//  KTPlaceHolder
//
//  Created by KT on 2017/8/15.
//  Copyright © 2017年 KEENTEAM. All rights reserved.
//

#import "UITextView+KTPlaceHolder.h"
#import <objc/runtime.h>
static const void *kt_placeHolderKey;
@implementation UITextView (KTPlaceHolder)
+(void)load{
    [super load];
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"layoutSubviews")),
                                   class_getInstanceMethod(self.class, @selector(ktPlaceHolder_swizzling_layoutSubviews)));
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
                                   class_getInstanceMethod(self.class, @selector(ktPlaceHolder_swizzled_dealloc)));
}
#pragma mark - swizzled
- (void)ktPlaceHolder_swizzled_dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self ktPlaceHolder_swizzled_dealloc];
}
- (void)ktPlaceHolder_swizzling_layoutSubviews {
    if (self.kt_placeHolder) {
        UIEdgeInsets textContainerInset = self.textContainerInset;
        CGFloat lineFragmentPadding = self.textContainer.lineFragmentPadding;
        CGFloat x = lineFragmentPadding + textContainerInset.left + self.layer.borderWidth;
        CGFloat y = textContainerInset.top + self.layer.borderWidth;
        CGFloat width = CGRectGetWidth(self.bounds) - x - textContainerInset.right - 2*self.layer.borderWidth;
        CGFloat height = [self.kt_placeHolderLabel sizeThatFits:CGSizeMake(width, 0)].height;
        self.kt_placeHolderLabel.frame = CGRectMake(x, y, width, height);
    }
    [self ktPlaceHolder_swizzling_layoutSubviews];
}
#pragma mark - associated
-(NSString *)kt_placeHolder{
    return objc_getAssociatedObject(self, &kt_placeHolderKey);
}
-(void)setKt_placeHolder:(NSString *)kt_placeHolder{
    objc_setAssociatedObject(self, &kt_placeHolderKey, kt_placeHolder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updatePlaceHolder];
}
-(UIColor *)kt_placeHolderColor{
    return self.kt_placeHolderLabel.textColor;
}
-(void)setKt_placeHolderColor:(UIColor *)kt_placeHolderColor{
    self.kt_placeHolderLabel.textColor = kt_placeHolderColor;
}
#pragma mark - update
- (void)updatePlaceHolder{
    if (self.text.length) {
        [self.kt_placeHolderLabel removeFromSuperview];
        return;
    }
    self.kt_placeHolderLabel.font = self.font?self.font:self.cacutDefaultFont;
    self.kt_placeHolderLabel.textAlignment = self.textAlignment;
    self.kt_placeHolderLabel.text = self.kt_placeHolder;
    [self insertSubview:self.kt_placeHolderLabel atIndex:0];
}
#pragma mark - lazzing
-(UILabel *)kt_placeHolderLabel{
    UILabel *placeHolderLab = objc_getAssociatedObject(self, @selector(kt_placeHolderLabel));
    if (!placeHolderLab) {
        placeHolderLab = [[UILabel alloc] init];
        placeHolderLab.numberOfLines = 0;
        placeHolderLab.textColor = [UIColor lightGrayColor];
        objc_setAssociatedObject(self, @selector(kt_placeHolderLabel), placeHolderLab, OBJC_ASSOCIATION_RETAIN);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlaceHolder) name:UITextViewTextDidChangeNotification object:self];
    }
    return placeHolderLab;
}
- (UIFont *)cacutDefaultFont{
    static UIFont *font = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UITextView *textview = [[UITextView alloc] init];
        textview.text = @" ";
        font = textview.font;
    });
    return font;
}

@end
