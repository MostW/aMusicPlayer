//
//  MainPlayVC.m
//  Musicplayer7
//
//  Created by 巫永健 on 2017/12/30.
//  Copyright © 2017年 巫永健. All rights reserved.
//

#import "MainPlayVC.h"
#import "GetMusicTool.h"
#import "PlayTool.h"
#import <Accelerate/Accelerate.h>

@interface MainPlayVC () {
    NSTimer *_timer;
    BOOL _musicSlide;
}

//背景大图
@property (weak, nonatomic) IBOutlet UIImageView *backgroudImageView;
@property (weak, nonatomic) IBOutlet UIView *backgroudView;


//顶部行
@property (weak, nonatomic) IBOutlet UILabel *musicTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;

//中心图片
@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;

//收藏行
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *musicNameLabel;


//进度条
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *musicProgress;



//控制按钮
@property (weak, nonatomic) IBOutlet UIButton *musicCycleButton;
@property (weak, nonatomic) IBOutlet UIButton *previousMusicButton;
@property (weak, nonatomic) IBOutlet UIButton *musicToggleButton;
@property (weak, nonatomic) IBOutlet UIButton *nextMusicButton;
@property (weak, nonatomic) IBOutlet UIButton *otherButton;


@end

@implementation MainPlayVC

+ (instancetype)shareMainPlayVC {
    static MainPlayVC *MP = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MP = [[MainPlayVC alloc] init];
    });
    return MP;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.view.tintColor = [UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9];
    NSLog(@"index at viewdidload: %ld", (long)_index);
    [PlayTool sharePlayTool].model = [GetMusicTool shareInstace].songs[_index];
    //观察index
    [self addObserver:self forKeyPath:@"index" options:NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld context:nil];
    [[PlayTool sharePlayTool] previousMusic];
    self.albumImageView.image = [PlayTool sharePlayTool].model.musicPic;
    self.musicTitleLabel.text = [PlayTool sharePlayTool].model.musicName;
    self.musicNameLabel.text = [PlayTool sharePlayTool].model.musicSinger;
    
    self.albumImageView.layer.cornerRadius = self.albumImageView.bounds.size.height / 2;
    self.albumImageView.layer.masksToBounds = YES;
    
    
    UIImage *blurImgWithNoWhite = [self imageToTransparent:[PlayTool sharePlayTool].model.musicPic];
    UIImage *blurImg = [self blurryImage:blurImgWithNoWhite withblur:0.5];
    self.backgroudImageView.image = blurImgWithNoWhite;
    
//    CGRect frame = [[UIScreen mainScreen] bounds];
//    self.backgroudImageView.frame = frame;
    
    _musicSlide = NO;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(progressMonitor) userInfo:nil repeats:YES];
    
    __weak typeof (self) weakSelf = self;
//    [self spin:weakSelf];
}

//图片旋转
- (void)spin: (MainPlayVC *)wSelf {
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        //用这个的话只会旋转一次，因为没有设置原点
//        self.albumImageView.transform = CGAffineTransformMakeRotation(M_PI);
        wSelf.albumImageView.transform = CGAffineTransformRotate(wSelf.albumImageView.transform, M_PI);
    } completion:^(BOOL flag){
        [wSelf spin:wSelf];
    }];
}

- (void)progressMonitor {
    NSInteger currentSeconds = [PlayTool sharePlayTool].player.currentTime.value / [PlayTool sharePlayTool].player.currentTime.timescale;
    NSInteger totalSecond = [[PlayTool sharePlayTool].player.currentItem duration].value / [[PlayTool sharePlayTool].player.currentItem duration].timescale;
    self.beginTimeLabel.text = [self transformTimeFormat:currentSeconds];
    self.endTimeLabel.text = [self transformTimeFormat:totalSecond];
    //用progress view空间就用下面的方法
//    self.musicProgress.progress = (CGFloat) currentSeconds / totalSecond;
    //用slider控件
    if (!_musicSlide) {
        [self.musicProgress setValue:(CGFloat) currentSeconds / totalSecond];
    }
    
}

- (NSString *)transformTimeFormat: (NSInteger)time {
    NSInteger seconds = time % 60;
    NSInteger minutes = (time / 60) % 60;
    NSString *timeStr = [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
    return timeStr;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"index"]) {
        NSLog(@"chang: %@", change);
        if ([change[@"old"] isEqual: change[@"new"]] ) {
            return;
        }
        else {
            [PlayTool sharePlayTool].model = [GetMusicTool shareInstace].songs[_index];
            [[PlayTool sharePlayTool] previousMusic];
            self.albumImageView.image = [PlayTool sharePlayTool].model.musicPic;
            self.musicTitleLabel.text = [PlayTool sharePlayTool].model.musicName;
            self.musicNameLabel.text = [PlayTool sharePlayTool].model.musicSinger;
            
            
            UIImage *blurImgWithNoWhite = [self imageToTransparent:[PlayTool sharePlayTool].model.musicPic];
            UIImage *blurImg = [self blurryImage:blurImgWithNoWhite withblur:0.5];
            self.backgroudImageView.image = blurImgWithNoWhite;

            
        }
        
    }
}

- (IBAction)closeBtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)lastSong:(UIButton *)sender {
    self.index = _index > 0 ? (_index - 1) : ([GetMusicTool shareInstace].songs.count - 1);
}

- (IBAction)playAndPause:(UIButton *)sender {
    if ([PlayTool sharePlayTool].player.rate == 0) {
        [[PlayTool sharePlayTool].player play];
    }
    else {
        [[PlayTool sharePlayTool].player pause];
    }
}


