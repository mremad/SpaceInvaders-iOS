var ebScriptQuery = function(scriptPath) {
  this.scriptPath = scriptPath;
}

var ebScriptFileName = "groupm.js";

ebScriptQuery.prototype = {
  get: function() {	
    var srcRegex = new RegExp(this.scriptPath.replace('.', '\\.') + '(\\?.*)?$');
    var scripts = document.getElementsByTagName("script");
    for (var i = 0; i < scripts.length; i++) {
      var script = scripts[i];
      if (script.src && script.src.match(srcRegex)) {
        var query = script.src.match(/\?([^#]*)(#.*)?/);
        return !query ? '' : query[1];
      }
    }
    return '';
  },
  parse: function() {	
    var result = {};
    var query = this.get();
    var components = query.split('&');
 
    for (var i = 0; i < components.length; i++) {
      var pair = components[i].split('=');
      var name = pair[0], value = pair[1];
 
      if (!result[name]) result[name] = [];
      
 
      // MacIE way
      var values = result[name];
      values[values.length] = value;
    }
    return result;
  }

}

try{
	var groupM_Queries = new ebScriptQuery(ebScriptFileName).parse();	
	
			if(groupM_Queries["site"]){
				var gmtsite = groupM_Queries["site"];
			}

			if(groupM_Queries["placement"]){
				var gmtbe = groupM_Queries["placement"];
			}
}catch(e){}

var gmtbase = 'gmads.net/r';
var gmturl=(location.protocol=='https:'?'https://'+gmtbase:'http://'+gmtbase);
var gmtp=(location.protocol.substring(0,5)=='https'?'https':'http');
var gmtr=Math.floor(Math.random()*9999999999);
var gmttzd=(new Date()).getTimezoneOffset();
var gmth=encodeURI(location.host);
var gmthp=encodeURI(location.pathname);
var gmtim=new Image();
gmtim.src=gmturl+'?gmttzd='+gmttzd+'&amp;gmtr='+gmtr+'&amp;gmth='+gmth+'&amp;gmtsrc=mmde&amp;gmtcl=1&amp;gmthp='+gmthp+'&amp;gmtctrl=1';
