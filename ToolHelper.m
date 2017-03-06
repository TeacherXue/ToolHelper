//
//  ToolHelper.m
//  USchoolCircle
//
//  Created by sunbingtuan on 13-10-28.
//  Copyright (c) 2013年 uskytec. All rights reserved.
//

#import "ToolHelper.h"
#import <AdSupport/AdSupport.h>
#import "vm_statistics.h"
#import "mach_host.h"
#import "mach_init.h"
#import <AudioToolbox/AudioToolbox.h>
#import <sys/sysctl.h>
#import <mach/mach.h>

#include <sys/param.h>
#include <sys/mount.h>
#import <CommonCrypto/CommonDigest.h>

#define kFullScreenSize           [UIScreen mainScreen].bounds.size
#define kFullScreenWidth          [UIScreen mainScreen].bounds.size.width
#define kFullScreenHeight         [UIScreen mainScreen].bounds.size.height
#define FILE_MANAGER           [NSFileManager defaultManager]
#define YEAR_MONTH_DAY_RANGE NSMakeRange(0, 10)
#define DAYNUMBERS  30.0  //30天


#define LOG_FILE_NAME @"AppRunLog.txt"

//static NSString * logPath;

@implementation ToolHelper
//去掉发表文字前的空格或者回车符
+(NSString *)DelbeforeBlankAndEnter:(NSString *)str1
{
    //    BOOL isStringtoSpace=YES;//是否是空格
    NSString *newstr = @"";
    NSString *strSpace =@" ";
    NSString *strEnter =@"\n";
    NSString *string;
    for(int i =0;i<[str1 length];i++)    {
        string = [str1 substringWithRange:NSMakeRange(i, 1)];//抽取子字符
        if((![string isEqualToString:strSpace])&&(![string isEqualToString:strEnter])){//判断是否为空格
            newstr = [str1 substringFromIndex:i];
            //            isStringtoSpace=NO; //如果是则改变 状态
            break;//结束循环
        }
    }
    return newstr;
    
}
//去掉发表文字后的空格或者回车符
+(NSString *)DelbehindEnterAndBlank:(NSString *)str2
{
    NSString *newstr = @"";
    NSString *newString = @" ";
    NSString *strEnter =@"\n";
    NSString *string;
    for(long i =[str2 length]-1;i>=0;i--)    {
        string = [str2 substringWithRange:NSMakeRange(i, 1)];//抽取子字符
        if((![string isEqualToString:strEnter])&&(![string isEqualToString:newString])){//判断是否为空格和回车
            newstr = [str2 substringToIndex:(i + 1)];
            break;//结束循环
        }
    }
    return newstr;
    
}

//去掉发表文字前的回车符
+(NSString *)DelbeforeEnter:(NSString *)str1
{
    //    BOOL isStringtoSpace=YES;//是否是空格
    NSString *newstr = @"";
    NSString *strEnter =@"\n";
    NSString *string;
    for(int i =0;i<[str1 length];i++)    {
        string = [str1 substringWithRange:NSMakeRange(i, 1)];//抽取子字符
        if(![string isEqualToString:strEnter]){//判断是否为空格
            newstr = [str1 substringFromIndex:i];
            //            isStringtoSpace=NO; //如果是则改变 状态
            break;//结束循环
        }
    }
    return newstr;
    
}
//去掉发表文字后的回车符
+(NSString *)DelbehindEnter:(NSString *)str2
{
    NSString *newstr = @"";
    NSString *strEnter =@"\n";
    NSString *string;
    for(long i =[str2 length]-1;i>=0;i--)    {
        string = [str2 substringWithRange:NSMakeRange(i, 1)];//抽取子字符
        if(![string isEqualToString:strEnter]){//判断是否为空格和回车
            newstr = [str2 substringToIndex:(i + 1)];
            break;//结束循环
        }
    }
    return newstr;
    
}

//返回距 1970年到现在的秒数
+(NSString *) getNowTimeWithLongType{
    return [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
}

//返回距 1970年到现在的秒数
+(UInt64) getSecondsFromTimeString:(NSString *)_str{
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date =  [formatter dateFromString:_str];
    return  [date timeIntervalSince1970];
}
//返回距 1970年到现在的秒数
+(UInt64) getSecondsFromTime:(NSDate *)_date{
    return  [_date timeIntervalSince1970];
}
//返回距 1970年到xx时间的的毫秒数
+(NSString *) getGiveTimeWithLongType:(NSDate *)timer{
    
    return [NSString stringWithFormat:@"%ld000", (long)[timer timeIntervalSince1970]];
}

//返回距 1970年到xx时间的的毫秒数
+(NSString *) getGiveTimeWithLongType1:(NSDate *)timer{
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
    NSString *date =  [formatter stringFromDate:timer];
    NSString *timeLocal = [[NSString alloc] initWithFormat:@"%@", date];
    return timeLocal;
}
//返回1970年到当前时间的的毫秒数
+(UInt64) getCurrentMilliSecondsTime{
    return [[NSDate date] timeIntervalSince1970]*1000;
}

//获取当前年月日字符串
+(NSString *) yearMonthDayString
{
    NSString * nowTime = [self getNowTimeWithType:DateHelperTimeTextTypeCut];
    NSString * YMD = [nowTime substringWithRange:YEAR_MONTH_DAY_RANGE];
    return YMD;
}
/**
 * 获取几天前或几天后的日期
 * daysNum:-(24*60*60)   (24*60*60)
 */
+(NSString *) getTheDate:(DateHelperTimeTextType)type daysNum:(double)daysNum
{
    NSString * dataString = nil;
  //  NSDateFormatter *dateFormatter = nil;
   NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    switch (type)
    {
        case DateHelperTimeTextTypeCut:
            [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
            break;
        case DateHelperTimeTextTypeColon:
            [dateFormatter setDateFormat:@"yyyy:MM:dd HH:mm:ss"];
            break;
        case DateHelperTimeTextTypeNone:
            [dateFormatter setDateFormat:@"yyyy MM dd HH:mm:ss"];
            break;
        case DateHelperTimeTextTypeYMD:
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            break;
        case DateHelperTimeTextTypeYMDNone:
            [dateFormatter setDateFormat:@"yyyyMMdd"];
            break;
        default:
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            break;
    }
    
    dataString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:daysNum]];
    return dataString;
}

//毫秒转换成日期时间
+(NSDate *)longTimeChangeToDate:(NSString *)longTime
{
    //     [[NSDate date] timeIntervalSince1970] 是可以获取到后面的毫秒 微秒的 ，只是在保存的时候省略掉了， 如一个时间戳不省略的情况下为 1395399556.862046 ，省略掉后为一般所见 1395399556 。所以想取得毫秒时用获取到的时间戳 *1000 ，想取得微秒时 用取到的时间戳 * 1000 * 1000 。
    double d = [longTime doubleValue];
    return [NSDate dateWithTimeIntervalSince1970:d/1000];//这里传入秒数;
}

//根据类型返回时间
+(NSString *) getNowTimeWithType:(DateHelperTimeTextType) type
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    switch (type)
    {
        case DateHelperTimeTextTypeCut:
            [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
            break;
        case DateHelperTimeTextTypeColon:
            [dateFormatter setDateFormat:@"yyyy:MM:dd HH:mm:ss"];
            break;
        case DateHelperTimeTextTypeNone:
            [dateFormatter setDateFormat:@"yyyy MM dd HH:mm:ss"];
            break;
        case DateHelperTimeTextTypeYMD:
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            break;
        case DateHelperTimeTextTypeYMDNone:
            [dateFormatter setDateFormat:@"yyyyMMdd"];
            break;
        default:
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            break;
    }
    
    NSString * dataString = [dateFormatter stringFromDate:[NSDate date]];
    
    return dataString;
}
//根据类型返回时间
+(NSString *) getStringTimeWithDataTime:(NSDate*)_date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * dataString = [dateFormatter stringFromDate:_date];
    return dataString;
}

