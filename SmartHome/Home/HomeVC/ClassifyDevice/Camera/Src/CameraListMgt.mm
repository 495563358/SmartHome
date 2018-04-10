//
//  CameraList.m
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-24.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CameraListMgt.h"
#import "PPPPDefine.h"


@implementation CameraListMgt

- (id)init
{
    self = [super init];
    if (self != nil) 
    {
        CameraArray = [[NSMutableArray alloc] init];
        cameraDB = [[CameraDBUtils alloc] init];
        
        cameraDB.selectDelegate = self;
        [cameraDB Open:@"OBJ_P2P_CAMERA_DB" TblName:@"OBJ_P2P_CAMERA_TBL"];
        [cameraDB SelectAll];
        
        m_Lock = [[NSCondition alloc] init];
    }
    
    return self;
}

-(BOOL)UpdateCameraAuthority:(NSString *)did User:(NSString *)user3 Pwd:(NSString *)pwd3{
    [m_Lock lock];
    //NSLog(@"UpdateCameraAuthority");
    
    int count = [self GetCount];
    int i;
    for ( i=0; i < count ; i++)
    {
        NSDictionary *cameraDic = [CameraArray objectAtIndex:i];
        NSString *_did = [cameraDic objectForKey:@STR_DID];
        //        NSLog(@"_did=%@",_did);
        //        NSLog(@"did==%@",did);
        if ([_did caseInsensitiveCompare:did]==NSOrderedSame) {
            NSString *pwd=[cameraDic objectForKey:@STR_PWD];
            NSString *user=[cameraDic objectForKey:@STR_USER];
            // NSLog(@"UpdateCameraAuthority  user=%@ pwd=%@ user3=%@  pwd3=%@",user,pwd,user3,pwd3);
            
            NSNumber *authority=[NSNumber numberWithBool:NO];
            if (([user3 caseInsensitiveCompare:user]==NSOrderedSame)&&([pwd3 caseInsensitiveCompare:pwd]==NSOrderedSame)) {
                authority=[NSNumber numberWithBool:YES];
                // NSLog(@"UpdateCameraAuthority  相等");
                
            }else{
                // NSLog(@"UpdateCameraAuthority 不相等");
                
            }
            
            NSString *name=[cameraDic objectForKey:@STR_NAME];
            UIImage *img = [cameraDic objectForKey:@STR_IMG];
            NSNumber *nPPPPStatus = [cameraDic objectForKey:@STR_PPPP_STATUS];
            
            NSNumber *nPPPPMode = [cameraDic objectForKey:@STR_PPPP_MODE];
            
            
            
            NSDictionary *dic=[[NSDictionary alloc ]initWithObjectsAndKeys:name,@STR_NAME,user,@STR_USER,pwd,@STR_PWD,nPPPPStatus,@STR_PPPP_STATUS,nPPPPMode,@STR_PPPP_MODE,authority,@STR_AUTHORITY,_did,@STR_DID,img,@STR_IMG, nil] ;
            
            [CameraArray replaceObjectAtIndex:i withObject:dic];
            [dic release];
            
            [m_Lock unlock];
            
            return YES;
        }
        
    }
    [m_Lock lock];
    return NO;
    
}


