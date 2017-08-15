//
//  UITextView+KTLimitCounter.m
//  KTPlaceHolder
//
//  Created by KT on 2017/8/15.
//  Copyright © 2017年 KEENTEAM. All rights reserved.
//

#import "UITextView+KTLimitCounter.h"
#import <objc/runtime.h>
static char limitCountKey;
static char labMarginKey;
static char labHeightKey;
@implementation UITextView (KTLimitCounter)
+ (void)load {
    [super load];
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"layoutSubviews")),
                                   class_getInstanceMethod(self.class, @selector(ktlimitCounter_swizzling_layoutSubviews)));
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
                                   class_getInstanceMethod(self.class, @selector(ktlimitCounter_swizzled_dealloc)));
}
#pragma mark - swizzled
- (void)ktlimitCounter_swizzled_dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    @try {
        [self removeObserver:self forKeyPath:@"layer.borderWidth"];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    [self ktlimitCounter_swizzled_dealloc];
}
- (void)ktlimitCounter_swizzling_layoutSubviews {
    [self ktlimitCounter_swizzling_layoutSubviews];
    if (self.kt_limitCount) {
        UIEdgeInsets textContainerInset = self.textContainerInset;
        textContainerInset.bottom = self.kt_labHeight;
        self.contentInset = textContainerInset;
        CGFloat x = CGRectGetMinX(self.frame)+self.layer.borderWidth;
        CGFloat y = CGRectGetMaxY(self.frame)-self.contentInset.bottom-self.layer.borderWidth;
        CGFloat width = CGRectGetWidth(self.bounds)-self.layer.borderWidth*2;
        CGFloat height = self.kt_labHeight;
        self.kt_inputLimitLabel.frame = CGRectMake(x, y, width, height);
        if ([self.superview.subviews containsObject:self.kt_inputLimitLabel]) {
            return;
        }
        [self.superview insertSubview:self.kt_inputLimitLabel aboveSubview:self];
    }
}
#pragma mark - associated
-(NSInteger)kt_limitCount{
    return [objc_getAssociatedObject(self, &limitCountKey) integerValue];
}
- (void)setKt_limitCount:(NSInteger)kt_limitCount{
    objc_setAssociatedObject(self, &limitCountKey, @(kt_limitCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateLimitCount];
}
-(CGFloat)kt_labMargin{
    return [objc_getAssociatedObject(self, &labMarginKey) floatValue];
}
-(void)setKt_labMargin:(CGFloat)kt_labMargin{
    objc_setAssociatedObject(self, &labMarginKey, @(kt_labMargin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateLimitCount];
}
-(CGFloat)kt_labHeight{
    return [objc_getAssociatedObject(self, &labHeightKey) floatValue];
}
-(void)setKt_labHeight:(CGFloat)kt_labHeight{
    objc_setAssociatedObject(self, &labHeightKey, @(kt_labHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateLimitCount];
}
#pragma mark -config
- (void)configTextView{
    self.kt_labHeight = 20;
    self.kt_labMargin = 10;
}
#pragma mark - update
- (void)updateLimitCount{
    if (self.text.length>self.kt_limitCount) {
        self.text = [self.text substringToIndex:self.kt_limitCount];
    }
    NSString *showText = [NSString stringWithFormat:@"%lu/%ld",(unsigned long)self.text.length,(long)self.kt_limitCount];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString
                                              alloc] initWithString:showText];
    NSUInteger length = [showText length];
    NSMutableParagraphStyle *
    style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.tailIndent = -self.kt_labMargin; //设置与尾部的距离
    style.alignment = NSTextAlignmentRight;//靠右显示
    [attrString addAttribute:NSParagraphStyleAttributeName value:style
                       range:NSMakeRange(0, length)];
    self.kt_inputLimitLabel.attributedText = attrString;
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"layer.borderWidth"]) {
        [self updateLimitCount];
    }
}
#pragma mark - lazzing
-(UILabel *)kt_inputLimitLabel{
    UILabel *label = objc_getAssociatedObject(self, @selector(kt_inputLimitLabel));
    if (!label) {
        label = [[UILabel alloc] init];
        label.backgroundColor = self.backgroundColor;
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentRight;
        objc_setAssociatedObject(self, @selector(kt_inputLimitLabel), label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateLimitCount)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self];
        [self addObserver:self forKeyPath:@"layer.borderWidth" options:NSKeyValueObservingOptionNew context:nil];
        [self configTextView];
    }
    return label;
}

@end
