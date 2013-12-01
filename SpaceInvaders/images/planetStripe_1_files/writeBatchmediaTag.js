/*
How to use this script.

attach the data portion of the tag to the custom script as a query string parameter ?data^

eg.
http://ds.serving-sys.com/BurstingRes/CustomScripts/writeBatchmediaTag.js?data^agency=[%agency%]&client=[%client%]&campaignId=[%tp_CampaignID%]&campaignName=[%tp_CampaignName%]&publisherId=[%tp_PublisherName%]&publisherName=[%tp_PublisherName%]&sideId=[%tp_SectionName%]&site=[%tp_SectionName%]&placementId=[%tp_PlacementID%]&placementName=[%tp_PlacementName%]&placementSize=[%tp_PlacementBannerSize%]&adId=[%tp_AdID%]&adName=[%tp_AdName%]&adGapId=[%tp_PlacementClassifications2%]

Add as either on ad download or on preLoad custom script

pg: 08.11.13 - Change the hard-coded http with location.protocol (https support)

*/

var ebScriptFileName = "writeBatchmediaTag.js"
var scriptID="";
var ebScriptQuery = function(scriptPath) {
  this.scriptPath = scriptPath;
}
ebScriptQuery.prototype = {
  get: function() {	
    var srcRegex = new RegExp(this.scriptPath.replace('.', '\\.') + '(\\?.*)?$');
    var scripts = document.getElementsByTagName("script");
    for (var i = 0; i < scripts.length; i++) {
      var script = scripts[i];
      if (script.src && script.src.match(srcRegex)) {
        scriptID = script.id;
		var query = script.src.match(/\?([^#]*)(#.*)?/);
        
		return !query ? '' : query[1];
      }
    }
    return '';
  },
  parse: function() {	
    var result = {};
    var query = this.get();
    var components = query.split('|');
	
	
    for (var i = 0; i < components.length; i++) {
      var pair = components[i].split('^');
      var name = pair[0], value = pair[1];
 
      if (!result[name]) result[name] = [];
      // decode
      if (!value) {
        value = 'true';
      } else {
        try {
          value = decodeURIComponent(value);
        } catch (e) {
          value = unescape(value);
        }
      }
 
      // MacIE way
      var values = result[name];
      values[values.length] = value;
    }
	
    return result;
  },
  flatten: function() {	
    var queries = this.parse();
    for (var name in queries) {
      queries[name] = queries[name][0];
    }
    return queries;
  },
  toString: function() {
    return 'ebScriptQuery [path=' + this.scriptPath + ']';
  }
}

var gEbBatchMediaQueries = new ebScriptQuery(ebScriptFileName).flatten();

var myData=gEbBatchMediaQueries.data;

var dataArray=myData.split("&");
var reString="";
for(var i = 0; i < dataArray.length;i++)
{
var ch=dataArray[i].indexOf("=");
var charLength=dataArray[i].length;
var sub1=dataArray[i].substring(0,ch+1)
var sub2=dataArray[i].substring(ch+1,charLength)
dataArray[i]=(sub1+escape(sub2));

if(i != dataArray.length-1){
reString+=dataArray[i]+"&";
}else{reString+=dataArray[i];}

}

var scriptTag= document.getElementById(scriptID)
scriptTag.removeAttribute("id")

var h=document.createElement("script")
h.id="t4ftvisgm";
document.body.appendChild(h);
h.setAttribute("data",reString);
h.setAttribute("src",location.protocol+"//t4ft.de/c/ftg_vis.min.js");

