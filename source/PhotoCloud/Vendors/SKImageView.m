//
//  SKImageView.m
//  PhotoCloud
//
//  Created by liupeng on 18/08/2016.
//  Copyright © 2016 liupeng. All rights reserved.
//

#import "SKImageView.h"
#import "PINCache.h"

@implementation SKImageView

- (void)setImageURL:(NSString *)url
{
    [[PINCache sharedCache] objectForKey:url block:^(PINCache *cache, NSString *key, id object) {
        if (object) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.image = object;
            });
        } else {
            self.imageLoadFinish = ^(NSImage *image, NSURL *url) {
                [[PINCache sharedCache] setObject:image forKey:url.absoluteString];
            };
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self downloadImageFromURL:url];
            });
        }
    }];
}

@end