- (BOOL)AddCamera:(NSString *)name DID:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd Snapshot:(UIImage *)img
{
    [m_Lock lock];
    NSLog(@"Add Camera...name:%@, did: %@, user: %@, pwd: %@", name, did, user, pwd);
    if ([self CheckCamere:did] == NO) {
        [m_Lock unlock];
        return NO;
    }
    NSNumber *authority=[NSNumber numberWithBool:NO];
    NSNumber *nPPPPStatus = [NSNumber numberWithInt:PPPP_STATUS_UNKNOWN];
    NSNumber *nPPPPMode = [NSNumber numberWithInt:PPPP_MODE_UNKNOWN];
    /*NSDictionary *cameraDic = [NSDictionary dictionaryWithObjectsAndKeys:name, @STR_NAME,
                               did, @STR_DID, user ,@STR_USER, pwd,@STR_PWD,// img,@STR_IMG,
                               nPPPPStatus, @STR_PPPP_STATUS,
                               nPPPPMode, @STR_PPPP_MODE,nil];*/
    NSDictionary *cameraDic = [NSDictionary dictionaryWithObjectsAndKeys:name, @STR_NAME,
                               did, @STR_DID, user ,@STR_USER, pwd,@STR_PWD,// img,@STR_IMG,
                               nPPPPStatus, @STR_PPPP_STATUS,
                               nPPPPMode, @STR_PPPP_MODE,authority,@STR_AUTHORITY,nil];
    
    if (NO == [cameraDB InsertCamera:name DID:did User:user Pwd:pwd])
    {
        NSLog(@"cameraDB InsertCamera return NO");
        if (NO == [cameraDB InsertCamera:name DID:did User:user Pwd:pwd])
        {
            [m_Lock unlock];
            return NO;
        }
        
    }
    
    [CameraArray addObject:cameraDic];
    [m_Lock unlock];
    return YES;
}

- (BOOL) EditCamera:(NSString *)olddid Name:(NSString *)name DID:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd
{
    [m_Lock lock];
    
    int count = [self GetCount];
    int i;
    for ( i=0; i < count ; i++) 
    {
        NSDictionary *cameraDic = [CameraArray objectAtIndex:i];
        NSString *_did = [cameraDic objectForKey:@STR_DID];
        
        if ([_did caseInsensitiveCompare:olddid] == NSOrderedSame)
        {
            UIImage *img = [cameraDic objectForKey:@STR_IMG];
            NSNumber *nPPPPStatus = [NSNumber numberWithInt:PPPP_STATUS_UNKNOWN];
            NSNumber *nPPPPMode = [NSNumber numberWithInt:PPPP_MODE_UNKNOWN];
            NSNumber *authority=[NSNumber numberWithBool:NO];
            /*NSDictionary *_cameraDic = [NSDictionary dictionaryWithObjectsAndKeys:name, @STR_NAME,
                                        did, @STR_DID, user ,@STR_USER, pwd,@STR_PWD, 
                                        nPPPPStatus, @STR_PPPP_STATUS,
                                        nPPPPMode, @STR_PPPP_MODE,
                                        img, @STR_IMG, nil];*/
            NSDictionary *_cameraDic = [NSDictionary dictionaryWithObjectsAndKeys:name, @STR_NAME,
                                        did, @STR_DID, user ,@STR_USER, pwd,@STR_PWD,
                                        nPPPPStatus, @STR_PPPP_STATUS,
                                        nPPPPMode, @STR_PPPP_MODE,
                                        img, @STR_IMG,authority,@STR_AUTHORITY, nil];
            
            [CameraArray replaceObjectAtIndex:i withObject:_cameraDic];
            [cameraDB UpdateCamera:name DID:did User:user Pwd:pwd OldDID:olddid];
            
            [m_Lock unlock];
            return YES;
        }
        
    }
    
    [m_Lock unlock];
    return NO;
}

