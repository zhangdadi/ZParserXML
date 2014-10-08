//
//  ZParserXML.h
//  TDDPayDock
//
//  Created by 张达棣 on 13-7-31.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//
//  若发现bug请致电:z_dadi@163.com,在此感谢你的支持。
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.



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