//计算流逝的时间 参数为一个标准格式的时间字符串
+(NSString *) calulatePassTime:(NSString *) timeText
{
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate * d= [date dateFromString:timeText];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    NSTimeInterval now=[[NSDate date] timeIntervalSince1970]*1;
    
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    if (cha < 60) {
        timeString= @"刚刚";
    }else if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
    }  else if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }  else if (cha/86400>1) {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        
        if ([timeString compare:@"1"] == NSOrderedSame)  {
            return @"昨天";
        }else if ([timeString compare:@"2"] == NSOrderedSame) {
            return @"前天";
        } else {
            return [timeText substringWithRange:NSMakeRange(5,5)];
        }
    }
    return timeString;
}
/*
 下拉刷新时间显示
 0分钟00秒-0分钟59秒   1分钟前；
 1分钟00秒-1分钟59秒   1分钟前；
 ⋯⋯                  ⋯⋯
 58分钟00秒-58分钟59秒 59分钟前；
 59分钟00秒-59分钟59秒 1小时前；
 1小时00分00秒-1小时59分钟59秒  2小时前；
 ⋯⋯
 22小时00分00秒-22小时59分钟59秒 23小时前；
 23小时00分00秒-23小时59分钟59秒 1天前；
 1天00小时00分00秒-1天23小时59分59秒 2天前
 （n-1）天00小时00分00秒-（n-1）天23小时59分59秒 N天前
 */
//计算流逝的时间 参数为一个标准格式的时间字符串2
+(NSString *) calulatePassTime2:(NSDate *)timeDate toTime:(NSDate *)timeDate2
{
    NSTimeInterval late=[timeDate2 timeIntervalSince1970]*1;
    NSTimeInterval now=[timeDate timeIntervalSince1970]*1;
    NSString *timeString=@"";
    NSTimeInterval cha=now-late;
    if (cha<120) {
        timeString = @"1分钟前";
    }  else if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
    }  else if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@小时前", timeString];
    }  else if (cha/86400>1) {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@天前", timeString];
    }
    return timeString;
}

/*
 信息广场时间显示
 0分钟00秒-0分钟59秒   1分钟前；
 1分钟00秒-1分钟59秒   1分钟前；
 ⋯⋯                  ⋯⋯
 58分钟00秒-58分钟59秒 59分钟前；
 59分00秒-23小时59分钟59秒 今天 HH：MM
 之后时间                  MM-DD HH：MM
 */
//计算流逝的时间 参数为一个标准格式的时间字符串2
+(NSString *) calulatePassTime3:(NSString *) timeText
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * d = [date dateFromString:timeText];
    NSTimeInterval late = [d timeIntervalSince1970];
    NSTimeInterval now =[[NSDate date] timeIntervalSince1970];
    NSString *currentStr = [date stringFromDate:[NSDate date]];
    NSString *todayStr = [NSString stringWithFormat:@"%@00:00:00",[currentStr substringWithRange:NSMakeRange(0, 11)]];
    NSDate *todayDate= [date dateFromString:todayStr];
    NSTimeInterval todaySecond = [todayDate timeIntervalSince1970];
    NSString *timeString=@"";
    NSTimeInterval cha = now-late;
    if (cha<120) {
        timeString = @"1分钟前";
    }  else if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@分钟前", timeString];
    }  else if (cha/3600>1&&cha/86400<1) {
        if (late > todaySecond) {
            //            timeString = [NSString stringWithFormat:@"%f", cha/3600];
            timeString = [NSString stringWithFormat:@"今天 %@",[timeText substringWithRange:NSMakeRange(11,5)]];
        }else{
            //            timeString = [NSString stringWithFormat:@"%f", cha/3600];
            timeString = [NSString stringWithFormat:@"昨天 %@",[timeText substringWithRange:NSMakeRange(11,5)]];
        }
    }  else if (cha/86400>1) {
        //        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeText substringWithRange:NSMakeRange(5,11)];;
    }
    return timeString;
}
/*
 0分钟00秒-0分钟59秒   1分钟前；
 
 1分钟00秒-1分钟59秒   1分钟前；
 ……
 59分钟00秒-59分钟59秒 59分钟前；
 
 1小时00分00秒-1小时59分钟59秒  1小时前；
 ……
 2小时0分00秒-23小时59分钟59秒  HH：MM
 1天00小时00分00秒-1天23小时59分59秒 1天前
 ……
 N天00小时00分00秒- N天23小时59分59秒 N天前（N≤7）
 A--列表中显示：MM-DD
 B--详细情况下：YY-MM-DD  HH：MM
 */
+(NSString *) calulatePassTime4:(NSString *) timeText Type:(NSInteger) typeForm
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *releaseDate= [dateFormatter dateFromString:timeText];
    NSString *currentStr = [dateFormatter stringFromDate:[NSDate date]];
//    NSString *todayStr = [NSString stringWithFormat:@"%@00:00:00",[currentStr substringWithRange:NSMakeRange(0, 11)]];
//    NSDate *todayDate= [dateFormatter dateFromString:todayStr];
    NSTimeInterval cha = [[NSDate date] timeIntervalSinceDate:releaseDate];
    NSString* timeString = @"";
    if (cha < 3600) {
        int minite = (int)cha;
        minite = minite/60;
        if (0 >= minite) {
            minite = 1;
        }
        timeString= [NSString stringWithFormat:@"%d分钟前",minite];
    } else if (cha>=3600 && (cha<3600*2)) {
        timeString=[NSString stringWithFormat:@"1小时前"];
    }else if (cha>=3600*2 && (cha<3600*24)) {
        timeString = [timeText substringWithRange:NSMakeRange(11, 5)];
    } else if (cha>=3600*24 && (cha<3600*24*7)) {
        int day = (int)cha;
        day = day/(3600*24);
        if (0 >= day) {
            day = 1;
        }
        timeString= [NSString stringWithFormat:@"%d天前",day];
    }  else {
        if (typeForm == DateHelperTimeForShowFormList) {
            timeString = [timeText substringWithRange:NSMakeRange(5, 5)];
        }else if(typeForm == DateHelperTimeForShowFormDetail){
            timeString = [timeText substringWithRange:NSMakeRange(2, 14)];
        }else{
            timeString = currentStr;
        }
        
    }
    return timeString;
}
/*
 0小时0分钟00秒- 23小时59分钟59秒 今天HH:MM
 之后时间  几月几日 HH:MM
 */
+(NSString *) calulatePassTime5:(NSString *) timeText;
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *releaseDate= [dateFormatter dateFromString:timeText];
    // NSString *currentStr = [dateFormatter stringFromDate:[NSDate date]];
    // NSString *todayStr = [NSString stringWithFormat:@"%@00:00:00",[currentStr substringWithRange:NSMakeRange(0, 11)]];
    // NSDate *todayDate= [dateFormatter dateFromString:todayStr];
    
    NSInteger TimeDifference =  3600 * 24 - ([[timeText substringWithRange:NSMakeRange(11, 2)] integerValue] * 3600 + [[timeText substringWithRange:NSMakeRange(14, 2)] integerValue] * 60 + [[timeText substringWithRange:NSMakeRange(17, 2)] integerValue]);
    NSTimeInterval cha = [[NSDate date] timeIntervalSinceDate:releaseDate];
    //    NSTimeInterval todaySecond = [todayDate timeIntervalSince1970];
    //    NSTimeInterval releaseSecond = [releaseDate timeIntervalSince1970];
    NSString* timeString = @"";
    if (cha < TimeDifference) {
        timeString = [NSString stringWithFormat:@"今天%@", [timeText substringWithRange:NSMakeRange(11, 5)]];
    }else if (cha >= TimeDifference)
    {
        timeString = [NSString stringWithFormat:@"%@月%@日%@", [timeText substringWithRange:NSMakeRange(5, 2)], [timeText substringWithRange:NSMakeRange(8, 2)], [timeText substringWithRange:NSMakeRange(11, 5)]];
        NSString * str = [NSString stringWithFormat:@"%@", [timeString substringWithRange:NSMakeRange( 0, 2)]];
        if ([str intValue] < 10) {
            timeString = [NSString stringWithFormat:@"%@", [timeString substringWithRange:NSMakeRange( 1, [timeString length] - 1)]];
        }
    }
    return timeString;
}


/*
 - 0分钟00秒-0分钟59秒   1分钟前；
 - 1分钟00秒-1分钟59秒   1分钟前；
 - ⋯⋯                  ⋯⋯
 - 59分钟00秒-59分钟59秒 59分钟前；
 - 1小时0分00秒-23小时59分钟59秒 今天 HH：MM
 - 之后时间                  MM-DD HH：MM
 */
