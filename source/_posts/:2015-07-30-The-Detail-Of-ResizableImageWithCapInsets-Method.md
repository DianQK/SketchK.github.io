---
title: 'resizableImageWithCapInsets:方法的探析'
comments: true
date: 2015-07-30 00:12:56
updated: 2017-03-20 15:12:00
tags:
	- iOS 
categories:
	- iOS

---

让我们深入分析下 resizableImageWithCapInsets: 方法

<!-- more -->

## 故事背景

苹果公司为iOS开发者提供了以下的方法用于处理图片的拉伸问题

```objc
    - (UIImage *)resizableImageWithCapInsets:(UIEdgeInsets)capInsets resizingMode:(UIImageResizingMode)resizingMode
    //为行文方便,之后简称该方法为拉伸方法
```

但在实际使用过程中,我发现自己对该方法的理解不够深入,所以今天特地编写了一些代码来探析该方法!
好了,废话不多说,下面我们就开始探析该方法的奥妙吧!

##方法介绍和说明

```objc
    - (UIImage *)resizableImageWithCapInsets:(UIEdgeInsets)capInsets resizingMode:(UIImageResizingMode)resizingMode
    //该方法返回的是UIImage类型的对象,即返回经该方法拉伸后的图像
    //传入的第一个参数capInsets是UIEdgeInsets类型的数据,即原始图像要被保护的区域
    //这个参数是一个结构体,定义如下
    //typedef struct { CGFloat top, left , bottom, right ; } UIEdgeInsets;
    //该参数的意思是被保护的区域到原始图像外轮廓的上部,左部,底部,右部的直线距离,参考图2.1
    //传入的第二个参数resizingMode是UIImageResizingMode类似的数据,即图像拉伸时选用的拉伸模式,
    //这个参数是一个枚举类型,有以下两种方式
    //UIImageResizingModeTile,     平铺 
    //UIImageResizingModeStretch,  拉伸
```

