//
//  VoicePlayer.h
//  VoiceEncoder
//
//  Created by godliu on 14-10-24.
//  Copyright (c) 2014年 godliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoiceEncoder : NSObject
{
    void *player;
}

- (id) init;
- (BOOL) isStopped;
- (void) setFreqs:(int *)_freqs freqCount:(int)_freqCount;
- (void) play:(NSString *)_text playCount:(long)_playCount muteInterval:(int)_muteInterval;
- (void) playWiFi:(char *)_mac macLen:(int)_macLen pwd:(NSString *)_pwd playCount:(long)_playCount muteInterval:(int)_muteInterval;

@end
