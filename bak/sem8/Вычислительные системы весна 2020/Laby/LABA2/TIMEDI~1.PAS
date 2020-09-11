unit TimeDiagramFormUnit;
{ Временная диаграмма}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, ToolWin, StdCtrls, Buttons, ActnList, Devices,
  ImgList, Menus, Grids, TeEngine, Series, TeeProcs, Chart;

type
  TTimeDiagramForm = class(TForm)
    StatusBar1: TStatusBar;
    ActionList1: TActionList;
    LargeAction: TAction;
    SmallAction: TAction;
    Panel3: TPanel;
    Panel4: TPanel;
    Splitter1: TSplitter;
    ScrollBox1: TScrollBox;
    PaintBox1: TPaintBox;
    ScrollBox2: TScrollBox;
    Label1: TLabel;
    TrackBar1: TTrackBar;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Bevel1: TBevel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Panel11: TPanel;
    StringGrid1: TStringGrid;
    ScrollBox3: TScrollBox;
    Label16: TLabel;
    Bevel2: TBevel;
    Label17: TLabel;
    Panel12: TPanel;
    StringGrid2: TStringGrid;
    ScrollBox4: TScrollBox;
    Label10: TLabel;
    Bevel3: TBevel;
    StringGrid3: TStringGrid;
    Panel13: TPanel;
    ScrollBox5: TScrollBox;
    Label11: TLabel;
    Label18: TLabel;
    Label24: TLabel;
    Bevel4: TBevel;
    Label25: TLabel;
    Panel14: TPanel;
    Panel15: TPanel;
    Label26: TLabel;
    Chart1: TChart;
    Series1: TBarSeries;
    Panel17: TPanel;
    Label13: TLabel;
    Label12: TLabel;
    Splitter2: TSplitter;
    Bevel5: TBevel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Panel18: TPanel;
    Label28: TLabel;
    Chart3: TChart;
    Series3: TBarSeries;
    Series4: TBarSeries;
    Memo1: TMemo;
    CheckBox2: TCheckBox;
    Panel16: TPanel;
    Label2: TLabel;
    Panel1: TPanel;
    Label3: TLabel;
    Panel2: TPanel;
    Label4: TLabel;
    Panel5: TPanel;
    Label5: TLabel;
    Panel6: TPanel;
    Label6: TLabel;
    Panel7: TPanel;
    Label7: TLabel;
    Panel8: TPanel;
    Label8: TLabel;
    Panel9: TPanel;
    Label9: TLabel;
    Panel10: TPanel;
    procedure TrackBar1Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure LargeActionExecute(Sender: TObject);
    procedure SmallActionExecute(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure DrawInfo;
    procedure CheckBox2Click(Sender: TObject);


    
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  Step = 60; // Расстояние между строками

type
  TMode = ( CPU ); // Вид строки

  TInfoLine = class
    public
      Y : Integer;
      Info : Array of TStatArr;
      LineMode : TMode;
      Caption : string[100];
      Number : Byte;
      constructor Create ( Num, ComNum : Byte; Mode : TMode );
      procedure DrawCaption;
      procedure DrawResult;
  end;

var
  TimeDiagramForm: TTimeDiagramForm;
  CPUQuant: Byte;
  Line : Array of TInfoLine;
  Order : Word;
  Size : Word;
  TaskQuant : Byte;
  Captions : Array [0..7] of string;


implementation

{$R *.DFM}



procedure TInfoLine.DrawCaption;
begin
  with  TimeDiagramForm.PaintBox1.Canvas do
    begin
      Font.Color := clBlack;
      Font.Style := [fsBold];
      Font.Height := 10;
      Brush.Color := $00379178;
      TextOut ( 10, Y , Caption );
    end;
end;





constructor TInfoLine.Create ( Num, ComNum : Byte; Mode : TMode );
var
  StNumber : string[2];
  i : Word;
begin
  Str ( Num, StNumber );
 case Mode of

  CPU :
      begin
        SetLength ( Info, High (DecisionSystem.CPU[Num].StatArr) + 1 );
        for i := 1 to High (DecisionSystem.CPU[Num].StatArr) do
                Info[i] := Devices.DecisionSystem.CPU[Num].StatArr[i];
        Caption := ' Процессор ' + StNumber;
        LineMode := CPU;
        Number := Num;
      end;

  end;
  Y := ComNum * Step;
end;





procedure TTimeDiagramForm.TrackBar1Change(Sender: TObject);
begin
  PaintBox1.Width := Size * TrackBar1.Position;
  DrawInfo;
end;




procedure TTimeDiagramForm.DrawInfo;
var
  i : Word;
begin
  Size := DecisionSystem.FinalTime * TrackBar1.Position * 5 + 30 + 120;
  PaintBox1.Width := Size;
  PaintBox1.Height := ( CPUQuant  ) * Step + Step;
  Order := 1;
  for i := 1 to CPUQuant do
    begin
      SetLength ( Line, Order );
      Line[Order-1] := TInfoLine.Create ( i, Order, CPU );
      Line[Order-1].DrawCaption;
      Line[Order-1].DrawResult;
      Order := Order + 1;
    end;
end;



procedure TTimeDiagramForm.FormActivate(Sender: TObject);
var
  st : string[6];
  i : Byte;
begin
  DrawInfo;
   for i := 0 to 7 do
    begin
      Panel16.Controls[i+8].Visible :=False ;
      Panel16.Controls[i].Visible := False;
    end;
  for i := 0 to TaskQuant-1 do
    begin
      Panel16.Controls[i+8].Visible := True;
      Panel16.Controls[i].Visible := True;
    end;
  Label2.Caption := Captions[0];
  Label3.Caption := Captions[1];
  Label4.Caption := Captions[2];
  Label5.Caption := Captions[3];
  Label6.Caption := Captions[4];
  Label7.Caption := Captions[5];
  Label8.Caption := Captions[6];
  Label9.Caption := Captions[7];

  Str ( DecisionSystem.FinalTime, st );
  Label18.Caption := st + ' МТ';
end;




procedure TTimeDiagramForm.LargeActionExecute(Sender: TObject);
begin
  if TrackBar1.Position < 4 then
    begin
      TrackBar1.Position := TrackBar1.Position + 1;
      PaintBox1.Width := Size * TrackBar1.Position;
      DrawInfo;
    end;
end;




procedure TTimeDiagramForm.SmallActionExecute(Sender: TObject);
begin
   if TrackBar1.Position > 1 then
    begin
      TrackBar1.Position := TrackBar1.Position - 1;
      PaintBox1.Width := Size * TrackBar1.Position;
      DrawInfo;
    end;
end;



procedure TInfoLine.DrawResult;
const
  MoveDown = 15;
var
  i, k : Word;
  st : string[3];
  Blok : TRect;
begin
  with TimeDiagramForm.PaintBox1.Canvas do
    begin
    Pen.Width := 1;
      Pen.Color := clBlack;
      MoveTo ( 120, Y + MoveDown );
      LineTo ( TimeDiagramForm.PaintBox1.Width , Y + MoveDown );
      k := 0;
      i := 120;
      while i < TimeDiagramForm.PaintBox1.Width - 30 do
        begin
          Pen.Width := 1;
          k := k + 1;
          MoveTo ( i, Y + MoveDown );
          LineTo ( i, Y + MoveDown + 10 );
          i := i + TimeDiagramForm.TrackBar1.Position * 5;
          Str ( (k-1), st );
          Brush.Color := $00379178;
          Font.Color := clBlack;
          Font.Style := [];
          Font.Height := 8;
          TextOut ( i - TimeDiagramForm.TrackBar1.Position * 5 + 1, Y + MoveDown + 10, st );
          k := k + 1;
          MoveTo ( i, Y + MoveDown );
          LineTo ( i, Y + MoveDown + 5 );
          i := i + TimeDiagramForm.TrackBar1.Position * 5;
          k := k + 1;
          MoveTo ( i, Y + MoveDown );
          LineTo ( i, Y + MoveDown + 5 );
          i := i + TimeDiagramForm.TrackBar1.Position * 5;
          k := k + 1;
          MoveTo ( i, Y + MoveDown );
          LineTo ( i, Y + MoveDown + 5 );
          i := i + TimeDiagramForm.TrackBar1.Position * 5;
          k := k + 1;
          MoveTo ( i, Y + MoveDown );
          LineTo ( i, Y + MoveDown + 5 );
          i := i + TimeDiagramForm.TrackBar1.Position * 5;
        end;
      i := 1;
      k := 120;
      while i <=  High ( Info ) do
        begin
          if (Info[i].Stat = Busy)  then
            begin
              Blok.TopLeft.x := k;
              Blok.TopLeft.y := Y - 5;
              Blok.BottomRight.x := k + TimeDiagramForm.TrackBar1.Position * 5;
              Blok.BottomRight.y := Y + 13;
              Brush.Style := bsSolid;
               case Info[i].Vert.g of
                      1 : Brush.Color := clBlue;
                      2 : Brush.Color := clLime;
                      3 : Brush.Color := clRed;
                      4 : Brush.Color := clTeal;
                      5 : Brush.Color := clYellow;
                      6 : Brush.Color := clFuchsia;
                      7 : Brush.Color := clAqua;
                      8 : Brush.Color := clPurple;
                end;
               FillRect ( Blok );
               MoveTo ( Blok.TopLeft.x, Blok.TopLeft.y );
               Pen.Width := 1;
               Pen.Color := clWhite;
               LineTo ( Blok.BottomRight.x, Blok.TopLeft.y );
               MoveTo ( Blok.TopLeft.x, Blok.BottomRight.y );
               Pen.Color := clGray;
               Pen.Width := 2;
               LineTo ( Blok.BottomRight.x, Blok.BottomRight.y );
               if ( Info[i].Vert.v <> Info[i - 1].Vert.v ) or
                  ( Info[i - 1].Vert.v = 0 ) or
                  ( Info[i - 1].Vert.g = 0 ) or
                  ( Info[i].Vert.g <> Info[i - 1].Vert.g ) or
                  ( Info[i].Stat <> Info[i-1].Stat )
                  then
                   begin
                     MoveTo ( Blok.TopLeft.x, Blok.TopLeft.y );
                     Pen.Width := 1;
                     Pen.Color := clWhite;
                     LineTo ( Blok.TopLeft.x, Blok.BottomRight.y );
                     if Info[i-1].Stat = Busy then
                       begin
                         MoveTo ( Blok.TopLeft.x-1, Blok.TopLeft.y );
                         Pen.Width := 2;
                         Pen.Color := clGray;
                         LineTo ( Blok.TopLeft.x-1, Blok.BottomRight.y );
                       end;
                     if TimeDiagramForm.TrackBar1.Position >= 3 then
                       begin
                         Pen.Width := 1;
                         Font.Color := clBlack;
                         Font.Style := [fsBold];
                         Font.Height := 10;
                         Str ( Info[i].Vert.v, st );
                         TextOut ( Blok.TopLeft.x + 1, Blok.TopLeft.y + 1, st );
                       end;
                   end;
             end;
          if (Info[i].Stat = Busy) and (Info[i+1].Stat <> Busy) then
            begin
              MoveTo ( Blok.BottomRight.x, Blok.TopLeft.y );
              Pen.Width := 2;
              Pen.Color := clGray;
              LineTo ( Blok.BottomRight.x, Blok.BottomRight.y );
            end;
          k := k + TimeDiagramForm.TrackBar1.Position * 5;
          i := i + 1;
        end;
    end;

end;

procedure TTimeDiagramForm.PaintBox1Paint(Sender: TObject);
begin
  DrawInfo;
end;



procedure TTimeDiagramForm.CheckBox2Click(Sender: TObject);
begin
  Splitter1.Visible := not ( Splitter1.Visible );
  Panel4.Visible := not ( Panel4.Visible );
  if Panel4.Visible then Panel4.Height := 240;
end;




end.
