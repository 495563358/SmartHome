//
//  oDropListStruct.h
//  P2PCamera
//
//  Created by mac on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#ifndef P2PCamera_oDropListStruct_h
#define P2PCamera_oDropListStruct_h

//记住加const

struct __param_value_t{
    int index;
    char szName[256];
    NSString *strTitle;
    NSString *strValue;
    int param1;
    int param2;
};


__param_value_t const extern_level[10] =
{
    {0,"",NSLocalizedStringFromTable(@"alarm_text_a2", @STR_LOCALIZED_FILE_NAME, nil)},
    {1,"",NSLocalizedStringFromTable(@"alarm_text_a1", @STR_LOCALIZED_FILE_NAME, nil)},
};
__param_value_t const extern_mode[10] =
{
    {0,"",NSLocalizedStringFromTable(@"Disconnect", @STR_LOCALIZED_FILE_NAME, nil)},
    {1,"",NSLocalizedStringFromTable(@"Close", @STR_LOCALIZED_FILE_NAME, nil)},
};
//__param_value_t const _motion_level[10] =
//{
//    {1,"1"},
//    {2,"2"},
//    {3,"3"},
//    {4,"4"},
//    {5,"5"},
//    {6,"6"},
//    {7,"7"},
//    {8,"8"},
//    {9,"9"},
//    {10,"10"},
//};

__param_value_t const _motion_level[10] =
{
    {1,"",NSLocalizedStringFromTable(@"MotionLevelHigh", @STR_LOCALIZED_FILE_NAME, nil)},
    {5,"",NSLocalizedStringFromTable(@"MotionLevelMiddle", @STR_LOCALIZED_FILE_NAME, nil)},
    {10,"",NSLocalizedStringFromTable(@"MotionLevelLow", @STR_LOCALIZED_FILE_NAME, nil)}
};

__param_value_t const motion_preset[17] =
{
    {0,"No"},
    {1,"1"},
    {2,"2"},
    {3,"3"},
    {4,"4"},
    {5,"5"},
    {6,"6"},
    {7,"7"},
    {8,"8"},
    {9,"9"},
    {10,"10"},
    {11,"11"},
    {12,"12"},
    {13,"13"},
    {14,"14"},
    {15,"15"},
    {16,"16"},
};

__param_value_t const pic_timer[15] =
{
    {0,"0"},
    {1,"1"},
    {3,"3"},
    {4,"4"},
    {5,"5"},
    {6,"6"},
    {7,"7"},
    {8,"8"},
    {9,"9"},
    {10,"10"},
    {15,"15"},
    {20,"20"},
    {25,"25"},
    {30,"30"},
    {60,"60"},
};


__param_value_t  const ntp_server[4] =
{
    {1,"1",@"time.nist.gov",@"time.nist.gov"},
    {2,"2",@"time.kriss.re.kr",@"time.kriss.re.kr"},
    {3,"3",@"time.windows.com",@"time.windows.com"},
    {4,"4",@"time.nuri.net",@"time.nuri.net"},
};

