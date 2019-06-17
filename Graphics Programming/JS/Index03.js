var quoteList = [
    "对于\"相互垂直\"的 基矢量 来说:<br>其长度都为1时, 称为标准正交基(orthonormal basis);<br>长度不全为1时, 称为正交基(orthogonal basis).",
    "点积(dot product) 也被称为 内积(inner product)<br>叉积(cross product) 也被称为 外积(outer product)",
    "表示: 对一个矢量缩放的结果==对点积结果进行缩放",
    "表示: 点积的操作数可以先进行矢量的加减",
    "表示: 可以直接用点积来求矢量的模, 而不需要模的计算公式",
    "通常情况下, 将多出来的分量称为 ω",
    "这并不是数学定义的矩阵, 而是图形学中的重要组成",
    "如果 λ₁ = λ₂ = λ₃, 则称为统一缩放(uniform scale); 否则称为非统一缩放(nouniform scale)",
    "这是因为unity是带轴旋转. 带轴旋转的 ZXYv 和不带轴旋转中的 YXZv 运算结果相同, 其逻辑顺序都是从Z轴->X轴->Y轴的旋转.",
    "这里是形象的说法. 因为A到B的空间变换就是将A空间的坐标系映射到B的坐标系, 因此可以将A当作B的子空间. 同理, 将B空间作为A空间的子空间也完全可以",
    "之所以是坐标系, 因为这样获得的矩阵是正交的. 因此其转置就是其逆, 才是变换矩阵",
    "T: Transform; R: Rotation; S: Scale",
    "投影指将顶点从View space 变换到 CVV中, 而阴影的产生是在之后的齐次除法(homogeneous division)中",
    "即满足从右手坐标系, 依照从右往左的矩阵计算顺序, 映射到Z∈[-ω, ω]的CVV中. 若对于DirectX([0, ω]之间), 需要进一步更改",
    "注意与透视投影的区别! 正交投影的ω值没有被矩阵改变, 而透视投影的ω值被矩阵改为了-Z(原来的Z)",
    "在unity中, 这一步是底层完成的. 我们只需要处理到Clip space即可",
    "这里的五个空间只是基础流水线上必须经过的五个空间. 实际上还有很多(例如切线空间)"
];

var imgS = [
    "图形学矩阵和变换.png",
    "基础变换矩阵.png",
    "旋转矩阵.png",
    "子空间到父空间的坐标变换.png",
    "正交投影和透视投影.png",
    "透视摄像机.png",
    "透视投影变换.png",
    "透视矩阵变换后的XYZW.png",
    "正交摄像机.png",
    "正交投影变换.png",
    "正交矩阵变换后的XYZW.png",
    "转化为屏幕坐标的简化公式.png"
];