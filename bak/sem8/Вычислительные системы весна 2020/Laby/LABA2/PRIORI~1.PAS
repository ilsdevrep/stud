unit PrioritetUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ExtCtrls;

type
  TPrioritetForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Button1: TButton;
    Button2: TButton;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    SpinEdit5: TSpinEdit;
    SpinEdit6: TSpinEdit;
    SpinEdit7: TSpinEdit;
    SpinEdit8: TSpinEdit;
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PrioritetForm: TPrioritetForm;
  TaskQuant : Byte;
  Captions : Array [0..7] of string;
  Prior: Array [1..8] of Byte; // массив приоритетов
  PrioritetFlag:Boolean;  //флаг, равен true, если используются приоритеты

implementation

uses MainUnit;



{$R *.DFM}





procedure TPrioritetForm.Button2Click(Sender: TObject);
begin
   close;
   MainForm.PrioritetCheckBox.Checked:=False;
end;


procedure TPrioritetForm.FormActivate(Sender: TObject);
var
   i:Byte;
begin
  PrioritetForm.Top := MainForm.Top +
                       Round ((MainForm.Height - PrioritetForm.Height)/2);
  PrioritetForm.Left := MainForm.Left +
                       Round ((MainForm.Width - PrioritetForm.Width)/2);
 for i := 0 to 7 do
    begin
      Panel2.Controls[i+8].Visible :=False ;
      Panel2.Controls[i].Visible := False;
    end;
  for i := 0 to TaskQuant-1 do
    begin
      Panel2.Controls[i+8].Visible := True;
      Panel2.Controls[i].Visible := True;
    end;
  Label1.Caption := Captions[0];
  Label2.Caption := Captions[1];
  Label3.Caption := Captions[2];
  Label4.Caption := Captions[3];
  Label5.Caption := Captions[4];
  Label6.Caption := Captions[5];
  Label7.Caption := Captions[6];
  Label8.Caption := Captions[7];

end;

procedure TPrioritetForm.Button1Click(Sender: TObject);
var
   i : Byte;
begin
   Prior[1]:=SpinEdit1.Value;
   Prior[2]:=SpinEdit2.Value;
   Prior[3]:=SpinEdit3.Value;
   Prior[4]:=SpinEdit4.Value;
   Prior[5]:=SpinEdit5.Value;
   Prior[6]:=SpinEdit6.Value;
   Prior[7]:=SpinEdit7.Value;
   Prior[8]:=SpinEdit8.Value;
   PrioritetForm.close;

end;


end.
