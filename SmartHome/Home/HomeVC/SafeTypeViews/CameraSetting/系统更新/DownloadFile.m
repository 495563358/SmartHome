//
//  DownloadFile.m
//  Eye4
//
//  Created by kensla on 15/2/10.
//
//

#import "DownloadFile.h"

@interface DownloadFile ()<NSURLConnectionDataDelegate,NSURLConnectionDelegate>
{
    //文件操作的句柄(不会自动创建文件)
    NSFileHandle *handle;
    
    //文件管理类
    NSFileManager *manager;
    
    //文件总大小
    unsigned long long allSize;
    
    //已经下载的进度
    unsigned long long downlaodSize;
    
    NSURLConnection *downlaodConnection;
}
@end

@implementation DownloadFile

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void) startDownloadFile:(NSString *)url{
    
    manager = [NSFileManager defaultManager];
    //	显示下载的目录
    NSLog(@"%@",NSHomeDirectory());
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
//    //首先判断当前文件是不是存在
//    if ([manager fileExistsAtPath:[self getDownloadPath]])
//    {
//        /*
//         如果文件存在需要分两种情况考虑：
//         1.已经下载完成
//         2.下载一部分
//         */
//        
//        //1.获取已经下载过的文件大小
//        NSDictionary *attributes = [manager attributesOfItemAtPath:[self getDownloadPath] error:nil];
//        downlaodSize = [attributes fileSize];
//        
//        //2.如果没有下载完，告诉服务器从哪个地方开始下载
//        [request setValue:[NSString stringWithFormat:@"bytes=%qu-",downlaodSize] forHTTPHeaderField:@"Range"];
//        
//    }
//    else//没有下载过
//    {
        [manager createFileAtPath:[self getDownloadPath] contents:nil attributes:nil];
//    }
    
    //初始化文件句柄
    handle = [NSFileHandle fileHandleForWritingAtPath:[self getDownloadPath]];
    
    //发送下载请求
    downlaodConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (NSString *)getDownloadPath
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    return [path stringByAppendingPathComponent:@"CH-sys-48-50-64.bin"];
}

#pragma mark -NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //获取文件总大小
    allSize = [response expectedContentLength];
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
//    if (httpResponse.statusCode == 206)
//    {
//        //如果是断点下载的话，总大小=获取的文件大小+原来的下载的大小
//        allSize = [response expectedContentLength] + downlaodSize;
//    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    downlaodSize += data.length;
    
    //  写入
    [handle seekToEndOfFile];
    [handle writeData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self closeDownload];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadSuccess" object:@"1"];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self closeDownload];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadSuccess" object:@"0"];
}

- (void)closeDownload
{
    //关闭
    [handle closeFile];
    //取消
    [downlaodConnection cancel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