+(NSString *) caculateRuleTime:(NSString *) timeText
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *releaseDate= [dateFormatter dateFromString:timeText];
    NSString *currentStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *todayStr = [NSString stringWithFormat:@"%@00:00:00",[currentStr substringWithRange:NSMakeRange(0, 11)]];
    NSDate *todayDate= [dateFormatter dateFromString:todayStr];
    NSTimeInterval cha = [[NSDate date] timeIntervalSinceDate:releaseDate];
    NSTimeInterval todaySecond = [todayDate timeIntervalSince1970];
    NSTimeInterval releaseSecond = [releaseDate timeIntervalSince1970];
    NSString* timeString = @"";
    if (cha < 3600) {
        int minite = (int)cha;
        minite = minite/60;
        if (0 >= minite) {
            minite = 1;
        }
        timeString= [NSString stringWithFormat:@"%d分钟前",minite];
    } else if (cha>=3600 && releaseSecond > todaySecond) {
        timeString=[NSString stringWithFormat:@"今天 %@", [timeText substringWithRange:NSMakeRange(11, 5)]];
    } else {
        timeString = [timeText substringWithRange:NSMakeRange(5, 11)];
    }
    return timeString;
}

+(NSString *)getCurrentTime{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss SS"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

+ (NSInteger)compareStartTime:(NSString *)startTim endTime:(NSString *)endTim
{
    NSDateFormatter* format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startDate=[format dateFromString:startTim];
    NSDate *endDate=[format dateFromString:endTim];
    return [startDate compare:endDate];
}

+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize image:(UIImage *)img
{
    UIImage *newImage = nil;
    CGSize imageSize = img.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [img drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
//还原图片方向
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
// 修改图片旋转问题
+(UIImage *) fixOrientationWithImage:(UIImage *)image {
    
    // No-op if the orientation is already correct
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch ((int)image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
    }
    
    switch ((int)image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

//获取设备系统版本
+(NSString *) getSystemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

//当前手机系统版本
+ (NSString *) getIOSVersion
{
    return [NSString stringWithFormat:@"%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]];
}
+ (float)getCurrentIOSVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}
//当前手机类型
+(NSString *)getDeviceModel
{
    return [[UIDevice currentDevice] model];
}
+ (NSString *)getDeviceUUID
{
    //    NSString *uuidStr = [[NSUserDefaults standardUserDefaults] objectForKey:DEVICE_UUID];
    //    if(uuidStr && [uuidStr length])
    //    {
    //        return uuidStr;
    //    }
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid);
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    //    [[NSUserDefaults standardUserDefaults] setObject:result forKey:DEVICE_UUID];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}
/**
 *获取设备名称 如：iPhone6   iPhone6s...
 */
+(NSString*) deviceName {
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString* code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];
    
    static NSDictionary* deviceNamesByCode = nil;
    
    if (!deviceNamesByCode) {
        
        deviceNamesByCode = @{@"i386"      :@"Simulator",
                              @"x86_64"    :@"Simulator",
                              @"iPod1,1"   :@"iPod Touch",      // (Original)
                              @"iPod2,1"   :@"iPod Touch",      // (Second Generation)
                              @"iPod3,1"   :@"iPod Touch",      // (Third Generation)
                              @"iPod4,1"   :@"iPod Touch",      // (Fourth Generation)
                              @"iPod7,1"   :@"iPod Touch",      // (6th Generation)
                              @"iPhone1,1" :@"iPhone",          // (Original)
                              @"iPhone1,2" :@"iPhone",          // (3G)
                              @"iPhone2,1" :@"iPhone",          // (3GS)
                              @"iPad1,1"   :@"iPad",            // (Original)
                              @"iPad2,1"   :@"iPad 2",          //
                              @"iPad3,1"   :@"iPad",            // (3rd Generation)
                              @"iPhone3,1" :@"iPhone 4",        // (GSM)
                              @"iPhone3,3" :@"iPhone 4",        // (CDMA/Verizon/Sprint)
                              @"iPhone4,1" :@"iPhone 4S",       //
                              @"iPhone5,1" :@"iPhone 5",        // (model A1428, AT&T/Canada)
                              @"iPhone5,2" :@"iPhone 5",        // (model A1429, everything else)
                              @"iPad3,4"   :@"iPad",            // (4th Generation)
                              @"iPad2,5"   :@"iPad Mini",       // (Original)
                              @"iPhone5,3" :@"iPhone 5c",       // (model A1456, A1532 | GSM)
                              @"iPhone5,4" :@"iPhone 5c",       // (model A1507, A1516, A1526 (China), A1529 | Global)
                              @"iPhone6,1" :@"iPhone 5s",       // (model A1433, A1533 | GSM)
                              @"iPhone6,2" :@"iPhone 5s",       // (model A1457, A1518, A1528 (China), A1530 | Global)
                              @"iPhone7,1" :@"iPhone 6 Plus",   //
                              @"iPhone7,2" :@"iPhone 6",        //
                              @"iPhone8,1" :@"iPhone 6S",       //
                              @"iPhone8,2" :@"iPhone 6S Plus",  //
                              @"iPad4,1"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Wifi
                              @"iPad4,2"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Cellular
                              @"iPad4,4"   :@"iPad Mini",       // (2nd Generation iPad Mini - Wifi)
                              @"iPad4,5"   :@"iPad Mini",       // (2nd Generation iPad Mini - Cellular)
                              @"iPad4,7"   :@"iPad Mini"        // (3rd Generation iPad Mini - Wifi (model A1599))
                              };
    }
    
    NSString* deviceName = [deviceNamesByCode objectForKey:code];
    
    if (!deviceName) {
        // Not found on database. At least guess main device type from string contents:
        
        if ([code rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        }
        else if([code rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        }
        else if([code rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        }
        else {
            deviceName = @"Unknown";
        }
    }
    
    return deviceName;
}
/**
 *剩余内存
 */
+(NSUInteger) freeMemory
{
    mach_port_t           host_port = mach_host_self();
    mach_msg_type_number_t   host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t               pagesize;
    vm_statistics_data_t     vm_stat;
    
    host_page_size(host_port, &pagesize);
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) NSLog(@"Failed to fetch vm statistics");
    
    natural_t   mem_free = vm_stat.free_count * (unsigned int)pagesize;
    
    return mem_free;
}
//总磁盘空间
+(NSString *)getTotalDiskSpace{
    
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_blocks);
    }
    
    return [self formattedFileSize:freeSpace];
}
//剩余磁盘空间
+(NSString *)getFreeDiskSpace{
    
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_bavail);
    }

    return [self formattedFileSize:freeSpace];
}

#pragma mark - platform information  获取平台信息
+ (NSUInteger)getAvailableMemory  //iphone下获取可用的内存大小
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if(kernReturn != KERN_SUCCESS)
        return NSNotFound;
    return (vm_page_size * vmStats.free_count / 1024.0) / 1024.0;
}
/**
 * 输出日志
 * logContents:日志内容
 */
+ (BOOL) bmsLog:(NSString *)logContents {
    BOOL bRet = NO;
    FileManager *fileManager;//文件管理工具类
    NSString *today=nil;
    NSString *logFile=nil;
    NSData *logData=nil;
    @try {
        
        fileManager = [FileManager getInstance];
        
        //documentDirectory =[fileManager getDocumentDirectory];//获取Docment路径
        
        today =[ToolHelper getNowTimeWithType:DateHelperTimeTextTypeYMDNone];
        logFile = @"logs/log";
        logFile = [logFile stringByAppendingString:today];
        logFile = [logFile stringByAppendingString:@".log"];
        
        today =[self getNowTimeWithType:DateHelperTimeTextTypeCut];
        today =[today stringByAppendingString:@"  "];
        logContents = [today stringByAppendingString:logContents];
        logContents = [logContents stringByAppendingString:@"\r\n"];
        
        logData = [logContents dataUsingEncoding: NSUnicodeStringEncoding];
        bRet = [fileManager writeFile:logFile contents:logData append:YES];
        
    } @catch (NSException *exception) {
        NSLog(@"creObject: 输出日志失败 %@: %@", [exception name], [exception reason]);
    } @finally {
        return bRet;
    }
}
/*
 
 //Log路径
 + (NSString*) LLogPath
 {
 if (!logPath)
 {
 NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
 
 logPath = [[NSString alloc] initWithString:[path stringByAppendingPathComponent:LOG_FILE_NAME]];
 }
 
 return logPath;
 }
 
 
 //清除Log
 + (void) clearLog
 {
	NSString * content = @"";
 
	NSString * fileName = [ToolHelper LLogPath];
	[content writeToFile:fileName
 atomically:NO
 encoding:NSStringEncodingConversionAllowLossy
 error:nil];
 }
 
 //将本地Log转为字符串数组
 + (NSArray*) getLogArray
 {
	NSString * fileName = [ToolHelper LLogPath];
 
	NSString *content = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
 
	NSMutableArray * array = (NSMutableArray *)[content componentsSeparatedByString:@"\n"];
	NSMutableArray * newArray = [[[NSMutableArray alloc] init] autorelease];
 
	for (int i = 0; i < [array count]; i++)
	{
 NSString * item = [array objectAtIndex:i];
 if ([item length])
 [newArray addObject:item];
	}
	return (NSArray*)newArray;
 }
 
 //新加一条log
 + (void) log:(NSString*) msg
 {
	NSString * logMessage = [NSString stringWithFormat:@"%@ %@", [ToolHelper getNowTimeWithType:DateHelperTimeTextTypeCut], msg];
 
	NSString * fileName = [ToolHelper LLogPath];
 
	FILE * f = fopen([fileName UTF8String], "at");
 
	fprintf(f, "%s\n", [logMessage UTF8String]);
 
	fclose (f);
 }
 */


//键盘音效
+(void) playKeyBordSound
{
    AudioServicesPlaySystemSound(1306);
}

+(void) playVibrateSound
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//震动
}

