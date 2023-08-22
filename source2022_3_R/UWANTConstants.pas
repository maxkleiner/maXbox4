unit UWANTConstants;

interface



const
  RUNTIME_NAME             = 'WANTRuntime';
  RUNTIME_VERSION          = '2.0.4';
  RUNTIME_BUILD_QUALIFIER  = 'ALPHA/DEVELOPMENT';
  WANT_WEBSITE_URL         = 'http://www.want-tool.org';
  DISCUSSION_GROUP_URL     = 'http://news.optimax.com/dnewsweb.exe?cmd=xover&group=sdforum.want';
  WANT_ISSUES_URL          = 'http://code.google.com/p/want2/issues';

  RUNTIME_STATIC_SIGNATURE =
    RUNTIME_NAME + ' '
   +RUNTIME_VERSION;

const
  BUILD_NO_MARKER: array[1..20] of Char = '@@WANT_BUILD_NUMBER:';
  BUILD_NO: array[1..16] of Char = '0000.00.00.00.00';

  DEFAULT_IDE_CAPTION  = 'WIDE (WANT 2.0 IDE) '
    + RUNTIME_BUILD_QUALIFIER;

  TERMINATED_NO_ERRORS_CAPTION = '  [TERMINATED NORMALLY: Press ENTER]';
  TERMINATED_WITH_ERRORS_CAPTION = '  [TERMINATED WITH ERRORS: Press ENTER]';
  PAUSED_CAPTION                 = '  [EXECUTION PAUSED: Press ENTER]';

const
  ERROR_Parse_UnsupportedConstruct       = 100;
  ERROR_Parse_UnexpectedToken            = 101;
  ERROR_Parse_Expression                 = 102;
  ERROR_Parse_Statement                  = 103;
  ERROR_Parse_Identifier                 = 104;
  ERROR_Parse_ProjectBlock               = 105;
  ERROR_Parse_ProjectNode                = 106;
  ERROR_Parse_Target                     = 107;
  ERROR_Parse_TargetBlock                = 108;
  ERROR_Parse_Procedure                  = 109;
  ERROR_Parse_ProcedureBlock             = 110;
  ERROR_Parse_IdentifierList             = 111;
  ERROR_Parse_TaskNode                   = 112;
  ERROR_Parse_CallNode                   = 113;
  ERROR_Parse_TaskArgument               = 114;
  ERROR_Parse_FunctionCallArgument       = 115;
  ERROR_Parse_IFCondition                = 116;
  ERROR_Parse_CASEExpression             = 117;
  ERROR_Parse_LoopCondition              = 118;
  ERROR_Parse_CallArgument               = 119;
  ERROR_Parse_FunctionCall               = 120;
  ERROR_Parse_DuplicateName              = 121;
  ERROR_Parse_UntilOutsideLoop           = 122;
  ERROR_Parse_ElseIfOutsideConditional   = 123;
  ERROR_Parse_CallArguments              = 124;
  ERROR_Parse_InvalidArrayDeclaration    = 125;
  ERROR_Parse_InvalidArrayIndexExpr      = 126;
  ERROR_Parse_InvalidNEWExpression       = 127;
  ERROR_Parse_InvalidType                = 128;


const
  ERROR_Import_MissingModule             = 201;

const
  ERROR_Loader_MissingModule             = 401;
  ERROR_Loader_DuplicateSymbol           = 402;

const
  ERROR_Analyzer_NoModulesDefined        = 501;
  ERROR_Analyzer_UnknownCallTarget       = 502;
  ERROR_Analyzer_InvalidCallTarget       = 503;
  ERROR_Analyzer_InvalidMethod           = 504;
  ERROR_Analyzer_ExpectingConstExpr      = 505;
  ERROR_Analyzer_InvalidLocalName        = 506;
  ERROR_Analyzer_TooFewArguments         = 507;
  ERROR_Analyzer_TooManyArguments        = 508;
  ERROR_Analyzer_UnableToResolve         = 509;
  ERROR_Analyzer_UnknownExpressionType   = 510;
  ERROR_Analyzer_UnknownStatementType    = 511;
  ERROR_Analyzer_InvalidVariableType     = 512;
  ERROR_Analyzer_InvalidConstExpr        = 513;
  ERROR_Analyzer_RunOnce                 = 514;
  ERROR_Analyzer_TooManyBindings         = 515;
  ERROR_Analyzer_OperatorIndex           = 516;
  ERROR_Analyzer_MissingSelf             = 517;
  ERROR_Analyzer_GeneralError            = 518;

  WARNING_Analyzer_UninitializedVariable = 1501;



