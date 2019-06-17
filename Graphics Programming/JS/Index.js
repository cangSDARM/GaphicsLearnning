var quoteList = [
    "\"数据总线\"是用于在多个设备间传输数据的通道. \"端口\"是用于在两个设备间传输数据的通道, 总线和端口将功能模块粘结在一起",
    "视锥裁剪(Frustum Culling)在视锥(viewing frustum)中运行并非易事, 因此放在规范立方体(Canonical view volume, CVV 一个单位立方体)中经行",
    "Object space --> World space 转换: 通常称为world matrix来转换",
    "World space --> View space 转换: GPU运算",
    "View space --> Project space 转换: 1. 用透视变换将顶点变换到CVV中; 2. 在CVV中经行视锥裁剪; 3. 将坐标映射到屏幕坐标系",
    "意味着无法获取例如\"是否是同一网格\"之类的信息, 但同时GPU可以并行处理",
    "齐次裁剪坐标也就是CVV坐标. 需要注意的是其深度值Z, 在OpenGL和Unity中, 范围是[-1, 1]; 而Direct中, 范围是[0, 1]",
    "关于c++视锥裁剪算法请参考: OGRE(Object-Oriented Graphics Rendering Engine)的源码",
    "这一阶段也被称为扫描变换(Scan Conversion)",
    "由于后置测试中被舍弃的片元会浪费前面的性能, 因此GPU通常会判断片元着色器和提前测试(Early-Z)是否冲突来决定是否使用提前测试. 如果冲突将禁用提前测试开启后置测试",
	"在OpenGL中是glDrawElements, DirectX中是DrawIndexedPrimitive",
	"现代渲染管线也称为可编程管线. 在较旧的GPU上称为固定函数流水线(Fixed-Function Pipeline), 这是一种配置管线(只提供开关功能)",
    "此部分内容会在第四部分(编写shader的数学基础)中完整叙述"
];