+(void) playVibrateAndNoticeAlertSound
{
    AudioServicesPlaySystemSound(1007);//提醒加震动
}
//static void completionCallback (SystemSoundID  mySSID) {
//    // Play again after sound play completion
//    AudioServicesPlaySystemSound(mySSID);
//}
//
//- (void) playSound {
//    // Get the main bundle for the app
//    CFBundleRef mainBundle;
//    SystemSoundID soundFileObject;
//    mainBundle = CFBundleGetMainBundle ();
//
//    // Get the URL to the sound file to play
//    CFURLRef soundFileURLRef  = CFBundleCopyResourceURL (
//                                                         mainBundle,
//                                                         CFSTR ("background"),
//                                                         CFSTR ("caf"),
//                                                         NULL
//                                                         );
//    // Create a system sound object representing the sound file
//    AudioServicesCreateSystemSoundID (
//                                      soundFileURLRef,
//                                      &soundFileObject
//                                      );
//    // Add sound completion callback
////    AudioServicesAddSystemSoundCompletion (soundFileObject, NULL, NULL,completionCallback,(void*) self);
//    // Play the audio
//    AudioServicesPlaySystemSound(soundFileObject);
//}
static void completionCallback(SystemSoundID sound_id, void* user_data){
    AudioServicesDisposeSystemSoundID(sound_id);
    CFRelease (user_data);    //CFURLCreateWithFileSystemPath()创建的需释放
    CFRunLoopStop (CFRunLoopGetCurrent());
}
+(void) playNoticeAlertSound
{
    SystemSoundID soundFileObject;
    CFBundleRef mainBundle;
    mainBundle = CFBundleGetMainBundle ();
    
    // Get the URL to the sound file to play
    CFURLRef soundFileURLRef  = CFBundleCopyResourceURL (
                                                         mainBundle,
                                                         CFSTR ("msgTritone"),
                                                         CFSTR ("caf"),
                                                         NULL
                                                         );
    // Create a system sound object representing the sound file
    AudioServicesCreateSystemSoundID (
                                      soundFileURLRef,
                                      &soundFileObject
                                      );
    // Add sound completion callback
    AudioServicesAddSystemSoundCompletion (soundFileObject, NULL, NULL,completionCallback,(void*)soundFileURLRef);
    // Play the audio
    AudioServicesPlaySystemSound(soundFileObject);
    
    
    //      AudioServicesPlayAlertSound(1007);//提醒声音
}

#if 0
//与设置模块声音/震动/活动通知 业务相关
+(void) playSettingSound{
    if (![defaults boolForKey:USER_BROTHER_TIME_STAUTS]) {
        if ([defaults boolForKey:USER_NOTICE_VOICE_STAUTS] && [defaults boolForKey:USER_NOTICE_VIBRATE_STATUS]) {
            [ToolHelper playVibrateAndNoticeAlertSound];
        }else if([defaults boolForKey:USER_NOTICE_VOICE_STAUTS]){
            [ToolHelper playNoticeAlertSound];
        }else if([defaults boolForKey:USER_NOTICE_VIBRATE_STATUS]){
            [ToolHelper playVibrateSound];
        }
    }else{
        NSInteger form = [defaults integerForKey:USER_BROTHER_TIME_FORM];
        NSInteger to = [defaults integerForKey:USER_BROTHER_TIME_TO];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString * dataString = [dateFormatter stringFromDate:[NSDate date]];
        NSInteger time = [[dataString substringWithRange:NSMakeRange(11, 2)] integerValue];
        [dateFormatter release];
        
        if (form < to) {//9-11点
            if (time>=form && time<to) {//勿扰时段   11-24｜0-9 可扰 9-11勿扰
            }else{
                if ([defaults boolForKey:USER_NOTICE_VOICE_STAUTS] && [defaults boolForKey:USER_NOTICE_VIBRATE_STATUS]) {
                    [ToolHelper playVibrateAndNoticeAlertSound];
                }else if([defaults boolForKey:USER_NOTICE_VOICE_STAUTS]){
                    [ToolHelper playNoticeAlertSound];
                }else if([defaults boolForKey:USER_NOTICE_VIBRATE_STATUS]){
                    [ToolHelper playVibrateSound];
                }
            }
        }else {//11-9点
            if (time<form && time>=to) { //勿扰时段   11-24｜0-9 勿扰  9-11可扰
                if ([defaults boolForKey:USER_NOTICE_VOICE_STAUTS] && [defaults boolForKey:USER_NOTICE_VIBRATE_STATUS]) {
                    [ToolHelper playVibrateAndNoticeAlertSound];
                }else if([defaults boolForKey:USER_NOTICE_VOICE_STAUTS]){
                    [ToolHelper playNoticeAlertSound];
                }else if([defaults boolForKey:USER_NOTICE_VIBRATE_STATUS]){
                    [ToolHelper playVibrateSound];
                }
            }
        }
    }
}
#endif

//字符串判空
+(BOOL) isBlankString:(NSString *)string {
    
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([string isEqual:[NSNull null]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    //    if (string.length==0) {
    //        return YES;
    //    }
    return NO;
}

+ (int)textLength:(NSString *)text//计算字符串长度
{
    float number = 0.0;
    for (int index = 0; index < [text length]; index++)
    {
        NSString *character = [text substringWithRange:NSMakeRange(index, 1)];
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3) {
            number++;
        } else {
            number = number + 0.5;
        }
    }
    return ceil(number);
}
#pragma mark - 判断字符串中是否存emoji在表情
+ (BOOL)judgeEmoji:(NSString *)text
{
    __block BOOL isEomji = NO;
    [text enumerateSubstringsInRange:NSMakeRange(0, [text length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     isEomji = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 isEomji = YES;
             }
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 isEomji = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 isEomji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 isEomji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 isEomji = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 isEomji = YES;
             }
         }
     }];
    return isEomji;
}

