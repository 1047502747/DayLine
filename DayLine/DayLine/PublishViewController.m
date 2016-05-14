//
//  PublishViewController.m
//  DayLine
//
//  Created by zxk on 16/4/24.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//


#import "PublishViewController.h"
#import "SigninViewController.h"
#import "PostViewController.h"
@interface PublishViewController ()<UIImagePickerControllerDelegate,
UINavigationControllerDelegate>{
    BOOL photo;
}
@property (strong, nonatomic) UIImagePickerController *imagePC;
@property (strong, nonatomic) NSMutableArray *objectsForShow;
@end


@implementation PublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _objectsForShow = [NSMutableArray new];
    _content.backgroundColor = [UIColor whiteColor];
    _content.delegate = self;
    
    //   label.= [[UILabel alloc]initWithFrame:CGRectMake(3, 3, 200, 20)];
//lable 不可被修改
    _lable.enabled = NO;
    _lable.text = @"我来说两句....";
    _lable.font =  [UIFont systemFontOfSize:12];
    _lable.textColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) textViewDidChange:(UITextView *)textView{
          if ([textView.text length] == 0) {
                 [_lable setHidden:NO];
               }else{
                   [_lable setHidden:YES];
    }
 }
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (void)pickImage:(UIImagePickerControllerSourceType)sourceType {
    NSLog(@"照片被按了");
    //判断当前选择的图片选择器控制器类型是否可用
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        //神奇的nil
        _imagePC = nil;
        //初始化一个图片选择器控制器对象
        _imagePC = [[UIImagePickerController alloc] init];
        //签协议
        _imagePC.delegate = self;
        //设置图片选择器控制器类型
        _imagePC.sourceType = sourceType;
        //设置选中的媒体文件是否可以被编辑
        _imagePC.allowsEditing = YES;
        //设置可以被选择的媒体文件的类型
        _imagePC.mediaTypes = @[(NSString *)kUTTypeImage];
        [self presentViewController:_imagePC animated:YES completion:nil];
    } else {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:sourceType == UIImagePickerControllerSourceTypeCamera ? @"您当前的设备没有照相功能" : @"您当前的设备无法打开相册" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertView addAction:confirmAction];
        [self presentViewController:alertView animated:YES completion:nil];
    }
}






- (IBAction)pickAction:(UITapGestureRecognizer *)sender {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self pickImage:UIImagePickerControllerSourceTypeCamera];
    }];
    UIAlertAction *choosePhoto = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self pickImage:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [actionSheet addAction:takePhoto];
    [actionSheet addAction:choosePhoto];
    [actionSheet addAction:cancelAction];
    [self presentViewController:actionSheet animated:YES completion:nil];
    
    
}


//当选择完媒体文件后调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //根据UIImagePickerControllerEditedImage这个键去拿到我们选中的已经编辑过的图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    //将上面拿到的图片设置为图片视图的图片
    _photo.image = image;
    if (image) {
        photo = YES;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}







- (IBAction)upload:(UIButton *)sender forEvent:(UIEvent *)event {
    
    UIImage *image = _photo.image;
    NSString *topic = _content.text;
    
    if (topic.length == 0 && image == nil) {
        
        [Utilities popUpAlertViewWithMsg:@"请填写所有信息或图片" andTitle:nil onView:self];
        return;
    }
    
    
    PFObject *posts = [PFObject objectWithClassName:@"Posts"];
    posts[@"topic"] = topic;
    PFUser *currentUser = [PFUser currentUser];
    posts[@"poster"] = currentUser;
    //设置图片上传
    if (photo) {
        UIImage *image = _photo.image;
        //将图片转换成png格式
        NSData *imageData = UIImagePNGRepresentation(image);
        PFFile *imageFile = [PFFile fileWithName:@"1.png" data:imageData];
        posts[@"photo"] = imageFile;
    }
    
    self.navigationController.view.userInteractionEnabled = NO;
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    [posts saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.navigationController.view.userInteractionEnabled = YES;
        [aiv stopAnimating];
        if (succeeded) {
            //创建刷新“我的”页面的通知
            NSNotification *note = [NSNotification notificationWithName:@"RefreshPost" object:nil];
            //结合线程触发上述通知（让通知要完成的事先执行完以后再执行触发通知这一行代码后面的代码）
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:note waitUntilDone:YES];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [Utilities popUpAlertViewWithMsg:@"当前上传用户有点多哦，请稍候再试" andTitle:nil onView:self];
        }
    }];
}





- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
//让text view控件实现：当键盘右下角按钮被按下后，收起键盘
//当文本输入视图中文字内容发生变化时调用（返回YES表示同意这个变化发生；返回NO表示不同意）
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //捕捉到键盘右下角按钮被按下这一事件（键盘右下角按钮被按钮实际上在文本输入视图中执行的是换行：\n）
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
