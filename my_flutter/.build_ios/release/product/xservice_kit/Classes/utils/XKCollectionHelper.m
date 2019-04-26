//
//  XKCollectionHelper.m
//  xservice_kit
//
//  Created by Jidong Chen on 2018/11/5.
//

#import "XKCollectionHelper.h"

@implementation XKCollectionHelper

+ (NSDictionary *)deepCopyNSDictionary:(NSDictionary *)origin filter:(XKCollectionFilter)filter
{
    if(origin.count < 1) return origin;
    NSMutableDictionary *copyed = [NSMutableDictionary new];
    [origin enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        //Filter: Do not include invalid things
        if(filter && !filter(obj)) return;
        
        if([obj isKindOfClass: NSDictionary.class]){
            copyed[key] = [self deepCopyNSDictionary:obj filter:filter];
        }else if([obj isKindOfClass:NSArray.class]){
            copyed[key] = [self deepCopyNSArray:obj filter:filter];
        }else{
            copyed[key] = obj;
        }
    }];
    
    return copyed;
}

+ (NSArray *)deepCopyNSArray:(NSArray *)origin filter:(XKCollectionFilter)filter
{
    if(origin.count < 1) return origin;
    NSMutableArray *copyed = [NSMutableArray new];
    [origin enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        //Filter: Do not include invalid things.
        if(filter && !filter(obj)) return;
        
        id nObj = nil;
        
        if([obj isKindOfClass: NSDictionary.class]){
            nObj = [self deepCopyNSDictionary:obj filter:filter];
        }else if([obj isKindOfClass:NSArray.class]){
            nObj = [self deepCopyNSArray:obj filter:filter];
        }else{
            nObj = obj;
        }
    
        if (nObj) {
            [copyed addObject:nObj];
        }
    }];
    
    return copyed;
}

@end
