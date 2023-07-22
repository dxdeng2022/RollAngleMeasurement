% 用于屏幕截取的类
% created by：杨世龙
% date：2023.5
classdef ScreenCapture
    
    methods

        function screenImage = capture(obj, roi)
            % 捕获屏幕截图
            screenImage = imcrop(obj.getFullScreenshot(), roi);
        end
        
        function fullScreenshot = getFullScreenshot(obj)
            % 获取完整的屏幕截图
            fullScreenshot = screencapture(0);
        end
        
        function roi = getROI(obj)
            % 获取感兴趣的屏幕区域
            figure('WindowState', 'maximized');  % 创建全屏窗口
            imshow(obj.getFullScreenshot());  % 显示完整的屏幕截图
            
            % 鼠标交互，选择感兴趣区域
            title('请用鼠标框选感兴趣的屏幕区域');
            h = drawrectangle;
            roi = round(h.Position);  % 等待用户完成选择并获取选择的区域坐标
            close;  % 关闭窗口
        end

        function processedImage = preprocessImage(obj, image)
            % 将图像转为灰度图像
            grayImage = rgb2gray(image);
            
%             % 对灰度图像进行二值化处理
            threshold = graythresh(grayImage);
            processedImage = imbinarize(grayImage, threshold);
%             processedImage = grayImage;

        end
    end
end
