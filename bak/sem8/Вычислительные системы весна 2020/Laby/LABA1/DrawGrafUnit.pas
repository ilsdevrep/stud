unit DrawGrafUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, Grids, StdCtrls, ExtCtrls, ComCtrls, ToolWin, GlobalTypes,
  Devices, Converter, OleCtnrs;

type
  TDrawForm = class(TForm)
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    CritWayToolButton: TToolButton;
    Panel1: TPanel;
    PaintBox1: TPaintBox;
    TaskComboBox: TComboBox;
    ToolButton3: TToolButton;
    FileNameStringGrid: TStringGrid;
    VertexImageList: TImageList;
    ButtonImageList: TImageList;
    HotButtonImageList: TImageList;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    Panel3: TPanel;
    Panel4: TPanel;
    Memo2: TMemo;
    Memo3: TMemo;
    procedure FormActivate(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure CritWayToolButtonClick(Sender: TObject);


  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DrawForm: TDrawForm;
  FileName : string;
  TempGraf : TGraf;
  CritWayFlag : Boolean;{ Если True, то граф перерисовывается с критическим путем }

  function ExcludePath ( Str : string ) : string;
 { Убирает из названия файла путь. Данная процедура также используется в
   модуле MainUnit }

implementation

{$R *.DFM}

function ExcludePath ( Str : string ) : string;
 { Убирает из названия файла путь. Данная процедура также используется в
   модуле MainUnit }
var
  st, i : Byte;
begin
  st := Length ( Str );
  i := st;
  while Str[i] <> '\'  do
    begin
      i := i - 1;
    end;
  Result := Copy ( Str, (i+1), (st-i) );

end;




procedure TDrawForm.FormActivate(Sender: TObject);
{ Считывание информации из таблицы имен }
begin
  TaskComboBox.Items := FileNameStringGrid.Cols[1];
  TaskComboBox.Text := TaskComboBox.Items[0];
  CritWayFlag := False;
end;


procedure TDrawForm.PaintBox1Paint(Sender: TObject);
{ Перерисовка графа }
var
  i : Byte;
begin
  for i := 0 to (FileNameStringGrid.RowCount-1) do
  if TaskComboBox.Text = FileNameStringGrid.Cells[1,i] then
    begin
     try
      TempGraf := Convert ( FileNameStringGrid.Cells[0,i] );
      if CritWayFlag then TempGraf.SetCritWay;
      TempGraf.DrawGraf ( PaintBox1, VertexImageList );
      Break;
     except
        MessageDlg(' Один из открытых .dat-файлов'#13#10'имеет недопустимые символы', mtError,[mbOK], 0);
        DrawForm.Close;
     end;
    end    else Continue;
end;



procedure TDrawForm.CritWayToolButtonClick(Sender: TObject);
{ Изображение критического пути }
var
  i : Byte;
begin
    CritWayFlag := True;
    TempGraf := Convert ( FileNameStringGrid.Cells[0,i] );
    TempGraf.SetCritWay;
    TempGraf.DrawGraf ( PaintBox1, VertexImageList );
    PaintBox1.Refresh;

end;


end.
