function clickwave(e) {
    var symbol = document.createElement("div");
    symbol.style.position = "absolute";
	symbol.style.left = (e.pageX) + "px";
    symbol.style.top = (e.pageY) + "px";
    symbol.style.zIndex = 9999;
	symbol.style.transition="all 1.5s";
    symbol.style.opacity = 1;
	
	symbol.style.border="1.5px white solid";
    symbol.style.borderRadius="100%";
    symbol.style.margin = "-5px -5px";
    symbol.style.width = "10px";
    symbol.style.height = "10px";
    
	symbol.addEventListener("transitionend",function(et){ 
		if(et.propertyName == "opacity" && et.srcElement.style.opacity==0)
			et.srcElement.remove();
	});
	
    document.body.appendChild(symbol);
    
    requestAnimationFrame(()=>{
        symbol.style.margin = "-40px -40px";
    	symbol.style.width = "80px";
        symbol.style.height = "80px";
        symbol.style.opacity = 0;
		symbol.style.backgroundColor = "white";
    });
};