+ (UIImage *)imageToExtent:(UIImage *)img  withTop:(CGFloat) top withBottom:(CGFloat) bottom
                  withLeft:(CGFloat) left withRight:(CGFloat) right{
    if ([img respondsToSelector:@selector(resizableImageWithCapInsets:resizingMode:)]) {
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        // 指定为拉伸模式，伸缩后重新赋值
        img = [img resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        
    }
    return img;
}

//_imageSize 为CGSizeZero时,原图大小
//图片压缩比_size小
//写入到 tmp 文件夹中
//返回图片路径
+(NSString *) image:(UIImage *)_img changeToSize:(CGSize)_imageSize size:(int)_size
{
    NSString *tmpDic = NSTemporaryDirectory();
    
    //以时间命名图片
    NSDate *date = [NSDate date];
    NSDateFormatter *formatDate = [[NSDateFormatter alloc] init] ;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ;
    [formatDate setLocale:locale];
    [formatDate setDateFormat:@"yyyyMMddHHmmss"];
    NSString* dateStr = [formatDate stringFromDate:date];
    
    NSString *imagelocalName_s = [NSString stringWithFormat:@"%@_s.jpg", dateStr];
    
    NSString *_image_Path  =  [tmpDic stringByAppendingPathComponent:imagelocalName_s];
    
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    
    CGFloat image_small_v = 1.0;
    
    if (CGSizeEqualToSize(_imageSize,CGSizeZero)) {
        
        if (_img.size.width>120 || _img.size.height > 120) {
            image_small_v = 0.6f;
        }
        
        NSData *imageData = UIImageJPEGRepresentation(_img, image_small_v);
        
        if (imageData.length>668328 && imageData.length<=868328) {
            image_small_v = 0.1;
        }else if(imageData.length>868328){
            image_small_v = 0.01;
        }else if (imageData.length<=668328 && imageData.length>468328){
            image_small_v = 0.3;
        } else if(imageData.length<468328 && imageData.length > 330844 ){
            image_small_v = 0.4;
        }
        while (imageData.length > _size  && image_small_v >=0.001f) {
            NSLog(@"imagesize: %lu, %f",(unsigned long)imageData.length,image_small_v);
            imageData =  UIImageJPEGRepresentation(_img, image_small_v);
            image_small_v -= 0.1f;
        }
        [imageData writeToFile:_image_Path atomically:YES];
        
    }else{
        
        UIImage *_image_s = [ToolHelper imageByScalingAndCroppingForSize:_imageSize image:_img];
        
        NSData *imageData = UIImageJPEGRepresentation(_image_s, image_small_v);
        
        while (imageData.length > _size  && image_small_v >0.01f) {
            image_small_v -= 0.1f;
            if (image_small_v<0.001f) {
                image_small_v = 0.001f;
            }
            imageData =  UIImageJPEGRepresentation(_image_s, image_small_v);
        }
        
        [imageData writeToFile:_image_Path atomically:YES];
    }
    //    });
    return _image_Path;
}


+(NSString*)superImageManage:(UIView*)theView
{
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, theView.opaque, 0.0);

    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    

    FileManager * fileManager = [[FileManager alloc] init];
    NSString * path = [fileManager getDocumentDirectory];
    NSString *tmpDic = [path stringByAppendingPathComponent:@"tuwen"];
    
    NSFileManager* fm=[NSFileManager defaultManager];
    if (![fm fileExistsAtPath:tmpDic]) {
        [fm createDirectoryAtPath:tmpDic withIntermediateDirectories:YES attributes:nil error:nil];
    }

    NSDate *date = [NSDate date];
    NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatDate setLocale:locale];
    [formatDate setDateFormat:@"yyyyMMddHHmmss"];
    NSString* dateStr = [formatDate stringFromDate:date];
    NSString *imagelocalName_s = [NSString stringWithFormat:@"%@_s.jpg", dateStr];
    NSString *_image_Path=[tmpDic stringByAppendingPathComponent:imagelocalName_s];
    
    NSData *pressSizeData = UIImageJPEGRepresentation(theImage, 1.0);
    
    float dataLength = 0.0;//倒数第二次压缩长度
    float compressQuality = 1.0;//压缩强度
    while (pressSizeData.length>100.0f*1024) {
        //不再压缩，退出
        if (dataLength==pressSizeData.length) {
            break;
        }
        dataLength = pressSizeData.length;
        compressQuality = compressQuality-0.1;
        pressSizeData = UIImageJPEGRepresentation(theImage, compressQuality);
        [NSThread sleepForTimeInterval:0.001];
    }

    [pressSizeData writeToFile:_image_Path atomically:YES];
    
    return _image_Path;
}



+(NSString *) imageToPost:(UIImage *)_img imagePlanSize:(CGFloat)_imagePlanSize imageContentSize:(int)_contentSize
{
    if (_imagePlanSize < 0.000001) {
        return nil;
    }
    
    NSString *tmpDic = NSTemporaryDirectory();
    
    //以时间命名图片
    NSDate *date = [NSDate date];
    NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatDate setLocale:locale];
    [formatDate setDateFormat:@"yyyyMMddHHmmss"];
    NSString* dateStr = [formatDate stringFromDate:date];
    
    NSString *imagelocalName_s = [NSString stringWithFormat:@"%@_s.jpg", dateStr];
    
    NSString *_image_Path  =  [tmpDic stringByAppendingPathComponent:imagelocalName_s];
    
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    
    CGFloat image_small_v = 0.8;
    UIImage *_image_s =  nil;
    
    if (_img.size.height*_img.size.width < _imagePlanSize) {//518400.0f = 720*720
        _image_s = _img;
    }else {
        
        CGSize _imageSize = CGSizeMake(720, 720);
        CGFloat lv = sqrt(_img.size.width*_img.size.height/_imagePlanSize);
        _imageSize.width = _img.size.width/lv ;
        _imageSize.height = _img.size.height/lv ;
        
        UIGraphicsBeginImageContext(_imageSize); // this will crop
        CGRect thumbnailRect = CGRectZero;
        thumbnailRect.origin = CGPointMake(0, 0);
        thumbnailRect.size.width= _imageSize.width + 10;
        thumbnailRect.size.height = _imageSize.height + 10;
        [_img drawInRect:thumbnailRect];
        _image_s = UIGraphicsGetImageFromCurrentImageContext();
        if(_image_s == nil)
            NSLog(@"could not scale image");
        //pop the context to get back to the default
        UIGraphicsEndImageContext();
    }
    NSData *imageData = UIImageJPEGRepresentation(_image_s, image_small_v);
    while (imageData.length > _contentSize  && image_small_v >0.01f) {
        CGFloat s = ((imageData.length/_contentSize) - 1.0f);
        if (s < 0.1f) {
            s = 0.1f;
        }else if( s < 0.5f && s > 0.1f){
            s = 0.2f;
        }else if( s > 0.5f && s < 1.0f){
            s = 0.4f;
        }else if(s > 1.0f){
            s = 0.6f;
        }
        image_small_v -= s;
        if (image_small_v < 0.001f) {
            image_small_v = 0.001f;
        }
        imageData =  UIImageJPEGRepresentation(_image_s, image_small_v);
    }
    [imageData writeToFile:_image_Path atomically:YES];
    
    return _image_Path;
}

+(UIImage *)imageToPost:(UIImage *)img imageContentSize:(int)contentSize{
    CGFloat image_small_v = 0.8;
    NSData *imageData = UIImageJPEGRepresentation(img, image_small_v);
    while (imageData.length > contentSize  && image_small_v >0.01f) {
        CGFloat s = ((imageData.length/contentSize) - 1.0f);
        if (s < 0.1f) {
            s = 0.1f;
        }else if( s < 0.5f && s > 0.1f){
            s = 0.2f;
        }else if( s > 0.5f && s < 1.0f){
            s = 0.4f;
        }else if(s > 1.0f){
            s = 0.6f;
        }
        image_small_v -= s;
        if (image_small_v < 0.001f) {
            image_small_v = 0.001f;
        }
        imageData =  UIImageJPEGRepresentation(img, image_small_v);
        
    }
    
    return [UIImage imageWithData:imageData];
    
}
+(NSString *)imageNewMethodToMake:(UIImage *)_img{
    
    if (_img == nil || _img == NULL) {
        return nil;
    }
    NSString *tmpDic = NSTemporaryDirectory();
    
    //以时间命名图片
    NSDate *date = [NSDate date];
    NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatDate setLocale:locale];
    [formatDate setDateFormat:@"yyyyMMddHHmmss"];
    NSString* dateStr = [formatDate stringFromDate:date];
    
    NSString *imagelocalName_s = [NSString stringWithFormat:@"%@_s.jpg", dateStr];
    
    NSString *_image_Path  =  [tmpDic stringByAppendingPathComponent:imagelocalName_s];
    
    if (_img.size.width > 640.0f) {
        
        CGSize size = CGSizeMake(640.0f, (_img.size.height/(_img.size.width/640.0f)));
        
        UIGraphicsBeginImageContext(size); // this will crop
        CGRect thumbnailRect = CGRectZero;
        thumbnailRect.origin = CGPointMake(0, 0);
        thumbnailRect.size.width= size.width + 10;
        thumbnailRect.size.height = size.height + 10;
        [_img drawInRect:thumbnailRect];
        UIImage *_image_s = UIGraphicsGetImageFromCurrentImageContext();
        if(_image_s == nil)
            NSLog(@"could not scale image");
        //pop the context to get back to the default
        UIGraphicsEndImageContext();
    }
    NSData *imageData = UIImageJPEGRepresentation(_img, 1.0);
    if (imageData.length > 80*1024) {
        NSData *imageData_S = UIImageJPEGRepresentation(_img, 0.3);
        [imageData_S writeToFile:_image_Path atomically:YES];
    }else{
        [imageData writeToFile:_image_Path atomically:YES];
    }
    return _image_Path;
}

