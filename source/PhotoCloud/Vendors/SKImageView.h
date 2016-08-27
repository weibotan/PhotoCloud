//
//  SKImageView.h
//  PhotoCloud
//
//  Created by liupeng on 18/08/2016.
//  Copyright © 2016 liupeng. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PVAsyncImageView.h"

@interface SKImageView : PVAsyncImageView

- (void)setImageURL:(NSString *)url;

@end
