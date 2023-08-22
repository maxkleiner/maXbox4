****************************************************************
Release Notes maXbox 3.5 September 2011
****************************************************************
- 10 Tutorials and 220 Examples
- Syntax Check F2 - Java Syntax in Context Menu
- Stop forever loops by edit and recompile if Options/ProcessMessages is set 
- Crypto Unit, SocketServer, UpdateService
- Upgrade of upsi_allfunctionslist.txt and upsi_allobjectslist.txt
- Service Site: http://www.softwareschule.ch/maxbox.htm 

****************************************************************
Release Notes maXbox 3.3 Juli 2011
****************************************************************
- prepare to WebService and CodeCompletion: uPSI_XMLUtil;  SOAPHTTPClient;            
- new Instance, componentcount, cipherbox, 15 new functions and new Examples

****************************************************************
Release Notes maXbox 3.2 April 2011
****************************************************************
- New Units: WideStrings, BDE, SqlExpr (DBX3), ADO_DB, StrHlpr, DateUtils, FileUtils
//Expansion to DateTimeLib and Expansion to Sys/File Utils
 JUtils / gsUtils / JvFunctions of Jedi Functions
- prepare to WebService: HTTPParser; HTTPUtil; uPSI_XMLUtil;  SOAPHTTPClient;            
- new Tutorial 9 and now 210 Examples

****************************************************************
Release Notes maXbox 3.1 March 2011
****************************************************************
please read also http://www.softwareschule.ch/maxboxnews.htm

Now almost 1000 functions /procedures and about 110 objects /classes from VCL, FCL, LCL or CLX
- start it from a USB stick or from a UNC Network Path
- new output menu of styles for prototyping or teaching include context menu
- include kernel functions of compiler and makro editor with RegEX2
- new Units: DB System, Tables and DataSets, Printer, MediaPlayer, Grids, Clipboard, Statusbar

****************************************************************
Release Notes maXbox 3.0 December 2010
****************************************************************

//Load examples *.txt from /examples and press F9!
//please read the readmefirst...or start with the tutorials in /help
//memo1 is script editor
//memo2 is output space

- over 600 new delphi, pascal, network and indy functions in built
- now 810 functions /procedures and 120 types and constants
  (see in the file: upsi_allfunctionslist.txt)
- png, tiff, jpg and more graphics support for canvas and TPicture
- SMTP, POP3, HTTP, FTP, sysutils, strutils, shell and ini support
- Improvments of 64Bit, PNG, and Ansi/WideStrings are done, Dialogs and Plugins are under way
  (e.g. MP3-Player and POP3-Mail Function)
- Now() is now the origin, you have to call DateTimeToStr(Now)
- maXCom examples 1-150 improved with students
- readonly Mode in ../Options/Save before Compile
- mX3 logo font is Tempus Sans ITC kursiv durchgestrichen 48
- use case designer (in speed button, popup & menu)
  note: when a model file has same name like the code file with extension *.uc
  it will load straight the use case editor from same directory 
  e.g. examples/50_program_starter.txt
         examples/50_program_starter.uc
- updating all the examples from _1 to _150 in 8 categories base, math, graphic, statistic, system, net, internet and games. 	

