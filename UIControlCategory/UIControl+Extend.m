//
//  UIControl+Extend.m
//  UIControlCategory
//
//  Created by Herry
//

#import "UIControl+Extend.h"
#import <objc/runtime.h>
@implementation UIControl (Extend)
@dynamic touchAreaInsets;

static const char *kUIControlExtened;

-(void)setTouchAreaInsets:(UIEdgeInsets)touchAreaInsets
{
    NSValue *value = [NSValue value:&touchAreaInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, &kUIControlExtened, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIEdgeInsets)touchAreaInsets
{
    NSValue *value = objc_getAssociatedObject(self, &kUIControlExtened);
    if(value) {
        UIEdgeInsets touchEdgeInsets = UIEdgeInsetsZero;
        [value getValue:&touchEdgeInsets];
        return touchEdgeInsets;
    }else {
        return UIEdgeInsetsZero;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if(UIEdgeInsetsEqualToEdgeInsets(self.touchAreaInsets, UIEdgeInsetsZero) ||
       !self.enabled || self.hidden) {
        return [super pointInside:point withEvent:event];
    }
    
    CGRect hitAreaFrame = UIEdgeInsetsInsetRect(self.bounds, self.touchAreaInsets);
    
    return CGRectContainsPoint(hitAreaFrame, point);
}

@end