+ (NSString *)fileOfImage:(UIImage *)image
{
    NSString *tmpDic = NSTemporaryDirectory();
    NSDate *date = [NSDate date];
    NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatDate setLocale:locale];
    [formatDate setDateFormat:@"yyyyMMddHHmmss"];
    NSString* dateStr = [formatDate stringFromDate:date];
    NSString *imagelocalName_s = [NSString stringWithFormat:@"%@_s.jpg", dateStr];
    NSString *_image_Path=[tmpDic stringByAppendingPathComponent:imagelocalName_s];
    NSData *imageDataJPG = UIImageJPEGRepresentation(image, 1.0);
    [imageDataJPG writeToFile:_image_Path atomically:YES];
    return _image_Path;
}
+ (NSString *)fileOfPressedImage:(UIImage *)image{
    NSString *tmpDic = NSTemporaryDirectory();
    NSDate *date = [NSDate date];
    NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatDate setLocale:locale];
    [formatDate setDateFormat:@"yyyyMMddHHmmss"];
    NSString* dateStr = [formatDate stringFromDate:date];
    NSString *imagelocalName_s = [NSString stringWithFormat:@"%@_s.jpg", dateStr];
    NSString *_image_Path=[tmpDic stringByAppendingPathComponent:imagelocalName_s];
    
    CGSize imageSize = image.size;
    if (imageSize.width>640) {
        imageSize.height = imageSize.height/(imageSize.width/640);
        imageSize.width = 640;
        UIGraphicsBeginImageContext(imageSize);
        [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSData *pressSizeData = UIImageJPEGRepresentation(image, 0.9);
        if (pressSizeData.length>80*1024){
            pressSizeData = UIImageJPEGRepresentation(scaledImage, 0.3);
        }
        [pressSizeData writeToFile:_image_Path atomically:YES];
        return _image_Path;
    }
    NSData *pressSizeData = UIImageJPEGRepresentation(image, 0.9);
    if (pressSizeData.length>80*1024){
        pressSizeData = UIImageJPEGRepresentation(image, 0.3);
    }
    [pressSizeData writeToFile:_image_Path atomically:YES];
    
    return _image_Path;
}

//白色填充
+ (NSString *)fileOfImgInSquareFillBlankWithWhiteBgAndPressedImage:(UIImage *)image
{
    NSLog(@"%@", NSStringFromCGSize(image.size));
    NSString *tmpDic = NSTemporaryDirectory();
    NSDate *date = [NSDate date];
    NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatDate setLocale:locale];
    [formatDate setDateFormat:@"yyyyMMddHHmmss"];
    NSString* dateStr = [formatDate stringFromDate:date];
    NSString *imagelocalName_s = [NSString stringWithFormat:@"%@_s.jpg", dateStr];
    NSString *_image_Path=[tmpDic stringByAppendingPathComponent:imagelocalName_s];
    
    CGSize imageSize;
    imageSize.height = kFullScreenWidth;
    imageSize.width = kFullScreenWidth;
    
    UIGraphicsBeginImageContext(imageSize);
    UIBezierPath* p = [UIBezierPath bezierPathWithRect:CGRectMake(0,0,kFullScreenWidth,kFullScreenWidth)];
    [[UIColor whiteColor] setFill];
    [p fill];
    
    NSLog(@"%f,%f",kFullScreenSize.width,kFullScreenSize.height);
    
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    UIImage *imageHavePress = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *pressSizeData = UIImageJPEGRepresentation(imageHavePress, 1.0);
    NSLog(@"%f", pressSizeData.length / 1024.0);
   [pressSizeData writeToFile:_image_Path atomically:YES];
    
    return _image_Path;
    
}
//将图像的中心放在正方形区域的中心，图形未填充的区域用黑色填充，并压缩到80－100k，
+ (NSString *)fileOfImgInSquareFillBlankWithBlackBgAndPressedImage:(UIImage *)image{
    NSLog(@"%@", NSStringFromCGSize(image.size));
    NSString *tmpDic = NSTemporaryDirectory();
    NSDate *date = [NSDate date];
    NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatDate setLocale:locale];
    [formatDate setDateFormat:@"yyyyMMddHHmmss"];
    NSString* dateStr = [formatDate stringFromDate:date];
    NSString *imagelocalName_s = [NSString stringWithFormat:@"%@_s.jpg", dateStr];
    NSString *_image_Path=[tmpDic stringByAppendingPathComponent:imagelocalName_s];
    
    CGSize imageSize;
    imageSize.height = kFullScreenWidth;
    imageSize.width = kFullScreenWidth;
    
    UIGraphicsBeginImageContext(imageSize);
    UIBezierPath* p = [UIBezierPath bezierPathWithRect:CGRectMake(0,0,kFullScreenWidth,kFullScreenWidth)];
    [[UIColor blackColor] setFill];
    [p fill];
    
    //    CGFloat xOriginImgInRect = 0.0;
    //    CGFloat yOriginImgInRect = 0.0;
    //    xOriginImgInRect = (kFullScreenWidth-image.size.width/2)/2;
    //    if (xOriginImgInRect<0.0) {
    //        xOriginImgInRect = 0.0;
    //    }
    //    yOriginImgInRect = (kFullScreenWidth-image.size.height/2)/2;
    //    if (yOriginImgInRect<0.0) {
    //        yOriginImgInRect = 0.0;
    //    }
    
    NSLog(@"%f,%f",kFullScreenSize.width,kFullScreenSize.height);
    
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    UIImage *imageHavePress = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *pressSizeData = UIImageJPEGRepresentation(imageHavePress, 1.0);
    if (pressSizeData.length>80*1024){
        pressSizeData = UIImageJPEGRepresentation(imageHavePress, 0.8);
    }
    [pressSizeData writeToFile:_image_Path atomically:YES];
    
    return _image_Path;
    
    //
    //    NSInteger ratioScale = 1;
    //    while (pressSizeData.length>100*1024) {
    //        ratioScale++;
    //        if (ratioScale==10) {
    //            pressSizeData = UIImageJPEGRepresentation(imageHavePress, 0.05);
    //            break;
    //        }else{
    //            pressSizeData = UIImageJPEGRepresentation(imageHavePress, 1-ratioScale*0.1);
    //        }
    //    }
    //
    //    [pressSizeData writeToFile:_image_Path atomically:YES];
    //    [formatDate release];
    //    [locale release];
    //
    //    return _image_Path;
}

+ (NSString *)fileOfImageData:(NSData *)imageData
{
    NSString *tmpDic = NSTemporaryDirectory();
    NSDate *date = [NSDate date];
    NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatDate setLocale:locale];
    [formatDate setDateFormat:@"yyyyMMddHHmmss"];
    NSString* dateStr = [formatDate stringFromDate:date];
    NSString *imagelocalName_s = [NSString stringWithFormat:@"%@_s.jpg", dateStr];
    NSString *_image_Path=[tmpDic stringByAppendingPathComponent:imagelocalName_s];
    [imageData writeToFile:_image_Path atomically:YES];
    return _image_Path;
}
+(NSString *) age:(NSString *)_birthday
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *_date= [dateFormat dateFromString:_birthday];
    [dateFormat setDateFormat:@"yyyy"];
    NSString *birthYear = [dateFormat stringFromDate:_date];
    NSDate *current = [NSDate date];
    NSString *currentYear = [dateFormat stringFromDate:current];
    [dateFormat setDateFormat:@"MM"];
    NSString *birthMonth = [dateFormat stringFromDate:_date];
    NSString *currentMonth = [dateFormat stringFromDate:current];
    [dateFormat setDateFormat:@"dd"];
    NSString *birthDay = [dateFormat stringFromDate:_date];
    NSString *currentDay = [dateFormat stringFromDate:current];
    
    int aboutAge = [currentYear intValue]-[birthYear intValue];
    if (aboutAge>0) {
        if ([birthMonth intValue]>[currentMonth intValue]) {
            aboutAge--;
        }else if ([birthDay intValue]>[currentDay intValue] && [birthMonth intValue]==[currentMonth intValue]){
            aboutAge--;
        }
    }
    NSString *age = [NSString stringWithFormat:@"%d",aboutAge];
    return age;
}
+(NSString *) xingzuoToString:(NSString *)_str{
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *_date= [dateFormat dateFromString:_str];
    
    NSString *_xingzuo = [ToolHelper xingzuoToDate:_date];
    
    return _xingzuo;
}
+(NSString *) xingzuoToDate:(NSDate *)_date{
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"MMdd"];
    
    NSString *timeString= [dateFormat stringFromDate:_date];
    
    long _month = [[timeString substringToIndex:2] integerValue];
    long _day = [[timeString substringFromIndex:2] integerValue];
    
    NSString *_xingzuo = @"";
    
    switch (_month) {
        case 1: {
            if (_day <=19) {
                _xingzuo =  @"摩羯座";
            }else{
                _xingzuo = @"水瓶座";
            } }
            break;
        case 2:{
            if (_day <=18) {
                _xingzuo =  @"水瓶座";
            }else{
                _xingzuo = @"双鱼座";
            } }
            break;
        case 3:{
            if (_day <=20) {
                _xingzuo =  @"双鱼座";
            }else{
                _xingzuo = @"白羊座";
            } }
            break;
        case 4:{
            if (_day <=19) {
                _xingzuo =  @"白羊座";
            }else{
                _xingzuo = @"金牛座";
            } }
            break;
        case 5:{
            if (_day <=20) {
                _xingzuo =  @"金牛座";
            }else{
                _xingzuo = @"双子座";
            } }
            break;
        case 6:{
            if (_day <=21) {
                _xingzuo =  @"双子座";
            }else{
                _xingzuo = @"巨蟹座";
            } }
            break;
        case 7:{
            if (_day <=22) {
                _xingzuo =  @"巨蟹座";
            }else{
                _xingzuo = @"狮子座";
            } }
            
            break;
        case 8:{
            if (_day <=22) {
                _xingzuo =  @"狮子座";
            }else{
                _xingzuo = @"处女座";
            } }
            break;
        case 9:{
            if (_day <=22) {
                _xingzuo =  @"处女座";
            }else{
                _xingzuo = @"天枰座";
            } }
            break;
        case 10:{
            if (_day <=23) {
                _xingzuo =  @"天枰座";
            }else{
                _xingzuo = @"天蝎座";
            } }
            break;
        case 11:{
            if (_day <=22) {
                _xingzuo =  @"天蝎座";
            }else{
                _xingzuo = @"射手座";
            } }
            break;
        case 12:{
            if (_day <=21) {
                _xingzuo =  @"射手座";
            }else{
                _xingzuo = @"摩羯座";
            } }
            break;
        default:
            break;
    }
    return _xingzuo;
}

