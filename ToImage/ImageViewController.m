//
//  ImageViewController.m
//  ToImage
//
//  Created by cici on 2017/7/20.
//  Copyright © 2017年 keke. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"View 保存为图片";
    self.view.backgroundColor=[UIColor whiteColor];
    
    // 因为要保存图片到系统相册，涉及到隐私，所以先在plist文件里面添加NSPhotoLibraryUsageDescription允许应用程序访问你的相册
    
    for (int i=0; i<6; i++) {
        
        UIView*vview=[[UIView alloc]initWithFrame:CGRectMake(30, 30, self.view.frame.size.width-60-i*60, self.view.frame.size.height-300-i*60)];
        
        vview.backgroundColor=[UIColor colorWithRed:(arc4random() % 256)/255.0 green:(arc4random() % 256)/255.0 blue:(arc4random() % 256)/255.0 alpha:1];
        vview.tag=100+i;
        
        if (i==0) {
            vview.frame=CGRectMake(30, 100, self.view.frame.size.width-60, self.view.frame.size.height-300);
            [self.view addSubview:vview];
        }else{
        
            //当前view放在上一个view上
            UIView*toImageView=(UIView*)[self.view viewWithTag:i-1+100];
            [toImageView addSubview:vview];
        }
           }
    
    NSArray*titleArr=@[@"全屏",@"①",@"②",@"③",@"④",@"⑤",@"⑥"];
    for (int i=0; i<7; i++) {
        
        UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(30+i*30, 70+i*30, self.view.frame.size.width-60-i*60, 30)];
        if (i==0) {
            btn.backgroundColor=[UIColor colorWithRed:(arc4random() % 256)/255.0 green:(arc4random() % 256)/255.0 blue:(arc4random() % 256)/255.0 alpha:1];
        }else{
            btn.backgroundColor=[UIColor clearColor];
        }
        
        [btn setTitle:titleArr[i] forState:0];
        [self.view addSubview:btn];
        btn.tag=1000+i;
        [btn addTarget:self action:@selector(getImage:) forControlEvents:UIControlEventTouchUpInside];
    }
   
}
-(void)getImage:(UIButton*)sender{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 取到要生成为图片的view
        UIView*toImageView=(UIView*)[self.view viewWithTag:sender.tag-1000+100];
        
        if (sender.tag==1000) {
            //取全屏
            UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, 0, [[UIScreen mainScreen] scale]);
            
            [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
            
        }else{
            UIGraphicsBeginImageContextWithOptions(toImageView.bounds.size, 0, [[UIScreen mainScreen] scale]);
            
            [toImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
         }
        
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(viewImage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    });
    
}
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        NSLog(@"成功");
    }else {
        NSLog(@"失败 - %@",error);
    }
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
