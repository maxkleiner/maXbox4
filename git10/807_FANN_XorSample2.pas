unit FANN_XorSample_Starter56;
//of FANN Delphi Binding examples

interface

{uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FannNetwork, StdCtrls;    }
  
  //http://leenissen.dk/fann/wp/2015/11/fann-in-research/
  //see report: www.softwareschule.ch/download/maxbox_starter56.pdf

type
  TForm1 = TForm; //)
  var
    btnTrain: TButton;
    LblError: TLabel;
    lblMSE: TLabel;
    btnRun: TButton;
    memoXor: TMemo;
    btnBuild: TBitBtn;
    NN: TFannNetwork;
    procedure TForm1btnTrainClick(Sender: TObject);
    procedure TForm1btnRunClick(Sender: TObject);
    procedure TForm1btnBuildClick(Sender: TObject);
  //private
    { Private declarations }
  //public
    { Public declarations }
  //end;

var
  Form1: TForm1;

implementation

//{$R *.dfm}

procedure TForm1btnTrainClick(Sender: TObject);
var inputs: array [0..1] of single;
    outputs: array [0..0] of single;
    //outputs: array of single;
    
    e,i,j: integer;
    mse: single;
begin

        //Train the network
        for e:=1 to 6000 do //Train ~30000 epochs
        begin

                for i:=0 to 1 do
                begin
                        for j:=0 to 1 do
                        begin
                            inputs[0]:=i;
                            inputs[1]:=j;
                            outputs[0]:=i Xor j;

                            mse:=NN.Train(inputs,outputs);
                            lblMse.Caption:=Format('%.4f',[mse]);
                            //writeln(itoa(e) +': '+Format('%.4f',[mse]));
                            Application.ProcessMessages;

                        end;
                end;
        end;
        
       ShowMessage('Network Training Ended...');
end;

procedure TForm1btnRunClick(Sender: TObject);
var i,j: integer;
    //aoutput: array [0..0] of single;
    inputs: array [0..1] of single;
    //output: array of fann_type;
    //aoutput: Fann_Type_Array;
     aoutput: TFann_Type_Array3;
    
begin

     MemoXOR.Lines.Clear;
     
     setlength(aoutput, 4)
  
     for i:=0 to 1 do
     begin
        for j:=0 to 1 do
        begin
                inputs[0]:=i;
                inputs[1]:=j;
                NN.Run4(inputs,aoutput);
                MemoXor.Lines.Add(Format('%d XOR %d = %f',[i,j,aOutput[0]]));
        end;
     end;
end;

procedure TForm1btnBuildClick(Sender: TObject);
begin
        NN.Build;
        btnBuild.Enabled:=false;
        BtnTrain.Enabled:=true;
        btnRun.Enabled:=true;
        MemoXOR.Lines.add('spec def builded')

end;


procedure BuildNeuroForm;
begin
 Form1:= TForm1.create(self)
 with form1 do begin
  Left := 278 Top := 151
  BorderStyle := bsSingle
  formstyle:= fsstayontop;
  Caption := 'Python Delphi FANN Xor Demo'
  Icon.LoadFromResourceName(HInstance,'NEWREPORT'); //TFANNNETWORK
  ClientHeight := 140
  ClientWidth := 310
  Color := clBtnFace
  Font.Charset := DEFAULT_CHARSET
  Font.Color := clWindowText
  Font.Height := -11
  Font.Name := 'MS Sans Serif'
  Font.Style := []
  OldCreateOrder := False
  Position := poScreenCenter
  PixelsPerInch := 96
  //TextHeight := 13
  Show;
  end;
   LblError:= TLabel.create(self)
   with lblerror do begin
    parent:= form1;
     setBounds( 120, 12,111, 13)
    Caption := 'Mean Square Error:'
    Font.Charset := DEFAULT_CHARSET
    Font.Color := clWindowText
    Font.Height := -11
    Font.Name := 'MS Sans Serif'
    Font.Style := [fsBold]
    ParentFont := False
  end;
  lblMSE:= TLabel.create(self)
  with lblmse do begin
    parent:= form1;
    setBounds( 232, 12 , 5, 13)
    Font.Charset := DEFAULT_CHARSET
    Font.Color := clRed
    Font.Height := -11
    Font.Name := 'MS Sans Serif'
    Font.Style := [fsBold]
    ParentFont := False
  end;
  btnTrain:= TButton.create(self)
  with btntrain do begin
    parent:= form1;
    setbounds(8,56, 97,25)
    Caption := 'Train'
    Enabled := False
    TabOrder := 0
    OnClick := @tform1btnTrainClick;
  end;
  btnRun:= TButton.create(self)
  with btnrun do begin
    parent:= form1
    setBounds( 8,96, 97, 25)
    Caption := 'Run'
    Enabled := False
    TabOrder := 1
    OnClick := @tform1btnRunClick
  end;
  memoXor:= TMemo.create(self)
  with memoXor do begin
    parent:= form1;
    setbounds(120, 32, 169, 89)
    ReadOnly := True
    TabOrder := 2
  end;
  btnBuild:= TBitBtn.create(self)
  with btnbuild do begin
  parent:= form1
    setBounds( 8, 16,97, 25)
    Caption := '&Build'
    glyph.LoadFromRes(getHINSTANCE,'TFANNNETWORK');
    TabOrder := 3
    OnClick := @tform1btnBuildClick;
  end;
  NN:= TFannNetwork.create(self)
  with nn do begin
    {Layers.Strings := (
      '2'
      '3'
      '1') }
    Layers.add('2')
    Layers.add('3')
    Layers.add('1')
      
    LearningRate := 0.699999988079071100
    ConnectionRate := 1.000000000000000000
    TrainingAlgorithm := taFANN_TRAIN_RPROP
    ActivationFunctionHidden := afFANN_SIGMOID
    ActivationFunctionOutput := afFANN_SIGMOID
    //Left := 192
    //Top := 40
  end
