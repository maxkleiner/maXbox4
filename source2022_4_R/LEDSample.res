



<!DOCTYPE html>
<html>
<head>
 <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" >
 <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" >
 
 <meta name="ROBOTS" content="NOARCHIVE">
 
 <link rel="icon" type="image/vnd.microsoft.icon" href="https://ssl.gstatic.com/codesite/ph/images/phosting.ico">
 
 
 <script type="text/javascript">
 
 
 
 
 var codesite_token = "ABZ6GAcZ_uD7i6Hi3gQoWwi4zNtp_0qCCw:1409327596943";
 
 
 var CS_env = {"assetVersionPath": "https://ssl.gstatic.com/codesite/ph/17097911804237236952", "relativeBaseUrl": "", "assetHostPath": "https://ssl.gstatic.com/codesite/ph", "domainName": null, "loggedInUserEmail": "maxkleiner1@gmail.com", "projectName": "cnpack", "profileUrl": "/u/117254424839310060777/", "projectHomeUrl": "/p/cnpack", "token": "ABZ6GAcZ_uD7i6Hi3gQoWwi4zNtp_0qCCw:1409327596943"};
 var _gaq = _gaq || [];
 _gaq.push(
 ['siteTracker._setAccount', 'UA-18071-1'],
 ['siteTracker._trackPageview']);
 
 _gaq.push(
 ['projectTracker._setAccount', 'UA-10074200-2'],
 ['projectTracker._trackPageview']);
 
 (function() {
 var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
 ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
 (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(ga);
 })();
 
 </script>
 
 
 <title>LEDSample.res - 
 cnpack -
 
 
 CnPack Team is made up of Chinese Programmers and Delphi / C++ Builder fans across the Internet. Our products include CnWizards, CnVCL, CVSTracNT and etc. - Google Project Hosting
 </title>
 <link type="text/css" rel="stylesheet" href="https://ssl.gstatic.com/codesite/ph/17097911804237236952/css/core.css">
 
 <link type="text/css" rel="stylesheet" href="https://ssl.gstatic.com/codesite/ph/17097911804237236952/css/ph_detail.css" >
 
 
 <link type="text/css" rel="stylesheet" href="https://ssl.gstatic.com/codesite/ph/17097911804237236952/css/d_sb.css" >
 
 
 
<!--[if IE]>
 <link type="text/css" rel="stylesheet" href="https://ssl.gstatic.com/codesite/ph/17097911804237236952/css/d_ie.css" >
<![endif]-->
 <style type="text/css">
 .menuIcon.off { background: no-repeat url(https://ssl.gstatic.com/codesite/ph/images/dropdown_sprite.gif) 0 -42px }
 .menuIcon.on { background: no-repeat url(https://ssl.gstatic.com/codesite/ph/images/dropdown_sprite.gif) 0 -28px }
 .menuIcon.down { background: no-repeat url(https://ssl.gstatic.com/codesite/ph/images/dropdown_sprite.gif) 0 0; }
 
 
 
  tr.inline_comment {
 background: #fff;
 vertical-align: top;
 }
 div.draft, div.published {
 padding: .3em;
 border: 1px solid #999; 
 margin-bottom: .1em;
 font-family: arial, sans-serif;
 max-width: 60em;
 }
 div.draft {
 background: #ffa;
 } 
 div.published {
 background: #e5ecf9;
 }
 div.published .body, div.draft .body {
 padding: .5em .1em .1em .1em;
 max-width: 60em;
 white-space: pre-wrap;
 white-space: -moz-pre-wrap;
 white-space: -pre-wrap;
 white-space: -o-pre-wrap;
 word-wrap: break-word;
 font-size: 1em;
 }
 div.draft .actions {
 margin-left: 1em;
 font-size: 90%;
 }
 div.draft form {
 padding: .5em .5em .5em 0;
 }
 div.draft textarea, div.published textarea {
 width: 95%;
 height: 10em;
 font-family: arial, sans-serif;
 margin-bottom: .5em;
 }

 
 .nocursor, .nocursor td, .cursor_hidden, .cursor_hidden td {
 background-color: white;
 height: 2px;
 }
 .cursor, .cursor td {
 background-color: darkblue;
 height: 2px;
 display: '';
 }
 
 
.list {
 border: 1px solid white;
 border-bottom: 0;
}

 
 </style>
</head>
<body class="t4">
<script type="text/javascript">
 window.___gcfg = {lang: 'en'};
 (function() 
 {var po = document.createElement("script");
 po.type = "text/javascript"; po.async = true;po.src = "https://apis.google.com/js/plusone.js";
 var s = document.getElementsByTagName("script")[0];
 s.parentNode.insertBefore(po, s);
 })();
</script>
<div class="headbg">

 <div id="gaia">
 

 <span>
 
 
 
 <b>maxkleiner1@gmail.com</b>
 
 
 | <a href="/u/117254424839310060777/" id="projects-dropdown" onclick="return false;"
 ><u>My favorites</u> <small>&#9660;</small></a>
 | <a href="/u/117254424839310060777/" onclick="_CS_click('/gb/ph/profile');"
 title="Profile, Updates, and Settings"
 ><u>Profile</u></a>
 | <a href="https://www.google.com/accounts/Logout?continue=https%3A%2F%2Fcode.google.com%2Fp%2Fcnpack%2Fsource%2Fbrowse%2Ftrunk%2Fcnvcl%2FExamples%2FLEDText%2FLEDSample.res%3Fr%3D654" 
 onclick="_CS_click('/gb/ph/signout');"
 ><u>Sign out</u></a>
 
 </span>

 </div>

 <div class="gbh" style="left: 0pt;"></div>
 <div class="gbh" style="right: 0pt;"></div>
 
 
 <div style="height: 1px"></div>
<!--[if lte IE 7]>
<div style="text-align:center;">
Your version of Internet Explorer is not supported. Try a browser that
contributes to open source, such as <a href="http://www.firefox.com">Firefox</a>,
<a href="http://www.google.com/chrome">Google Chrome</a>, or
<a href="http://code.google.com/chrome/chromeframe/">Google Chrome Frame</a>.
</div>
<![endif]-->



 <table style="padding:0px; margin: 0px 0px 10px 0px; width:100%" cellpadding="0" cellspacing="0"
 itemscope itemtype="http://schema.org/CreativeWork">
 <tr style="height: 58px;">
 
 
 
 <td id="plogo">
 <link itemprop="url" href="/p/cnpack">
 <a href="/p/cnpack/">
 
 
 <img src="/p/cnpack/logo?cct=1347960908"
 alt="Logo" itemprop="image">
 
 </a>
 </td>
 
 <td style="padding-left: 0.5em">
 
 <div id="pname">
 <a href="/p/cnpack/"><span itemprop="name">cnpack</span></a>
 </div>
 
 <div id="psum">
 <a id="project_summary_link"
 href="/p/cnpack/"><span itemprop="description">CnPack Team is made up of Chinese Programmers and Delphi / C++ Builder fans across the Internet. Our products include CnWizards, CnVCL, CVSTracNT and etc.</span></a>
 
 </div>
 
 
 </td>
 <td style="white-space:nowrap;text-align:right; vertical-align:bottom;">
 
 <form action="/hosting/search">
 <input size="30" name="q" value="" type="text">
 
 <input type="submit" name="projectsearch" value="Search projects" >
 </form>
 
 </tr>
 </table>

</div>

 
<div id="mt" class="gtb"> 
 <a href="/p/cnpack/" class="tab ">Project&nbsp;Home</a>
 
 
 
 
 <a href="/p/cnpack/downloads/list" class="tab ">Downloads</a>
 
 
 
 
 
 <a href="/p/cnpack/w/list" class="tab ">Wiki</a>
 
 
 
 
 
 <a href="/p/cnpack/issues/list"
 class="tab ">Issues</a>
 
 
 
 
 
 <a href="/p/cnpack/source/checkout"
 class="tab active">Source</a>
 
 
 
 
 
 
 
 
 <div class=gtbc></div>
</div>
<table cellspacing="0" cellpadding="0" width="100%" align="center" border="0" class="st">
 <tr>
 
 
 
 
 
 
 <td class="subt">
 <div class="st2">
 <div class="isf">
 
 


 <span class="inst1"><a href="/p/cnpack/source/checkout">Checkout</a></span> &nbsp;
 <span class="inst2"><a href="/p/cnpack/source/browse/">Browse</a></span> &nbsp;
 <span class="inst3"><a href="/p/cnpack/source/list">Changes</a></span> &nbsp;
 
 
 
 
 
 
 
 </form>
 <script type="text/javascript">
 
 function codesearchQuery(form) {
 var query = document.getElementById('q').value;
 if (query) { form.action += '%20' + query; }
 }
 </script>
 </div>
</div>

 </td>
 
 
 
 <td align="right" valign="top" class="bevel-right"></td>
 </tr>
</table>


<script type="text/javascript">
 var cancelBubble = false;
 function _go(url) { document.location = url; }
</script>
<div id="maincol"
 
>

 




<div class="expand">
<div id="colcontrol">
<style type="text/css">
 #file_flipper { white-space: nowrap; padding-right: 2em; }
 #file_flipper.hidden { display: none; }
 #file_flipper .pagelink { color: #0000CC; text-decoration: underline; }
 #file_flipper #visiblefiles { padding-left: 0.5em; padding-right: 0.5em; }
</style>
<table id="nav_and_rev" class="list"
 cellpadding="0" cellspacing="0" width="100%">
 <tr>
 
 <td nowrap="nowrap" class="src_crumbs src_nav" width="33%">
 <strong class="src_nav">Source path:&nbsp;</strong>
 <span id="crumb_root">
 
 <a href="/p/cnpack/source/browse/?r=654">svn</a>/&nbsp;</span>
 <span id="crumb_links" class="ifClosed"><a href="/p/cnpack/source/browse/trunk/?r=654">trunk</a><span class="sp">/&nbsp;</span><a href="/p/cnpack/source/browse/trunk/cnvcl/?r=654">cnvcl</a><span class="sp">/&nbsp;</span><a href="/p/cnpack/source/browse/trunk/cnvcl/Examples/?r=654">Examples</a><span class="sp">/&nbsp;</span><a href="/p/cnpack/source/browse/trunk/cnvcl/Examples/LEDText/?r=654">LEDText</a><span class="sp">/&nbsp;</span>LEDSample.res</span>
 
 


 </td>
 
 
 <td nowrap="nowrap" width="33%" align="right">
 <table cellpadding="0" cellspacing="0" style="font-size: 100%"><tr>
 
 
 <td class="flipper"><b>r654</b></td>
 
 </tr></table>
 </td> 
 </tr>
</table>

<div class="fc">
 
 
 <p><em>
 
 This file is not plain text (only UTF-8 and Latin-1
 text encodings are currently supported).
 
 </em></p>
 
 
 <div id="log">
 <div style="text-align:right">
 <a class="ifCollapse" href="#" onclick="_toggleMeta(this); return false">Show details</a>
 <a class="ifExpand" href="#" onclick="_toggleMeta(this); return false">Hide details</a>
 </div>
 <div class="ifExpand">
 
 
 <div class="pmeta_bubble_bg" style="border:1px solid white">
 <div class="round4"></div>
 <div class="round2"></div>
 <div class="round1"></div>
 <div class="box-inner">
 <div id="changelog">
 <p>Change log</p>
 <div>
 <a href="/p/cnpack/source/detail?spec=svn654&amp;r=2">r2</a>
 by zhoujingyu
 on May 23, 2009
 &nbsp; <a href="/p/cnpack/source/diff?spec=svn654&r=2&amp;format=side&amp;path=/trunk/cnvcl/Examples/LEDText/LEDSample.res&amp;old_path=/trunk/cnvcl/Examples/LEDText/LEDSample.res&amp;old=">Diff</a>
 </div>
 <pre>[No log message]</pre>
 </div>
 
 
 
 
 
 
 <script type="text/javascript">
 var detail_url = '/p/cnpack/source/detail?r=2&spec=svn654';
 var publish_url = '/p/cnpack/source/detail?r=2&spec=svn654#publish';
 // describe the paths of this revision in javascript.
 var changed_paths = [];
 var changed_urls = [];
 
 changed_paths.push('/trunk/cnvcl');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/CleanInplace.bat');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/CleanInplace.bat?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Design');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Design?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Design/Common');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Design/Common?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Design/Common/CnClasses开发包基础类.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Design/Common/CnClasses开发包基础类.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Design/Debug');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Design/Debug?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Design/Debug/CnDebugger需求与设计说明书.doc');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Design/Debug/CnDebugger需求与设计说明书.doc?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Design/MultiLang');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Design/MultiLang?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Design/MultiLang/CnPack多语组件包概要设计说明书.doc');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Design/MultiLang/CnPack多语组件包概要设计说明书.doc?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Design/MultiLang/多语包修改后的设计方案.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Design/MultiLang/多语包修改后的设计方案.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Design/MultiLang/多语包在专家包中的使用说明.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Design/MultiLang/多语包在专家包中的使用说明.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Design/MultiLang/多语包需求说明.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Design/MultiLang/多语包需求说明.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Design/NonVisual');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Design/NonVisual?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Design/NonVisual/CnDock系列组件设计说明书.doc');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Design/NonVisual/CnDock系列组件设计说明书.doc?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Design/NonVisual/CnTimer组件设计说明书.doc');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Design/NonVisual/CnTimer组件设计说明书.doc?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Design/Skin');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Design/Skin?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Design/Skin/CnSkin系列组件设计说明书.doc');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Design/Skin/CnSkin系列组件设计说明书.doc?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Develop');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Develop?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Develop/CnCalendar历法说明.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Develop/CnCalendar历法说明.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Develop/CnDebugger接口帮助文档.doc');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Develop/CnDebugger接口帮助文档.doc?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Develop/CnPackDHibernate帮助文档.doc');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Develop/CnPackDHibernate帮助文档.doc?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Develop/CnPack不可视组件帮助文档.doc');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Develop/CnPack不可视组件帮助文档.doc?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Develop/CnPack停靠组件帮助文档.doc');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Develop/CnPack停靠组件帮助文档.doc?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Develop/CnPack多语组件帮助文档.doc');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Develop/CnPack多语组件帮助文档.doc?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Develop/CnPack平滑字体组件帮助文档.doc');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Develop/CnPack平滑字体组件帮助文档.doc?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Develop/CnPack网络组件帮助文档.doc');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Develop/CnPack网络组件帮助文档.doc?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Develop/CnTimer详解.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Develop/CnTimer详解.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Develop/如何使用编译开关建立可移植的代码.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Develop/如何使用编译开关建立可移植的代码.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Project');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Project?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Project/CVS使用说明.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Project/CVS使用说明.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Project/CnPack公益基金章程.doc');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Project/CnPack公益基金章程.doc?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Project/CnPack协同开发预案.htm');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Project/CnPack协同开发预案.htm?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Project/CnPack开发方案.doc');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Project/CnPack开发方案.doc?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Project/CnPack开发组成员手册.doc');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Project/CnPack开发组成员手册.doc?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Project/CnPack开发组报名申请函.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Project/CnPack开发组报名申请函.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Project/Delphi开发能力自我评测.doc');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Project/Delphi开发能力自我评测.doc?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Project/如何为CnPack组件包捐献及移植代码.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Project/如何为CnPack组件包捐献及移植代码.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/2002年10月份工作总结.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2002年10月份工作总结.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/2002年11月份工作总结.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2002年11月份工作总结.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/2002年2月份工作总结.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2002年2月份工作总结.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/2002年3月份工作总结.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2002年3月份工作总结.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/2002年4月份工作总结.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2002年4月份工作总结.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/2002年5月份工作总结.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2002年5月份工作总结.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/2002年6月份工作总结.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2002年6月份工作总结.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/2002年7月份工作总结.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2002年7月份工作总结.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/2002年8月份工作总结.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2002年8月份工作总结.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/2002年9月15日北京聚会会议记要.doc');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2002年9月15日北京聚会会议记要.doc?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/2002年9月份工作总结.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2002年9月份工作总结.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/2003年10月11日管理员会议纪要.doc');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2003年10月11日管理员会议纪要.doc?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/2003年10月份工作总结.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2003年10月份工作总结.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/2003年11月份工作总结.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2003年11月份工作总结.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/2003年12月份与2004年1月份工作总结.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2003年12月份与2004年1月份工作总结.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/2003年4月份工作总结.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2003年4月份工作总结.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/2003年5月份工作总结.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2003年5月份工作总结.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/2003年6月份工作总结.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2003年6月份工作总结.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/2003年7月份工作总结.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2003年7月份工作总结.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/2003年8月份工作总结.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2003年8月份工作总结.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/2003年9月份工作总结.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2003年9月份工作总结.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/2003年第一季度工作总结.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2003年第一季度工作总结.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/2004年2月份与2004年3月份工作总结.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2004年2月份与2004年3月份工作总结.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/2004年4月份与2004年5月份工作总结.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2004年4月份与2004年5月份工作总结.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/2004年6月份与2004年7月份工作总结.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2004年6月份与2004年7月份工作总结.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/2004年8月份9月份10月份工作总结.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2004年8月份9月份10月份工作总结.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/2004年年度工作总结.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2004年年度工作总结.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/2005年第一季度工作总结.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2005年第一季度工作总结.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/2005年第三季度工作总结.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2005年第三季度工作总结.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/2005年第二季度工作总结.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2005年第二季度工作总结.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/2006年工作总结.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2006年工作总结.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/2007年上半年工作总结.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2007年上半年工作总结.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/2007年下半年工作总结.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2007年下半年工作总结.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/2008年上半年工作总结.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2008年上半年工作总结.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/2008年下半年工作总结.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2008年下半年工作总结.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Report/InfoQ采访稿.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/InfoQ采访稿.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Templates');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Templates?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Templates/CnPack.dot');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Templates/CnPack.dot?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Templates/CnPack_CVSTrac任务单模板.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Templates/CnPack_CVSTrac任务单模板.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Templates/CnPack发布文档模板.dot');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Templates/CnPack发布文档模板.dot?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Templates/CnPack演示文稿模板.pot');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Templates/CnPack演示文稿模板.pot?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Templates/CnPack组件帮助文档模板.dot');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Templates/CnPack组件帮助文档模板.dot?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Templates/Delphi单元规范格式.pas');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Templates/Delphi单元规范格式.pas?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Templates/Delphi编码规范.htm');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Templates/Delphi编码规范.htm?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Templates/开发组会议记录模版.dot');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Templates/开发组会议记录模版.dot?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Templates/文本文档标准格式.txt');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Templates/文本文档标准格式.txt?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Templates/组件包框架详细设计模板.dot');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Templates/组件包框架详细设计模板.dot?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Templates/组件包概要设计模板.dot');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Templates/组件包概要设计模板.dot?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Doc/Templates/组件设计说明书模板.dot');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Doc/Templates/组件设计说明书模板.dot?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/ADOUpdateSQL');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/ADOUpdateSQL?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/ADOUpdateSQL/CnADOUpdateSQL.mdb');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/ADOUpdateSQL/CnADOUpdateSQL.mdb?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/ADOUpdateSQL/Project1.cfg');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/ADOUpdateSQL/Project1.cfg?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/ADOUpdateSQL/Project1.dof');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/ADOUpdateSQL/Project1.dof?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/ADOUpdateSQL/Project1.dpr');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/ADOUpdateSQL/Project1.dpr?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/ADOUpdateSQL/Project1.res');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/ADOUpdateSQL/Project1.res?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/ADOUpdateSQL/Unit1.dfm');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/ADOUpdateSQL/Unit1.dfm?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/ADOUpdateSQL/Unit1.pas');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/ADOUpdateSQL/Unit1.pas?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/ActiveScript');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/ActiveScript?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/ActiveScript/CnASDemo.cfg');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/ActiveScript/CnASDemo.cfg?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/ActiveScript/CnASDemo.dof');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/ActiveScript/CnASDemo.dof?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/ActiveScript/CnASDemo.dpr');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/ActiveScript/CnASDemo.dpr?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/ActiveScript/CnASDemo.res');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/ActiveScript/CnASDemo.res?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/ActiveScript/Unit1.dfm');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/ActiveScript/Unit1.dfm?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/ActiveScript/Unit1.pas');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/ActiveScript/Unit1.pas?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/AntiCheater');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/AntiCheater?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/AntiCheater/AntiCheater.cfg');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/AntiCheater/AntiCheater.cfg?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/AntiCheater/AntiCheater.dof');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/AntiCheater/AntiCheater.dof?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/AntiCheater/AntiCheater.dpr');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/AntiCheater/AntiCheater.dpr?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/AntiCheater/AntiCheater.res');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/AntiCheater/AntiCheater.res?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/AntiCheater/AntiCheaterTest.dfm');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/AntiCheater/AntiCheaterTest.dfm?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/AntiCheater/AntiCheaterTest.pas');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/AntiCheater/AntiCheaterTest.pas?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/AutoOption');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/AutoOption?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/AutoOption/AutoOption.cfg');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/AutoOption/AutoOption.cfg?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/AutoOption/AutoOption.dof');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/AutoOption/AutoOption.dof?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/AutoOption/AutoOption.dpr');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/AutoOption/AutoOption.dpr?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/AutoOption/AutoOption.res');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/AutoOption/AutoOption.res?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/AutoOption/Unit1.dfm');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/AutoOption/Unit1.dfm?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/AutoOption/Unit1.pas');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/AutoOption/Unit1.pas?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CameraEye');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CameraEye?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CameraEye/Project1.cfg');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CameraEye/Project1.cfg?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CameraEye/Project1.dof');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CameraEye/Project1.dof?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CameraEye/Project1.dpr');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CameraEye/Project1.dpr?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CameraEye/Project1.res');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CameraEye/Project1.res?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CameraEye/Unit1.dfm');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CameraEye/Unit1.dfm?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CameraEye/Unit1.pas');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CameraEye/Unit1.pas?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CheckTreeView');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CheckTreeView?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CheckTreeView/Project1.cfg');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CheckTreeView/Project1.cfg?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CheckTreeView/Project1.dof');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CheckTreeView/Project1.dof?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CheckTreeView/Project1.dpr');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CheckTreeView/Project1.dpr?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CheckTreeView/Project1.res');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CheckTreeView/Project1.res?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CheckTreeView/Unit1.dfm');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CheckTreeView/Unit1.dfm?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CheckTreeView/Unit1.pas');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CheckTreeView/Unit1.pas?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnAAFontDemo');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnAAFontDemo?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnAAFontDemo/AAFont.dof');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnAAFontDemo/AAFont.dof?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnAAFontDemo/AAFont.dpr');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnAAFontDemo/AAFont.dpr?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnAAFontDemo/AAFont.res');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnAAFontDemo/AAFont.res?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnAAFontDemo/Mid.res');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnAAFontDemo/Mid.res?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnAAFontDemo/Unit1.dfm');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnAAFontDemo/Unit1.dfm?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnAAFontDemo/Unit1.pas');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnAAFontDemo/Unit1.pas?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnButtons');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnButtons?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnButtons/Project1.cfg');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnButtons/Project1.cfg?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnButtons/Project1.dof');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnButtons/Project1.dof?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnButtons/Project1.dpr');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnButtons/Project1.dpr?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnButtons/Project1.res');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnButtons/Project1.res?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnButtons/Unit1.dfm');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnButtons/Unit1.dfm?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnButtons/Unit1.pas');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnButtons/Unit1.pas?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnButtons/Unit2.dfm');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnButtons/Unit2.dfm?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnButtons/Unit2.pas');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnButtons/Unit2.pas?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnCalendar');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnCalendar?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnCalendar/TestCal.cfg');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnCalendar/TestCal.cfg?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnCalendar/TestCal.dof');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnCalendar/TestCal.dof?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnCalendar/TestCal.dpr');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnCalendar/TestCal.dpr?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnCalendar/TestCal.res');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnCalendar/TestCal.res?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnCalendar/Unit1.dfm');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnCalendar/Unit1.dfm?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnCalendar/Unit1.pas');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnCalendar/Unit1.pas?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnEdit');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnEdit?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnEdit/CnEditDemo.cfg');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnEdit/CnEditDemo.cfg?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnEdit/CnEditDemo.dof');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnEdit/CnEditDemo.dof?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnEdit/CnEditDemo.dpr');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnEdit/CnEditDemo.dpr?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnEdit/CnEditDemo.res');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnEdit/CnEditDemo.res?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnEdit/uMain.dfm');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnEdit/uMain.dfm?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnEdit/uMain.pas');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnEdit/uMain.pas?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnInet');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnInet?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnInet/CnInetDemo.cfg');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnInet/CnInetDemo.cfg?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnInet/CnInetDemo.dof');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnInet/CnInetDemo.dof?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnInet/CnInetDemo.dpr');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnInet/CnInetDemo.dpr?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnInet/CnInetDemo.res');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnInet/CnInetDemo.res?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnInet/Unit1.dfm');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnInet/Unit1.dfm?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnInet/Unit1.pas');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnInet/Unit1.pas?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnModem');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnModem?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnModem/ProjectModem.cfg');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnModem/ProjectModem.cfg?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnModem/ProjectModem.dof');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnModem/ProjectModem.dof?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnModem/ProjectModem.dpr');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnModem/ProjectModem.dpr?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnModem/ProjectModem.res');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnModem/ProjectModem.res?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnModem/uFrmModem.dfm');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnModem/uFrmModem.dfm?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnModem/uFrmModem.pas');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnModem/uFrmModem.pas?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnSkinMagicDemo');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnSkinMagicDemo?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnSkinMagicDemo/CnSkinMagic_Sample.pas');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnSkinMagicDemo/CnSkinMagic_Sample.pas?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnSkinMagicDemo/MainFrm.dfm');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnSkinMagicDemo/MainFrm.dfm?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnSkinMagicDemo/MainFrm.pas');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnSkinMagicDemo/MainFrm.pas?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnSkinMagicDemo/SkinMagicDemo.cfg');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnSkinMagicDemo/SkinMagicDemo.cfg?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnSkinMagicDemo/SkinMagicDemo.dof');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnSkinMagicDemo/SkinMagicDemo.dof?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnSkinMagicDemo/SkinMagicDemo.dpr');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnSkinMagicDemo/SkinMagicDemo.dpr?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnSkinMagicDemo/SkinMagicDemo.res');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnSkinMagicDemo/SkinMagicDemo.res?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnUDP');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnUDP?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnUDP/UDPDemo.cfg');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnUDP/UDPDemo.cfg?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnUDP/UDPDemo.dof');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnUDP/UDPDemo.dof?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnUDP/UDPDemo.dpr');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnUDP/UDPDemo.dpr?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnUDP/UDPDemo.res');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnUDP/UDPDemo.res?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnUDP/UDPDemoFrm.dfm');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnUDP/UDPDemoFrm.dfm?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnUDP/UDPDemoFrm.pas');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnUDP/UDPDemoFrm.pas?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnWaterImage');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnWaterImage?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnWaterImage/Unit1.dfm');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnWaterImage/Unit1.dfm?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnWaterImage/Unit1.pas');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnWaterImage/Unit1.pas?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnWaterImage/WaterImage.cfg');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnWaterImage/WaterImage.cfg?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnWaterImage/WaterImage.dof');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnWaterImage/WaterImage.dof?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnWaterImage/WaterImage.dpr');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnWaterImage/WaterImage.dpr?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/CnWaterImage/WaterImage.res');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/CnWaterImage/WaterImage.res?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/ColorGrid');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/ColorGrid?r\x3d2\x26spec\x3dsvn654');
 
 
 changed_paths.push('/trunk/cnvcl/Examples/ColorGrid/ColorGridDemo.cfg');
 changed_urls.push('/p/cnpack/source/browse/trunk/cnvcl/Examples/ColorGrid/ColorGridDemo.cfg?r\x3d2\x26spec\x3dsvn654');
 
 
 function getCurrentPageIndex() {
 for (var i = 0; i < changed_paths.length; i++) {
 if (selected_path == changed_paths[i]) {
 return i;
 }
 }
 }
 function getNextPage() {
 var i = getCurrentPageIndex();
 if (i < changed_paths.length - 1) {
 return changed_urls[i + 1];
 }
 return null;
 }
 function getPreviousPage() {
 var i = getCurrentPageIndex();
 if (i > 0) {
 return changed_urls[i - 1];
 }
 return null;
 }
 function gotoNextPage() {
 var page = getNextPage();
 if (!page) {
 page = detail_url;
 }
 window.location = page;
 }
 function gotoPreviousPage() {
 var page = getPreviousPage();
 if (!page) {
 page = detail_url;
 }
 window.location = page;
 }
 function gotoDetailPage() {
 window.location = detail_url;
 }
 function gotoPublishPage() {
 window.location = publish_url;
 }
