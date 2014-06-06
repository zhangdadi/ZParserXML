//
//  StackXML.m
//  TDDPayDock
//
//  Created by 张达棣 on 13-7-31.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "StackXML.h"

@interface StackXML ()

@property (nonatomic, retain) NSMutableArray *starckArray;
@end

@implementation StackXML
@synthesize starckArray = _starckArray;

- (id) init {
    self = [super init];
    if (self) {
        self.starckArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) dealloc {
    self.starckArray = nil;
}


- (NSInteger)stackCount {
    if (_starckArray == nil) {
        return 0;
    }
    return [_starckArray count];
}

- (void)pushStackWithString:(NSString *)str {
    if (str == nil || [str isEqualToString:@""] || [str isEqualToString:@" "]) {
        return;
    }
    
    if (_starckArray == nil) {
        self.starckArray = [[NSMutableArray alloc] init];
    }
    
    [_starckArray addObject:str];
}

- (NSString *)popStack {
    if (_starckArray == nil) {
        return nil;
    }
    
    NSInteger i = [_starckArray count]-1;
    NSString *str = [[_starckArray objectAtIndex:i] copy];
    [_starckArray removeObjectAtIndex:i];
    return str;
}


@end
