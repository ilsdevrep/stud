unit MainUnit;
{ Основной модуль программы }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Spin, ModelDialog, Menus,
  DrawGrafUnit,  TimeDiagramFormUnit, ToolWin, ComCtrls,
  Buttons, GlobalTypes, Devices, Converter,
  ActnList, ImgList, OleCtnrs, jpeg, PrioritetUnit;

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
    Label6: TLabel;
    CountLabel: TLabel;
    OpenDialog: TOpenDialog;
    OpenBitBtn: TBitBtn;
    Label8: TLabel;
    WorkingModeLabel: TLabel;
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
    Panel2: TPanel;
    Label4: TLabel;
    Image1: TImage;
    DiagAction: TAction;
    FindAction: TAction;
    ToolButton2: TToolButton;
    PrioritetCheckBox: TCheckBox;
    PrioritetLabel: TLabel;
    procedure ModelButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure OpenBitBtnClick(Sender: TObject);
    procedure TimeDiagramActionExecute(Sender: TObject);
    procedure N_ExitClick(Sender: TObject);
    procedure DrawFormActionExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StrategyComboBoxChange(Sender: TObject);
    procedure PrioritetCheckBoxClick(Sender: TObject);


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
  i,k : Byte;
  LineCount : Word;
  MinTempTime, MaxTempTime : Word;
begin
  OKModelDlg.Top := MainForm.Top +
                       Round ((MainForm.Height - OKModelDlg.Height)/2);
  OKModelDlg.Left := MainForm.Left +
                       Round ((MainForm.Width - OKModelDlg.Width)/2);
  Int := MainForm.CPUSpinEdit.Value;
  Str ( Int, st );
  OKModelDlg.CPULabel.Caption := st;
  OKModelDlg.Label6.Caption := MainForm.TasksLabel.Caption;
  OKModelDlg.WorkingModeLabel.Caption := MainForm.WorkingModeLabel.Caption;
  OKModelDlg.StrategyLabel.Caption := StrategyComboBox.Text;
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
                Panels[1].Width := 30 + 5*(Length(MainForm.TasksLabel.Caption));
                Panels[1].Text := 'Задачи : ' + MainForm.TasksLabel.Caption;
                if MainForm.PrioritetCheckBox.Checked =True
                 then Panels[2].Text:= 'С приоритетами'
                 else Panels[2].Text:='Без приоритетов';
              end;

            TimeDiagramAction.Enabled := True;
            TimeDiagramFormUnit.CPUQuant := MainForm.CPUSpinEdit.Value;
            TimeDiagramFormUnit.TaskQuant := MainForm.OpenDialog.Files.Count;
            for i := 0 to OpenDialog.Files.Count-1 do
               TimeDiagramFormUnit.Captions[i] := ExcludePath ( OpenDialog.Files[i] );


           { Создается объект - "МВС" }
          try
            DecisionSystem := TDecisionSystem.Create ( MainForm.CPUSpinEdit.Value,
                        MainForm.OpenDialog.Files.Count, MainStrat, MainForm.OpenDialog.Files );
            DecisionSystem.MakeTimeTable;
            DecisionSystem.Run;
            with TimeDiagramForm do
              begin
                Str ( DecisionSystem.CPUKoef :4 :1, st );
                TimeDiagramForm.Label13.Caption := st + ' %';
                StringGrid1.Cells[1,0] := 'Процессор';
                StringGrid1.Cells[0,0] := '     # ';
                StringGrid1.RowCount := CPUSpinEdit.Value + 1 ;
                for i := 1 to StringGrid1.RowCount - 1 do StringGrid1.Cells[0,i] := '    ' + IntToStr (i);
                for i := 1 to StringGrid1.RowCount do
                  begin
                    if i <= DecisionSystem.CPUQuant then
                      begin
                        Str ( DecisionSystem.CPU[i].Koef :4 :1, st );
                        StringGrid1.Cells[1,i] := st
                      end
                    else StringGrid1.Cells[1,i] := '';

                  end;
                StringGrid2.Cells[4,0] := 'Окончание';
                StringGrid2.Cells[3,0] := 'Начало';
                StringGrid2.Cells[2,0] := 'Процессор';
                StringGrid2.Cells[1,0] := 'Узел';
                StringGrid2.Cells[0,0] := 'Задача';
                with DecisionSystem do
                  begin
                    LineCount := 0;
                     for i:=1 to GrafQuant do
                     for k := 1 to Graf[i].VertexQuant do
                      begin
                        LineCount := LineCount + 1;
                        StringGrid2.RowCount := LineCount + 1;
                        StringGrid2.Cells[0, LineCount] := ExcludePath ( MainForm.OpenDialog.Files[i-1] );
                        StringGrid2.Cells[1, LineCount] := IntToStr ( k );
                        StringGrid2.Cells[2, LineCount] := IntToStr ( Graf[i].Vertex[k].CPUNumber );
                        StringGrid2.Cells[3, LineCount] := IntToStr ( Graf[i].Vertex[k].Finish - Graf[i].Vertex[k].DecisionTime );
                        StringGrid2.Cells[4, LineCount] := IntToStr ( Graf[i].Vertex[k].Finish );
                      end;
                    StringGrid3.Cells[0,0] := 'Задача';
                    StringGrid3.Cells[1,0] := 'min';
                    StringGrid3.Cells[2,0] := 'max';
                    StringGrid3.RowCount := DecisionSystem.GrafQuant + 1;
                    MinTempTime := 0;
                    MaxTempTime := 0;
                    for i := 1 to DecisionSystem.GrafQuant do
                      begin
                        StringGrid3.Cells[0,i] := ExcludePath ( MainForm.OpenDialog.Files[i-1] );
                        StringGrid3.Cells[1,i] := IntToStr (DecisionSystem.Graf[i].MinTime);
                        if DecisionSystem.Graf[i].MinTime >  MinTempTime then MinTempTime := DecisionSystem.Graf[i].MinTime;
                        StringGrid3.Cells[2,i] := IntToStr (DecisionSystem.Graf[i].MaxTime);
                        MaxTempTime := MaxTempTime + DecisionSystem.Graf[i].MaxTime;
                      end;
                    Label21.Caption := IntToStr ( MaxTempTime ) + ' MT';
                    Label23.Caption := IntToStr ( MinTempTime ) + ' MT';
                    Chart1.Series[0].Clear;
                    for i := 1 to CPUQuant do
                       Chart1.Series[0].AddXY ( i, CPU[i].Koef, IntToStr(i), clBlue );
                    Chart3.Series[0].Clear;
                    Chart3.Series[1].Clear;
                    for i := 1 to GrafQuant do
                      begin
                        Chart3.Series[0].AddXY ( i, Graf[i].MinTime, ExcludePath ( MainForm.OpenDialog.Files[i-1] ), clBlue );
                        Chart3.Series[1].AddXY ( i, Graf[i].MaxTime, ExcludePath ( MainForm.OpenDialog.Files[i-1] ), clAqua );
                     end;
                  end;

              end;
            TimeDiagramForm.ShowModal;

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
  if StrategyComboBox.Text = 'С  максимальным  количеством  последователей' then MainStrat := MaxChild;


