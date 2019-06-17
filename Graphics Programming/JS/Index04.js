var quoteList = [
	"shader名字显示在Inspector中. 类似于\"Custom/Shader\"的会出现在材质面板中的Shader->Custom->Shader",
	"属性, 类似c#的public字段. Properties仅仅是为了在面板中展示字段, 其中的定义与赋值可以在任何内容中写",
	"2D贴图的 \" \" 内 可选择: white, red, bump, black 或 空字符串",
	"3D纹理只能用脚本创建, 且 OpenGL3.0 以上才支持",
	"相当于main函数. 而当当前显卡不支持时就会报错. 单独出错则跳过, 全部出错跳转到Fallback",
	"每个 Pass 引起一次渲染流水线",
	"#7未使用",
	"渲染设置, 如颜色混合等. 也可以在Pass中设置. 在这里设置适用于所有Pass",
	"这里所写的所有标签key值是SubShader独有的. Pass中无法设置",
	"名字应该全为大写字符(因为Unity自动将小写转为大写)",
	"5.3时Unity只支持: SoftVegetation"
];