unit MainUnit;
{ Основной модуль программы }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Spin, ModelDialog, Menus,
  DrawGrafUnit,  TimeDiagramFormUnit, ToolWin, ComCtrls,
  Buttons, GlobalTypes, Devices, Converter,
  ActnList, ImgList,  OleCtnrs, jpeg;

type
  TMainForm = class(TForm)
    DSParamsGroupBox: TGroupBox;
    CPUSpinEdit: TSpinEdit;
    Label3: TLabel;
    StrategyComboBox: TComboBox;
    ModelButton: TButton;
    MainMenu1: TMainMenu;
    N_Graf: TMenuItem;
    N_DrawGraf: TMenuItem;
    N_TimeDiagram: TMenuItem;
    TaskGroupBox: TGroupBox;
    TasksLabel: TLabel;
    Label5: TLabel;
    OpenDialog: TOpenDialog;
    OpenBitBtn: TBitBtn;
    ActionList1: TActionList;
    DrawFormAction: TAction;
    TimeDiagramAction: TAction;
    N_Separ: TMenuItem;
    N_Exit: TMenuItem;
    ModelResultAction: TAction;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    DrawGrafToolButton: TToolButton;
    TimeDiagramToolButton: TToolButton;
    Separ1ToolButton: TToolButton;
    HelpAction: TAction;
    ImageList: TImageList;
    HotImageList: TImageList;
    HelpOleContainer: TOleContainer;
    Panel1: TPanel;
    Bevel1: TBevel;
    Image1: TImage;
    DiagAction: TAction;
    FindAction: TAction;
    ToolButton2: TToolButton;
    Label4: TLabel;
    procedure ModelButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure OpenBitBtnClick(Sender: TObject);
    procedure TimeDiagramActionExecute(Sender: TObject);
    procedure N_ExitClick(Sender: TObject);
    procedure DrawFormActionExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StrategyComboBoxChange(Sender: TObject);
    

  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  MainForm: TMainForm;
  MainStrat : TStrategy;

implementation

{$R *.DFM}




procedure TMainForm.ModelButtonClick(Sender: TObject);
{ Вызывается при нажатии на кнопку "Моделироать".
  При ее нажатии установленные параметры передаются в диалоговое
  окно, затем создается МВС с заданными параметрами.
  Здесь же поверяется, какую кнопку пользователь нажал в диалоговом окне }
var
  st : String;
  Int : Integer;
  i, k : Byte;
  LineCount : Word;
  MinTempTime, MaxTempTime : Word;
