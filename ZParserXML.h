//
//  ZParserXML.h
//  TDDPayDock
//
//  Created by 张达棣 on 13-7-31.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//


/**
 *  此类ARC，如是非ARC工程请在类文件加上参数-fobjc-arc。
 */


#import <Foundation/Foundation.h>

@interface ZParserXML : NSObject<NSXMLParserDelegate>

+ (NSDictionary *)parserXMLData:(NSData *)data;
+ (NSDictionary *)parserXMLString:(NSString *)string;
/**
 *  解析xml
 *
 *  @param data  解析的数据
 *  @param array 一定重复的字段(砬到这字段转化成数组)
 */
+ (NSDictionary *)parserXMLData:(NSData *)data repeatKey:(NSArray *)repeatKeys;

@end

//#ifdef	__cplusplus
//extern "C"{
//#endif

NSDictionary* ZParserXMLData(NSData *Data);
NSDictionary* ZParserXMLData(NSData *Data, NSArray *repeatKeys);
NSDictionary* ZParserXMLString(NSString *String);

//#ifdef	__cplusplus
//}	//extern "C"
//#endif

@interface NSData (ZParserXML)
- (NSDictionary *)ZParserXML;
@end

@interface NSString (ZParserXML)
- (NSDictionary *)ZParserXML;
@end