{ max@kleiner.com  V3.0.0.6 February 2011
  new version and examples from
     http://www.softwareschule.ch/maxbox.htm }


Information for the CLX Linux Version
****************************************************************
you can start a shell script with the name e.g. "maxboxstart.sh":
-----------------------------------------------------------------------------
#!/bin/bash
cd `dirname $0`
export LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH
./maxbox3clx
exit 0
-----------------------------------------------------------------------------
so it will include the path to the 2 symbolic links and you can start the box
 from the shell, from script or with click from a stick.
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
Release Notes on V2.9.2
- ftp, html support (based on indy sockets), examples 104-120
Release Notes on V2.9.1
- http support (based on indy sockets), examples 101-103
-----------------------------------------------------------------------------
Release Notes on V2.9.0
-----------------------------------------------------------------------------

Note about vista and win7: by using labels from TLabel set transparent:= false;
for graphics/forms concerning visibility/performance try the ProcessMessages! flag
under /Options/ProcessMessages! 

****************************************************************
Changes in maXbox 2.9 Juni 2010
****************************************************************
- font editor in menu 
- include bug in menu show include solved, also relative path 
- bitmap support for canvas and TPicture
- TDataSet and DB fields support
- use case designer (in speed button, popup & menu)
  note: when a model file has a same name like the code file but the extension *.uc
  it will load straight in the use case editor from same directory (e.g. examples)
  e.g. examples/50_program_starter.txt
       examples/50_program_starter.uc	


Changes in maXbox 2.8.1 April 2010
****************************************************************
- refresh problem after clipboard actions in editor solved
- standard math functions added (exp, ln, sqr, arctan etc.)
- doesn't hang after long running (application.processMessages)
- commandline interface in shell:>maxbox2.exe "script_file.txt"
- starter tutorial2 in /docs maxbox_starter2.pdf 


maXbox 2.8 Januar 2010
****************************************************************
- 2 file history in ini file and change between
- more perfomance in debug mode 
- starter tutorial in /docs maxbox_starter.pdf
- assign2 and reset2 functions
- special characters in edit mode 
- reptilian liquid motion function (rlmf)


Changes in maXbox 2.7.1 November 2009
****************************************************************
- debug and decompile functions with a second compile engine
- inbuilt math and stat lib
- all time and date functions internal now
- playMP3, stopMP3, closeMP3
- save bytecode bug solves (options show bytecode)

****************************************************************
News in maXbox v 2.7
****************************************************************
code completion in bds_delphi.dci - delphi compatible
escape and cut/copy paste in memo1
write() and TFileStruct bug solved
function reverseString
line numbers in gutter
statusline and toolbar
enhanced clipboard
check the demo: 38_pas_box_demonstrator.txt
published on http://sourceforge.net/projects/maxbox
subset was extended by the Poly data type that allows you to operate with dynamic data structures (lists, trees, and more) without using pointers and apply Pascal language in the Artificial Intelligence data domain with the same success.
PasScript supports more wide subset of the OP language. You can use such concepts as units, default parameters, overloaded routines, open arrays, records, sets, pointers, classes, objects, class references, events, exceptions, and more in a script. PasScript syntax is 98% compatible with OP.
Allow scripts to use dll functions, the syntax is like:
function FindWindow(C1, C2: PChar): Longint; external 'FindWindowA@user32.dll stdcall'; 
You can include files {$I pas_includebox.inc} and print out your work.
maXbox includes a preprocessor that allows you to use defines ({$IFDEF}, {$ELSE}, {$ENDIF}) to include other files in your script ({$I filename.inc}). 

------------------------------------------------------------------
Important First Steps and Tips and Tricks:
------------------------------------------------------------------
1. You can load a script by open the file.
2. Then you can compile /save the file (F9).
3. When using the menu options/show_linenumbers the editor is in read only mode!
4. The output window is object memo2 from TMemo and you can program it.
5. Last file, font- and window size are saved in a ini file. -->maxboxdef.ini
6. By escape <esc> you can close the box.
7. The source in the zip is almost complete, please contact for further source.
8. Some functions like random or beep do have a second one: random2, put2, beep2, assign2 etc.
9. Read the tutorial starter 1-8 in tutorial in /docs maxbox_starter.pdf


Tips of the Day for Version V3.5
----------------------------------------------

- Click on the red maXbox Sign (right on top) opens your work directory
- You can printout your scripts as a pdf-file
- You do have a context menu with the right mouse click
- With the UseCase Editor you can convert graphic formats too.
- On menu Options you find 4 Addons as compiled scripts 
- You don't need a mouse to handle maXbox, use shortcuts
- With F2 you check syntax with F9 you compile
- With escape you can leave the box
- In directory /exercises you find a few compilats 
- Drag n' drop your scripts in the box
- Open in menu Outpout a new instance of the box to compare or prepare your scripts
- You can get templates as code completion with ctrl j in the editor like
  classp or iinterface or ttimer (you type classp and then CTRL J)
- In menu output you can set output menu in edit mode by unchecking read only memo       



just inside maXbox
         ____    ___   _      ____    _   _   _
        |  _ \  |  _| | |    |  _ \  | | | | | |
        | | . | | |_  | |    | |_| | | |_| | | |
        | | | | |  _| | |    |  __/  |  _  | | |          
        | |_. | | |_  | |__  | |     | | | | | |                      
        |____/  |___| |____| |_|     |_| |_| |_|                                   

max@kleiner.com
 
new version and examples from
http://www.softwareschule.ch/maxbox.htm
http://www.softwareschule.ch/download/maxbox3.zip
http://sourceforge.net/projects/maxbox


// to Delphi users:
 Also add this line to your project source (.DPR).
{$D-} will prevent placing Debug info to your code.
{$L-} will prevent placing local symbols to your code.
{$O+} will optimize your code, remove unnecessary variables etc.
{$Q-} removes code for Integer overflow-checking.
{$R-} removes code for range checking of strings, arrays etc.
{$S-} removes code for stack-checking. USE ONLY AFTER HEAVY TESTING !
{$Y-} will prevent placing smybol information to your code.


Dear software manufacturer,

your software maXbox is listed in the heise software directory at <http://www.heise.de/software/download/maxbox/76464> and we recently started offering version CLX 3.2 (maxbox3clx.tar.gz) for download.

Fortunately, our automatic virus checks (done in co-operation with AV-Test GmbH) with more than 40 virus scanners do not indicate a virus infection. Just in case you are interested in the scan result we are sending you the detailed scan report:

============================================================

Scan report of: 39788-maxbox3clx.tar.gz

AntiVir -
Avast -
AVG -
BitDefender -
CA-AV -
ClamAV -
Command -
Command (Online) -
Eset Nod32 -
Fortinet -
F-Prot -
G Data -
Ikarus -
K7 Computing -
Kaspersky -
Kaspersky (Online) -
McAfee -
McAfee (BETA) -
McAfee (Online) -
McAfee GW Edition (Online) -
Microsoft -
Norman -
Panda -
Panda (Online) -
PC Tools -
QuickHeal -
Rising -
Sophos -
Sophos (Online) -
Sunbelt -
Symantec -
Symantec (BETA) -
Trend Micro -
Trend Micro (Cons.) -
Trend Micro (CPR) -
VBA32 -
VirusBuster -

============================================================

The following updates have been used for the test (all times in GMT):

AntiVir vdf_fusebundle.zip 2011-06-29 16:15
Avast av5db.zip 2011-06-29 09:20
AVG avg10cmd1191a4294.zip 2011-06-29 10:10
BitDefender bdc.zip 2011-06-29 17:35
CA-AV fv_nt86.exe 2011-06-29 19:10
ClamAV daily.cvd 2011-06-29 17:00
Command antivir-z-201106291210.zip 2011-06-29 16:45
Command (Online) antivir-z-201106291210.zip 2011-06-29 16:45
Eset Nod32 minnt3.exe 2011-06-29 13:45
Fortinet vir_high 2011-06-29 18:35
F-Prot antivir.def 2011-06-29 16:05
G Data bd.zip 2011-06-29 18:45
Ikarus t3sigs.vdb 2011-06-29 16:20
K7 Computing k7cmdline.zip 2011-06-29 15:20
Kaspersky kdb-i386-cumul.zip 2011-06-29 18:40
Kaspersky (Online) kdb-i386-cumul.zip 2011-06-29 18:40
McAfee avvdat-6392.zip 2011-06-29 16:25
McAfee (BETA) avvwin_netware_betadat.zip 2011-06-29 19:25
McAfee (Online) avvdat-6392.zip 2011-06-29 16:25
McAfee GW Edition (Online) mfegw-cmd-scanner-windows.zip 2011-06-29 17:05
Microsoft mpam-fe.exe 2011-06-29 13:35
Norman nvc5oem.zip 2011-06-29 13:25
Panda pav.zip 2011-06-29 12:15
Panda (Online) pav.zip 2011-06-29 12:15
PC Tools avdb.zip 2011-06-29 18:20
QuickHeal qhadvdef.zip 2011-06-29 15:55
Rising RavDef.zip 2011-06-29 06:50
Sophos ides.zip 2011-06-29 19:30
Sophos (Online) ides.zip 2011-06-29 19:30
Sunbelt CSE39VT-EN-9725-F.sbr.sgn 2011-06-29 18:00
Symantec streamset.zip 2011-06-29 19:25
Symantec (BETA) symrapidreleasedefsv5i32.exe 2011-06-29 19:50
Trend Micro lpt255.zip 2011-06-29 03:15
Trend Micro (Cons.) cvsapi255.zip 2011-06-29 03:20
Trend Micro (CPR) lpt256.zip 2011-06-29 19:20
VBA32 vba32w-latest.rar 2011-06-29 09:45
VirusBuster vdb.zip 2011-06-29 16:10


Greetings,
your heise software team

Dear software manufacturer,

your software maXbox is listed in the heise software directory at <http://www.heise.de/software/download/maxbox/76464>. You did grant us permission to make it available on our download servers.

We would like to inform you that our automatic virus checks (done in co-operation with AV-Test GmbH) with more than 40 virus scanners generated some warnings in version 3 (maxbox3.zip).

This is the detailed report:

============================================================

Scan report of: 39790-maxbox3.zip

AntiVir -
Avast -
AVG -
BitDefender -
CA-AV -
ClamAV -
Command -
Command (Online) -
Eset Nod32 -
Fortinet -
F-Prot -
G Data -
Ikarus -
K7 Computing -
Kaspersky -
Kaspersky (Online) -
McAfee -
McAfee (BETA) -
McAfee (Online) -
McAfee GW Edition (Online) -
Microsoft -
Norman -
Panda -
Panda (Online) -
PC Tools -
QuickHeal -
Rising -
Sophos NirSoft (PUA)
Sophos (Online) NirSoft (PUA)
Sunbelt -
Symantec -
Symantec (BETA) -
Trend Micro -
Trend Micro (Cons.) -
Trend Micro (CPR) -
VBA32 -
VirusBuster -

============================================================

The following updates have been used for the test (all times in GMT):

AntiVir vdf_fusebundle.zip 2011-06-29 16:15
Avast av5db.zip 2011-06-29 09:20
AVG avg10cmd1191a4294.zip 2011-06-29 10:10
BitDefender bdc.zip 2011-06-29 19:55
CA-AV fv_nt86.exe 2011-06-29 19:10
ClamAV daily.cvd 2011-06-29 17:00
Command antivir-z-201106291210.zip 2011-06-29 16:45
Command (Online) antivir-z-201106291210.zip 2011-06-29 16:45
Eset Nod32 minnt3.exe 2011-06-29 13:45
Fortinet vir_high 2011-06-29 18:35
F-Prot antivir.def 2011-06-29 16:05
G Data bd.zip 2011-06-29 18:45
Ikarus t3sigs.vdb 2011-06-29 20:20
K7 Computing k7cmdline.zip 2011-06-29 15:20
Kaspersky kdb-i386-cumul.zip 2011-06-29 19:55
Kaspersky (Online) kdb-i386-cumul.zip 2011-06-29 19:55
McAfee avvdat-6392.zip 2011-06-29 16:25
McAfee (BETA) avvwin_netware_betadat.zip 2011-06-29 19:55
McAfee (Online) avvdat-6392.zip 2011-06-29 16:25
McAfee GW Edition (Online) mfegw-cmd-scanner-windows.zip 2011-06-29 17:05
Microsoft mpam-fe.exe 2011-06-29 13:35
Norman nvc5oem.zip 2011-06-29 20:15
Panda pav.zip 2011-06-29 12:15
Panda (Online) pav.zip 2011-06-29 12:15
PC Tools avdb.zip 2011-06-29 19:55
QuickHeal qhadvdef.zip 2011-06-29 15:55
Rising RavDef.zip 2011-06-29 06:50
Sophos ides.zip 2011-06-29 19:30
Sophos (Online) ides.zip 2011-06-29 19:30
Sunbelt CSE39VT-EN-9726-F.sbr.sgn 2011-06-29 20:10
Symantec streamset.zip 2011-06-29 19:25
Symantec (BETA) symrapidreleasedefsv5i32.exe 2011-06-29 19:50
Trend Micro lpt255.zip 2011-06-29 03:15
Trend Micro (Cons.) cvsapi255.zip 2011-06-29 03:20
Trend Micro (CPR) lpt256.zip 2011-06-29 20:05
VBA32 vba32w-latest.rar 2011-06-29 09:45
VirusBuster vdb.zip 2011-06-29 16:10


This is most probably a false alarm. Therefore we are nevertheless offering the file for download but are also checking with the manufacturers of the anti-virus software. You should find an updated scan report in a few days at <http://www.heise.de/software/download/maxbox/76464> (Download-Button).

Greetings,
your heise software team
