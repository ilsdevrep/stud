
unit U1labor1_3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Buttons, Mask, Grids, Spin, ExtCtrls;

type
  TFormlabor1 = class(TForm)
    PageControl1: TPageControl;
    neue_Page: TTabSheet;
    KPUF_Page: TTabSheet;
    Rechnen_Page: TTabSheet;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    P1: TEdit;
    P2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    BitBtn1: TBitBtn;
    Label4: TLabel;
    Label5: TLabel;
    Editk: TEdit;
    UpDown1: TUpDown;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    EditN: TEdit;
    CheckBox3: TCheckBox;
    Label9: TLabel;
    Label10: TLabel;
    EditPp: TEdit;
    NeueOK: TBitBtn;
    Neueclear: TBitBtn;
    MemoNeue: TMemo;
    Memo1: TMemo;
    Input: TBitBtn;
    UpDown2: TUpDown;
    TabSheet1: TTabSheet;
    ClearBtn: TBitBtn;
    Zad: TTabSheet;
    RG1: TRadioGroup;
    SG: TStringGrid;
    Image1: TImage;
    Image2: TImage;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    procedure EditNKeyPress(Sender: TObject; var Key: Char);
    procedure EditPpKeyPress(Sender: TObject; var Key: Char);
    procedure NeueclearClick(Sender: TObject);
    procedure NeueOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure EditkKeyPress(Sender: TObject; var Key: Char);
    procedure InputClick(Sender: TObject);
    procedure EditkChange(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure RG1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    gleiche:boolean; // булева переменная, равна "true", если вероятности
                     // безотказной работы у всех устройств одинаковы
    N,kpufN,Nrs: integer;   // число устройств в системе, число КПУФ и число РС
    Pp:array[0..20] of real;// массив вероятностей безотказной работы устройств
    kpuf     :array [0..100] of string; // массив КПУФ
    rs       :array [0..1000] of string;// массив РС
    procedure malenA();
    procedure malenB();
    procedure malenC();
    procedure malenD();
    procedure malenE();
  end;

var
  Formlabor1: TFormlabor1;

implementation
{$R *.DFM}

// процедура изображения на странице Zad PageControl1
// варианта "а" исследуемой структуры
procedure TFormlabor1.malenA();
begin
   Image1.Canvas.Pen.Width:=1;          // установили толщину карандаша =1
   Image1.Canvas.Brush.Color:=clMenu;   // установили цвет кисти
   // очистили область для рисования
   Image1.Canvas.FillRect(Rect(0,0,305,225));
   refresh;
   // рисуем схему надежности
   Image1.Canvas.MoveTo(1,50);   Image1.Canvas.LineTo(290,50);
   Image1.Canvas.MoveTo(20,50);  Image1.Canvas.LineTo(20,170);
   Image1.Canvas.LineTo(260,170); Image1.Canvas.LineTo(260,50);
   Image1.Canvas.MoveTo(20,110);  Image1.Canvas.LineTo(100,110);
   Image1.Canvas.LineTo(100,50);
   Image1.Canvas.MoveTo(150,50);  Image1.Canvas.LineTo(150,170);
   Image1.Canvas.Rectangle(40,35,80,65);
   Image1.Canvas.Rectangle(190,35,230,65);
   Image1.Canvas.Rectangle(40,95,80,125);
   Image1.Canvas.Rectangle(130,95,170,125);
   Image1.Canvas.Rectangle(240,95,280,125);
   Image1.Canvas.Rectangle(40,155,80,185);
   Image1.Canvas.Rectangle(190,155,230,185);
   // "номеруем" устройства
   Image1.Canvas.TextOut(55,45,'1');  Image1.Canvas.TextOut(55,105,'2');
   Image1.Canvas.TextOut(55,165,'3'); Image1.Canvas.TextOut(145,105,'4');
   Image1.Canvas.TextOut(205,45,'5'); Image1.Canvas.TextOut(205,165,'6');
   Image1.Canvas.TextOut(255,105,'7');
   Image1.Canvas.Pen.Width:=2;   // установили толщину карандаша =2
   //расставляем точки на местах пересечений
   Image1.Canvas.Ellipse(19,49,22,52);   Image1.Canvas.Ellipse(19,109,22,112);
   Image1.Canvas.Ellipse(99,49,102,52);  Image1.Canvas.Ellipse(19,49,22,52);
   Image1.Canvas.Ellipse(149,49,152,52); Image1.Canvas.Ellipse(149,169,152,172);
   Image1.Canvas.Ellipse(259,49,262,52);
end;

// процедура изображения на странице Zad PageControl1
// варианта "б" исследуемой структуры
procedure TFormlabor1.malenB();
begin
   Image1.Canvas.Pen.Width:=1;         // установили толщину карандаша =1
   Image1.Canvas.Brush.Color:=clMenu;  // установили цвет кисти
   // очистили область для рисования
   Image1.Canvas.FillRect(Rect(0,0,305,225));
   refresh;
   // рисуем схему надежности
   Image1.Canvas.MoveTo(1,40);   Image1.Canvas.LineTo(290,40);
   Image1.Canvas.MoveTo(20,40);  Image1.Canvas.LineTo(20,170);
   Image1.Canvas.LineTo(260,170); Image1.Canvas.LineTo(260,40);
   Image1.Canvas.MoveTo(260,105); Image1.Canvas.LineTo(120,105);
   Image1.Canvas.MoveTo(120,40);  Image1.Canvas.LineTo(120,170);
   Image1.Canvas.Rectangle(40,25,80,55);
   Image1.Canvas.Rectangle(40,155,80,185);
   Image1.Canvas.Rectangle(170,25,210,55);
   Image1.Canvas.Rectangle(170,90,210,120);
   Image1.Canvas.Rectangle(100,60,140,90);
   Image1.Canvas.Rectangle(100,120,140,150);
   Image1.Canvas.Rectangle(170,155,210,185);
   // "номеруем" устройства
   Image1.Canvas.TextOut(55,35,'1');  Image1.Canvas.TextOut(55,160,'2');
   Image1.Canvas.TextOut(115,70,'3'); Image1.Canvas.TextOut(115,130,'4');
   Image1.Canvas.TextOut(185,35,'5'); Image1.Canvas.TextOut(185,100,'6');
   Image1.Canvas.TextOut(185,160,'7');
   Image1.Canvas.Pen.Width:=2;  // установили толщину карандаша =2
   //расставляем точки на местах пересечений
   Image1.Canvas.Ellipse(19,39,22,42);  Image1.Canvas.Ellipse(119,39,122,42);
   Image1.Canvas.Ellipse(259,39,262,42);Image1.Canvas.Ellipse(119,104,122,107);
   Image1.Canvas.Ellipse(119,169,122,172);Image1.Canvas.Ellipse(259,104,262,107);
end;

// процедура изображения на странице Zad PageControl1 
// варианта "в" исследуемой структуры
procedure TFormlabor1.malenC();
begin
   Image1.Canvas.Pen.Width:=1;        // установили толщину карандаша =1
   Image1.Canvas.Brush.Color:=clMenu; // установили цвет кисти
   // очистили область для рисования
   Image1.Canvas.FillRect(Rect(0,0,305,225));
   refresh;
   // рисуем схему надежности
   Image1.Canvas.MoveTo(1,50);   Image1.Canvas.LineTo(290,50);
   Image1.Canvas.MoveTo(30,50);  Image1.Canvas.LineTo(30,170);
   Image1.Canvas.LineTo(260,170); Image1.Canvas.LineTo(260,50);
   Image1.Canvas.MoveTo(145,50);  Image1.Canvas.LineTo(145,80);
   Image1.Canvas.MoveTo(105,170); Image1.Canvas.LineTo(105,80);
   Image1.Canvas.LineTo(185,80);  Image1.Canvas.LineTo(185,170);
   Image1.Canvas.Rectangle(10,100,50,130);
   Image1.Canvas.Rectangle(60,35,100,65);
   Image1.Canvas.Rectangle(190,35,230,65);
   Image1.Canvas.Rectangle(125,155,165,185);
   Image1.Canvas.Rectangle(240,100,280,130);
   Image1.Canvas.Rectangle(85,100,125,130);
   Image1.Canvas.Rectangle(165,100,205,130);
   // "номеруем" устройства
   Image1.Canvas.TextOut(25,110,'1');  Image1.Canvas.TextOut(75,45,'2');
   Image1.Canvas.TextOut(100,110,'3'); Image1.Canvas.TextOut(140,165,'4');
   Image1.Canvas.TextOut(205,45,'5'); Image1.Canvas.TextOut(180,110,'6');
   Image1.Canvas.TextOut(255,110,'7');
   Image1.Canvas.Pen.Width:=2;  // установили толщину карандаша =2
   //расставляем точки на местах пересечений
   Image1.Canvas.Ellipse(29,49,32,52);   Image1.Canvas.Ellipse(144,49,147,52);
   Image1.Canvas.Ellipse(259,49,262,52); Image1.Canvas.Ellipse(144,79,147,82);
   Image1.Canvas.Ellipse(104,169,107,172);
   Image1.Canvas.Ellipse(184,169,187,172);
end;

// процедура изображения на странице Zad PageControl1
// варианта "г" исследуемой структуры
procedure TFormlabor1.malenD();
begin
   Image1.Canvas.Pen.Width:=1;         // установили толщину карандаша =1
   Image1.Canvas.Brush.Color:=clMenu;  // установили цвет кисти
   // очистили область для рисования
   Image1.Canvas.FillRect(Rect(0,0,305,225));
   refresh;
   // рисуем схему надежности
   Image1.Canvas.MoveTo(1,90);   Image1.Canvas.LineTo(290,90);
   Image1.Canvas.MoveTo(20,90);  Image1.Canvas.LineTo(20,190);
   Image1.Canvas.LineTo(190,190); Image1.Canvas.LineTo(190,90);
   Image1.Canvas.MoveTo(270,90); Image1.Canvas.LineTo(270,40);
   Image1.Canvas.LineTo(105,40);  Image1.Canvas.LineTo(105,190);
   Image1.Canvas.Rectangle(40,75,80,105);
   Image1.Canvas.Rectangle(130,75,170,105);
   Image1.Canvas.Rectangle(210,75,250,105);
   Image1.Canvas.Rectangle(130,25,170,55);
   Image1.Canvas.Rectangle(85,120,125,150);
   Image1.Canvas.Rectangle(40,175,80,205);
   Image1.Canvas.Rectangle(130,175,170,205);
   // "номеруем" устройства
   Image1.Canvas.TextOut(55,85,'1');   Image1.Canvas.TextOut(55,185,'2');
   Image1.Canvas.TextOut(100,130,'3'); Image1.Canvas.TextOut(145,85,'4');
   Image1.Canvas.TextOut(145,185,'5');Image1.Canvas.TextOut(145,35,'6');
   Image1.Canvas.TextOut(225,85,'7');
   Image1.Canvas.Pen.Width:=2;   // установили толщину карандаша =2
   //расставляем точки на местах пересечений
   Image1.Canvas.Ellipse(19,89,22,92);   Image1.Canvas.Ellipse(104,89,107,92);
   Image1.Canvas.Ellipse(189,89,192,92);  Image1.Canvas.Ellipse(269,89,272,92);
   Image1.Canvas.Ellipse(104,189,107,192);
end;

// процедура изображения на странице Zad PageControl1
// варианта "д" исследуемой структуры
procedure TFormlabor1.malenE();
begin
   Image1.Canvas.Pen.Width:=1;         // установили толщину карандаша =1
   Image1.Canvas.Brush.Color:=clMenu;  // установили цвет кисти
   // очистили область для рисования
   Image1.Canvas.FillRect(Rect(0,0,305,225));
   refresh;
   // рисуем схему надежности
   Image1.Canvas.MoveTo(1,30);   Image1.Canvas.LineTo(290,30);
   Image1.Canvas.MoveTo(20,30);  Image1.Canvas.LineTo(20,190);
   Image1.Canvas.LineTo(260,190); Image1.Canvas.LineTo(260,30);
   Image1.Canvas.MoveTo(20,75);  Image1.Canvas.LineTo(160,75);
   Image1.Canvas.MoveTo(20,145);  Image1.Canvas.LineTo(160,145);
   Image1.Canvas.MoveTo(160,30);  Image1.Canvas.LineTo(160,190);
   Image1.Canvas.Rectangle(50,15,90,45);
   Image1.Canvas.Rectangle(190,15,230,45);
   Image1.Canvas.Rectangle(50,60,90,90);
   Image1.Canvas.Rectangle(50,130,90,160);
   Image1.Canvas.Rectangle(50,175,90,205);
   Image1.Canvas.Rectangle(140,95,180,125);
   Image1.Canvas.Rectangle(190,175,230,205);
   // "номеруем" устройства
   Image1.Canvas.TextOut(65,25,'1');  Image1.Canvas.TextOut(65,70,'2');
   Image1.Canvas.TextOut(65,140,'3'); Image1.Canvas.TextOut(65,185,'4');
   Image1.Canvas.TextOut(155,105,'5'); Image1.Canvas.TextOut(205,25,'6');
   Image1.Canvas.TextOut(205,185,'7');
   Image1.Canvas.Pen.Width:=2;  // установили толщину карандаша =2
   //расставляем точки на местах пересечений
   Image1.Canvas.Ellipse(19,29,22,32);   Image1.Canvas.Ellipse(19,74,22,77);
   Image1.Canvas.Ellipse(19,144,22,147); Image1.Canvas.Ellipse(159,29,162,32);
   Image1.Canvas.Ellipse(259,29,262,32);
   Image1.Canvas.Ellipse(159,74,162,77); Image1.Canvas.Ellipse(159,144,162,147);
end;

// процедура, обеспечивающая правильность ввода числа устройств
// (в виде целого числа)
procedure TFormlabor1.EditNKeyPress(Sender: TObject; var Key: Char);
begin
if not (key in ['0'..'9']) then key:=#27
                           else NeueOK.Enabled:=true;
end;

// процедура, обеспечивающая правильность ввода
// вероятности безотказной работы устройств,
// в случае если вероятности безотказной работы у всех устройств одинаковы
// (в виде вещественного числа)
procedure TFormlabor1.EditPpKeyPress(Sender: TObject; var Key: Char);
begin
  if (not(key in ['0'..'9'])and(not(key in [','])))  then key:=#27;
end;

// процедура очистки окон ввода
procedure TFormlabor1.NeueclearClick(Sender: TObject);
begin
 EditPp.Clear; MemoNeue.Clear;
 EditN.Enabled:= true; EditN.Clear;
end;

// процедура ввода исходных данных
procedure TFormlabor1.NeueOKClick(Sender: TObject);
var
  i,j,k:integer;
  buchstabe:array[0..20] of char;
  string1:string;
  komas:array[0..20] of boolean;
  koma: boolean;
label l1, l2, L01, L02;
begin
     N:=Strtoint(EditN.text);
         if N=1 then
            begin
              EditPp.visible:=true;  MemoNeue.Visible:=false;
            end;
         // проверка правильности ввода числа устройств
         if N=0 then  // число устройств = 0
            begin
              MessageBox(0,'Вы не ввели число устройств!!!','Ошибка',MB_OK);
              EditPp.visible:=true;  MemoNeue.Visible:=false;
              Editn.Text:='';
              goto L1;
            end;
         if N>20 then  // число устройств > 20
            begin
              MessageBox(0,'Слишком большое число устройств!'+#10+#13+
                           '    Вы уверены,что в системе '+#10+#13+
                           '      так много устройств?','Ошибка',MB_OK);
              EditPp.visible:=true;  MemoNeue.Visible:=false;
              NeueOK.Enabled:=false; Editn.Text:='';
              goto L1;
            end;
  for i:=0 to 20 do komas[i]:=false;
  koma:=false;
  if gleiche=false then
  // если вероятности безотказной работы у разных устройств разные
  begin
     for i:=0 to n-1 do
     begin
        String1:=MemoNeue.Lines[i];
        k:=Length(String1);
        if(k<1)then goto l2// если i-ая строка (отвечающая за i-ое устройство)
                           // пустая, то переход к выводу сообщения об ошибке
          else
          // если i-ая строка (отвечающая за i-ое устройство) не пустая, то
          // начинаем проверять ее содержимое
              begin
                for j:=1 to k-1 do
                begin
                  if not((String1[j]>='0')and(String1[j]<='9'))
                  then begin // символ строки не является цифрой  =>
                       if ((not(komas[i]))and (String1[j]=','))
                           // если этот символ является запятой и в этой
                           // строке запятой еще не было
                           then komas[i]:=true
                           // иначе -  переход к выводу сообщения об ошибке
                           else goto l2;
                       end;
                end;
                // преобразуем i-ую строку в вещественное число
                Pp[i]:=StrtoFloat(String1);
                // если полученное вещественное число >1, то
                // переход к выводу сообщения об ошибке,
                // т.к. вероятность должна быть меньше или равна 1
                if Pp[i]>1 then goto l2;
              end;
     end;
     // убираем все лишние строки (если число строк больше числа устройств)
     // в окне ввода вероятностей безотказной работы устройств
     for i:=n to MemoNeue.Lines.Count do MemoNeue.Lines[i]:='';
  end
  // если вероятности безотказной работы у всех устройств одинаковы
    else
    begin
      k:=EditPp.GetTextLen;
      if(k<1)then goto L01 // если окно ввода вероятности безотказной работы
                           // пустое, то переход к выводу сообщения об ошибке
         else// если окно ввода вероятности безотказной работы не пустое,
             // то начинаем проверять его содержимое
         begin
            k:=k-1;
            EditPp.GetTextBuf(buchstabe,21);
            for j:=0 to k do
            begin
              if not((buchstabe[j]>='0')and (buchstabe[j]<='9'))
                  then  // символ строки не является цифрой  =>
                    if (not(koma) and (buchstabe[j]=','))
                    // если этот символ является запятой и запятой еще не было
                       then koma:=true
                    // иначе -  переход к выводу сообщения об ошибке
                       else goto L01;
            end;
            // преобразуем строку в вещественное число
            Pp[0]:=StrtoFloat(EditPp.text);
            // если полученное вещественное число >1, то
            // переход к выводу сообщения об ошибке,
            // т.к. вероятность должна быть меньше или равна 1
            if Pp[0]>1 then goto L01;
            if N>1 then begin
                           for i:=1 to N-1 do Pp[i]:=Pp[0];
                        end;
        end;
  end;
  // делаем доступной для работы страницу ввода массива КПУФ
  Kpuf_page.Enabled:=true;
  goto l1; // обход сообщений об ошибке
l2: // преобразуем номер устройства, для которого вероятность безотказной
    // работы введена не верно,  в строку
    String1:=InttoStr(i+1);
    // вывод сообщение об ошибке
    if i+1<9 then
    // если номер устройства, для которого вероятность безотказной работы
    // введена не верно, меньше 10, то выведем  только один знак строки
    ShowMessage('Вы ошиблись при вводе вероятности'+#10+#13+
              'безотказной  работы '+ String1[1]+'-го устройства!')
    // иначе(число двузначное) выведем два знака строки
    else
    ShowMessage('Вы ошиблись при вводе вероятности'+#10+#13+
              'безотказной  работы '+ String1[1]+String1[2]+'-го устройства!');
goto l1; // обход лишнего сообщения об ошибке
L01: // вывод сообщение об ошибке
     ShowMessage('Вы ошиблись при вводе вероятности'
                +#10+#13+'  безотказной  работы  устройств!');
l1:
end;

procedure TFormlabor1.FormCreate(Sender: TObject);
var i: integer;
// действия, выполняемые про создании главной формы
begin
  // по умолчанию вероятности безотказной работы у всех устройств одинаковы
  gleiche:=true;
  // задаем размеры ячеек таблицы, в которой будут выведены исходные данные
  // для проведения лабораторной работы (в соответствии с вариантом)
  SG.ColWidths[0]:=130;   SG.RowHeights[0]:=25;
  // создаем шапку таблицы
  for i:=1 to 7 do SG.Cells[i,0]:='    '+ InttoStr(i);
  SG.Cells[0,1]:='        Pэ';
  SG.Cells[0,2]:='Pп (дублирование)';
  SG.Cells[0,3]:='Pп (троирование)';
end;

procedure TFormlabor1.CheckBox3Click(Sender: TObject);
begin
 if CheckBox3.Checked=true then
 // если поставили галочку в переключателе
 // "вероятности безотказной работы у всех устройств одинаковы", то
         begin
 // сделали видимым окно ввода "общей" вероятности безотказной работы устройств
          EditPp.visible:=true;
          gleiche:=true;
 // сделали невидимым окно ввода вероятностей безотказной работы устройств
          MemoNeue.Visible:=false;
         end
 else
 // если убрали галочку в переключателе
 // "вероятности безотказной работы у всех устройств одинаковы", то
         begin
 // сделали видимым окно ввода "общей" вероятности безотказной работы устройств
          EditPp.visible:=false;
          gleiche:=false;
 // сделали видимым окно ввода вероятностей безотказной работы устройств
          MemoNeue.Visible:=true;
         end;
end;

// процедура, обеспечивающая правильность ввода числа КПУФ
// (в виде целого числа)
procedure TFormlabor1.EditkKeyPress(Sender: TObject; var Key: Char);
begin
 if not (key in ['0'..'9']) then key:=#27
                            else Input.Enabled:=true;
end;

// процедура ввода массива КПУФ
procedure TFormlabor1.InputClick(Sender: TObject);
var
  i,j,k,z:integer;
  string2:string;
label l3,l4;
begin
     kpufN:=Strtoint(Editk.text);
     // проверка правильности ввода числа КПУФ
         if kpufN=0 then  // число КПУФ =1
            begin
              MessageBox(0,'Вы не ввели количество КПУФ!!!','Ошибка',MB_OK);
              // сделали пассивной клавишу ввода масива КПУФ
              Input.Enabled:=false;
              EditK.Text:=''; // очистили окно ввода числа КПУФ
              goto L3;  // переход к выводу сообщения об ошибке
            end;
     // проверка правильности ввода КПУФ
     // счет элементов массива КПУФ идет с 0 !!!
     for i:=0 to kpufN-1 do
     begin
        String2:=Memo1.Lines[i];
        k:=Length(String2);
        if k<>N then goto l4 
        // если число символов в строке КПУФ не равно числу устройств, то
        // переход к выводу сообщения об ошибке
          else
        // иначе проверка содержимого строки
              begin
                for j:=1 to k do
                // если символ строки не является '0' или '1', то
                // переход к выводу сообщения об ошибке
                    if not((String2[j]='0')or(String2[j]='1')) then goto l4;
                // если строка состоит только из '0' и '1', то запоминаем ее
                Kpuf[i]:=String2;
                // если массив запомненных КПУФ содержит более одного КПУФ,
                // сравнивыем последний  КПУФ со всеми предыдущими
                if i>0 then
                       begin
                         for j:=0 to i-1 do
                // если есть совпадающие КПУФ,
                // то переход к выводу сообщения об ошибке
                            if Kpuf[i]=Kpuf[j] then goto l4;
                       end;
              end;
     end;
     // убираем все лишние строки (если число строк больше числа КПУФ)
     // в окне ввода КПУФ
     for i:=kpufN to Memo1.Lines.Count do Memo1.Lines[i]:='';
     // делаем доступной для работы страницу выполнения расчета
     Rechnen_Page.Enabled:=true;
     goto l3;  // обход сообщений об ошибке
l4:
  // преобразуем номер не верно введенного КПУФ в строку
  String2:=InttoStr(i+1);
  // вывод сообщение об ошибке
  if i+1<9 then
  // если номер не верно введенного КПУФ меньше 10,
  // то выведем  только один знак строки
   ShowMessage('Вы ошиблись при вводе '+ String2[1]+'-го КПУФ!')
  // иначе(число двузначное) выведем два знака строки
  else ShowMessage('Вы ошиблись при вводе '+ String2[1]+String2[2]+'-го КПУФ!');
l3:
end;

procedure TFormlabor1.EditkChange(Sender: TObject);
begin
// если при изменении в окне ввода числа КПУФ
// число КПУФ стало > 0, то делаем активной клавишу ввода масива КПУФ
if Strtoint(Editk.text)>0 then input.Enabled:=true;
end;

procedure TFormlabor1.BitBtn1Click(Sender: TObject);
var
r,s,teil:real;
i,j,z,max,mask,t,num:integer;
y     :array [1..30] of real;
kp    :array [0..30] of integer;
RSint :array [0..100] of integer;
st, sammlung :string;
label L0;
begin
if CheckBox1.Checked=true then
//    Расчет по первому алгоритму
  begin
    //преобразуем КПУФы из строкового типа в целый (из Kpuf в Kp)
    for i:=0 to KpufN-1 do
    begin
       kp[i]:=0;
       z:=1;
       for j:=1 to N do
       begin
          if Kpuf[i][j]='1' then kp[i]:=kp[i]+z;
          z:=z*2;
       end;
    end;
    // теперь из получим  RSint - все работоспособные состояния
    max:=1;
    for i:=1 to N do  max:=max*2;
    max:=max-1; // максимальный КПУФ
    z:=0;
    for i:=1 to max do
    begin
       for j:=0 to KpufN-1 do
       begin
          if ((i and Kp[j])>=Kp[j] ) then
            begin
               for t:=0 to z-1 do
                  // сразу уберем повторные работоспособные состояния
                  if (i=RSint[t]) then goto L0;
               RSint[z]:=i;
               z:=z+1;
            end;
       L0:
       end;
    end;
    s:=0;
    for i:=0 to z-1 do //перебор всех РС
    begin
       teil:=1;
       t:=1;
       for j:=1 to N do
       begin
          if ((RSint[i]and t)>0) then r:=Pp[j-1]  else r:=1-Pp[j-1];
          teil:=teil*r;
          t:=t*2;
       end;
       s:=s+teil;
    end;
    P1.text:=FloattoStr(s);
  end;
if CheckBox2.Checked=true then
//    Расчет по второму алгоритму
// ( с использованием теоремы сложения вероятностей совместных событий )
  begin
     max:=1; s:=0;
     for i:=1 to Kpufn do
     begin
        y[i]:=0; max:=max*2;
     end;
     max:=max-1;
     // подсчет первого слагаемого суммы - y[1]
     for i:=0 to KpufN-1 do
     begin
        teil:=1;
        for j:=1 to N do
           if (Kpuf[i][j]='1') then teil:=teil*Pp[j-1];
        y[1]:=y[1]+teil;
     end;
     // подсчет остальных слагаемых -  y[2] ... Y[KpufN]
     for z:=3 to max do
     begin
        //  ищем все возможные сочетания из KpufN  по 2,3...KpufN
        mask:=1; num:=0;  Teil:=1;
        for i:=0 to Kpufn-1 do
        begin
           if ((z and mask)>0) then
              begin
                 num:=num+1;
                 if num=1 then sammlung:=Kpuf[i]
                    else begin
                            for j:=1 to N do
                               if Kpuf[i][j]='1' then sammlung[j]:='1';
                         end;
              end;
           mask:=mask*2;
        end;
        if num>1 then
           begin
              for j:=1 to N do
                 if sammlung[j]='1' then Teil:=Teil*Pp[j-1];
              y[num]:=y[num]+Teil;
           end;
     end;
     // суммируем все y[i]  =>
     // получаем значение вероятности безотказной работы системы
     for i:=1 to Kpufn do
     begin
        if ((i and 1)>0) then s:=s+y[i]
                         else s:=s-y[i];
     end;
     P2.text:=FloattoStr(s);
  end;
end;

procedure TFormlabor1.ClearBtnClick(Sender: TObject);
begin
 Memo1.Clear;   // очистили окно ввода КПУФ
end;

procedure TFormlabor1.RG1Click(Sender: TObject);
begin
// варианты структур для 10 бригад
case RG1.ItemIndex of
0: begin
   // вызов процедуры изображения на странице Zad PageControl1
   // варианта "а" исследуемой структуры
   malenA;
   // заполняем ячееки таблицы, в которой будут выводятся исходные данные
   // для проведения лабораторной работы (в соответствии с вариантом)
   SG.Cells[1,1]:='0.690'; SG.Cells[2,1]:='0.690'; SG.Cells[3,1]:='0.850';
   SG.Cells[4,1]:='0.750'; SG.Cells[5,1]:='0.700'; SG.Cells[6,1]:='0.890';
   SG.Cells[7,1]:='0.910';
   SG.Cells[1,2]:='0.920'; SG.Cells[2,2]:='0.930'; SG.Cells[3,2]:='0.975';
   SG.Cells[4,2]:='0.890'; SG.Cells[5,2]:='0.950'; SG.Cells[6,2]:='0.985';
   SG.Cells[7,2]:='0.965';
   SG.Cells[1,3]:='0.920'; SG.Cells[2,3]:='0.925'; SG.Cells[3,3]:='0.960';
   SG.Cells[4,3]:='0.850'; SG.Cells[5,3]:='0.945'; SG.Cells[6,3]:='0.970';
   SG.Cells[7,3]:='0.960';
   end;
1: begin
   // вызов процедуры изображения на странице Zad PageControl1
   // варианта "б" исследуемой структуры
   malenB;
   SG.Cells[1,1]:='0.710'; SG.Cells[2,1]:='0.850'; SG.Cells[3,1]:='0.890';
   SG.Cells[4,1]:='0.740'; SG.Cells[5,1]:='0.690'; SG.Cells[6,1]:='0.890';
   SG.Cells[7,1]:='0.620';
   SG.Cells[1,2]:='0.985'; SG.Cells[2,2]:='0.960'; SG.Cells[3,2]:='0.965';
   SG.Cells[4,2]:='0.955'; SG.Cells[5,2]:='0.870'; SG.Cells[6,2]:='0.980';
   SG.Cells[7,2]:='0.850';
   SG.Cells[1,3]:='0.965'; SG.Cells[2,3]:='0.940'; SG.Cells[3,3]:='0.945';
   SG.Cells[4,3]:='0.950'; SG.Cells[5,3]:='0.850'; SG.Cells[6,3]:='0.950';
   SG.Cells[7,3]:='0.840';
   end;
2: begin
   // вызов процедуры изображения на странице Zad PageControl1
   // варианта "в" исследуемой структуры
   malenC;
   // заполняем ячееки таблицы, в которой будут выводятся исходные данные
   // для проведения лабораторной работы (в соответствии с вариантом)
   SG.Cells[1,1]:='0.730'; SG.Cells[2,1]:='0.750'; SG.Cells[3,1]:='0.880';
   SG.Cells[4,1]:='0.810'; SG.Cells[5,1]:='0.820'; SG.Cells[6,1]:='0.930';
   SG.Cells[7,1]:='0.800';
   SG.Cells[1,2]:='0.965'; SG.Cells[2,2]:='0.950'; SG.Cells[3,2]:='0.985';
   SG.Cells[4,2]:='0.960'; SG.Cells[5,2]:='0.935'; SG.Cells[6,2]:='0.955';
   SG.Cells[7,2]:='0.985';
   SG.Cells[1,3]:='0.950'; SG.Cells[2,3]:='0.940'; SG.Cells[3,3]:='0.970';
   SG.Cells[4,3]:='0.935'; SG.Cells[5,3]:='0.920'; SG.Cells[6,3]:='0.940';
   SG.Cells[7,3]:='0.960';
   end;
3: begin
   // вызов процедуры изображения на странице Zad PageControl1
   // варианта "г" исследуемой структуры
   malenD;
   // заполняем ячееки таблицы, в которой будут выводятся исходные данные
   // для проведения лабораторной работы (в соответствии с вариантом)
   SG.Cells[1,1]:='0.770'; SG.Cells[2,1]:='0.650'; SG.Cells[3,1]:='0.890';
   SG.Cells[4,1]:='0.750'; SG.Cells[5,1]:='0.720'; SG.Cells[6,1]:='0.690';
   SG.Cells[7,1]:='0.800';
   SG.Cells[1,2]:='0.980'; SG.Cells[2,2]:='0.955'; SG.Cells[3,2]:='0.950';
   SG.Cells[4,2]:='0.945'; SG.Cells[5,2]:='0.964'; SG.Cells[6,2]:='0.970';
   SG.Cells[7,2]:='0.975';
   SG.Cells[1,3]:='0.970'; SG.Cells[2,3]:='0.940'; SG.Cells[3,3]:='0.930';
   SG.Cells[4,3]:='0.935'; SG.Cells[5,3]:='0.940'; SG.Cells[6,3]:='0.965';
   SG.Cells[7,3]:='0.960';
   end;
4: begin
   // вызов процедуры изображения на странице Zad PageControl1
   // варианта "д" исследуемой структуры
   malenE;
   // заполняем ячееки таблицы, в которой будут выводятся исходные данные
   // для проведения лабораторной работы (в соответствии с вариантом)
   SG.Cells[1,1]:='0.650'; SG.Cells[2,1]:='0.620'; SG.Cells[3,1]:='0.620';
   SG.Cells[4,1]:='0.670'; SG.Cells[5,1]:='0.640'; SG.Cells[6,1]:='0.700';
   SG.Cells[7,1]:='0.740';
   SG.Cells[1,2]:='0.960'; SG.Cells[2,2]:='0.965'; SG.Cells[3,2]:='0.970';
   SG.Cells[4,2]:='0.970'; SG.Cells[5,2]:='0.970'; SG.Cells[6,2]:='0.940';
   SG.Cells[7,2]:='0.965';
   SG.Cells[1,3]:='0.930'; SG.Cells[2,3]:='0.950'; SG.Cells[3,3]:='0.955';
   SG.Cells[4,3]:='0.935'; SG.Cells[5,3]:='0.940'; SG.Cells[6,3]:='0.935';
   SG.Cells[7,3]:='0.945';
   end;
5: begin
   // вызов процедуры изображения на странице Zad PageControl1
   // варианта "а" исследуемой структуры
   malenA;
   // заполняем ячееки таблицы, в которой будут выводятся исходные данные
   // для проведения лабораторной работы (в соответствии с вариантом)
   SG.Cells[1,1]:='0.650'; SG.Cells[2,1]:='0.650'; SG.Cells[3,1]:='0.870';
   SG.Cells[4,1]:='0.920'; SG.Cells[5,1]:='0.640'; SG.Cells[6,1]:='0.820';
   SG.Cells[7,1]:='0.900';
   SG.Cells[1,2]:='0.930'; SG.Cells[2,2]:='0.920'; SG.Cells[3,2]:='0.980';
   SG.Cells[4,2]:='0.980'; SG.Cells[5,2]:='0.950'; SG.Cells[6,2]:='0.960';
   SG.Cells[7,2]:='0.960';
   SG.Cells[1,3]:='0.920'; SG.Cells[2,3]:='0.915'; SG.Cells[3,3]:='0.960';
   SG.Cells[4,3]:='0.970'; SG.Cells[5,3]:='0.945'; SG.Cells[6,3]:='0.930';
   SG.Cells[7,3]:='0.940';
   end;
6: begin
   // вызов процедуры изображения на странице Zad PageControl1
   // варианта "б" исследуемой структуры
   malenB;
   // заполняем ячееки таблицы, в которой будут выводятся исходные данные
   // для проведения лабораторной работы (в соответствии с вариантом)
   SG.Cells[1,1]:='0.800'; SG.Cells[2,1]:='0.680'; SG.Cells[3,1]:='0.680';
   SG.Cells[4,1]:='0.690'; SG.Cells[5,1]:='0.730'; SG.Cells[6,1]:='0.760';
   SG.Cells[7,1]:='0.900';
   SG.Cells[1,2]:='0.880'; SG.Cells[2,2]:='0.985'; SG.Cells[3,2]:='0.850';
   SG.Cells[4,2]:='0.850'; SG.Cells[5,2]:='0.900'; SG.Cells[6,2]:='0.935';
   SG.Cells[7,2]:='0.950';
   SG.Cells[1,3]:='0.870'; SG.Cells[2,3]:='0.980'; SG.Cells[3,3]:='0.840';
   SG.Cells[4,3]:='0.845'; SG.Cells[5,3]:='0.890'; SG.Cells[6,3]:='0.920';
   SG.Cells[7,3]:='0.925';
   end;
7: begin
   // вызов процедуры изображения на странице Zad PageControl1
   // варианта "в" исследуемой структуры
   malenC;
   // заполняем ячееки таблицы, в которой будут выводятся исходные данные
   // для проведения лабораторной работы (в соответствии с вариантом)
   SG.Cells[1,1]:='0.710'; SG.Cells[2,1]:='0.800'; SG.Cells[3,1]:='0.750';
   SG.Cells[4,1]:='0.650'; SG.Cells[5,1]:='0.830'; SG.Cells[6,1]:='0.890';
   SG.Cells[7,1]:='0.760';
   SG.Cells[1,2]:='0.940'; SG.Cells[2,2]:='0.985'; SG.Cells[3,2]:='0.970';
   SG.Cells[4,2]:='0.960'; SG.Cells[5,2]:='0.975'; SG.Cells[6,2]:='0.980';
   SG.Cells[7,2]:='0.970';
   SG.Cells[1,3]:='0.935'; SG.Cells[2,3]:='0.980'; SG.Cells[3,3]:='0.945';
   SG.Cells[4,3]:='0.955'; SG.Cells[5,3]:='0.965'; SG.Cells[6,3]:='0.965';
   SG.Cells[7,3]:='0.960';
   end;
8: begin
   // вызов процедуры изображения на странице Zad PageControl1
   // варианта "г" исследуемой структуры
   malenD;
   // заполняем ячееки таблицы, в которой будут выводятся исходные данные
   // для проведения лабораторной работы (в соответствии с вариантом)
   SG.Cells[1,1]:='0.650'; SG.Cells[2,1]:='0.770'; SG.Cells[3,1]:='0.950';
   SG.Cells[4,1]:='0.720'; SG.Cells[5,1]:='0.750'; SG.Cells[6,1]:='0.690';
   SG.Cells[7,1]:='0.800';
   SG.Cells[1,2]:='0.965'; SG.Cells[2,2]:='0.980'; SG.Cells[3,2]:='0.970';
   SG.Cells[4,2]:='0.960'; SG.Cells[5,2]:='0.950'; SG.Cells[6,2]:='0.970';
   SG.Cells[7,2]:='0.970';
   SG.Cells[1,3]:='0.940'; SG.Cells[2,3]:='0.965'; SG.Cells[3,3]:='0.960';
   SG.Cells[4,3]:='0.940'; SG.Cells[5,3]:='0.935'; SG.Cells[6,3]:='0.965';
   SG.Cells[7,3]:='0.955';
   end;
9:begin
   // вызов процедуры изображения на странице Zad PageControl1
   // варианта "д" исследуемой структуры
   malenE;
   // заполняем ячееки таблицы, в которой будут выводятся исходные данные
   // для проведения лабораторной работы (в соответствии с вариантом)
   SG.Cells[1,1]:='0.650'; SG.Cells[2,1]:='0.630'; SG.Cells[3,1]:='0.630';
   SG.Cells[4,1]:='0.620'; SG.Cells[5,1]:='0.790'; SG.Cells[6,1]:='0.750';
   SG.Cells[7,1]:='0.770';
   SG.Cells[1,2]:='0.965'; SG.Cells[2,2]:='0.965'; SG.Cells[3,2]:='0.960';
   SG.Cells[4,2]:='0.955'; SG.Cells[5,2]:='0.970'; SG.Cells[6,2]:='0.950';
   SG.Cells[7,2]:='0.950';
   SG.Cells[1,3]:='0.945'; SG.Cells[2,3]:='0.935'; SG.Cells[3,3]:='0.930';
   SG.Cells[4,3]:='0.930'; SG.Cells[5,3]:='0.945'; SG.Cells[6,3]:='0.940';
   SG.Cells[7,3]:='0.940';
   end;
end;
end;

end.
