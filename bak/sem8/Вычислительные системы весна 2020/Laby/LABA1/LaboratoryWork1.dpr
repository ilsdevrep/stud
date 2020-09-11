program LaboratoryWork1;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  ModelDialog in 'ModelDialog.pas' {OKModelDlg},
  TimeDiagramFormUnit in 'TimeDiagramFormUnit.pas' {TimeDiagramForm},
  DrawGrafUnit in 'DrawGrafUnit.pas' {DrawForm},
  Converter in 'Converter.pas',
  GlobalTypes in 'GlobalTypes.pas',
  Devices in 'Devices.pas';


{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Моделирование МВС';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TOKModelDlg, OKModelDlg);
  Application.CreateForm(TTimeDiagramForm, TimeDiagramForm);
  Application.CreateForm(TDrawForm, DrawForm);
  Application.Run;
end.
