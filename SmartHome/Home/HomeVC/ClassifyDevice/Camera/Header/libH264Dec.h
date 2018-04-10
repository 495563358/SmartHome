//
//  libH264Dec.h
//  TestMyH264Dec
//
//  Created by Tsang on 12-12-5.
//  Copyright (c) 2012年 Tsang. All rights reserved.
//

#ifndef TestMyH264Dec_libH264Dec_h
#define TestMyH264Dec_libH264Dec_h

extern "C"
{
    int InitH264Decoder();
    int UninitH264Decoder();
    int DecoderH264Frame(uint8_t* h264Frame, int h264len, uint8_t**yuv, int *yuvlen, int* nWidth, int* nHeight);
    void YUV420toRGB565(unsigned int *rgb, unsigned char *y, unsigned char *u, unsigned char* v, int width, int height);

}

#endif