</script>

 
 <style type="text/css">
 #review_nav {
 border-top: 3px solid white;
 padding-top: 6px;
 margin-top: 1em;
 }
 #review_nav td {
 vertical-align: middle;
 }
 #review_nav select {
 margin: .5em 0;
 }
 </style>
 <div id="review_nav">
 <table><tr><td>Go to:&nbsp;</td><td>
 <select name="files_in_rev" onchange="window.location=this.value">
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl?r=2&amp;spec=svn654"
 
 >/trunk/cnvcl</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/CleanInplace.bat?r=2&amp;spec=svn654"
 
 >/trunk/cnvcl/CleanInplace.bat</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc?r=2&amp;spec=svn654"
 
 >/trunk/cnvcl/Doc</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Design?r=2&amp;spec=svn654"
 
 >/trunk/cnvcl/Doc/Design</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Design/Common?r=2&amp;spec=svn654"
 
 >/trunk/cnvcl/Doc/Design/Common</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Design/Common/CnClasses开发包基础类.txt?r=2&amp;spec=svn654"
 
 >.../CnClasses开发包基础类.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Design/Debug?r=2&amp;spec=svn654"
 
 >/trunk/cnvcl/Doc/Design/Debug</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Design/Debug/CnDebugger需求与设计说明书.doc?r=2&amp;spec=svn654"
 
 >...gger需求与设计说明书.doc</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Design/MultiLang?r=2&amp;spec=svn654"
 
 >/trunk/cnvcl/Doc/Design/MultiLang</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Design/MultiLang/CnPack多语组件包概要设计说明书.doc?r=2&amp;spec=svn654"
 
 >...�件包概要设计说明书.doc</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Design/MultiLang/多语包修改后的设计方案.txt?r=2&amp;spec=svn654"
 
 >...�包修改后的设计方案.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Design/MultiLang/多语包在专家包中的使用说明.txt?r=2&amp;spec=svn654"
 
 >...�专家包中的使用说明.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Design/MultiLang/多语包需求说明.txt?r=2&amp;spec=svn654"
 
 >...tiLang/多语包需求说明.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Design/NonVisual?r=2&amp;spec=svn654"
 
 >/trunk/cnvcl/Doc/Design/NonVisual</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Design/NonVisual/CnDock系列组件设计说明书.doc?r=2&amp;spec=svn654"
 
 >...k系列组件设计说明书.doc</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Design/NonVisual/CnTimer组件设计说明书.doc?r=2&amp;spec=svn654"
 
 >...CnTimer组件设计说明书.doc</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Design/Skin?r=2&amp;spec=svn654"
 
 >/trunk/cnvcl/Doc/Design/Skin</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Design/Skin/CnSkin系列组件设计说明书.doc?r=2&amp;spec=svn654"
 
 >...n系列组件设计说明书.doc</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Develop?r=2&amp;spec=svn654"
 
 >/trunk/cnvcl/Doc/Develop</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Develop/CnCalendar历法说明.txt?r=2&amp;spec=svn654"
 
 >...velop/CnCalendar历法说明.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Develop/CnDebugger接口帮助文档.doc?r=2&amp;spec=svn654"
 
 >...CnDebugger接口帮助文档.doc</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Develop/CnPackDHibernate帮助文档.doc?r=2&amp;spec=svn654"
 
 >...CnPackDHibernate帮助文档.doc</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Develop/CnPack不可视组件帮助文档.doc?r=2&amp;spec=svn654"
 
 >...k不可视组件帮助文档.doc</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Develop/CnPack停靠组件帮助文档.doc?r=2&amp;spec=svn654"
 
 >...Pack停靠组件帮助文档.doc</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Develop/CnPack多语组件帮助文档.doc?r=2&amp;spec=svn654"
 
 >...Pack多语组件帮助文档.doc</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Develop/CnPack平滑字体组件帮助文档.doc?r=2&amp;spec=svn654"
 
 >...�滑字体组件帮助文档.doc</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Develop/CnPack网络组件帮助文档.doc?r=2&amp;spec=svn654"
 
 >...Pack网络组件帮助文档.doc</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Develop/CnTimer详解.txt?r=2&amp;spec=svn654"
 
 >...cl/Doc/Develop/CnTimer详解.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Develop/如何使用编译开关建立可移植的代码.txt?r=2&amp;spec=svn654"
 
 >...�关建立可移植的代码.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Project?r=2&amp;spec=svn654"
 
 >/trunk/cnvcl/Doc/Project</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Project/CVS使用说明.txt?r=2&amp;spec=svn654"
 
 >.../Doc/Project/CVS使用说明.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Project/CnPack公益基金章程.doc?r=2&amp;spec=svn654"
 
 >...ect/CnPack公益基金章程.doc</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Project/CnPack协同开发预案.htm?r=2&amp;spec=svn654"
 
 >...ect/CnPack协同开发预案.htm</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Project/CnPack开发方案.doc?r=2&amp;spec=svn654"
 
 >...c/Project/CnPack开发方案.doc</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Project/CnPack开发组成员手册.doc?r=2&amp;spec=svn654"
 
 >.../CnPack开发组成员手册.doc</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Project/CnPack开发组报名申请函.txt?r=2&amp;spec=svn654"
 
 >...Pack开发组报名申请函.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Project/Delphi开发能力自我评测.doc?r=2&amp;spec=svn654"
 
 >...lphi开发能力自我评测.doc</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Project/如何为CnPack组件包捐献及移植代码.txt?r=2&amp;spec=svn654"
 
 >...�件包捐献及移植代码.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report?r=2&amp;spec=svn654"
 
 >/trunk/cnvcl/Doc/Report</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2002年10月份工作总结.txt?r=2&amp;spec=svn654"
 
 >.../2002年10月份工作总结.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2002年11月份工作总结.txt?r=2&amp;spec=svn654"
 
 >.../2002年11月份工作总结.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2002年2月份工作总结.txt?r=2&amp;spec=svn654"
 
 >...t/2002年2月份工作总结.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2002年3月份工作总结.txt?r=2&amp;spec=svn654"
 
 >...t/2002年3月份工作总结.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2002年4月份工作总结.txt?r=2&amp;spec=svn654"
 
 >...t/2002年4月份工作总结.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2002年5月份工作总结.txt?r=2&amp;spec=svn654"
 
 >...t/2002年5月份工作总结.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2002年6月份工作总结.txt?r=2&amp;spec=svn654"
 
 >...t/2002年6月份工作总结.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2002年7月份工作总结.txt?r=2&amp;spec=svn654"
 
 >...t/2002年7月份工作总结.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2002年8月份工作总结.txt?r=2&amp;spec=svn654"
 
 >...t/2002年8月份工作总结.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2002年9月15日北京聚会会议记要.doc?r=2&amp;spec=svn654"
 
 >...5日北京聚会会议记要.doc</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2002年9月份工作总结.txt?r=2&amp;spec=svn654"
 
 >...t/2002年9月份工作总结.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2003年10月11日管理员会议纪要.doc?r=2&amp;spec=svn654"
 
 >...��11日管理员会议纪要.doc</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2003年10月份工作总结.txt?r=2&amp;spec=svn654"
 
 >.../2003年10月份工作总结.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2003年11月份工作总结.txt?r=2&amp;spec=svn654"
 
 >.../2003年11月份工作总结.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2003年12月份与2004年1月份工作总结.txt?r=2&amp;spec=svn654"
 
 >...��2004年1月份工作总结.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2003年4月份工作总结.txt?r=2&amp;spec=svn654"
 
 >...t/2003年4月份工作总结.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2003年5月份工作总结.txt?r=2&amp;spec=svn654"
 
 >...t/2003年5月份工作总结.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2003年6月份工作总结.txt?r=2&amp;spec=svn654"
 
 >...t/2003年6月份工作总结.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2003年7月份工作总结.txt?r=2&amp;spec=svn654"
 
 >...t/2003年7月份工作总结.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2003年8月份工作总结.txt?r=2&amp;spec=svn654"
 
 >...t/2003年8月份工作总结.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2003年9月份工作总结.txt?r=2&amp;spec=svn654"
 
 >...t/2003年9月份工作总结.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2003年第一季度工作总结.txt?r=2&amp;spec=svn654"
 
 >...3年第一季度工作总结.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2004年2月份与2004年3月份工作总结.txt?r=2&amp;spec=svn654"
 
 >...��2004年3月份工作总结.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2004年4月份与2004年5月份工作总结.txt?r=2&amp;spec=svn654"
 
 >...��2004年5月份工作总结.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2004年6月份与2004年7月份工作总结.txt?r=2&amp;spec=svn654"
 
 >...��2004年7月份工作总结.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2004年8月份9月份10月份工作总结.txt?r=2&amp;spec=svn654"
 
 >...�9月份10月份工作总结.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2004年年度工作总结.txt?r=2&amp;spec=svn654"
 
 >...rt/2004年年度工作总结.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2005年第一季度工作总结.txt?r=2&amp;spec=svn654"
 
 >...5年第一季度工作总结.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2005年第三季度工作总结.txt?r=2&amp;spec=svn654"
 
 >...5年第三季度工作总结.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2005年第二季度工作总结.txt?r=2&amp;spec=svn654"
 
 >...5年第二季度工作总结.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2006年工作总结.txt?r=2&amp;spec=svn654"
 
 >...c/Report/2006年工作总结.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2007年上半年工作总结.txt?r=2&amp;spec=svn654"
 
 >...2007年上半年工作总结.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2007年下半年工作总结.txt?r=2&amp;spec=svn654"
 
 >...2007年下半年工作总结.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2008年上半年工作总结.txt?r=2&amp;spec=svn654"
 
 >...2008年上半年工作总结.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/2008年下半年工作总结.txt?r=2&amp;spec=svn654"
 
 >...2008年下半年工作总结.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Report/InfoQ采访稿.txt?r=2&amp;spec=svn654"
 
 >...cl/Doc/Report/InfoQ采访稿.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Templates?r=2&amp;spec=svn654"
 
 >/trunk/cnvcl/Doc/Templates</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Templates/CnPack.dot?r=2&amp;spec=svn654"
 
 >...k/cnvcl/Doc/Templates/CnPack.dot</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Templates/CnPack_CVSTrac任务单模板.txt?r=2&amp;spec=svn654"
 
 >...nPack_CVSTrac任务单模板.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Templates/CnPack发布文档模板.dot?r=2&amp;spec=svn654"
 
 >...tes/CnPack发布文档模板.dot</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Templates/CnPack演示文稿模板.pot?r=2&amp;spec=svn654"
 
 >...tes/CnPack演示文稿模板.pot</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Templates/CnPack组件帮助文档模板.dot?r=2&amp;spec=svn654"
 
 >...Pack组件帮助文档模板.dot</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Templates/Delphi单元规范格式.pas?r=2&amp;spec=svn654"
 
 >...tes/Delphi单元规范格式.pas</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Templates/Delphi编码规范.htm?r=2&amp;spec=svn654"
 
 >...Templates/Delphi编码规范.htm</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Templates/开发组会议记录模版.dot?r=2&amp;spec=svn654"
 
 >.../开发组会议记录模版.dot</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Templates/文本文档标准格式.txt?r=2&amp;spec=svn654"
 
 >...tes/文本文档标准格式.txt</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Templates/组件包框架详细设计模板.dot?r=2&amp;spec=svn654"
 
 >...�包框架详细设计模板.dot</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Templates/组件包概要设计模板.dot?r=2&amp;spec=svn654"
 
 >.../组件包概要设计模板.dot</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Doc/Templates/组件设计说明书模板.dot?r=2&amp;spec=svn654"
 
 >.../组件设计说明书模板.dot</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples?r=2&amp;spec=svn654"
 
 >/trunk/cnvcl/Examples</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/ADOUpdateSQL?r=2&amp;spec=svn654"
 
 >/trunk/cnvcl/Examples/ADOUpdateSQL</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/ADOUpdateSQL/CnADOUpdateSQL.mdb?r=2&amp;spec=svn654"
 
 >.../ADOUpdateSQL/CnADOUpdateSQL.mdb</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/ADOUpdateSQL/Project1.cfg?r=2&amp;spec=svn654"
 
 >...amples/ADOUpdateSQL/Project1.cfg</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/ADOUpdateSQL/Project1.dof?r=2&amp;spec=svn654"
 
 >...amples/ADOUpdateSQL/Project1.dof</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/ADOUpdateSQL/Project1.dpr?r=2&amp;spec=svn654"
 
 >...amples/ADOUpdateSQL/Project1.dpr</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/ADOUpdateSQL/Project1.res?r=2&amp;spec=svn654"
 
 >...amples/ADOUpdateSQL/Project1.res</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/ADOUpdateSQL/Unit1.dfm?r=2&amp;spec=svn654"
 
 >.../Examples/ADOUpdateSQL/Unit1.dfm</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/ADOUpdateSQL/Unit1.pas?r=2&amp;spec=svn654"
 
 >.../Examples/ADOUpdateSQL/Unit1.pas</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/ActiveScript?r=2&amp;spec=svn654"
 
 >/trunk/cnvcl/Examples/ActiveScript</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/ActiveScript/CnASDemo.cfg?r=2&amp;spec=svn654"
 
 >...amples/ActiveScript/CnASDemo.cfg</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/ActiveScript/CnASDemo.dof?r=2&amp;spec=svn654"
 
 >...amples/ActiveScript/CnASDemo.dof</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/ActiveScript/CnASDemo.dpr?r=2&amp;spec=svn654"
 
 >...amples/ActiveScript/CnASDemo.dpr</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/ActiveScript/CnASDemo.res?r=2&amp;spec=svn654"
 
 >...amples/ActiveScript/CnASDemo.res</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/ActiveScript/Unit1.dfm?r=2&amp;spec=svn654"
 
 >.../Examples/ActiveScript/Unit1.dfm</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/ActiveScript/Unit1.pas?r=2&amp;spec=svn654"
 
 >.../Examples/ActiveScript/Unit1.pas</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/AntiCheater?r=2&amp;spec=svn654"
 
 >/trunk/cnvcl/Examples/AntiCheater</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/AntiCheater/AntiCheater.cfg?r=2&amp;spec=svn654"
 
 >...ples/AntiCheater/AntiCheater.cfg</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/AntiCheater/AntiCheater.dof?r=2&amp;spec=svn654"
 
 >...ples/AntiCheater/AntiCheater.dof</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/AntiCheater/AntiCheater.dpr?r=2&amp;spec=svn654"
 
 >...ples/AntiCheater/AntiCheater.dpr</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/AntiCheater/AntiCheater.res?r=2&amp;spec=svn654"
 
 >...ples/AntiCheater/AntiCheater.res</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/AntiCheater/AntiCheaterTest.dfm?r=2&amp;spec=svn654"
 
 >.../AntiCheater/AntiCheaterTest.dfm</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/AntiCheater/AntiCheaterTest.pas?r=2&amp;spec=svn654"
 
 >.../AntiCheater/AntiCheaterTest.pas</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/AutoOption?r=2&amp;spec=svn654"
 
 >/trunk/cnvcl/Examples/AutoOption</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/AutoOption/AutoOption.cfg?r=2&amp;spec=svn654"
 
 >...amples/AutoOption/AutoOption.cfg</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/AutoOption/AutoOption.dof?r=2&amp;spec=svn654"
 
 >...amples/AutoOption/AutoOption.dof</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/AutoOption/AutoOption.dpr?r=2&amp;spec=svn654"
 
 >...amples/AutoOption/AutoOption.dpr</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/AutoOption/AutoOption.res?r=2&amp;spec=svn654"
 
 >...amples/AutoOption/AutoOption.res</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/AutoOption/Unit1.dfm?r=2&amp;spec=svn654"
 
 >...cl/Examples/AutoOption/Unit1.dfm</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/AutoOption/Unit1.pas?r=2&amp;spec=svn654"
 
 >...cl/Examples/AutoOption/Unit1.pas</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CameraEye?r=2&amp;spec=svn654"
 
 >/trunk/cnvcl/Examples/CameraEye</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CameraEye/Project1.cfg?r=2&amp;spec=svn654"
 
 >.../Examples/CameraEye/Project1.cfg</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CameraEye/Project1.dof?r=2&amp;spec=svn654"
 
 >.../Examples/CameraEye/Project1.dof</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CameraEye/Project1.dpr?r=2&amp;spec=svn654"
 
 >.../Examples/CameraEye/Project1.dpr</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CameraEye/Project1.res?r=2&amp;spec=svn654"
 
 >.../Examples/CameraEye/Project1.res</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CameraEye/Unit1.dfm?r=2&amp;spec=svn654"
 
 >...vcl/Examples/CameraEye/Unit1.dfm</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CameraEye/Unit1.pas?r=2&amp;spec=svn654"
 
 >...vcl/Examples/CameraEye/Unit1.pas</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CheckTreeView?r=2&amp;spec=svn654"
 
 >/trunk/cnvcl/Examples/CheckTreeView</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CheckTreeView/Project1.cfg?r=2&amp;spec=svn654"
 
 >...mples/CheckTreeView/Project1.cfg</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CheckTreeView/Project1.dof?r=2&amp;spec=svn654"
 
 >...mples/CheckTreeView/Project1.dof</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CheckTreeView/Project1.dpr?r=2&amp;spec=svn654"
 
 >...mples/CheckTreeView/Project1.dpr</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CheckTreeView/Project1.res?r=2&amp;spec=svn654"
 
 >...mples/CheckTreeView/Project1.res</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CheckTreeView/Unit1.dfm?r=2&amp;spec=svn654"
 
 >...Examples/CheckTreeView/Unit1.dfm</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CheckTreeView/Unit1.pas?r=2&amp;spec=svn654"
 
 >...Examples/CheckTreeView/Unit1.pas</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnAAFontDemo?r=2&amp;spec=svn654"
 
 >/trunk/cnvcl/Examples/CnAAFontDemo</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnAAFontDemo/AAFont.dof?r=2&amp;spec=svn654"
 
 >...Examples/CnAAFontDemo/AAFont.dof</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnAAFontDemo/AAFont.dpr?r=2&amp;spec=svn654"
 
 >...Examples/CnAAFontDemo/AAFont.dpr</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnAAFontDemo/AAFont.res?r=2&amp;spec=svn654"
 
 >...Examples/CnAAFontDemo/AAFont.res</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnAAFontDemo/Mid.res?r=2&amp;spec=svn654"
 
 >...cl/Examples/CnAAFontDemo/Mid.res</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnAAFontDemo/Unit1.dfm?r=2&amp;spec=svn654"
 
 >.../Examples/CnAAFontDemo/Unit1.dfm</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnAAFontDemo/Unit1.pas?r=2&amp;spec=svn654"
 
 >.../Examples/CnAAFontDemo/Unit1.pas</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnButtons?r=2&amp;spec=svn654"
 
 >/trunk/cnvcl/Examples/CnButtons</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnButtons/Project1.cfg?r=2&amp;spec=svn654"
 
 >.../Examples/CnButtons/Project1.cfg</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnButtons/Project1.dof?r=2&amp;spec=svn654"
 
 >.../Examples/CnButtons/Project1.dof</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnButtons/Project1.dpr?r=2&amp;spec=svn654"
 
 >.../Examples/CnButtons/Project1.dpr</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnButtons/Project1.res?r=2&amp;spec=svn654"
 
 >.../Examples/CnButtons/Project1.res</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnButtons/Unit1.dfm?r=2&amp;spec=svn654"
 
 >...vcl/Examples/CnButtons/Unit1.dfm</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnButtons/Unit1.pas?r=2&amp;spec=svn654"
 
 >...vcl/Examples/CnButtons/Unit1.pas</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnButtons/Unit2.dfm?r=2&amp;spec=svn654"
 
 >...vcl/Examples/CnButtons/Unit2.dfm</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnButtons/Unit2.pas?r=2&amp;spec=svn654"
 
 >...vcl/Examples/CnButtons/Unit2.pas</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnCalendar?r=2&amp;spec=svn654"
 
 >/trunk/cnvcl/Examples/CnCalendar</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnCalendar/TestCal.cfg?r=2&amp;spec=svn654"
 
 >.../Examples/CnCalendar/TestCal.cfg</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnCalendar/TestCal.dof?r=2&amp;spec=svn654"
 
 >.../Examples/CnCalendar/TestCal.dof</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnCalendar/TestCal.dpr?r=2&amp;spec=svn654"
 
 >.../Examples/CnCalendar/TestCal.dpr</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnCalendar/TestCal.res?r=2&amp;spec=svn654"
 
 >.../Examples/CnCalendar/TestCal.res</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnCalendar/Unit1.dfm?r=2&amp;spec=svn654"
 
 >...cl/Examples/CnCalendar/Unit1.dfm</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnCalendar/Unit1.pas?r=2&amp;spec=svn654"
 
 >...cl/Examples/CnCalendar/Unit1.pas</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnEdit?r=2&amp;spec=svn654"
 
 >/trunk/cnvcl/Examples/CnEdit</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnEdit/CnEditDemo.cfg?r=2&amp;spec=svn654"
 
 >...l/Examples/CnEdit/CnEditDemo.cfg</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnEdit/CnEditDemo.dof?r=2&amp;spec=svn654"
 
 >...l/Examples/CnEdit/CnEditDemo.dof</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnEdit/CnEditDemo.dpr?r=2&amp;spec=svn654"
 
 >...l/Examples/CnEdit/CnEditDemo.dpr</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnEdit/CnEditDemo.res?r=2&amp;spec=svn654"
 
 >...l/Examples/CnEdit/CnEditDemo.res</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnEdit/uMain.dfm?r=2&amp;spec=svn654"
 
 >.../cnvcl/Examples/CnEdit/uMain.dfm</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnEdit/uMain.pas?r=2&amp;spec=svn654"
 
 >.../cnvcl/Examples/CnEdit/uMain.pas</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnInet?r=2&amp;spec=svn654"
 
 >/trunk/cnvcl/Examples/CnInet</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnInet/CnInetDemo.cfg?r=2&amp;spec=svn654"
 
 >...l/Examples/CnInet/CnInetDemo.cfg</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnInet/CnInetDemo.dof?r=2&amp;spec=svn654"
 
 >...l/Examples/CnInet/CnInetDemo.dof</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnInet/CnInetDemo.dpr?r=2&amp;spec=svn654"
 
 >...l/Examples/CnInet/CnInetDemo.dpr</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnInet/CnInetDemo.res?r=2&amp;spec=svn654"
 
 >...l/Examples/CnInet/CnInetDemo.res</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnInet/Unit1.dfm?r=2&amp;spec=svn654"
 
 >.../cnvcl/Examples/CnInet/Unit1.dfm</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnInet/Unit1.pas?r=2&amp;spec=svn654"
 
 >.../cnvcl/Examples/CnInet/Unit1.pas</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnModem?r=2&amp;spec=svn654"
 
 >/trunk/cnvcl/Examples/CnModem</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnModem/ProjectModem.cfg?r=2&amp;spec=svn654"
 
 >...xamples/CnModem/ProjectModem.cfg</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnModem/ProjectModem.dof?r=2&amp;spec=svn654"
 
 >...xamples/CnModem/ProjectModem.dof</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnModem/ProjectModem.dpr?r=2&amp;spec=svn654"
 
 >...xamples/CnModem/ProjectModem.dpr</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnModem/ProjectModem.res?r=2&amp;spec=svn654"
 
 >...xamples/CnModem/ProjectModem.res</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnModem/uFrmModem.dfm?r=2&amp;spec=svn654"
 
 >...l/Examples/CnModem/uFrmModem.dfm</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnModem/uFrmModem.pas?r=2&amp;spec=svn654"
 
 >...l/Examples/CnModem/uFrmModem.pas</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnSkinMagicDemo?r=2&amp;spec=svn654"
 
 >...k/cnvcl/Examples/CnSkinMagicDemo</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnSkinMagicDemo/CnSkinMagic_Sample.pas?r=2&amp;spec=svn654"
 
 >...MagicDemo/CnSkinMagic_Sample.pas</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnSkinMagicDemo/MainFrm.dfm?r=2&amp;spec=svn654"
 
 >...ples/CnSkinMagicDemo/MainFrm.dfm</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnSkinMagicDemo/MainFrm.pas?r=2&amp;spec=svn654"
 
 >...ples/CnSkinMagicDemo/MainFrm.pas</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnSkinMagicDemo/SkinMagicDemo.cfg?r=2&amp;spec=svn654"
 
 >...nSkinMagicDemo/SkinMagicDemo.cfg</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnSkinMagicDemo/SkinMagicDemo.dof?r=2&amp;spec=svn654"
 
 >...nSkinMagicDemo/SkinMagicDemo.dof</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnSkinMagicDemo/SkinMagicDemo.dpr?r=2&amp;spec=svn654"
 
 >...nSkinMagicDemo/SkinMagicDemo.dpr</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnSkinMagicDemo/SkinMagicDemo.res?r=2&amp;spec=svn654"
 
 >...nSkinMagicDemo/SkinMagicDemo.res</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnUDP?r=2&amp;spec=svn654"
 
 >/trunk/cnvcl/Examples/CnUDP</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnUDP/UDPDemo.cfg?r=2&amp;spec=svn654"
 
 >...cnvcl/Examples/CnUDP/UDPDemo.cfg</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnUDP/UDPDemo.dof?r=2&amp;spec=svn654"
 
 >...cnvcl/Examples/CnUDP/UDPDemo.dof</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnUDP/UDPDemo.dpr?r=2&amp;spec=svn654"
 
 >...cnvcl/Examples/CnUDP/UDPDemo.dpr</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnUDP/UDPDemo.res?r=2&amp;spec=svn654"
 
 >...cnvcl/Examples/CnUDP/UDPDemo.res</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnUDP/UDPDemoFrm.dfm?r=2&amp;spec=svn654"
 
 >...cl/Examples/CnUDP/UDPDemoFrm.dfm</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnUDP/UDPDemoFrm.pas?r=2&amp;spec=svn654"
 
 >...cl/Examples/CnUDP/UDPDemoFrm.pas</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnWaterImage?r=2&amp;spec=svn654"
 
 >/trunk/cnvcl/Examples/CnWaterImage</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnWaterImage/Unit1.dfm?r=2&amp;spec=svn654"
 
 >.../Examples/CnWaterImage/Unit1.dfm</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnWaterImage/Unit1.pas?r=2&amp;spec=svn654"
 
 >.../Examples/CnWaterImage/Unit1.pas</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnWaterImage/WaterImage.cfg?r=2&amp;spec=svn654"
 
 >...ples/CnWaterImage/WaterImage.cfg</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnWaterImage/WaterImage.dof?r=2&amp;spec=svn654"
 
 >...ples/CnWaterImage/WaterImage.dof</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnWaterImage/WaterImage.dpr?r=2&amp;spec=svn654"
 
 >...ples/CnWaterImage/WaterImage.dpr</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/CnWaterImage/WaterImage.res?r=2&amp;spec=svn654"
 
 >...ples/CnWaterImage/WaterImage.res</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/ColorGrid?r=2&amp;spec=svn654"
 
 >/trunk/cnvcl/Examples/ColorGrid</option>
 
 <option value="/p/cnpack/source/browse/trunk/cnvcl/Examples/ColorGrid/ColorGridDemo.cfg?r=2&amp;spec=svn654"
 
 >...ples/ColorGrid/ColorGridDemo.cfg</option>
 
 </select>
 </td></tr></table>
 
 
 <div id="review_instr" class="closed">
 <a class="ifOpened" href="/p/cnpack/source/detail?r=2&spec=svn654#publish">Publish your comments</a>
 <div class="ifClosed">Double click a line to add a comment</div>
 </div>
 
 </div>
 
 
 </div>
 <div class="round1"></div>
 <div class="round2"></div>
 <div class="round4"></div>
 </div>
 <div class="pmeta_bubble_bg" style="border:1px solid white">
 <div class="round4"></div>
 <div class="round2"></div>
 <div class="round1"></div>
 <div class="box-inner">
 <div id="older_bubble">
 <p>Older revisions</p>
 
 <a href="/p/cnpack/source/list?path=/trunk/cnvcl/Examples/LEDText/LEDSample.res&start=2">All revisions of this file</a>
 </div>
 </div>
 <div class="round1"></div>
 <div class="round2"></div>
 <div class="round4"></div>
 </div>
 
 <div class="pmeta_bubble_bg" style="border:1px solid white">
 <div class="round4"></div>
 <div class="round2"></div>
 <div class="round1"></div>
 <div class="box-inner">
 <div id="fileinfo_bubble">
 <p>File info</p>
 
 <div>Size: 1536 bytes</div>
 
 <div><a href="//cnpack.googlecode.com/svn-history/r654/trunk/cnvcl/Examples/LEDText/LEDSample.res">View raw file</a></div>
 </div>
 
 <div id="props">
 <p>File properties</p>
 <dl>
 
 <dt>svn:mime-type</dt>
 <dd>application/octet-stream</dd>
 
 </dl>
 </div>
 
 </div>
 <div class="round1"></div>
 <div class="round2"></div>
 <div class="round4"></div>
 </div>
 </div>
 </div>


