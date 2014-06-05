//
//  ZParserXML.h
//  TDDPayDock
//
//  Created by 张达棣 on 13-7-31.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//
//  版本号: v2.0

#import <Foundation/Foundation.h>

@interface ZParserXML : NSObject<NSXMLParserDelegate>

//解析方法
+ (NSDictionary *)parserXMLData:(NSData *)data;
//解析方法
+ (NSDictionary *)parserXMLString:(NSString *)string;

@end

@interface NSData (ZParserXML)
//解析方法
- (NSDictionary *)ZParserXML;
@end

@interface NSString (ZParserXML)
//解析方法
- (NSDictionary *)ZParserXML;
@end