- (NSInteger) UpdateCamereaImage:(NSString *)did Image:(UIImage *)img
{
    [m_Lock lock];
    if (img == nil) {
        [m_Lock unlock];
        return NO;
    }
    
    int count = [self GetCount];
    int i;
    for ( i=0; i < count ; i++) 
    {
        NSDictionary *cameraDic = [CameraArray objectAtIndex:i];
        NSString *_did = [cameraDic objectForKey:@STR_DID];        
        
        if ([_did caseInsensitiveCompare:did] == NSOrderedSame)
        {
            NSString *_name = [cameraDic objectForKey:@STR_NAME];
            NSString *_user = [cameraDic objectForKey:@STR_USER];
            NSString *_pwd = [cameraDic objectForKey:@STR_PWD];
            NSNumber *PPPPStatus = [cameraDic objectForKey:@STR_PPPP_STATUS];
            NSNumber *PPPPMode = [cameraDic objectForKey:@STR_PPPP_MODE];
            
            NSDictionary *_cameraDic = [NSDictionary dictionaryWithObjectsAndKeys:_name, @STR_NAME, 
                                        _did, @STR_DID, _user ,@STR_USER, _pwd,@STR_PWD, 
                                        PPPPStatus, @STR_PPPP_STATUS,
                                        PPPPMode, @STR_PPPP_MODE,
                                        img, @STR_IMG, nil];
            [CameraArray replaceObjectAtIndex:i withObject:_cameraDic];
            [m_Lock unlock];
            return i;
        }        
    }
    
    [m_Lock unlock];
    
    return -1;
}
- (NSInteger) UpdatePPPPMode:(NSString *)did mode:(int)mode
{
    [m_Lock lock];
    
    int count = [self GetCount];
    int i;
    for ( i=0; i < count ; i++) 
    {
        NSDictionary *cameraDic = [CameraArray objectAtIndex:i];
        NSString *_did = [cameraDic objectForKey:@STR_DID];
        
        
        if ([_did caseInsensitiveCompare:did] == NSOrderedSame)
        {
            NSString *_name = [cameraDic objectForKey:@STR_NAME];
            NSString *_user = [cameraDic objectForKey:@STR_USER];
            NSString *_pwd = [cameraDic objectForKey:@STR_PWD];
            UIImage *img = [cameraDic objectForKey:@STR_IMG];
            NSNumber *PPPPStatus = [cameraDic objectForKey:@STR_PPPP_STATUS];
            NSNumber *PPPPMode = [[NSNumber alloc] initWithInt:mode];//[NSNumber numberWithInt:mode];
            
            NSDictionary *_cameraDic = [NSDictionary dictionaryWithObjectsAndKeys:_name, @STR_NAME, 
                                        _did, @STR_DID, _user ,@STR_USER, _pwd,@STR_PWD,
                                        PPPPStatus, @STR_PPPP_STATUS,
                                        PPPPMode, @STR_PPPP_MODE,
                                        img, @STR_IMG, nil];
            [CameraArray replaceObjectAtIndex:i withObject:_cameraDic];
            [PPPPMode release];
            [m_Lock unlock];
            return i;
        }
        
    }

    [m_Lock unlock];
    return -1;
}

- (NSInteger) UpdatePPPPStatus:(NSString *)did status:(int)status
{
    [m_Lock lock];
    
    //NSLog(@"UpdatePPPPStatus ... did: %@, status: %d", did, status);
    
    int count = [self GetCount];
    int i;
    for ( i=0; i < count ; i++) 
    {
        NSDictionary *cameraDic = [CameraArray objectAtIndex:i];
        NSString *_did = [cameraDic objectForKey:@STR_DID];
        
        
        if ([_did caseInsensitiveCompare:did] == NSOrderedSame)
        {
            NSString *_name = [cameraDic objectForKey:@STR_NAME];
            NSString *_user = [cameraDic objectForKey:@STR_USER];
            NSString *_pwd = [cameraDic objectForKey:@STR_PWD];
            UIImage *img = [cameraDic objectForKey:@STR_IMG];
            NSNumber *PPPPMode = [cameraDic objectForKey:@STR_PPPP_MODE];
            NSNumber *PPPPStatus = [[NSNumber alloc] initWithInt:status];//[NSNumber numberWithInt:status];
            
            NSDictionary *_cameraDic = [NSDictionary dictionaryWithObjectsAndKeys:_name, @STR_NAME, 
                                        _did, @STR_DID, _user ,@STR_USER, _pwd,@STR_PWD, 
                                        PPPPStatus, @STR_PPPP_STATUS,
                                        PPPPMode, @STR_PPPP_MODE,
                                        img, @STR_IMG, nil];
            [CameraArray replaceObjectAtIndex:i withObject:_cameraDic];
            [PPPPStatus release];
            [m_Lock unlock];
            return i;
        }
        
    }
    [m_Lock unlock];
    return -1;
}