</div>

</div>
</div>


<script src="https://ssl.gstatic.com/codesite/ph/17097911804237236952/js/source_file_scripts.js"></script>

 <script type="text/javascript" src="https://ssl.gstatic.com/codesite/ph/17097911804237236952/js/kibbles.js"></script>
 <script type="text/javascript">
 var lastStop = null;
 var initialized = false;
 
 function updateCursor(next, prev) {
 if (prev && prev.element) {
 prev.element.className = 'cursor_stop cursor_hidden';
 }
 if (next && next.element) {
 next.element.className = 'cursor_stop cursor';
 lastStop = next.index;
 }
 }
 
 function pubRevealed(data) {
 updateCursorForCell(data.cellId, 'cursor_stop cursor_hidden');
 if (initialized) {
 reloadCursors();
 }
 }
 
 function draftRevealed(data) {
 updateCursorForCell(data.cellId, 'cursor_stop cursor_hidden');
 if (initialized) {
 reloadCursors();
 }
 }
 
 function draftDestroyed(data) {
 updateCursorForCell(data.cellId, 'nocursor');
 if (initialized) {
 reloadCursors();
 }
 }
 function reloadCursors() {
 kibbles.skipper.reset();
 loadCursors();
 if (lastStop != null) {
 kibbles.skipper.setCurrentStop(lastStop);
 }
 }
 // possibly the simplest way to insert any newly added comments
 // is to update the class of the corresponding cursor row,
 // then refresh the entire list of rows.
 function updateCursorForCell(cellId, className) {
 var cell = document.getElementById(cellId);
 // we have to go two rows back to find the cursor location
 var row = getPreviousElement(cell.parentNode);
 row.className = className;
 }
 // returns the previous element, ignores text nodes.
 function getPreviousElement(e) {
 var element = e.previousSibling;
 if (element.nodeType == 3) {
 element = element.previousSibling;
 }
 if (element && element.tagName) {
 return element;
 }
 }
 function loadCursors() {
 // register our elements with skipper
 var elements = CR_getElements('*', 'cursor_stop');
 var len = elements.length;
 for (var i = 0; i < len; i++) {
 var element = elements[i]; 
 element.className = 'cursor_stop cursor_hidden';
 kibbles.skipper.append(element);
 }
 }
 function toggleComments() {
 CR_toggleCommentDisplay();
 reloadCursors();
 }
 function keysOnLoadHandler() {
 // setup skipper
 kibbles.skipper.addStopListener(
 kibbles.skipper.LISTENER_TYPE.PRE, updateCursor);
 // Set the 'offset' option to return the middle of the client area
 // an option can be a static value, or a callback
 kibbles.skipper.setOption('padding_top', 50);
 // Set the 'offset' option to return the middle of the client area
 // an option can be a static value, or a callback
 kibbles.skipper.setOption('padding_bottom', 100);
 // Register our keys
 kibbles.skipper.addFwdKey("n");
 kibbles.skipper.addRevKey("p");
 kibbles.keys.addKeyPressListener(
 'u', function() { window.location = detail_url; });
 kibbles.keys.addKeyPressListener(
 'r', function() { window.location = detail_url + '#publish'; });
 
 kibbles.keys.addKeyPressListener('j', gotoNextPage);
 kibbles.keys.addKeyPressListener('k', gotoPreviousPage);
 
 
 kibbles.keys.addKeyPressListener('h', toggleComments);
 
 }
 </script>
