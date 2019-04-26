//
//  XKCollectionHelper.h
//  xservice_kit
//
//  Created by Jidong Chen on 2018/11/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef bool (^XKCollectionFilter)(id value);

@interface XKCollectionHelper : NSObject

+ (NSDictionary *)deepCopyNSDictionary:(NSDictionary *)origin filter:(XKCollectionFilter)filter;
+ (NSArray *)deepCopyNSArray:(NSArray *)array filter:(XKCollectionFilter)filter;

@end

NS_ASSUME_NONNULL_END
