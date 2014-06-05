//
//  ZParserXML.m
//  TDDPayDock
//
//  Created by 张达棣 on 13-7-31.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

/**
 *
 *  本类解析XML的核心算法原理：顺序读取XML的元素，当砬到结束元素(</key>)时，就把当前层字典加入到外层所在字典，然后回朔到上一个元素所在层；
 *  如果不是相同层的元素就新建一个字典，如果是相同层的元素，有数据时就把这数据加入这层的字典。
 *
 */

#import "ZParserXML.h"
#import "StackXML.h"

@interface ZParserXML ()

@property (nonatomic, retain) StackXML        *stack;       //保存key的栈
@property (nonatomic, retain) NSMutableString *tempParser;  //保存的是parser
@property (nonatomic, assign) NSInteger       countKey;     //有几层不同的key
@property (nonatomic, retain) NSMutableArray  *tierKeyArray;   //有几层key就保存几个数组

@end


@implementation ZParserXML

@synthesize stack          = _stack;
@synthesize tempParser     = _tempParser;
@synthesize countKey       = _countKey;
@synthesize tierKeyArray   = _tierKeyArray;

+ (NSDictionary *)parserXMLData:(NSData *)data {
    ZParserXML *parser = [[self alloc] init];
    [parser startParserXMLData:data];
    if (parser.tierKeyArray.count > 0) {
        return [parser.tierKeyArray objectAtIndex:0];
    } else {
        return nil;
    }
}

+ (NSDictionary *)parserXMLString:(NSString *)string {
    return [ZParserXML parserXMLData:[string dataUsingEncoding:NSASCIIStringEncoding]];
}

- (void)startParserXMLData:(NSData *)data {
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.shouldProcessNamespaces = NO;
    parser.shouldReportNamespacePrefixes = NO;
    parser.shouldResolveExternalEntities = NO;
    parser.delegate = self;
    [parser parse];
}

//XML解析
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    self.stack = [[StackXML alloc] init];
    self.tierKeyArray = [[NSMutableArray alloc] initWithCapacity:5];
    _countKey = 0;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    self.stack = nil;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    ++_countKey; //每碰到一个开始key就加1
    [_stack pushStackWithString:elementName]; //把开始key入栈
    self.tempParser = [[NSMutableString alloc] init];
    
    if (_countKey > [_tierKeyArray count]) { //如果砬到的key不是相同层则申请新字典
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [_tierKeyArray addObject:dict];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [_tempParser appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    --_countKey; //每碰到一个结束key就减1
    NSString *str = [_stack popStack]; //把当前最后的key出栈
    if (![str isEqualToString:elementName]) {
        NSLog(@"============栈异常===========!");
        return;
    }
    if (_countKey >= _tierKeyArray.count) {
        NSLog(@"============异常=============!");
        return;
    }
    //_temp有数据，则加入对应层的字典，无数据说明连续2次或2次以上的结束key，则把里层key的字典加入外层key的字典
    if (_tempParser.length > 0 || (![self judgeStrValue:_tempParser] && [_tierKeyArray count] - 1 <= _countKey)){
        //_temp有数据
        [self startContinuousEndWithKey:elementName];
        
    } else if ([_tierKeyArray count] - 1 > _countKey) { //YES表示有里层key的字典
        //_temp无数据
        [self continuousEndKey:elementName];
            
        //把里层的key字典删除
        [_tierKeyArray removeObjectAtIndex:_countKey + 1];
    }
}

#pragma mark - 判断文本框是否为0与空值,不为空则返回YES。
- (BOOL)judgeStrValue:(NSString *)str {
    NSMutableString *nstrSpace1 = [NSMutableString stringWithCapacity:str.length];
    for (int i = 0; i < str.length; i++) {
        [nstrSpace1 appendString:@" "];
    }
    if (str == nil || [str isEqualToString:nstrSpace1] || str.length == 0) {
        return NO;
    }
    else {
        return YES;
    }
}

/**
 *  开始的key连着结束的key的情况，直接把数据加入到对应字典中，比如：<id>1</id>
 *
 *  @param key xml的elementName
 */
- (void)startContinuousEndWithKey:(NSString *)key {
    NSMutableDictionary *dict = [_tierKeyArray objectAtIndex:_countKey];//取得对应层的字典
    [dict setValue:_tempParser forKey:key];
    self.tempParser = nil;
}

/**
 *  连续2次或2次以上的结束key，则把里层key的字典加入外层key的字典,比如：<user><id>1</id></user>，请详细看continuousEndKeyAllArray方法的说明。
 *
 *  @param key xml的elementName
 */
- (void)continuousEndKey:(NSString *)key {
    NSMutableDictionary *nexDict = [_tierKeyArray objectAtIndex:_countKey + 1]; //取得里层(当前层的下一层)的字典
    NSDictionary *currentlyDict = [_tierKeyArray objectAtIndex:_countKey]; //取得外层（当前层）的字典
    id nowDict = [currentlyDict objectForKey:key]; //取得外层（当前层）字典对应的id
    
    if (nowDict == nil) { //外层id为空，则第一次遇到这个key
        [currentlyDict setValue:nexDict forKey:key];
        
    } else {//第二次以上碰到相同的Key
        NSMutableArray *array = nil;
        if ([nowDict isKindOfClass:[NSMutableDictionary class]]) { //第二次遇到这个key，是重复，转换成数组
            array = [[NSMutableArray alloc] initWithObjects:nowDict, nil];
        } else {
            array = (NSMutableArray*)nowDict;
        }
        [array addObject:nexDict];
        [currentlyDict setValue:array forKey:key];
    }
}

/**
 *  连续2次或2次以上的结束key，则把里层key的字典加入外层key的字典,比如：<user><id>1</id></user>
 *  与continuousEndKey对立，请选择使用，此方法当砬到的元素没有具体数据时，不管此元素有几个都把其转换成数组，
 *  比如：<clu><user><id>1</id><name>zhangdadi</name></user></clu>，此时在字典里clu对应的val是一个数组，而不是字典。
 *  这样做的目的，是为的防止当解析的是数据项时，不用在取数据时判断是字典还是数组，比如：当解析的是好友列表的数据，假设好友信息是存放在clu
 *  的val中，若不这样做好友数只有1个人的时候，为数组，好友数为2个人，为字典，那在外面取好友列表的数据时就比较麻烦，要判断是数组还是字典，
 *  而用此方法替换continuousEndKey方法，解析出来的字典里都会弄成数组了。
 *  数组了。
 *
 *  @param key xml的elementName
 */
- (void)continuousEndKeyAllArray:(NSString *)key {
    NSMutableDictionary *nexDict = [_tierKeyArray objectAtIndex:_countKey + 1]; //取得里层(当前层的下一层)的字典
    NSDictionary *currentlyDict = [_tierKeyArray objectAtIndex:_countKey]; //取得外层（当前层）的字典
    NSMutableArray *nowDict = [currentlyDict objectForKey:key]; //取得外层（当前层）字典对应的id
    
    if (nowDict == nil) { //外层id为空，则第一次遇到这个key
        [currentlyDict setValue:nexDict forKey:key];
        NSMutableArray *array = [[NSMutableArray alloc] initWithObjects :nexDict, nil];
        [currentlyDict setValue:array forKey:key];
    }
    [nowDict addObject:nexDict];
}

@end


@implementation NSData (ZParserXML)

- (NSDictionary *)ZParserXML {
    return [ZParserXML parserXMLData:self];
}

@end


@implementation NSString (ZParserXML)

-(NSDictionary *)ZParserXML {
    return [ZParserXML parserXMLString:self];
}

@end