__param_value_t const time_zone[29] =
{
    {39600,"",NSLocalizedStringFromTable(@"datetimeZone0", @STR_LOCALIZED_FILE_NAME, nil)},
    {36000,"",NSLocalizedStringFromTable(@"datetimeZone1", @STR_LOCALIZED_FILE_NAME, nil)},
    {32400,"",NSLocalizedStringFromTable(@"datetimeZone2", @STR_LOCALIZED_FILE_NAME, nil)},
    {28800,"",NSLocalizedStringFromTable(@"datetimeZone3", @STR_LOCALIZED_FILE_NAME, nil)},
    {25200,"",NSLocalizedStringFromTable(@"datetimeZone4", @STR_LOCALIZED_FILE_NAME, nil)},
    {21600,"",NSLocalizedStringFromTable(@"datetimeZone5", @STR_LOCALIZED_FILE_NAME, nil)},
    {18000,"",NSLocalizedStringFromTable(@"datetimeZone6", @STR_LOCALIZED_FILE_NAME, nil)},
    {14400,"",NSLocalizedStringFromTable(@"datetimeZone7", @STR_LOCALIZED_FILE_NAME, nil)},
    {12600,"",NSLocalizedStringFromTable(@"datetimeZone8", @STR_LOCALIZED_FILE_NAME, nil)},
    {10800,"",NSLocalizedStringFromTable(@"datetimeZone9", @STR_LOCALIZED_FILE_NAME, nil)},
    {7200,"",NSLocalizedStringFromTable(@"datetimeZone10", @STR_LOCALIZED_FILE_NAME, nil)},
    {3600,"",NSLocalizedStringFromTable(@"datetimeZone11", @STR_LOCALIZED_FILE_NAME, nil)},
    {0,"",NSLocalizedStringFromTable(@"datetimeZone12", @STR_LOCALIZED_FILE_NAME, nil)},
    {-3600,"",NSLocalizedStringFromTable(@"datetimeZone13", @STR_LOCALIZED_FILE_NAME, nil)},
    {-7200,"",NSLocalizedStringFromTable(@"datetimeZone14", @STR_LOCALIZED_FILE_NAME, nil)},
    {-10800,"",NSLocalizedStringFromTable(@"datetimeZone15", @STR_LOCALIZED_FILE_NAME, nil)},
    {-12600,"",NSLocalizedStringFromTable(@"datetimeZone16", @STR_LOCALIZED_FILE_NAME, nil)},
    {-14400,"",NSLocalizedStringFromTable(@"datetimeZone17", @STR_LOCALIZED_FILE_NAME, nil)},
    {-16200,"",NSLocalizedStringFromTable(@"datetimeZone18", @STR_LOCALIZED_FILE_NAME, nil)},
    {-18000,"",NSLocalizedStringFromTable(@"datetimeZone19", @STR_LOCALIZED_FILE_NAME, nil)},
    {-19800,"",NSLocalizedStringFromTable(@"datetimeZone20", @STR_LOCALIZED_FILE_NAME, nil)},
    {-21600,"",NSLocalizedStringFromTable(@"datetimeZone21", @STR_LOCALIZED_FILE_NAME, nil)},
    {-25200,"",NSLocalizedStringFromTable(@"datetimeZone22", @STR_LOCALIZED_FILE_NAME, nil)},
    {-28800,"",NSLocalizedStringFromTable(@"datetimeZone23", @STR_LOCALIZED_FILE_NAME, nil)},
    {-32400,"",NSLocalizedStringFromTable(@"datetimeZone24", @STR_LOCALIZED_FILE_NAME, nil)},
    {-34200,"",NSLocalizedStringFromTable(@"datetimeZone25", @STR_LOCALIZED_FILE_NAME, nil)},
    {-36000,"",NSLocalizedStringFromTable(@"datetimeZone26", @STR_LOCALIZED_FILE_NAME, nil)},
    {-39600,"",NSLocalizedStringFromTable(@"datetimeZone27", @STR_LOCALIZED_FILE_NAME, nil)},
    {-43200,"",NSLocalizedStringFromTable(@"datetimeZone28", @STR_LOCALIZED_FILE_NAME, nil)},
};

//email ssl
__param_value_t const ssl[] =
{
    
    {0, "NONE"},
    {1, "SSL"},
    {2, "TLS"},
};

//email smtp server
__param_value_t const smtp_svr[] =
{
    {0,"smtp.gmail.com",@"",@"",465,2},
    {1,"smtp.mail.yahoo.com",@"",@"",25,0},
    {2,"smtp.sina.com",@"",@"",25,0},
    {3,"smtp.qq.com",@"",@"",25,0},
    {4,"smtp.sohu.com",@"",@"",25,0},
    {5,"smtp.yeah.net",@"",@"",25,0},
    {6,"smtp.126.com",@"",@"",25,0},
    {7,"smtp.163.com",@"",@"",25,0},
    {8,"smtp.tom.com",@"",@"",25,0},
    {9,"smtp.264.net",@"",@"",25,0},
    {10,"smtp.21cn.com",@"",@"",25,0},
    {11,"mx.eyou.com",@"",@"",25,0},
};

#endif