//创建路径文件夹
+(BOOL) createFolderByPath:(NSString *)_folderPath
{
    NSFileManager * _fileManager = FILE_MANAGER;
    
    if(![_fileManager fileExistsAtPath:_folderPath])
    {
        return [_fileManager createDirectoryAtPath:_folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return YES;
}

//读取文件路径
+(NSString *)getConfigFile:(NSString *)fileName
{
    //读取documents路径:
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);//得到documents的路径，为当前应用程序独享
    NSString *documentD = [paths objectAtIndex:0];
    NSString *configFile = [documentD stringByAppendingPathComponent:fileName]; //得到documents目录下fileName文件的路径
    return configFile;
}

//获取app自带资源路径
+ (NSString*) pathForResource:(NSString*)resourcepath
{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    path = [path stringByAppendingPathComponent:resourcepath];
    return path;
}
//计算文件大小
+(NSString *)getFileSizeWithPath:(NSString *)fileURLString{
    NSString *size;
    @try {
        if (nil == fileURLString) {
            return nil;
        }
        NSError *error;
        //文件
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fileURLString error:&error];
        //大小
        NSInteger fileSize = [[fileAttributes objectForKey:NSFileSize] intValue];
        //文本描述
        size = [NSString stringWithFormat:@"%@",[self formattedFileSize:fileSize]];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        return size;
    }
}
//计算大小算法（以bytes、KB、MB、GB）结尾 ，增强可读性
+ (NSString *)formattedFileSize:(unsigned long long)size
{
    
    NSString *formattedStr = nil;
    @try {
        if (size == 0)
            formattedStr = @"Empty";
        else
            if (size > 0 && size < 1024)
                formattedStr = [NSString stringWithFormat:@"%qu bytes", size];
            else
                if (size >= 1024 && size < pow(1024, 2))
                    formattedStr = [NSString stringWithFormat:@"%.1f KB", (size / 1024.)];
                else
                    if (size >= pow(1024, 2) && size < pow(1024, 3))
                        formattedStr = [NSString stringWithFormat:@"%.2f MB", (size / pow(1024, 2))];
                    else
                        if (size >= pow(1024, 3))
                            formattedStr = [NSString stringWithFormat:@"%.3f GB", (size / pow(1024, 3))];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        return formattedStr;
    }
    
}


#if 0
+ (void)updateSoftwareWithLoading:(BOOL)loading withResult:(CheckVersionCallBack)callBack
{
    DLog(@"检查更新中......");
    if (loading) {
        [MBProgressHUD showInScreen:YES];
    }
    NSMutableDictionary *_dic = [NSMutableDictionary dictionary];
    [_dic setObject:[defaults objectForKey:USER_ID] forKey:@"userId"];
    
    [_dic setObject:@"ios" forKey:@"app_type"];
    [_dic setObject:@"241" forKey:@"version"];
    [_dic setObject:@"xsq" forKey:@"product"];
    if ([defaults objectForKey:USCHOOL_ID]) {
        [_dic setObject:[defaults objectForKey:USCHOOL_ID] forKey:@"schoolId"];
    }
    MKNetworkEngine *engine = [NetworkEngine shareVersionEngine];
    MKNetworkOperation *op = [engine operationWithPath:pUpdateSoftware params:_dic httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        DLog(@"[completedOperation responseString]-->%@",[completedOperation responseString]);
        callBack([completedOperation responseString]);
        if (loading) {
            [MBProgressHUD disappearFromScreen];
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        if (loading) {
            [OMGToast showWithText:@"网络请求失败，请稍后重试" topOffset:kTipsTopOffset duration:2.0];
            [MBProgressHUD disappearFromScreen];
        }
    }];
    [engine enqueueOperation:op];
}
#endif
#if 0
+ (BOOL)locationServiceEnable{
    return  [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied;
    
    //    if ([MyCLController sharedInstance].locationManager.locationServicesEnabled==FALSE) ｛//dosomething;｝
    //        来判断定位服务的设置是否开启，现在问题又来了，
    //        就是如何才能在自己的程序里跳转到 “设置”－>“定位服务”的那个系统页面呢？
    //
    //    - (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
    //    {
    //        if (error.code == kCLErrorDenied){
    //            // User denied access to location service
    //        }
    //    }
    //    // ios 5.0及其一下版本，可以直接跳转到设置界面进行定位设置
    //    NSURL*url=[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
    //    [[UIApplication sharedApplication] openURL:url];
}
#endif
#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"0x"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

/**
 *  截图
 *
 *  @param theView 所截图像所在view
 *  @param r       截图范围
 *
 *  @return 所得图片
 */
+ (UIImage *)imageFromView: (UIView *)theView atFrame:(CGRect)r
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(r);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"%@", NSStringFromCGSize(theImage.size));
    
    //    2、生成指定大小图片
//    CGFloat height = 0;
//    if (iOS7OrLater) {
//        height = 20;
//    }
    //        CGSize size = {kScreenWidth, (667 + 44 + height) * (kScreenWidth / 375)};
    CGSize size = {kScreenWidth,kScreenHeight};
    UIGraphicsBeginImageContext(size);
    CGRect rect = {{0,0}, size};
    [theImage drawInRect:rect];
    UIImage *compressedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"%@", NSStringFromCGSize(compressedImg.size));
    
    return compressedImg;


    
}
 //获取裁剪图片
+ (UIImage *)imageViewFromView:(UIView *)imageView atFrame:(CGRect)rect
{
   // UIGraphicsBeginImageContext(imageView.frame.size);
    UIGraphicsBeginImageContextWithOptions(imageView.frame.size, YES, 0);
    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"%@", NSStringFromCGSize(newImg.size));
    
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(newImg.CGImage, rect);
    UIImage * compressedImg = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return compressedImg;

}

