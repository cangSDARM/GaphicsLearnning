var quoteList = [
    "这个等式也被称为光照模型(Lighting Model)",
    "间接光照(indirect light): 进入摄像机的光照之前经过了不止一次的反射",
    "如果没有使用全局光照技术(global illumination), 自发光并不会作为一个光源照射物体, 只是使得自身亮度提高",
    "亦称位Blinn-Phong模型. 是一种各向同性的模型, 无法实现菲涅尔反射(Fresnel reflection)",
    "场景中最亮的平行光一定是按逐像素处理(且在Base中处理)<br>渲染模式设置为\"Not Important\"的按逐顶点或SH<br>渲染模式设置为\"Important\"的按逐像素处理<br>若以上规则小于Quality Setting中的Pixel Light Count, 则更多光源按逐像素",
    "G-buffer(Geometry-buffer)存储了表面法线, 位置, 用于光照计算的材质属性等",
    "其它光照参考: https://docs.unity3d.com/Manual/RenderTech-DefferedShadering.html",
    "参考: https://docs.unity3d.com/Manual/RenderingPath.html",
    "unity为简化计算会使用_LightTexture0(cookie后, 为_LightTextureB0)计算衰减, 但不够精确. 因此通常使用数学计算和衰减纹理来共同计算",
    "可以将Fallback设置为VertexLit或Diffuse等不透明物体的shader. 虽然可以接收和投射阴影, 但效果和不透明物体一样"
];

var imgS = [
    "Blinn-Phong光照模型.png",
    "halfLambert.png",
    "前向渲染的两种Pass.png",
    "常用内置光照变量.png"
];