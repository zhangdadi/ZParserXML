//
//  StackXML.h
//  TDDPayDock
//
//  Created by 张达棣 on 13-7-31.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

/**
 *  此类ARC，如是非ARC工程请在类文件加上参数-fobjc-arc。
 *
 */

#import <Foundation/Foundation.h>

@interface StackXML : NSObject

/**
 *  入栈
 *
 *  @param str 入栈数据
 */
- (void)pushStackWithString:(NSString *)str;

/**
 *  出栈
 *
 *  @return 出栈数据
 */
- (NSString *)popStack;

@end