#pragma mark private method
//方形裁剪
+(UIImage *)getClipImageWithOrigRect:(CGRect)origRect ClipRect:(CGRect)clipRect scale:(CGFloat)scale imageRef:(CGImageRef)imageRef
{

    UIGraphicsBeginImageContext(clipRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, clipRect, imageRef);
    UIImage * clipImage = [UIImage imageWithCGImage:imageRef scale:1./scale/[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp];
    UIGraphicsEndImageContext();
    CFRelease(imageRef);
    return clipImage;
    //    return  [self CircularClipImage:clipImage];
    
}


+(NSString *)getCompressImgPathOfOldSize:(UIImage*)image
{
    FileManager * fileManager = [[FileManager alloc] init];
    NSString * path = [fileManager getDocumentDirectory];
    NSString *tmpDic = [path stringByAppendingPathComponent:@"tuwen"];
    
    NSFileManager* fm=[NSFileManager defaultManager];
    if (![fm fileExistsAtPath:tmpDic]) {
        [fm createDirectoryAtPath:tmpDic withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatDate setLocale:locale];
    [formatDate setDateFormat:@"yyyyMMddHHmmss"];
    NSString* dateStr = [formatDate stringFromDate:date];
    NSString *imagelocalName_s = [NSString stringWithFormat:@"%@_s.jpg", dateStr];
    NSString *_image_Path=[tmpDic stringByAppendingPathComponent:imagelocalName_s];

    
    float dataLength = 0.0;//倒数第二次压缩长度
    float compressQuality = 1.0;//压缩强度
    NSData * pressSizeData = UIImageJPEGRepresentation(image, compressQuality);

    while (pressSizeData.length>100.0f*1024) {
        //不再压缩，退出
        if (dataLength==pressSizeData.length) {
            break;
        }
        dataLength = pressSizeData.length;
        compressQuality = compressQuality-0.1;
        pressSizeData = UIImageJPEGRepresentation(image, compressQuality);
        [NSThread sleepForTimeInterval:0.001];
    }
    
    [pressSizeData writeToFile:_image_Path atomically:YES];
    
    return _image_Path;

}

/**
 * 获取分辨率
 */
+ (NSDictionary *) getScreenResolution {
    
    
    CGRect rect_screen = [[UIScreen mainScreen]bounds];
    
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    
    CGSize size_screen = rect_screen.size;
    float width = size_screen.width * scale_screen;
    float height = size_screen.height * scale_screen;
    int iWidth = (int)floorf(width);
    int iHeight = (int)floorf(height);
    NSString *strWidth =[NSString stringWithFormat:@"%d",iWidth];
    NSString *strHeight =[NSString stringWithFormat:@"%d",iHeight];
    //顺序添加对象和键值来创建一个字典，注意结尾是nil
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:strWidth,@"width",strHeight,@"height",nil];
    return dictionary;
}
/**
 * 判断指定的内容是否是数字
 */
+ (BOOL) isNumber:(NSString *)strNumber {
    BOOL bRet = NO;
    NSString *NUMBERS = @"0123456789\n";
    NSCharacterSet *cs;
    NSString *filtered=nil;
    if (nil == strNumber || [strNumber length] == 0) {
        return bRet;
    }
    // 返回一个字符集包含一个给定的字符串中的字符
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    //将字符串拆分
    filtered = [[strNumber componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    bRet = [strNumber isEqualToString:filtered];
    return bRet;
}

/**
 *  字典转换字符串
 */

+(NSString *)lxlcustomDictionaryToString:(id)dic{
    NSError *dataParseErr=nil;
    if (dic && ![dic isKindOfClass:[NSNull class]]) {
        return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&dataParseErr] encoding:NSUTF8StringEncoding];
    }else{
        return @"";
    }
    
}

/**
 *  返回值的含义：
 *      100 表示 大于10s 101表示大于1天  102表示大于3天   103表示大于5天
 *      104 表示 大于10天    105表示大于20天  106表示大于30天  10000表示nil
 *      以上表示 大于10s、大于30天已经实现，其它目前没有扩展
 */
+(NSString *)getTimeRange:(id)timeParameter{
    BOOL bRet=NO;
    NSString *bRetStr;
    //当前时间
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[NSDate date];
    NSTimeZone *timeZone=[NSTimeZone systemTimeZone];
    NSInteger index=[timeZone secondsFromGMTForDate:date];
    NSDate *today=[date dateByAddingTimeInterval:index];
    NSDate *beforeDate=nil;
    NSDate *currentDate=nil;
//    传入时间
    if ([timeParameter isKindOfClass:[NSString class]]) {
        
        beforeDate=[dateFormatter dateFromString:timeParameter];
        
        if (!timeParameter) {
            bRet=NO;
            bRetStr=@"10000";
        }else{
            if ([timeParameter isEqualToString:@""]) {
                NSLog(@"time0:%@",[defaults objectForKey:currentNowTime]);
                NSString *str=[NSString stringWithFormat:@"%@",[defaults objectForKey:currentNowTime]];
                if (!str) {
                    return  bRetStr=@"10000";
                }
                NSArray *arr=[str componentsSeparatedByString:@" "];
                NSMutableString *strstr=[[NSMutableString alloc] init];
                for (int i=0;i<[arr count]-1;i++) {
                    if (i%2) {
                        [strstr appendString:@" "];
                        [strstr appendString:arr[i]];
                    }else{
                        [strstr appendString:arr[i]];
                    }
                }
                
                currentDate=[dateFormatter dateFromString:strstr];
                NSInteger index=[timeZone secondsFromGMTForDate:currentDate];
                NSDate *newDate=[currentDate dateByAddingTimeInterval:index];
                
                
                NSTimeInterval timeInt=[today timeIntervalSinceDate:newDate];
                NSString *todayStr=[NSString stringWithFormat:@"%@",today];
                [defaults setObject:todayStr forKey:currentNowTime];
                NSLog(@"time1:%@",[defaults objectForKey:currentNowTime]);
                if (timeInt>10.0) {
                    bRetStr=@"100";
                }else{
                    bRetStr=@"10000";
                }
                NSLog(@"timeInt vlaue is %f",timeInt);
            }else{
                NSTimeInterval timeInt=[today timeIntervalSinceDate:beforeDate];
                
                double dayNumbers=timeInt/(24*60*60);
                NSLog(@"间隔天数：%f",dayNumbers);
                if (dayNumbers >DAYNUMBERS) {
                    bRet=YES;
                    bRetStr=@"106";
                }else{
                    bRet=NO;
                    bRetStr=@"10000";
                }
            }
        }
    }
    else {
        bRetStr=@"10000";
    }
    
    
    return bRetStr;
    
}


- (NSString*)getIp:(NSString*)address
{
    if ([address hasPrefix:@"http://"]) {
        
        address = [address substringFromIndex:[@"http://" length]];
    }
    NSRange range = [address rangeOfString:@":" options:NSBackwardsSearch];
    
    if (range.length==0) {
        return address;
    }else{
        
        if (range.location < 5) {
            NSLog(@"Error Alive Address:%@",address);
            return address;
        }else{
            return [address substringToIndex:range.location];
        }
    }
}

- (NSString*)getPort:(NSString*)address
{
    NSRange range = [address rangeOfString:@":" options:NSBackwardsSearch];
    if (range.location < 5) {
        NSLog(@"Error Alive Address:%@", address);
        address=@"80";
        return address;
    }else{
        
        return [address substringFromIndex:range.location + 1];
    }
}
#pragma mark 获取应用内存情况
// 获取当前设备可用内存(单位：MB）
+ (double)getFacilityAvailableMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0+((vm_page_size *vmStats.inactive_count) / 1024.0) / 1024.0;
//    struct statfs buf;
//    long long freespace = -1;
//    if(statfs("/var", &buf) >= 0){
//        freespace = (long long)(buf.f_bsize * buf.f_bfree);
//    }
//    return freespace/1024/1024;
}

// 获取当前任务所占用的内存（单位：MB）
+ (double)usedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

/**
 * 字符串转换成字典
 */
+(NSMutableDictionary *)lxlcustomDataToDic:(id)dic{
    NSData *data=nil;
    
    if (!dic) {
        return nil;
    }
    
    if ([dic isKindOfClass:[NSData class]]) {
        data=dic;
    }else if([dic isKindOfClass:[NSString class]]){
        data=[dic dataUsingEncoding:NSUTF8StringEncoding];

    }else{
        
        return nil;
        
    }
    
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

}

//MD5加密
+ (NSString *)MD5ByAStr:(NSString *)aSourceStr{
    const char* cStr = [aSourceStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (NSInteger i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x", result[i]];
    }
    
    return ret;
}

//获取当前应用的版本号
+(NSString *)getAppVersion
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];      //获取项目版本号
    return version;
}

/****************随机数**************/
//获取一个随机数范围在：[500,1000），包括500，包括1000
+(NSString *)getRandom
{
    int y = (arc4random() % 501) + 500;
    return [NSString stringWithFormat:@"%d", y];
}


//密码判断
+ (BOOL)isUserPassword:(NSString *)userPwd
{
    NSString *regex = @"[a-zA-Z0-9_@]{6,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:userPwd];
}

+ (BOOL)valiMobile:(NSString *)mobile
{
    if ([[mobile substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"1"]) {
        return YES;
    }else{
        return NO;
    }
}
@end
