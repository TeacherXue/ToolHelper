# ToolHelper
本项目是一些常用的iOS开发中用到的小工具类，包括：时间、字符串、文件、图片、设备、声音、日志、等功能点，直接集成到项目即可，主要功能如下：


/* --------------------------------- 时间相关  --------------------------*/

//返回距 1970年到现在的秒数 
+(NSString *) getNowTimeWithLongType;

//返回距 1970年到现在的秒数
+(UInt64) getSecondsFromTimeString:(NSString *)_str;

//返回距 1970年到现在的秒数
+(UInt64) getSecondsFromTime:(NSDate *)_date;

//返回距 1970年到xx时间的的毫秒数
+(NSString *) getGiveTimeWithLongType:(NSDate *)timer;

//返回距 1970年到xx时间的的毫秒数
+(NSString *) getGiveTimeWithLongType1:(NSDate *)timer;

//返回1970年到当前时间的的毫秒数
+(UInt64) getCurrentMilliSecondsTime;

//获取当前年月日字符串
+(NSString *) yearMonthDayString;
/**
 * 获取几天前或几天后的日期
 * daysNum:-(24*60*60)   (24*60*60)
 */
+(NSString *) getTheDate:(DateHelperTimeTextType)type daysNum:(double)daysNum;

//毫秒转换成日期时间
+(NSDate *)longTimeChangeToDate:(NSString *)longTime;

//根据类型返回时间
+(NSString *) getNowTimeWithType:(DateHelperTimeTextType) type;

//根据类型返回时间
+(NSString *) getStringTimeWithDataTime:(NSDate*)_date;

//计算流逝的时间 参数为一个标准格式的时间字符串
+(NSString *) calulatePassTime:(NSString *) timeText;

//计算流逝的时间 参数为一个标准格式的时间字符串 2
+(NSString *) calulatePassTime2:(NSDate *)timeDate toTime:(NSDate *)timeDate2;

//计算流逝的时间 参数为一个标准格式的时间字符串 3
+(NSString *) calulatePassTime3:(NSString *) timeText;

//计算流逝的时间 参数为一个标准格式的时间字符串 5
+(NSString *) calulatePassTime5:(NSString *) timeText;

//计算流逝的时间 参数为一个标准格式的时间字符串, 和显示的位置
+(NSString *) calulatePassTime4:(NSString *) timeText Type:(DateHelperTimeForShowForm) typeForm;
//string的格式必须是 yyyy-mm-dd hh:mm:ss

//信息广场，信息广场详情的评论列表的时间显示规则
+(NSString *) caculateRuleTime:(NSString *) timeText;

+ (NSInteger)compareStartTime:(NSString *) start endTime:(NSString *)end;

+(NSString *)getCurrentTime;
/* --------------------------------- 字符串相关  --------------------------*/
//字符串判空
+(BOOL) isBlankString:(NSString *)string;

//去掉发表文字前的空格或者回车符
+(NSString *)DelbeforeBlankAndEnter:(NSString *)str1;

//去掉发表文字后的空格或者回车符
+(NSString *)DelbehindEnterAndBlank:(NSString *)str2;

//去掉发表文字前的空格或者回车符
+(NSString *)DelbeforeEnter:(NSString *)str1;

//去掉发表文字后的空格或者回车符
+(NSString *)DelbehindEnter:(NSString *)str2;

//计算字符串长度
+ (int)textLength:(NSString *)text;

// 判断字符串中是否存emoji在表情
+ (BOOL)judgeEmoji:(NSString *)text;


/* --------------------------------- 图片相关  --------------------------*/
//图片CGSize缩小放大
+ (UIImage*) imageByScalingAndCroppingForSize:(CGSize)targetSize image:(UIImage *)img;

//还原图片方向
+(UIImage *)fixOrientation:(UIImage *)aImage;
// 修改图片旋转问题
+(UIImage *)fixOrientationWithImage:(UIImage *)image;

//图片拉伸边角不变形
//top:顶端盖高度; bottom:底端盖高度; left:左端盖宽度; right:右端盖宽度
+ (UIImage *)imageToExtent:(UIImage *)img  withTop:(CGFloat) top withBottom:(CGFloat) bottom
                  withLeft:(CGFloat) left withRight:(CGFloat) right;

//_imageSize 为空时,原图大小
//图片压缩比_size小
//写入到 tmp 文件夹中
//返回图片路径 
+ (NSString *) image:(UIImage *)img changeToSize:(CGSize)_imageSize size:(int)_size;
+ (NSString *)fileOfImage:(UIImage *)image;
+ (NSString *)fileOfPressedImage:(UIImage *)image;
+ (NSString *)fileOfImageData:(NSData *)imageData;
//将图像的中心放在正方形区域的中心，图形未填充的区域用黑色填充，并压缩到小于100k（实际要求小于80-100k），
+ (NSString *)fileOfImgInSquareFillBlankWithBlackBgAndPressedImage:(UIImage *)image;
//白色填充
+ (NSString *)fileOfImgInSquareFillBlankWithWhiteBgAndPressedImage:(UIImage *)image;
//此方法还需像素px处理 取适当比列，主要解决android不奔溃问题
//_imagePlanSize 图片面积大小
//_contentSize 图片压缩后内存大小
+(NSString *) imageToPost:(UIImage *)_img imagePlanSize:(CGFloat)_imagePlanSize imageContentSize:(int)_contentSize;
//contentSize 图片压缩后的内存大小
+(UIImage *)imageToPost:(UIImage *)img imageContentSize:(int)contentSize;

