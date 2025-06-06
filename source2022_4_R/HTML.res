        ��  ��                  �   4   ��
 S O U R C E _ H T M L       0 	        <html>
<head>
<title>Example HTML Source File</title>
</head>
<body>
<h1>Example HTML source file</h1>
<p>This page loaded from HTML source code.</p>
</body>
</html>
 �  0   �� H E L P _ H T M L       0 	        <HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=windows-1252">
<style>
<!--
body {
	font-family: "Arial";
  font-size: 8pt;
  color: black;
  margin-left: 2px;
  margin-right: 2px;
  margin-top: 0px;
  margin-bottom: 0px;
  background-color: #FFFFDD;
}
h1 {
	font-size: 12pt;
  color: navy;
  margin-top: 0px;
  margin-bottom: 0px;
}
h2 {
	font-size: 10pt;
  color: navy;
  margin-top: 4px;
  margin-bottom: 0px;
}
h3 {
	font-size: 8pt;
  margin-top: 4px;
  margin-bottom: 0px;
}
p {
  margin-top: 4px;
  margin-bottom: 0px;
}
ul {
  margin-top: 0px;
  margin-bottom: 0px;
/*  padding-left: 0px;
  margin-left: 16px; */
  padding-left: 0px;
  margin-left: 16px;
  text-indent: 0px;
}
li {
  margin-top: 4px;
  margin-bottom: 0px;
}
-->
</style>
</HEAD>
<BODY LINK="#0000ff" VLINK="#800080">

<H1>Demo Help</H1>

<P>This pane describes how to use this demo program which accompanies the
article
&quot;<A HREF="http://www.delphidabbler.com/articles.php?article=14"
target="_blank">How to load and save documents in TWebBrowser in a Delphi-like
way</A>&quot;.</P>

<P>The program's main window has four main areas:</P>

<UL>
<LI>The top left pane, labelled &quot;Test browser&quot; contains a
	<em>TWebBrowser</em> control that is used to display sample output.
  The control is wrapped by a <em>TWebBrowserWrapper</em> object, as defined in
  the article and included in this demo as
  <code>UWebBrowserWrapper.pas</code>.</LI>
<LI>The text box labelled &quot;HTML Code&quot; displays code or text extracted
	from the test browser using the various Save buttons. HTML code can be
  entered in the box and loaded into the browser using the Load buttons. To
  generate some sample HTML code to load into the browser click the
  &quot;Show Sample HTML source&quot; link above the text box.</LI>
<LI>The bottom half of the screen holds various buttons and other controls
	that are used to exercise <em>TWebBrowserWrapper</em>'s methods.</LI>
<LI>The right hand pane, storing this help message was loaded using the
	<em>TWebBrowserWrapper. NavigateToResource</em> method.</LI>
</UL>

<P>The buttons at the bottom of the form exercise the various methods of the
	<em>TWebBrowserWrapper</em> class discussed in the article. Let's look at
  their use now.</P>

<H2>Save Buttons</H2>

<P>The save buttons all store the content of the demo browser. Whether they
store the full HTML code, the code inside the &lt;body&gt; tag or simply the
document as plain text depends on the save style selected in the Save Style
radio group. The article explains the different save styles in more detail.</P>

<H3>Save to String button</H3>

<P>Clicking this button saves the current content of the demo browser to a
string and then displays the string in the HTML code window.</P>

<H3>Save to Stream button</H3>

<P>This button saves the current demo browser content to a stream and then
loads the stream into the HTML code window. It's effect is the same as
the Save to String button except that it operates in a different way.</P>

<H3>Save to File button</H3>

<P>Clicking this button displays a standard file save dialog box where you
enter a file name. The content of the demo browser is then saved to the
file.</P>

<H2>Load Buttons</H2>

<P>These buttons are used to load HTML content into an existing document.
Each button gets the HTML code from a different source.</P>

<H3>Load From String button</H3>

<P>This button extracts the contents of the HTML Code text box and stores
it in a string. It then loads the string into the demo browser (no checks
are made that this is valid HTML). Some sample HTML code to load can be
displayed in the text box by clicking the Show Sample HTML Code link above
the text box.</P>

<H3>Load From Stream button</H3>

<P>This performs the same action as above, except this button stores the
HTML code text box contents in a stream and then loads the demo browser
document from the stream.</P>

<H3>Load From File button</H3>

<P>Clicking this button opens a standard file open dialog box and loads
the HTML from whichever local file is selected. A sample file named Test.html is
included with the demo.</p>

<H2>Navigate Buttons</H2>

<P>These buttons are used to navigate to a given URL. The article describes
the difference between the Navigate*** and Load*** methods of
<em>TWebBrowserWrapper</em>.</P>

<H3>Navigate to URL button</H3>

<P>Clicking this button navigates the demo browser to the URL entered in
the URL edit box that lies along the bottom of the screen. Enter any
valid URL in this box before clicking the button.</P>

<H3>Navigate to Local File button</H3>

<P>A file open dialog is displayed when this button is clicked from where
a local file can be selected. The selected file is then displayed in the
demo browser using the file:// protocol. A sample file named Test.html is
included with the demo.</P>

<H3>Navigate to Resource button</H3>

<P>This button causes a HTML file from the program's resources to be
loaded into the demo browser.</P>

<H2>Experiment Please</H2>

<P>Go ahead - experiment and check the source code!</P>

</BODY>
</HTML>
�   8   �� H T M L R E S _ H T M L         0 	        <html>
<head>
<title>Example HTML res:// File</title>
</head>
<body>
<h1>Example HTML resource file</h1>
<p>This page loaded from HTML resources.</p>
</body>
</html>
 