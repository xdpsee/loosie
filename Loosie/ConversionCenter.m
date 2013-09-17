//
//  ConversionCenter.m
//  Loosie
//
//  Created by Shay Aviv on 9/10/13.
//  Copyright (c) 2013 Shay Aviv. All rights reserved.
//

#import "ConversionCenter.h"

#import <iTunesLibrary/ITLibMediaItem.h>

#import "Passthrough.h"
#import "VorbisEncoder.h"
#import "MP3Encoder.h"
#import "FLACEncoder.h"
#import "WaveEncoder.h"

@implementation ConversionCenter {
    NSDictionary *defaultsKeyByKind;
}

- (id)init {
    self = [super init];
    if (self) {
        defaultsKeyByKind = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"LosslessTargetEncoder", @"Apple Lossless audio file",
                             @"LosslessTargetEncoder", @"WAV audio file",
                             @"LosslessTargetEncoder", @"AIFF audio file",
                             @"AACTargetEncoder", @"AAC audio file",
                             @"AACTargetEncoder", @"Purchased AAC audio file",
                             @"MP3TargetEncoder", @"MPEG audio file", nil];
    }
    return self;
}

VorbisEncoder *CreateVorbisEncoder() {
    VorbisEncoder *vorbisEncoder = [[VorbisEncoder alloc] init];
    vorbisEncoder.includeAdvancedMetadata = [[NSUserDefaults standardUserDefaults] boolForKey:@"IncludeAdvancedMetadata"];
    return vorbisEncoder;
}

MP3Encoder *CreateMP3Encoder() {
    MP3Encoder *mp3Encoder = [[MP3Encoder alloc] init];
    mp3Encoder.includeAdvancedMetadata = [[NSUserDefaults standardUserDefaults] boolForKey:@"IncludeAdvancedMetadata"];
    return mp3Encoder;
}

FLACEncoder *CreateFLACEncoder() {
    FLACEncoder *flacEncoder = [[FLACEncoder alloc] init];
    flacEncoder.includeAdvancedMetadata = [[NSUserDefaults standardUserDefaults] boolForKey:@"IncludeAdvancedMetadata"];
    return flacEncoder;
}

- (id <Encoder>)encoderForMediaItem:(ITLibMediaItem *)item {
    if (item.mediaKind == ITLibMediaItemMediaKindSong && !item.isDRMProtected) {
        NSString *encoderTypeKey = defaultsKeyByKind[item.kind];
        switch([[NSUserDefaults standardUserDefaults] integerForKey:encoderTypeKey]) {
            case 0:
                return [[Passthrough alloc] init];
            case 1:
                return CreateVorbisEncoder();
            case 2:
                return CreateMP3Encoder();
            case 3:
                return CreateFLACEncoder();
            case 4:
                return [[WaveEncoder alloc] init];
        }
    }
    return nil;
}

@end