![图2.1 capInsets 参数示意图.png](http://upload-images.jianshu.io/upload_images/406302-97d6960fd2294e17.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)

## 设计实验方法

###实验对象
* Image对象尺寸为60`*`128(为行文方便,之后简称为原始图像,图3.1)
* ImageView对象尺寸为180`*`384(为行文方便,之后简称为相框)

![图3.1 原始图像.png](http://upload-images.jianshu.io/upload_images/406302-f8be96709d90f10a.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)

###实验方法
1. 对原始图像使用拉伸方法并输入不同的参数
2. 将拉伸后的图像放入相框,观察其拉伸效果

###测试软件的界面设计
界面设计如图3.2

* 正上方为原始图像窗口,用于显示原始图像的效果
* 左下方为测试图像窗口,用于显示测试状况的效果
* 右下方为对比图像窗口,用于显示默认状况的效果

![图3.2 测试软件的界面设计.png](http://upload-images.jianshu.io/upload_images/406302-72bf074747c7a491.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)

## 实验分析

### 拉伸模式

resizingMode参数为UIImageResizingModeStretch

#### capInsets参数为UIEdgeInsetsMake(0, 0, 0, 0)时 

当我们向拉伸方法传入该组参数时,代表我们未对原始图像的任何区域进行保护.其拉伸效果如图4.1.1
**在该种情况下,我们发现原始图像按比例放大了3倍,因此我们将该情况当做拉伸模式下的默认状况**

**在之后的实验中,我们将该种状况当做参考对象,显示在界面的右下角**

![图4.1.1 测试结果1.png](http://upload-images.jianshu.io/upload_images/406302-553c751be57b23e8.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)

#### capInsets参数为UIEdgeInsetsMake(42, 0, 0, 0)时

当我们向拉伸方法传入该组参数时,代表我们对原始图像上部的三分之一进行保护(即红色方块区域).其拉伸效果如图4.1.2

**在该种情况下,我们可以发现拉伸后的图像中:**

* 原始图像中受保护的区域(即红色方块区域)在Y轴方向保持了原比例,但在X轴方向进行了拉伸
* 原始图像中未受保护的区域,直接按比例进行了拉伸

![图4.1.2 测试结果2.png](http://upload-images.jianshu.io/upload_images/406302-f62f15b275831931.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)

#### capInsets参数为UIEdgeInsetsMake(0,20, 0, 0)时 

当我们向拉伸方法传入该组参数时,代表我们对原始图像左部的三分之一进行保护(即红色方块区域).其拉伸效果如图4.1.3

**在该种情况下,我们可以发现拉伸后的图像中:**

* 原始图像中受保护的区域(即红色方块区域)在X轴方向保持了原比例,但在Y轴方向进行了拉伸
* 原始图像中未受保护的区域,直接按比例进行了拉伸

![图4.1.3 测试结果3.png](http://upload-images.jianshu.io/upload_images/406302-69218879c2013c9d.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)

#### capInsets参数为UIEdgeInsetsMake(42, 20, 42, 20)时

当我们向拉伸方法传入该组参数时,代表我们对原始图像除数字5以外的区域进行保护(即两个红色方块围起来的区域).其拉伸效果如图4.1.4

**在该种情况下,我们可以发现拉伸后的图像中:**

* 在X轴上,由于1被左边和上边的设置保护,3被右边和上边的设置保护,所以只能用中间的2来拉伸,同理最底下的7,8,9
* 在Y轴上,由于1被左边和上边的设置保护,7被左边和下边的设置保护,所以只能用中间的4来拉伸,同理最底下的3,6,9
* 由于5没有被保护,所以在整个剩余的空间中,用5进行拉伸填充

![图4.1.4 测试结果4.png](http://upload-images.jianshu.io/upload_images/406302-369b2e1cf801c638.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)

### 选择平铺模式

resizingMode参数为UIImageResizingModeTile

#### capInsets参数为UIEdgeInsetsMake(0, 0, 0, 0)时 
当我们向拉伸方法传入该组参数时,代表我们未对原始图像的任何区域进行保护.其平铺效果如图4.2.1

**在该种情况下,我们发现原始图像按比例填充了相框,因此我们将该情况当做拉伸模式下的默认状况**

**在之后的实验中,我们将该种状况当做参考对象,显示在界面的右下角**

![图4.2.1 测试结果1.png](http://upload-images.jianshu.io/upload_images/406302-e1634cd4f03e26d4.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)

#### capInsets参数为UIEdgeInsetsMake(42, 0, 0, 0)时
当我们向拉伸方法传入该组参数时,代表我们对原始图像上部的三分之一进行保护(即红色方块区域).其平铺效果如图4.2.2

**在该种情况下,我们可以发现拉伸后的图像中:**

* 原始图像中受保护的区域(即红色方块区域)在Y轴方向保持了原比例,但在X轴方向进行了平铺填充
* 原始图像中未受保护的区域,直接按比例进行了平铺,但不包含被保护的区域(注意观察蓝色箭头所指的区域)

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/406302-4070bfdc54fa06cd.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)

#### capInsets参数为UIEdgeInsetsMake(0,20, 0, 0)时 
当我们向拉伸方法传入该组参数时,代表我们对原始图像左部的三分之一进行保护(即红色方块区域).其平铺效果如图4.2.3

**在该种情况下,我们可以发现拉伸后的图像中:**

* 原始图像中受保护的区域(即红色方块区域)在X轴方向保持了原比例,但在Y轴方向进行了平铺填充
* 原始图像中未受保护的区域,直接按比例进行了平铺,但不包含被保护的区域(注意观察蓝色箭头所指的区域)

![图4.2.3 测试结果3.png](http://upload-images.jianshu.io/upload_images/406302-3156e09e8fc1fba8.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)

#### capInsets参数为UIEdgeInsetsMake(42, 20, 42, 20)时
当我们向拉伸方法传入该组参数时,代表我们对原始图像除数字5以外的区域进行保护(即两个红色方块围起来的区域).其拉伸效果如图4.2.4

**在该种情况下,我们可以发现拉伸后的图像中:**

* 在X轴上,由于1被左边和上边的设置保护,3被右边和上边的设置保护,所以只能用中间的2来平铺,同理最底下的7,8,9
* 在Y轴上,由于1被左边和上边的设置保护,7被左边和下边的设置保护,所以只能用中间的4来平铺,同理最底下的3,6,9
* 由于5没有被保护,所以在整个剩余的空间中,用5进行平铺填充

![图4.2.4 测试结果4.png](http://upload-images.jianshu.io/upload_images/406302-37c5ce16047b8a0a.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)

## 结论和建议
通过8组实验数据可以观察出拉伸方法在平铺模式和拉伸模式下的变化过程和主要区别,由此我们可知:

* 对原始图形使用拉伸方法且在四周增加保护区域后,能保证原始图形的四个角不失真,但其余部分的变化细节则有不同
* 如果原始图像的外轮廓不平整的话,使用拉伸方式会让外轮廓的不平整度放大,使用平铺方式应该能减小这种情况

## 示例代码
示例代码可以在[这里](https://github.com/SketchK/SketchK.github.io/tree/blog-code/2015-07-30-DemoForResizableImageWithCapInsets)获得。