<script src="https://ssl.gstatic.com/codesite/ph/17097911804237236952/js/code_review_scripts.js"></script>
<script type="text/javascript">
 function showPublishInstructions() {
 var element = document.getElementById('review_instr');
 if (element) {
 element.className = 'opened';
 }
 }
 var codereviews;
 function revsOnLoadHandler() {
 // register our source container with the commenting code
 var paths = {'svn654': '/trunk/cnvcl/Examples/LEDText/LEDSample.res'}
 codereviews = CR_controller.setup(
 {"assetVersionPath": "https://ssl.gstatic.com/codesite/ph/17097911804237236952", "relativeBaseUrl": "", "assetHostPath": "https://ssl.gstatic.com/codesite/ph", "domainName": null, "loggedInUserEmail": "maxkleiner1@gmail.com", "projectName": "cnpack", "profileUrl": "/u/117254424839310060777/", "projectHomeUrl": "/p/cnpack", "token": "ABZ6GAcZ_uD7i6Hi3gQoWwi4zNtp_0qCCw:1409327596943"}, '', 'svn654', paths,
 CR_BrowseIntegrationFactory);
 
 // register our source container with the commenting code
 // in this case we're registering the container and the revison
 // associated with the contianer which may be the primary revision
 // or may be a previous revision against which the primary revision
 // of the file is being compared.
 codereviews.registerSourceContainer(document.getElementById('lines'), 'svn654');
 
 codereviews.registerActivityListener(CR_ActivityType.REVEAL_DRAFT_PLATE, showPublishInstructions);
 
 codereviews.registerActivityListener(CR_ActivityType.REVEAL_PUB_PLATE, pubRevealed);
 codereviews.registerActivityListener(CR_ActivityType.REVEAL_DRAFT_PLATE, draftRevealed);
 codereviews.registerActivityListener(CR_ActivityType.DISCARD_DRAFT_COMMENT, draftDestroyed);
 
 
 var initialized = true;
 reloadCursors();
 }
 window.onload = function() {keysOnLoadHandler(); revsOnLoadHandler();};

</script>
<script type="text/javascript" src="https://ssl.gstatic.com/codesite/ph/17097911804237236952/js/dit_scripts.js"></script>

 
 
 
 <script type="text/javascript" src="https://ssl.gstatic.com/codesite/ph/17097911804237236952/js/ph_core.js"></script>
 
 
 
 
</div> 

<div id="footer" dir="ltr">
 <div class="text">
 <a href="/projecthosting/terms.html">Terms</a> -
 <a href="http://www.google.com/privacy.html">Privacy</a> -
 <a href="/p/support/">Project Hosting Help</a>
 </div>
</div>
 <div class="hostedBy" style="margin-top: -20px;">
 <span style="vertical-align: top;">Powered by <a href="http://code.google.com/projecthosting/">Google Project Hosting</a></span>
 </div>

 
 


 
 </body>
</html>

