//
//  EVHTMLManager.h
//  eViewer
//
//  Created by cookie on 6/20/16.
//  Copyright © 2016 cookie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HomePageCompleteHandler)(NSMutableArray *array);

@interface EVHTMLManager : NSObject

- (void)getPage:(NSInteger)page withHandler:(HomePageCompleteHandler)hander;

@end
