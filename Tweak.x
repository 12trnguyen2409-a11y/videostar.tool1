#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <PhotosUI/PhotosUI.h>

static BOOL isToolEnabled = NO;
static id currentSelectedLayerObject = nil; // Lưu Layer đang chọn

// ==========================================
// 1. BẮT SỰ KIỆN CHỌN LAYER CỦA VIDEO STAR
// ==========================================
// LƯU Ý: Bạn phải thay "VSLayerManager" và "selectLayer:" bằng tên thật của app
%hook VSLayerManager 

- (void)selectLayer:(id)layer {
    %orig; // Chạy code gốc của app
    currentSelectedLayerObject = layer; // Ghi nhớ Layer này vào biến của Tool
    NSLog(@"[Tool] Đã chọn Layer: %@", layer);
}

%end

// ==========================================
// 2. GIAO DIỆN NÚT BẤM NỔI & CHỌN ẢNH
// ==========================================
%hook UIWindow

- (void)makeKeyAndVisible {
    %orig;
    
    UIButton *floatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    floatBtn.frame = CGRectMake(self.bounds.size.width - 70, self.bounds.size.height - 150, 50, 50);
    floatBtn.layer.cornerRadius = 25;
    floatBtn.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8];
    [floatBtn setTitle:@"VS" forState:UIControlStateNormal];
    [floatBtn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    floatBtn.layer.borderWidth = 2.0;
    floatBtn.layer.borderColor = [UIColor cyanColor].CGColor;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [floatBtn addGestureRecognizer:pan];
    [floatBtn addTarget:self action:@selector(toggleTool:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:floatBtn];
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    CGPoint translation = [pan translationInView:pan.view.superview];
    pan.view.center = CGPointMake(pan.view.center.x + translation.x, pan.view.center.y + translation.y);
    [pan setTranslation:CGPointZero inView:pan.view.superview];
}

- (void)toggleTool:(UIButton *)sender {
    isToolEnabled = !isToolEnabled;
    if (isToolEnabled) {
        sender.backgroundColor = [UIColor cyanColor];
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        if (!currentSelectedLayerObject) {
            // Cảnh báo nếu chưa chọn Layer
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Lỗi" message:@"Hãy chọn một Layer trên màn hình trước khi bật Tool!" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self.rootViewController presentViewController:alert animated:YES completion:nil];
            isToolEnabled = NO;
            return;
        }
        
        // Mở thư viện ảnh
        [self showPhotoPicker];
    } else {
        sender.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8];
        [sender setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    }
}

- (void)showPhotoPicker {
    PHPickerConfiguration *config = [[PHPickerConfiguration alloc] init];
    config.selectionLimit = 1; // Chọn 1 ảnh để tốc độ nhanh nhất
    config.filter = PHPickerFilter.imagesFilter;
    
    PHPickerViewController *picker = [[PHPickerViewController alloc] initWithConfiguration:config];
    picker.delegate = (id<PHPickerViewControllerDelegate>)self;
    
    [self.rootViewController presentViewController:picker animated:YES completion:nil];
}

// ==========================================
// 3. NHẬN ẢNH VÀ NHÉT THẲNG VÀO LAYER
// ==========================================
- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results {
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (results.count == 0) return;
    
    NSItemProvider *provider = results[0].itemProvider;
    [provider loadObjectOfClass:[UIImage class] completionHandler:^(UIImage *image, NSError *error) {
        if (image && currentSelectedLayerObject) {
            // TỐC ĐỘ: Ghi đè trực tiếp vào bộ nhớ của Layer, không qua UI
            dispatch_async(dispatch_get_main_queue(), ^{
                // LƯU Ý: Thay "setImage:" bằng hàm thật của Video Star để đổi ảnh
                if ([currentSelectedLayerObject respondsToSelector:@selector(setImage:)]) {
                    [currentSelectedLayerObject performSelector:@selector(setImage:) withObject:image];
                } else if ([currentSelectedLayerObject respondsToSelector:@selector(updateImage:)]) {
                    [currentSelectedLayerObject performSelector:@selector(updateImage:) withObject:image];
                }
                NSLog(@"[Tool] Đã thay ảnh vào Layer siêu tốc!");
            });
        }
    }];
}

%end