const
  ERROR_Runtime_NoMainModule             = 701;
  ERROR_RunTime_NotImplemented           = 702;
  ERROR_Runtime_EvalRef                  = 703;
  ERROR_Runtime_UnknownCallTarget        = 704;
  ERROR_Runtime_InvalidLoopCondition     = 705;
  ERROR_Runtime_IncompatibleTypes        = 706;
  ERROR_Runtime_InvalidVariableType      = 707;
  ERROR_Runtime_ExpressionEval           = 708;
  ERROR_RunTime_FileNotFound             = 709;
  ERROR_Runtime_BindArgument             = 710;
  ERROR_Runtime_ExecutionAborted         = 711;
  ERROR_Runtime_UnassignedVar            = 712;
  ERROR_Runtime_InvalidRefType           = 713;
  ERROR_Runtime_ArgByValue               = 714;
  ERROR_Runtime_ArgByReference           = 715;
  ERROR_Runtime_ModuleHasNoSymTable      = 716;
  ERROR_Runtime_InvalidRefTarget         = 717;
  ERROR_Runtime_UnknownType              = 718;
  ERROR_Runtime_InvalidSwitchCondition   = 719;


  WARNING_Runtime_TargetInvokeViaCall    = 1701;


const
  ERROR_Module_InvalidArgumentValue      = 1707;

const
  WARNING_Module_FileIsReadOnly          = 2707;
  WARNING_Module_FileIsHidden            = 2708;


const
  ERROR_SystemOperators_Assign           = 2001;
  ERROR_SystemOperators_Index            = 2002;



const
  VariableArgumentListEllipsis = '...';
  VariableArgumentListMarker = '___';

const
  WANTType_String    = 'System.String';
  WANTType_Boolean   = 'System.Boolean';
  WANTType_Number    = 'System.Number';
  WANTType_Array     = 'System.Array';


const
  DEFAULT_MODULE_NAME     = 'DEFAULT';
  DEFAULT_SCRIPT_NAME = 'build.want';
  DEFAULT_FILE_EXT = '.want';

