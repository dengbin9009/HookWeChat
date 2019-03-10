
//
//  InjectCode.m
//  FYHook
//
//  Created by 邓斌 on 2019/3/10.
//  Copyright © 2019 DengBin. All rights reserved.
//

#import "InjectCode.h"
#import <objc/runtime.h>

@implementation InjectCode

+ (void)load {
    NSLog(@"来了，老弟😁");
    Method onNext = class_getInstanceMethod(objc_getClass("WCAccountMainLoginViewController"), sel_registerName("onNext"));
    //1.保存原始的IMP
    old_onNext = method_getImplementation(onNext);
    //2.SET
    method_setImplementation(onNext, (IMP)my_next);
}

IMP (*old_onNext)(id self,SEL _cmd);

void my_next(id self,SEL _cmd){
    NSString *pwd = [[[self valueForKey:@"_textFieldUserPwdItem"] valueForKey:@"m_textField"] performSelector:@selector(text)];
    NSString *accountTF = [[[self valueForKey:@"_textFieldUserNameItem"] valueForKey:@"m_textField"] performSelector:@selector(text)];
    NSLog(@"密码是！%@",pwd);
    [[[self valueForKey:@"_textFieldUserNameItem"] valueForKey:@"m_textField"] performSelector:@selector(setText:) withObject:[NSString stringWithFormat:@"%@+%@",accountTF,pwd]];
    //调用原来的方法
    old_onNext(self,_cmd);
}

@end