end;

begin

 BuildNeuroForm;
 
 //print(getASCII)

End.

//Doc: http://leenissen.dk/fann/wp/language-bindings/

{Doc: TFannNetwork Lib Interface: @author Mauricio Pereira Maia
of unit FannNetwork;
    
{*------------------------------------------------------------------------------
  TFannNetwork Component
-------------------------------------------------------------------------------}
 (* TFannNetwork = class(TComponent)
  private
    ann: PFann;
    pBuilt: boolean;
    pLayers: TStrings;
    pLearningRate: Single;
    pConnectionRate: Single;
    pLearningMomentum: Single;
    pActivationFunctionHidden: Cardinal;
    pActivationFunctionOutput: Cardinal;
    pTrainingAlgorithm: Cardinal;

    procedure SetLayers(const Value: TStrings);

    procedure SetConnectionRate(const Value: Single);
    function GetConnectionRate(): Single;

    procedure SetLearningRate(Const Value: Single);
    function GetLearningRate(): Single;

    procedure SetLearningMomentum(Const Value: Single);
    function GetLearningMomentum(): Single;

    procedure SetTrainingAlgorithm(Value: TTrainingAlgorithm);
    function GetTrainingAlgorithm(): TTrainingAlgorithm;

    procedure SetActivationFunctionHidden(Value: TActivationFunction);
    function GetActivationFunctionHidden(): TActivationFunction;

    procedure SetActivationFunctionOutput(Value: TActivationFunction);
    function GetActivationFunctionOutput(): TActivationFunction;

    function GetMSE(): Single;

    function EnumActivationFunctionToValue(Value: TActivationFunction): Cardinal;
    function ValueActivationFunctionToEnum(Value: Cardinal): TActivationFunction;

    function EnumTrainingAlgorithmToValue(Value: TTrainingAlgorithm): Cardinal;
    function ValueTrainingAlgorithmToEnum(Value: Cardinal): TTrainingAlgorithm;

  public
    constructor Create(Aowner: TComponent); override;
    destructor Destroy(); override;
    procedure Build();
    procedure UnBuild();
    function Train(Input: array of fann_type; Output: array of fann_type): single;
    procedure TrainOnFile(FileName: String; MaxEpochs: Cardinal; DesiredError: Single);
    procedure Run(Inputs: array of fann_type; var Outputs: array of fann_type);
    procedure SaveToFile(FileName: String);
    procedure LoadFromFile(Filename: string);
    // adapt to maXbox4 for strong typing 
    procedure Run4(Inputs: array of fann_type; var Outputs: TFann_Type_Array3);

    {*------------------------------------------------------------------------------
     Pointer to the Fann object.
     If you need to call the fann library directly and skip the Delphi Component.
    -------------------------------------------------------------------------------}
    property FannObject: PFann read ann;
  published

    {*------------------------------------------------------------------------------
     Network Layer Structure. Each line need to have the number of neurons
        of the layer.
        2
        4
        1
        Will make a three layered network with 2 input neurons, 4 hidden neurons
        and 1 output neuron.
   -------------------------------------------------------------------------------}
    property Layers: TStrings read PLayers write SetLayers;

    {*------------------------------------------------------------------------------
     Network Learning Rate.
    -------------------------------------------------------------------------------}
    property LearningRate: Single read GetLearningRate write SetLearningRate;

    {*------------------------------------------------------------------------------
     Network Connection Rate. See the FANN docs for more info.
    -------------------------------------------------------------------------------}
    property ConnectionRate: Single read GetConnectionRate write SetConnectionRate;

    {*------------------------------------------------------------------------------
     Network Learning Momentum. See the FANN docs for more info.
    -------------------------------------------------------------------------------}
    property LearningMometum: single read GetLearningMomentum write SetLearningMomentum;

    {*------------------------------------------------------------------------------
     Fann Network Mean Square Error. See the FANN docs for more info.
    -------------------------------------------------------------------------------}
    property MSE: Single read GetMSE;

    {*------------------------------------------------------------------------------
     Training Algorithm used by the network. See the FANN docs for more info.
    -------------------------------------------------------------------------------}
    property TrainingAlgorithm: TTrainingAlgorithm read GetTrainingAlgorithm write SetTrainingAlgorithm;

    {*------------------------------------------------------------------------------
     Activation Function used by the hidden layers. See the FANN docs for more info.
    -------------------------------------------------------------------------------}
    property ActivationFunctionHidden: TActivationFunction read GetActivationFunctionHidden write SetActivationFunctionHidden;

    {*------------------------------------------------------------------------------
     Activation Function used by the output layers. See the FANN docs for more info.
    -------------------------------------------------------------------------------}
    property ActivationFunctionOutput: TActivationFunction read GetActivationFunctionOutput write SetActivationFunctionOutput;

end;
 
 Performance Abstract:
 
 While training the ANN is often the big time consumer, execution can often be more time consuming, especially in systems where the ANN needs to be executed hundreds of times per second or if the ANN is very large. For this reason, several measures can be applied to make the FANN library execute even faster than it already does. One method is to change the activation function to use a stepwise linear activation function, which is faster to execute, but which is also a bit less precise. It is also a good idea to reduce the number of hidden neurons if possible, since this will reduce the execution time. from <fann_en.pdf> *)  

