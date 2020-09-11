unit ModelDialog;
{ Реализация диалога "подтверждение моделирования" }
interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, ComCtrls;

type
  TOKModelDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    CPULabel: TLabel;
    StrategyLabel: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure CancelBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OKModelDlg: TOKModelDlg;

implementation

uses MainUnit;

{$R *.DFM}

procedure TOKModelDlg.CancelBtnClick(Sender: TObject);
{ Закрытие диалога при нажатии на кнопку "Нет"}
begin
  Close;
end;

end.