+(NSString*)superImageManage:(UIView*)theView;

//新规则大图片处理方法
/*
 1、手机上传大图到服务端，处理规则：
 A、图片像素：宽度最大640，小于640的不处理；
 B、如何图片大小<80K,则不处理，否则：
 IOS 质量压缩参数 0.3，不在做递归压缩；
 ANDROID质量压缩参数 70，不在做递归压缩；
 C、图片最终多少K，不考虑。
 */
+(NSString *) imageNewMethodToMake:(UIImage *)_img;
//截图
+ (UIImage *)imageFromView: (UIView *)theView atFrame:(CGRect)r;

+(UIImage *)getClipImageWithOrigRect:(CGRect)origRect ClipRect:(CGRect)clipRect scale:(CGFloat)scale imageRef:(CGImageRef)imageRef;



+(NSString *)getCompressImgPathOfOldSize:(UIImage*)image;
/* --------------------------------- 文件操作相关  --------------------------*/
 
//创建路径文件夹
+(BOOL) createFolderByPath:(NSString *)_folderPath;
 
//获取文件路径
+(NSString *)getConfigFile:(NSString *)fileName;

//获取app自带资源路径
+ (NSString*) pathForResource:(NSString*)resourcepath;


//获取文件大小 filehelp
+(NSString *)getFileSizeWithPath:(NSString *)fileURLString;

//计算大小算法（以bytes、KB、MB、GB）结尾 ，增强可读性
+ (NSString *)formattedFileSize:(unsigned long long)size;

/* --------------------------------- 星座相关  --------------------------*/
// 输入时间必须是格式 yyyy-MM-dd 或 yyyy-MM-dd HH:mm:ss
+(NSString *) age:(NSString *)_birthday;
+(NSString *) xingzuoToString:(NSString *)_str;
+(NSString *) xingzuoToDate:(NSDate *)_date;


/* --------------------------------- 设备相关  --------------------------*/
//获取设备系统版本
+(NSString *) getSystemVersion;

//当前手机系统版本
+ (NSString *) getIOSVersion;
+ (float)getCurrentIOSVersion;
//当前手机类型
+(NSString *)getDeviceModel;

//剩余内存
+(NSUInteger) freeMemory ;  

//iphone下获取可用的内存大小
+ (NSUInteger)getAvailableMemory ;

+(NSString *)getDeviceUUID;

//获取设备名称 如：iPhone6   iPhone6s...
+(NSString*) deviceName;

//获取磁盘空间
+(NSString *)getFreeDiskSpace;
//总磁盘空间
+(NSString *)getTotalDiskSpace;


/* --------------------------------- 声音相关 ----------------------- */
//键盘音效
+(void) playKeyBordSound;

+(void) playVibrateSound;//震动

+(void) playVibrateAndNoticeAlertSound;//提醒加震动
 
+(void) playNoticeAlertSound;//消息提醒声音


//与设置模块声音/震动/活动通知 业务相关
+(void) playSettingSound;


/* --------------------------------- 日志相关  --------------------------*/
/**
 * 输出日志
 * logContents:日志内容
 */
+ (BOOL) bmsLog:(NSString *)logContents;
/*
//新加一条log
+ (void) log:(NSString*) msg;

//清除Log
+ (void) clearLog;

//将本地Log转为字符串数组
+ (NSArray*) getLogArray;
 */

/* ----------------------软件更新------------------------*/
+ (void)updateSoftwareWithLoading:(BOOL)loading withResult:(CheckVersionCallBack)callBack;


+ (BOOL)locationServiceEnable;

+ (UIColor *) colorWithHexString: (NSString *)color;

/**
 * 获取分辨率
 */
+ (NSDictionary *) getScreenResolution;
/**
 * 判断指定的内容是否是数字
 */
+ (BOOL) isNumber:(NSString *)strNumber;
/**
 * 截取图片
 */
+ (UIImage *)imageViewFromView:(UIView *)imageView atFrame:(CGRect)rect;

/**
 *  字典转换字符串
 */

+(NSString *)lxlcustomDictionaryToString:(id)dic;

/**
 *  返回值的含义：
 *      100 表示 大于10s 101表示大于1天  102表示大于3天   103表示大于5天
 *      104 表示 大于10天    105表示大于20天  106表示大于30天  10000表示nil
 */
+(NSString *)getTimeRange:(id)timeParameter;

/**
 *
 *
 * 字符串转换成字典
 */

+(NSMutableDictionary *)lxlcustomDataToDic:(id)dic;

// 获取当前设备可用内存(单位：MB）
+ (double)getFacilityAvailableMemory;
// 获取当前任务所占用的内存（单位：MB）
+ (double)usedMemory;

//MD5加密
+ (NSString *)MD5ByAStr:(NSString *)aSourceStr;

//获取当前应用的版本号
+(NSString *)getAppVersion;

/****************随机数**************/
//获取一个随机数范围在：[500,1000），包括500，包括1000
+(NSString *)getRandom;

//密码判断
+ (BOOL)isUserPassword:(NSString *)userPwd;
//对字典进行截取
+ (NSString *)dealWithHistoryModel:(NSMutableDictionary *)modelDic;
//手机号判断
+ (BOOL)valiMobile:(NSString *)mobile;
