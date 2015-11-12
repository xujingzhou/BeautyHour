
#import "QHFilePath.h"

@implementation QHFilePath

+ (NSString *)getFilePath:(NSString *)fileNameAndType
{
    NSString *szFilename = [fileNameAndType stringByDeletingPathExtension];
    NSString *szFileext = [fileNameAndType pathExtension];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:[szFilename stringByAppendingString:@"@2x"] ofType:szFileext];
    
    return path;
}

@end
