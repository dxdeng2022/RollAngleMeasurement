<h2 align="center">大范围滚转角测量系统</h2>

### 说明

一个基于 Matlab 开发的滚转角（Roll Angle）测量系统，配合相应硬件实现大范围、高精度、远程绝对式角度测量。

所用技术栈：

- Matlab 2021b

已支持的平台：

- Windows

基于斯托克斯的滚转角测量系统，其原理为通过延迟器将滚转角的变化调制到输出光的斯托克斯矢量中，通过对出射斯托克斯矢量的求解进而求解相应的滚转角。其物理模型和实物系统如下图所示。

<p align="center"><img src="images\物理模型.png" alt="物理模型" style="zoom:150%;"></p>

<p align="center"><img src="images\系统实物.png" alt="系统实物" style="zoom:130%;"></p>

所使用的硬件平台：
- 光源：工作波长为635nm的单色激光光源
- 偏振片：LPVISC100-MP2（Thorlabs, Inc., USA）
- 非偏分束器：CCM1-BS013/M（Thorlabs, Inc., USA）
- 延迟器：定制的1/8波片
- 偏振仪：PAX1000VIS/M（Thorlabs, Inc., USA）

整套系统的数学模型为：

$$S_{out}=M_{B S}^{t} M_{S R}(\delta,-\beta) M_{R M} M_{S R}(\delta, \beta) M_{B S}^{r} S_{in} $$

实测精度如下图所示：

<p align="center"><img src="images\实测精度.png" alt="实测精度" style="zoom:120%;"></p>

### 源码使用方法

1. 源码包含四个主脚本及部分辅助函数
2. **main.m** 可依节顺次运行，其用途为读取csv表格、校准系统参量、实现角度测量，所使用数据均为从PAX1000偏振仪上保存好的数据
3. **main_automeasurement.m** 依次顺次运行则可实现校准系统参量、借助OCR技术不断从PAX1000上截取屏幕以获取对应的斯托克斯矢量、从获取的斯托克斯矢量中提取滚转角
4. **mian_sim.m** 基于构建的滚转角测量数学模型进行数学仿真
5. **main_test.m** 手动遍历角度值用以分析何处误差最小
6. 其余辅助函数保证主脚本的运行

### 其他

请确保相应的Matlab App包 安装完成

### 特别鸣谢

**Yangsl, [Wangyf](https://github.com/WangYF-learnmore "WangYF-learnmore"), Zhouwg, Wangxs and [Prof Chenxg](https://github.com/xiuguochen "Prof. Dr. Xiuguo Chen")**

### 参考文献

[1] Chen X, Liao J, Gu H, et al. Proof of principle of an optical Stokes absolute roll-angle sensor with ultra-large measuring range[J]. Sensors and Actuators A: Physical, 2019, 291: 144-149.

[2] Chen X, Liao J, Gu H, et al. Remote absolute roll-angle measurement in range of 180° based on polarization modulation[J]. Nanomanufacturing and Metrology, 2020, 3: 228-235.