const
  Tag_Self           = 'self';
  Tag_Node           = 'node';
  Tag_Item           = 'item';
  Tag_Modules        = 'modules';
  Tag_Module         = 'module';
  Tag_ModuleRef      = 'moduleref';
  Tag_Constructor    = 'constructor';
  Tag_Target         = 'target';
  Tag_Literal        = 'literal';
  Tag_Imports        = 'imports';
  Tag_Import         = 'import';
  Tag_Statements     = 'statements';
  Tag_Dependencies   = 'dependencies';
  Tag_Depends        = 'depends';
  Tag_Constants      = 'constants';
  Tag_Parameters     = 'parameters';
  Tag_Variables      = 'variables';
  Tag_ClassVars      = 'classdata';
  Tag_Arguments      = 'arguments';
  Tag_Arg            = 'arg';
  Tag_Result         = 'result';
  Tag_Const          = 'const';
  Tag_Call           = 'call';
  Tag_Ref            = 'nameref';
  Tag_StaticRef      = 'static-ref';
  Tag_Expression     = 'expression';
  //Tag_Return         = 'return';
  Tag_Exit           = 'exit';
  Tag_Break          = 'break';
  Tag_Continue       = 'continue';


  //Tag_IfThen        = 'if-then';
  Tag_Switch         = 'switch';
  Tag_Branch         = 'if-branch';

  Tag_Loop           = 'loop';
  Tag_While          = 'while';
  Tag_Until          = 'until';
  Tag_Initialization = 'initialization';
  Tag_Increment      = 'increment';


  Tag_VarDef         = 'var-def';
  Tag_Var            = 'var';
  Tag_ClassVar       = 'class-var';
  Tag_VarRef         = 'var-ref';
  Tag_VarValue       = 'var-value';

  Tag_Param          = 'param';
  Tag_ParamRef       = 'param-ref';
  Tag_Files          = 'files';
  Tag_File           = 'file';

  Tag_Messages       = 'messages';
  Tag_Calls          = 'calls';

  Tag_WANT           = 'WANT';
  Tag_Frame          = 'frame';
  Tag_MethodCall     = 'method-call';
  Tag_Object         = 'object';
  Tag_CallEvent      = 'call-event';


  Tag_Runtime        = 'runtime';
  Tag_RegModules     = 'RegModules';
  Tag_SymTable       = 'SymTable';
  Tag_SymEntry       = 'symbol';
  Tag_Stack          = 'stack';


  Tag_Breakpoint     = 'breakpoint';


  Tag_SysLoader      = 'Startup';
  Tag_Parser         = 'Parser';
  Tag_SymLoader      = 'SymLoader';
  Tag_Importer       = 'Importer';
  Tag_Analyzer       = 'Analyzer';
  Tag_Optimizer      = 'Optimizer';
  Tag_Runner         = 'Runner';

  Tag_Fatal          = 'fatal';
  Tag_Error          = 'error';
  Tag_Warning        = 'warning';
  Tag_Info           = 'info';
  Tag_Message        = 'message';



  Attr_ID            = 'ID';
  Attr_RefID         = 'RefID';
  Attr_Name          = 'Name';
  Attr_Message       = 'Message';
  Attr_SymType       = 'SymType';
  Attr_Type          = 'Type';
  Attr_TypeID        = 'TypeID';
  Attr_Class         = 'Class';
  Attr_Value         = 'Value';
  Attr_LineNo        = 'LineNo';
  Attr_ColNo         = 'ColNo';
  Attr_Visibility    = 'Visibility';
  Attr_Virtual       = 'Virtual';
  Attr_Owner         = 'Owner';
  Attr_OwnerID       = 'OwnerID';
  Attr_OwnerIndex    = 'OwnerIndex';
  Attr_TargetID      = 'TargetID';
  Attr_Mode          = 'Mode';
  Attr_Optional      = 'Optional';
  Attr_NameIndex     = 'NameIndex';
  Attr_ImplClass     = 'ImplClass';
  Attr_ImplClassRef  = 'ImplClassRef';
  Attr_From          = 'From';
  Attr_FileName      = 'FileName';
  Attr_Path          = 'Path';
  Attr_Signature     = 'Signature';
  Attr_Build         = 'Build';
  Attr_FileID        = 'FileID';
  Attr_UserModule    = 'UserModule';
  Attr_FormalDef     = 'FormalDef';
  Attr_ActualRef     = 'ActualRef';
  Attr_NumRuns       = 'NumRuns';
  Attr_RunTickCount  = 'RunTickCount';
  Attr_ArgNo         = 'ArgNo';
  Attr_LocalDef      = 'LocalDef';
  Attr_FrameOffset   = 'FrameOffset';
  Attr_LocalIndex    = 'LocalIndex';
  Attr_OpenArg       = 'OpenArg';
  Attr_ExitNow       = 'ExitNow';

  Attr_Errors        = 'Errors';
  Attr_Warnings      = 'Warnings';
  Attr_Hints         = 'Hints';
  Attr_Infos         = 'Infos';
  Attr_Messages      = 'Messages';
  Attr_Tokens        = 'Tokens';
  Attr_Lines         = 'Lines';
  Attr_Symbols       = 'Symbols';
  Attr_LOC           = 'LOC';
  Attr_Bytes         = 'Bytes';
  Attr_Files         = 'Files';
  Attr_NonJunk       = 'NonJunk';
  Attr_Count         = 'Count';
  Attr_NamedArg      = 'NamedArg';

  Attr_MainModule    = 'MainModule';
  Attr_HashIndex     = 'HashIndex';

  Attr_StartTime     = 'StartTime';
  Attr_EndTime       = 'EndTime';
  Attr_Time          = 'Time';
  Attr_Timestamp     = 'Timestamp';
  Attr_Result        = 'Result';
  Attr_PrevFrame     = 'PrevFrame';
  Attr_Function      = 'Function';        

  Attr_ModuleCount   = 'ModuleCount';
  Attr_Depth         = 'Depth';

  Attr_XMLGen        = 'XMLGen';
  Attr_XMLFolder     = 'XMLFolder';



  OPERATOR_ASSIGN         = '#ASSIGN';
  OPERATOR_NEW            = '#NEW';
  OPERATOR_EQUAL          = '#EQUAL';
  OPERATOR_NOTEQUAL       = '#NOTEQUAL';
  OPERATOR_LESSTHAN       = '#LESSTHAN';
  OPERATOR_GREATERTHAN    = '#GREATERTHAN';
  OPERATOR_GREATEROREQUAL = '#GREATEROREQUAL';
  OPERATOR_LESSOREQUAL    = '#LESSOREQUAL';
  OPERATOR_SHR            = '#SHR';
  OPERATOR_SHL            = '#SHL';
  OPERATOR_OR             = '#OR';
  OPERATOR_XOR            = '#XOR';
  OPERATOR_NOT            = '#NOT';
  OPERATOR_MULT           = '#MULT';
  OPERATOR_FDIV           = '#FDIV';
  OPERATOR_DIV            = '#DIV';
  OPERATOR_MOD            = '#MOD';
  OPERATOR_AND            = '#AND';
  OPERATOR_PLUS           = '#PLUS';
  OPERATOR_UPLUS          = '#UPLUS';
  OPERATOR_MINUS          = '#MINUS';
  OPERATOR_UMINUS         = '#UMINUS';
  OPERATOR_ATTRIB         = '#ATTRIB';
  OPERATOR_INDEX          = '#INDEX';
  OPERATOR_MODULE         = '#MODULE';


  ParamMode_Input    = 'VAL';
  ParamMode_Output   = 'REF';

  WANTType_Module    = 'Module';
  WANTType_Set       = 'Set';
  WANTType_Method    = 'Method';
  WANTType_Record    = 'Record';
  WANTType_Int64     = 'Int64';
  WANTType_Reference = 'Reference';
  WANTType_List      = 'List';


  SYSTEMProc_WriteLn = 'WriteLn';
  SYSTEMProc_ReadLn  = 'ReadLn';


  NodeName_Result   =  'Result';

  Literal_Nil        = '0';
  Literal_True       = 'True';
  Literal_False      = 'False';
  Literal_EmptyStr   = '';
  Literal_Zero       = '0';
  Literal_NULL       = 'NULL';


  Value_Success     = 'SUCCESS';
  Value_Error       = 'ERROR';
  Value_Result      = 'Result';

  Value_FOR         = 'FOR';
  Value_FOREACH     = 'FOREACH';
  Value_WHILE       = 'WHILE';
  Value_REPEAT      = 'REPEAT';



  ConfigTag_MainForm = 'MainForm';
  ConfigTag_Editor   = 'Editor';
  ConfigTag_Runtime  = 'Runtime';
  ConfigTag_IDE      = 'IDE';

  Config_PauseOnTerminateRun = 'PauseOnTerminateRun';
  Config_StopOnBreakpoint = 'StopOnBreakpoint';

  Config_LogCalls          = 'LogCalls';
  Config_XMLGen            = 'XMLGen';
  Config_XMLFolder         = 'XMLFolder';
  Config_TraceCalls        = 'TraceCalls';
  Config_TabWidth          = 'TabWidth';
  Config_WordWrap          = 'WordWrap';
  Config_LineSpacing       = 'LineSpacing';
  Config_ViewSpecialChars  = 'ViewSpecialChars';

  Config_Left          = 'Left';
  Config_Top           = 'Top';
  Config_Width         = 'Width';
  Config_Height        = 'Height';
  Config_Maximized     = 'Maximized';
  Config_ShowStatusBar = 'ShowStatusBar';
  Config_ShowMessages  = 'ShowMessages';
  Config_SplitterPos   = 'SplitterPos';
  Config_Name          = 'Name';

  Config_Directory     = 'Directory';
  Config_Parameters    = 'Parameters';


  INFO_NOT_FOR_DISTRIBUTION = 'UNRELEASED - PRIVATE BUILD: NOT FOR DISTRIBUTION';


implementation

//initialization
  //if Build_NO_Marker[1] = '@' then
    //; //Prevent the marker from being eliminated
end.