- (BOOL) RemoveCamerea:(NSString *)did
{
    [m_Lock lock];
    int count = [self GetCount];
    int i;
    for ( i=0; i < count ; i++) 
    {
        NSDictionary *cameraDic = [CameraArray objectAtIndex:i];
        NSString *_did = [cameraDic objectForKey:@STR_DID];
        
        if ([_did caseInsensitiveCompare:did] == NSOrderedSame)
        {
            [CameraArray removeObjectAtIndex:i];
            [cameraDB RemoveCamera:_did];
            [m_Lock unlock];
            return YES;
        }
        
    }
    [m_Lock unlock];
    return NO;
}

- (NSDictionary*) GetCameraAtIndex:(NSInteger)index
{
    [m_Lock lock];
    if (index >= CameraArray.count)
    {
        [m_Lock unlock];
        return nil;
    }
    
    NSDictionary *cameraDic = [CameraArray objectAtIndex:index];
    [cameraDic retain];
    [cameraDic autorelease];
    [m_Lock unlock];
    return cameraDic;
}

- (int) GetCount
{
    return CameraArray.count;
}

- (int) GetIndexFromDID:(NSString*) did{
    for (int i = 0; i < CameraArray.count; i ++) {
        NSDictionary* cameraDic = [CameraArray objectAtIndex:i];
        NSString* _did = [cameraDic objectForKey:@STR_DID];
        if ([_did caseInsensitiveCompare:did] == NSOrderedSame) {
            return i;
        }
    }
    return [CameraArray count];
}

- (BOOL) CheckCamere:(NSString *)did
{
    for (NSDictionary *cameraDic in CameraArray)
    {
        NSString *_did = [cameraDic objectForKey:@STR_DID];
        
        if ([_did caseInsensitiveCompare:did] == NSOrderedSame )
        {
            return NO;
        }
    }
    return YES;
}


- (BOOL) RemoveCameraAtIndex:(NSInteger) index
{
    if (index > [self GetCount]) 
    {
        return NO;
    }
    
    NSDictionary *cameraDic = [CameraArray objectAtIndex:index];
    NSString *did = [cameraDic objectForKey:@STR_DID];
    
    //NSLog(@"RemoveCameraAtIndex.. addr: %@, port:%@", addr, port);
    [cameraDB RemoveCamera:did];
    [CameraArray removeObjectAtIndex:index];
   
    return YES;
}

- (UIImage*) GetCameraSnapshotImage: (NSString*) strDID
{
    //获取路径
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:strDID];
    //NSLog(@"strPath: %@", strPath);

    strPath = [strPath stringByAppendingPathComponent:@"snapshot.jpg"];
    //NSLog(@"strPath: %@", strPath);
    
    UIImage *imgRead = [UIImage imageWithContentsOfFile:strPath];
    
    return imgRead;
}

#pragma mark -
#pragma mark DBSelectResultDelegate

- (void)SelectP2PResult:(NSString *)name DID:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd
{
    //NSLog(@"SelectP2PResult....name: %@, did: %@, user: %@, pwd: %@", name, did, user, pwd);
    
    NSNumber *nPPPPStatus = [NSNumber numberWithInt:PPPP_STATUS_UNKNOWN];
    NSNumber *nPPPPMode = [NSNumber numberWithInt:PPPP_MODE_UNKNOWN];
        
    //UIImage *img = nil;
    NSDictionary *cameraDic = [NSDictionary dictionaryWithObjectsAndKeys:name, @STR_NAME, 
                               did, @STR_DID, user ,@STR_USER, pwd,@STR_PWD, //img, @STR_IMG,
                               nPPPPStatus, @STR_PPPP_STATUS,
                               nPPPPMode, @STR_PPPP_MODE,nil];  
    
    [CameraArray addObject:cameraDic];
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    UIImage *image = [self GetCameraSnapshotImage:did];
    if (image != nil) {
        [self UpdateCamereaImage:did Image:image];
    }
    [pool release];

}

- (void)dealloc
{
    [CameraArray release];
    CameraArray = nil;
    [cameraDB Close];
    [cameraDB release];
    cameraDB = nil;
    [super dealloc];
}

@end
