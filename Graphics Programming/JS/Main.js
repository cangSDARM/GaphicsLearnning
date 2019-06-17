//内容展开与隐藏
(function() {
    var expansion = document.getElementsByClassName("Expansion");
    Display(document.getElementsByClassName("hidden"), "none");
    for(var i = 0, l=expansion.length; i<l; i++){
        expansion[i].onclick = function () {
            var div = this.nextSibling;
            while(true){
                if(div.className === "Tab hidden" || div.className === "hidden"){
                    break;
                }else{
                    div = div.nextSibling;
                }
            }
            if(div.style.display === "block"){
                Display(div, "none", true);
                    this.style.backgroundColor = "#293134";
                this.style.color = "#E0E2E4";
            }else{
                this.style.backgroundColor = "#E0E2E4";
                    this.style.color = "#293134";
                    Display(div, "block", true);
                    div.style.fontSize =
                        (document.defaultView.getComputedStyle(this, null).fontSize.toString().replace("px","") - 1).toString() + "px";
            }
        };
    }
    function Display(cla, displayType, type) {
        type = typeof type !== 'undefined' ? type : false;
        if(type){
            cla.style.display = displayType;
            return;
        }
        for(var i = 0, l=cla.length; i < l; i++){
            cla[i].style.display = displayType;
        }
    }
})();


//注释的显示于隐藏
(function() {
    var quote = document.getElementsByClassName("Quote");
    var div = document.getElementById("Quote");
    for (var i = 0, l=quote.length; i < l; i++) {
        quote[i].onmouseover = function () {
            div.style.display = "block";
            div.innerHTML = quoteList[this.id.replace("#", "") - 1];
        };
        quote[i].onmouseout = function () {
            div.style.display = "none";
        };
    }
})();


//URL跳转
(function () {
    function SetBackFront(backnotfront) {
        var neighbour = document.getElementsByClassName("Title")[0];
        var jumpNode = document.createElement("hr");
        document.getElementById("Main").insertBefore(jumpNode , neighbour.nextSibling);
        if(backnotfront){
            jumpNode.setAttribute("id", "Back");
            jumpNode.setAttribute("title", "返回上一页");
            jumpNode.onclick = function () {
                var url = decodeURI(window.location.href);
                window.location.href =  url.substring(0, url.lastIndexOf("/") + 1) + urlNode.before_;
            };
        }else{
            jumpNode.setAttribute("id", "Front");
            jumpNode.setAttribute("title", "跳转下一页");
            jumpNode.onclick = function () {
                var url = decodeURI(window.location.href);
                window.location.href =  url.substring(0, url.lastIndexOf("/") + 1) + urlNode.after_;
            };
        }
    }
    var neighbour = document.getElementsByTagName("hr")[0];
    if(neighbour.className === "Unreplace"){
        neighbour.style.width = "100%";
        ScalePage(false);
    }else{
        FindURL();
        neighbour.style.display = "none";
        var loc = urlNode.this_;
        //设置页面title
        var title = loc.replace(new RegExp("[0-9]+. "),"");
        document.head.getElementsByTagName("title")[0].innerHTML = title.substring(0, title.lastIndexOf(".html"));
        //设置显示title
        var titleNode = document.getElementsByClassName("Title")[0];
        var thisFileName = titleNode.innerHTML;
        thisFileName = thisFileName.substring(0, thisFileName.lastIndexOf(" —— ") + 4);
        titleNode.innerHTML = thisFileName + title.replace(".html", "");
        //设置跳转
        SetBackFront(false);
        SetBackFront(true);
        ScalePage(true);
    }
})();
//跳转
function ScalePage(isP2C) {
    if(isP2C){
        var i = -1;
        for(var key in urls[urlNode.this_]){
            i++;
            document.getElementsByClassName("Scale")[i].href = key;
        }
    }else{
		document.getElementsByClassName("Scale")[0].onclick = function () {
            window.history.go(-1);
        };
    }
}

//图片的模态对话框
(function () {
   var imgs = document.getElementsByClassName("Imgs");
   for(var j = 0, l=imgs.length; j<l; j++){
       imgs[j].onclick = function () {
           var target = document.getElementById(this.getAttribute("about"));
           target.setAttribute("title", "缩小");
           if(target.height > window.innerHeight){
               var scale = window.innerHeight/target.height;
               target.width = target.width * scale;
               target.height = target.height * scale;
           }
           target.src = staticDir + imgS[parseInt(target.getAttribute("id").replace("@",""))-1];
           target.onclick = function () {
               target.parentNode.classList.add("hide");
               target.classList.add("hide");
           };
           target.parentNode.classList.remove("hide");
           target.classList.remove("hide");
       }
   }
})();