end;




procedure TMainForm.OpenBitBtnClick(Sender: TObject);
{ Нажатие на кнопку "Открыть задачи" }
var
  st, FileStr : string[100];
  i : Byte;
begin
  OpenBitBtn.Hint := 'Открытие задач';
  OpenDialog.Execute;
  try
    if OpenDialog.Files.Count < 2 then
     begin
       WorkingModeLabel.Caption := 'Однозадачный';
       PrioritetCheckBox.Checked :=False;
       PrioritetLabel.Caption:='';
       OKModelDlg.Prioritet.Caption:='';
       PrioritetCheckBox.Enabled :=False;
     end;
    if (OpenDialog.Files.Count >= 2)
     then
       begin
         PrioritetCheckBox.Enabled :=true;
         WorkingModeLabel.Caption := 'Многозадачный ';
         PrioritetLabel.Caption:='без приоритетов';
       end;
    Str ( OpenDialog.Files.Count, st );
    CountLabel.Caption := st;
    TasksLabel.Caption := '';
    for i := 0 to (OpenDialog.Files.Count-1) do
      begin
        TasksLabel.Caption := TasksLabel.Caption + ' ,  ' + DrawGrafUnit.ExcludePath ( OpenDialog.Files[i] );
      end;
    FileStr :=  TasksLabel.Caption;
    Delete ( FileStr, 1, 2 );
    TasksLabel.Caption := FileStr;
    DrawFormAction.Enabled := True;
    Label5.Enabled := True;
    Label6.Enabled := True;
    Label8.Enabled := True;
  except
    DrawFormAction.Enabled := False;
    Label5.Enabled := False;
    Label6.Enabled := False;
    Label8.Enabled := False;
    WorkingModeLabel.Caption := '';
    CountLabel.Caption := '';
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
  i : Byte;
  st : string;
begin
  try
   DrawForm.FileNameStringGrid.RowCount := OpenDialog.Files.Count;
   DrawForm.FileNameStringGrid.Cols[0] := OpenDialog.Files;
   for i := 0 to (OpenDialog.Files.Count-1) do
     begin
       st := OpenDialog.Files[i];
       DrawForm.FileNameStringGrid.Cells[1,i] := ExcludePath ( st );
     end;
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
  if StrategyComboBox.Text = 'С  максимальным  количеством  последователей' then MainStrat := MaxChild;

end;


procedure TMainForm.PrioritetCheckBoxClick(Sender: TObject);
var
   i:Byte;
begin
     if PrioritetCheckBox.Checked =True
     then
         begin
            OKModelDlg.Prioritet.Caption :='  с  приоритетами';
            PrioritetLabel.Caption:='с  приоритетами';
            PrioritetUnit.TaskQuant := MainForm.OpenDialog.Files.Count;
            for i := 0 to OpenDialog.Files.Count-1 do
                PrioritetUnit.Captions[i] := ExcludePath ( OpenDialog.Files[i] );
            PrioritetForm.Show;
            PrioritetFlag:=true;
         end
     else
      begin
        OKModelDlg.Prioritet.Caption :='без приоритетов';
        PrioritetLabel.Caption:='без приоритетов';
        PrioritetFlag:=False;
      end;
end;

end.