- (IBAction)nextSong:(UIButton *)sender {
    self.index = (_index + 1) % [GetMusicTool shareInstace].songs.count;
}

//这种模糊白边太大了
//- (UIImage *)blurryImage: (UIImage *)image {
//    //CIImage,相当于UIImage,作用为获取图片资源
//    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
//    //CIFilter,高斯模糊滤镜
//    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
//    //将图片输入到滤镜中
//    [blurFilter setValue:ciImage forKey:kCIInputImageKey];
//    //设置模糊程度,默认为10,取值范围(0-100)
//    [blurFilter setValue:@(5) forKey:@"inputRadius"];
//    //将处理好的图片输出
//    CIImage *outCIImage = [blurFilter valueForKey:kCIOutputImageKey];
//    CIContext *context = [CIContext contextWithOptions:nil];
//    //获取CGImage句柄,也就是从数据流中取出图片
//    CGImageRef outCGImage = [context createCGImage:outCIImage fromRect:[outCIImage extent]];
//    //最终获取到图片
//    UIImage * blurImage = [UIImage imageWithCGImage:outCGImage];
//    //释放CGImage句柄
//    CGImageRelease(outCGImage);
//    return blurImage;
//}

/**
 * 使用vImage实现模糊效果
 */
- (UIImage *)blurryImage:(UIImage *)image withblur:(CGFloat)blur{
    
    if (blur < 0.f || blur > 1.0f) blur = 0.5f;
    
    int boxSize = (int)(blur * 100);
    boxSize -=(boxSize % 2) + 1;
    
    // 图像处理
    CGImageRef img = image.CGImage;
    
    // 输入缓存 输出缓存
    vImage_Buffer inBuffer,outBuffer;
    
    vImage_Error error;
    
    // 像素缓存
    void * pixelBuffer;
    
    //数据源提供者，Defines an opaque type that supplies Quartz with data.
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    // provider’s data.
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    //宽，高，字节/行，data
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //像数缓存，字节行*图片高
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    // 第三个中间的缓存区,抗锯齿的效果
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    //Convolves a region of interest within an ARGB8888 source image by an implicit M x N kernel that has the effect of a box filter.
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) NSLog(@"error from convolution %ld", error);
    
    //    NSLog(@"字节组成部分：%zu",CGImageGetBitsPerComponent(img));
    
    //颜色空间DeviceRGB
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //用图片创建上下文,CGImageGetBitsPerComponent(img),7,8
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(image.CGImage));
    
    //根据上下文，处理过的图片，重新组件
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage * outImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    
    //CGColorSpaceRelease(colorSpace);   //多余的释放
    
    // 释放句柄
    CGImageRelease(imageRef);
    
    return outImage;
}

//去除图片中的白色像素
- (UIImage *) imageToTransparent:(UIImage*) image

{
    // 分配内存
    
    const int imageWidth = image.size.width;
    
    const int imageHeight = image.size.height;
    
    size_t bytesPerRow = imageWidth * 4;
    
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    
    // 创建context
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    
    
    // 遍历像素
    
    int pixelNum = imageWidth * imageHeight;
    
    uint32_t* pCurPtr = rgbImageBuf;
    
    for (int i = 0; i < pixelNum; i++, pCurPtr++)
        
    {
        
        //        //去除白色...将0xFFFFFF00换成其它颜色也可以替换其他颜色。
        
        //        if ((*pCurPtr & 0xFFFFFF00) >= 0xffffff00) {
        
        //
        
        //            uint8_t* ptr = (uint8_t*)pCurPtr;
        
        //            ptr[0] = 0;
        
        //        }
        
        //接近白色
        
        //将像素点转成子节数组来表示---第一个表示透明度即ARGB这种表示方式。ptr[0]:透明度,ptr[1]:R,ptr[2]:G,ptr[3]:B
        
        //分别取出RGB值后。进行判断需不需要设成透明。
        
        uint8_t* ptr = (uint8_t*)pCurPtr;
        
        if (ptr[1] > 240 && ptr[2] > 240 && ptr[3] > 240) {
            
            //当RGB值都大于240则比较接近白色的都将透明度设为0.-----即接近白色的都设置为透明。某些白色背景具有杂质就会去不干净，用这个方法可以去干净
            
//            ptr[0] = 0;
            ptr[1] = 204;
            ptr[2] = 204;
            ptr[3] = 204;
            
        }
        
    }
    
    // 将内存转成image
    
    CGDataProviderRef dataProvider =CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, nil);
    
    
    
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight,8, 32, bytesPerRow, colorSpace,
                                        
                                        kCGImageAlphaLast |kCGBitmapByteOrder32Little, dataProvider,
                                        
                                        NULL, true,kCGRenderingIntentDefault);
    
    CGDataProviderRelease(dataProvider);
    
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    // 释放
    
    CGImageRelease(imageRef);
    
    CGContextRelease(context);
    
    CGColorSpaceRelease(colorSpace);
    
    return resultUIImage;
    
}

- (IBAction)changeMusicProgress:(id)sender {
    _musicSlide = YES;
}
- (IBAction)setMusicTime:(id)sender {
    
    CGFloat totalTime = CMTimeGetSeconds([[PlayTool sharePlayTool].player.currentItem duration]);
    NSInteger dragedSeconds = floorf(self.musicProgress.value * totalTime);
    [[PlayTool sharePlayTool].player seekToTime:CMTimeMakeWithSeconds(dragedSeconds, 1)];
    _musicSlide = NO;
    
}
- (IBAction)noChangeMusic:(id)sender {
    _musicSlide = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