begin
  MessageBeep ( 0 );
  OKModelDlg.Top := MainForm.Top +
                       Round ((MainForm.Height - OKModelDlg.Height)/2);
  OKModelDlg.Left := MainForm.Left +
                       Round ((MainForm.Width - OKModelDlg.Width)/2);
  Int := MainForm.CPUSpinEdit.Value;
  Str ( Int, st );
  OKModelDlg.CPULabel.Caption := st;
  OKModelDlg.StrategyLabel.Caption := StrategyComboBox.Text;
  OKModelDlg.Label6.Caption := MainForm.TasksLabel.Caption;
  try
    if DecisionSystem <> nil then
      begin
        DecisionSystem.Destroy;
        DecisionSystem := nil;
      end;
  except
  end;

  case OKModelDlg.ShowModal of
    mrOk : { Начало моделирования }
          begin

            with TimeDiagramForm.StatusBar1 do
              begin
                Panels[0].Text := 'Процессоров : ' +OKModelDlg.CPULabel.Caption;
                Panels[1].Width := 70 + 5*(Length(MainForm.TasksLabel.Caption));
                Panels[1].Text := 'Задача : ' + MainForm.TasksLabel.Caption;
                if  MainStrat = MaxTime then Panels[2].Text:='С максимальным временем выполнения';
                if  MainStrat = MinTime then Panels[2].Text:='С минимальным временем выполнения';
              end;
            TimeDiagramAction.Enabled := True;
            TimeDiagramFormUnit.CPUQuant := MainForm.CPUSpinEdit.Value;
            TimeDiagramFormUnit.Captions[0] := ExcludePath ( OpenDialog.Files[0] );

          { Создается объект - "МВС" }
          try
            DecisionSystem := TDecisionSystem.Create ( MainForm.CPUSpinEdit.Value,
                         MainStrat, MainForm.OpenDialog.Files[0] );
            DecisionSystem.MakeTimeTable;
            DecisionSystem.Run;
            with TimeDiagramForm do
              begin
                DecisionSystem.CPUKoef :=0;
                StringGrid1.Cells[1,0] := 'Процессор';
                StringGrid1.Cells[0,0] := '     # ';
                StringGrid1.RowCount := CPUSpinEdit.Value + 1 ;
                for i := 1 to StringGrid1.RowCount - 1 do StringGrid1.Cells[0,i] := '     '+ IntToStr (i);
                for i := 1 to StringGrid1.RowCount do
                  begin
                    if i <= DecisionSystem.CPUQuant then
                      begin
                        Str ( DecisionSystem.CPU[i].Koef :4 :1, st );
                        StringGrid1.Cells[1,i] :='    '+ st;
                        DecisionSystem.CPUKoef :=DecisionSystem.CPUKoef+DecisionSystem.CPU[i].Koef;
                      end
                    else StringGrid1.Cells[1,i] := '';
                  end;
                DecisionSystem.CPUKoef :=DecisionSystem.CPUKoef/DecisionSystem.CPUQuant;
                Str ( DecisionSystem.CPUKoef :4 :1, st );
                TimeDiagramForm.Label13.Caption := st + ' %';

                StringGrid2.Cells[3,0] := 'Окончание';
                StringGrid2.Cells[2,0] := 'Начало';
                StringGrid2.Cells[1,0] := 'Процессор';
                StringGrid2.Cells[0,0] := 'Узел';
                with DecisionSystem do
                  begin
                    LineCount := 0;
                     for k := 1 to Graf.VertexQuant do
                      begin
                        LineCount := LineCount + 1;
                        StringGrid2.RowCount := LineCount + 1;
                        StringGrid2.Cells[0, LineCount] := IntToStr ( k );
                        StringGrid2.Cells[1, LineCount] := IntToStr ( Graf.Vertex[k].CPUNumber );
                        StringGrid2.Cells[2, LineCount] := IntToStr ( Graf.Vertex[k].Finish -Graf.Vertex[k].DecisionTime );
                        StringGrid2.Cells[3, LineCount] := IntToStr ( Graf.Vertex[k].Finish );
                      end;
                    MinTempTime := 0;
                    MaxTempTime := 0;
                    if DecisionSystem.Graf.MinTime >  MinTempTime then MinTempTime := DecisionSystem.Graf.MinTime;
                    MaxTempTime := MaxTempTime + DecisionSystem.Graf.MaxTime;
                    Label21.Caption := IntToStr ( MaxTempTime ) + ' MT';
                    Label23.Caption := IntToStr ( MinTempTime ) + ' MT';
                    Chart1.Series[0].Clear;
                    for i := 1 to CPUQuant do Chart1.Series[0].AddXY ( i, CPU[i].Koef, IntToStr(i), clBlue );
                    Chart3.Series[0].Clear;
                    Chart3.Series[1].Clear;
                    Chart3.Series[0].AddXY ( 1, Graf.MinTime, ExcludePath ( MainForm.OpenDialog.Files[0] ), clBlue);
                    Chart3.Series[1].AddXY ( 1, Graf.MaxTime, ExcludePath ( MainForm.OpenDialog.Files[0] ), clAqua );

              end;
            TimeDiagramForm.ShowModal;
          end;
          except
             MessageDlg(' Ошибка при создании МВС.'#10#13'Попробуйте изменить набор задач.', mtError,[mbOK], 0);
             OKModelDlg.Close;
          end;
          end;

    mrCancel :
          begin
            try
              if DecisionSystem <> nil then
                begin
                  DecisionSystem.Destroy;
                  DecisionSystem := nil;
                end;
            finally
              DecisionSystem := nil;
              TimeDiagramAction.Enabled := False;
            end;
          end;
  end;

end;


procedure TMainForm.FormActivate(Sender: TObject);
{ Задает первоначальные значения некоторых параметров в осноном окне
  и в диалоговом окне "Начать моделирования работы МВС ?"
  при запуске программы }
var
  st : String;
  Int : Integer;
begin

  OKModelDlg.Top := MainForm.Top +
                       Round ((MainForm.Height - OKModelDlg.Height)/2);
  OKModelDlg.Left := MainForm.Left +
                       Round ((MainForm.Width - OKModelDlg.Width)/2);
  Int := MainForm.CPUSpinEdit.Value;
  Str ( Int, st );
  OKModelDlg.CPULabel.Caption := st;
  OKModelDlg.StrategyLabel.Caption := StrategyComboBox.Text;
  if StrategyComboBox.Text = 'С  максимальным  временем  выполнения' then MainStrat := MaxTime;
  if StrategyComboBox.Text = 'С  минимальным  временем  выполнения'  then MainStrat := MinTime;

end;



procedure TMainForm.OpenBitBtnClick(Sender: TObject);
{ Нажатие на кнопку "Открыть задачи" }


begin
  OpenBitBtn.Hint := 'Открытие задачи';
  OpenDialog.Execute;
  try
    TasksLabel.Caption := DrawGrafUnit.ExcludePath ( OpenDialog.Files[0] );
    DrawFormAction.Enabled := True;
    Label5.Enabled := True;

  except
    DrawFormAction.Enabled := False;
    Label5.Enabled := False;

  end;
  if OpenDialog.Files.Count < 1 then  ModelButton.Enabled := False
    else ModelButton.Enabled := True;
end;





procedure TMainForm.TimeDiagramActionExecute(Sender: TObject);
{ Открытие окна "Временная диаграмма" }
begin
  TimeDiagramForm.ShowModal;
end;




procedure TMainForm.N_ExitClick(Sender: TObject);
{ Выход из программы }
begin
  Close;
end;


procedure TMainForm.DrawFormActionExecute(Sender: TObject);
{ Открытие окна "Изображение графа" и передача в это окно названий файлов,
  открытых в основном окне}
var

  st : string;
begin
 try
   DrawForm.FileNameStringGrid.RowCount := 1;
   DrawForm.FileNameStringGrid.Cols[0] := OpenDialog.Files;
   st := OpenDialog.Files[0];
   DrawForm.FileNameStringGrid.Cells[1,0] := ExcludePath ( st );

  except

  end;
  DrawForm.ShowModal;
end;





procedure TMainForm.FormShow(Sender: TObject);
begin

    Image1.Visible := True;

end;

  
procedure TMainForm.StrategyComboBoxChange(Sender: TObject);
begin
  if StrategyComboBox.Text = 'С  максимальным  временем  выполнения' then MainStrat := MaxTime;
  if StrategyComboBox.Text = 'С  минимальным  временем  выполнения'  then MainStrat := MinTime;
end;


end.
