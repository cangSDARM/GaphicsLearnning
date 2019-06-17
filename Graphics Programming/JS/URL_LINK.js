//总URL
//noinspection JSNonASCIINames
var urls = {
    "1. 渲染流水线.html": "",
    "2. 前置知识.html": "",
    "3. 编写shader的数学基础.html":{
        "innerMatrix.html":""
    },
    "4. Shader语法.html":{
        "shader1.0.html":"",
        "shader2.0.html":"",
        "shader3.0.html":"",
		"shaderLab&CG.html":""
    },
    "5. 光照.html":"",
	"6. 纹理.html":"",
    "7. 透明效果.html":"",
    "8. 简单动画.html":"",
    "9. 后期处理.html":"",
    "10. 特殊渲染.html":""
};
var urlNode = {
    "parent_": "",
    "before_":"",
    "after_":"",
    "this_":""
};
var staticDir = ["Files/"];

/**
 * @return {string}
 */
function _FindURL(URL, URLS, nearNode) {
    var fath = false;
    var e;
    var parentNode;
    var parent = "undefined";
    var key;
    var index = -1;
    var sorted = Object.keys(URLS);
    for(key in URLS){
        index++;
        if(key === URL){
            //beforeNode
            if(nearNode === 0){
                index--;
                return typeof sorted[index] !== "undefined" ? sorted[index] : "undefined";

                //afterNode
            }else if(nearNode === 1){
                index++;
                return typeof sorted[index] !== "undefined" ? sorted[index] : "undefined";

                //parentNode
            }else if(nearNode === 2){
                return typeof parent!=="undefined" ? parent : "undefined";
            }

            //thisNode
            return URL;
        }
        if(URLS[sorted[index]] !== ""){
            fath = true;
            parent = key;
            parentNode = URLS[sorted[index]];
        }
    }
    if(fath){
        URLS = parentNode;
        _FindURL(URL, URLS, nearNode);
    }
}
function Check() {
    for(var key in urlNode){
        if(urlNode[key] === "undefined"){
            urlNode[key] = "1. 渲染流水线.html";
        }
    }
}
function FindURL() {
    var thisFileName = decodeURI(window.location.href) + "#";
    thisFileName = thisFileName.substring(thisFileName.lastIndexOf("/") + 1).replace(new RegExp("#+"), "");
    thisFileName = thisFileName.substring(0, thisFileName.lastIndexOf(".html") + 5);
    urlNode.after_ = _FindURL(thisFileName, urls, 1);
    urlNode.before_ = _FindURL(thisFileName, urls, 0);
    urlNode.this_ = _FindURL(thisFileName, urls);
    Check();
}
console.log("不知道啥问题...反正不是根节点的url调用FindURL会假死(然而并没有什么死循环)");
