Changes in maXbox 2.8.1 April 2010
*************************************************
- refresh problem after clipboard actions in editor solved
- standard math functions added (exp, ln, sqr, arctan etc.)
- doesn't hang after long running (application.processMessages)
- command line interface in shell ::>maxbox2.exe "script_file.txt"
- starter tutorial2 in /docs maxbox_starter2.pdf 


maXbox 2.8 Janaur 2010
*************************************************
- 2 file history in ini file and change between
- more perfomance in debug mode 
- starter tutorial in /docs maxbox_starter.pdf
- assign2 and reset2 functions
- special characters in edit mode 
- reptilian liquid motion function (rlmf)


Changes in maXbox 2.7.1 November 2009
*************************************************

- debug and decompile functions with a second compile engine
- inbuilt math and stat lib
- all time and date functions internal now
- playMP3, stopMP3, closeMP3
- save bytecode bug solves (options show bytecode)

*************************************************
News in maXbox v 2.7
*************************************************
code completion in bds_delphi.dci - delphi compatible
escape and cut/copy paste in memo1
write() and TFileStruct bug solved
function reverseString
line numbers in gutter
statusline and toolbar
enhanced clipboard
check the demo: 38_pas_box_demonstrator.txt
published on http://sourceforge.net/projects/maxbox


*************************************************
Notice about maXbox 2.5
*************************************************

maXbox is a scripter tool with an inbuild delphi engine in one exe!
It is designed for teaching and analyzing methods and algorithms and runs under Win and Linux (CLX) to build Delphi in a box. 

MaXbox and PascalScript is an interpreter of a vast subset of the OP (ObjectPascal) language which supports all OP data types except interfaces and generics.
This subset was extended by the Poly data type that allows you to operate with dynamic data structures (lists, trees, and more) without using pointers and apply Pascal language in the Artificial Intelligence data domain with the same success.
PasScript supports more wide subset of the OP language. You can use such concepts as units, default parameters, overloaded routines, open arrays, records, sets, pointers, classes, objects, class references, events, exceptions, and more in a script. PasScript syntax is 98% compatible with OP.
Allow scripts to use dll functions, the syntax is like:
function FindWindow(C1, C2: PChar): Longint; external 'FindWindowA@user32.dll stdcall'; 
In V2.5 you can include files {$I pas_includebox.inc} and print out your work.
maXbox includes a preprocessor that allows you to use defines ({$IFDEF}, {$ELSE}, {$ENDIF}) and include other files in your script ({$I filename.inc}). 

------------------------------------------------------------------
Important First Steps:
------------------------------------------------------------------
1. You can load a script by open the file.
2. Then you can compile /save the file (F9).
3. When using the menu options/show_linenumbers the editor is in read only mode!
4. The output window is object memo2 from TMemo and you can program it.
5. Last file, font- and window size are saved in a ini file. -->maxboxdef.ini
6. By escape <esc> you can close the box.
7. The source in the zip is not complete, please contact for further source.
8. Some functions like random or beep do have a second one: random2, beep2, assign2 etc.
9. Read the tutorial starter in tutorial in /docs maxbox_starter.pdf


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
http://www.softwareschule.ch/download/maxbox2.zip
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
