program MyLab5;

uses
  Windows,
  Messages,
  SysUtils;

{ Служебные функции Дельфи для форматирования строк и т.д. }

{ Глобальные объявления }
  const szClassName='Shablon';  { Имя оконного класса }
  var   wndClass:TWndClassEx;   { Структура оконного класса }
        hWnd: THandle;          { Хэндл создаваемого окна }
        msg:TMsg;               { Структура-сообщение }
        R,G,B:byte;             { Составляющие цвета фона }
        ElReg:HRGN;
{ Оконная процедура обработки сообщения }

 function WndProc(hWnd: THandle; Msg: integer; wParam: longint; lParam: longint): longint; stdcall;
 const
       step:integer=50;
       {$WRITEABLECONST ON}
       xOffset:integer=0; //Фактически это статические переменные
       yOffset:integer=0;
       {$WRITEABLECONST OFF}
   var
       ps:TPaintStruct; { Структура информации о рисовании }
       hdc:THandle;     { Хэндл контекста устройства }
       rect, trec:TRect;      { Структура информации о прямоугольной области }
       k1,k2,k3,k4,k5,k6,k7,k8,k9,k0: SmallInt;
       st_up, st_down, st_left, st_right: SmallInt;
       Flag:boolean;
       x,y:word; C_x,C_y:word; koord:TPoint;
       hBrush,hOldBrush:THandle; { Хэндлы старого и нового }
                                 { объектов-кистей }
       S1:String;  { Строковая переменная }



 begin
 result:=0;
  //rect1: TRect =(Left: 50;Top: 50;Right: 100;Bottom: 100;);
  case Msg of
    WM_Paint:
     begin
      hdc:=BeginPaint(hwnd,ps); { Взять WM_Paint и начать рисование }
      GetClientRect(hwnd,rect);{ Получение параметров клиентской области окна }
      { Создание кисти заданного цвета и взятие }
      { её в контекст устройства }
      hBrush:=CreateSolidBrush(rgb(R,G,B));
      hOldBrush:=SelectObject(hdc,hBrush);
      //OffsetRgn(ElReg,xOffset,yOffset);
      PaintRgn(hdc,ElReg);
      { Удаляем выбранную кисть из контекста устройства }
      { и восстанавливаем старую кисть }
      DeleteObject(SelectObject(hdc,hOldBrush));
      EndPaint(hwnd,ps);{ Завершение рисования. Удаление контекста устройства }
     end;
    WM_lButtonDown:
      begin
       xOffset:=SmallInt(lparam);
       yOffset:=SmallInt(HiWord(lparam));
      end;

    WM_MouseMove:
    begin

        if PtInRegion(ElReg,SmallInt(lparam),SmallInt(HiWord(lparam))) then
        begin
          if (wParam=MK_LBUTTON) then
            begin
              GetRgnBox(ElReg,trec);
              OffsetRgn(ElReg,SmallInt(lparam)-xOffset,{HiWord(lparam)-}SmallInt(HiWord(lparam))-yOffset);
              xOffset:=SmallInt(lparam);
              yOffset:=SmallInt(HiWord(lparam));
              InvalidateRect(hwnd,nil,true); { Перерисовать окно сейчас же, не дожидаясь опустошения очереди }
              UpdateWindow(hwnd);
            end;
        end;
       

    end;

    WM_Keydown:
     begin
      Flag:=false;
       case wParam of

       //верх
          VK_UP: begin
                Flag:=true;
                OffsetRgn(ElReg,0,-1*step);
              end;
       //вниз
           VK_DOWN: begin
               Flag:=true;
                OffsetRgn(ElReg,0,1*step);
              end;
       //влево
           VK_LEFT: begin
               Flag:=true;
               OffsetRgn(ElReg,-1*step,0);
              end;
       //вправо
           VK_RIGHT: begin
               Flag:=true;
               OffsetRgn(ElReg,1*step,0);
              end;
          byte('0'): begin
               Flag:=true;
                G := 255; R := 255; B := 0;
              end;
           byte('1'): begin
               Flag:=true;
                G := 255; R := 0; B := 0;
              end;
           byte('2'): begin
               Flag:=true;
                G := 0; R := 0; B := 255;
              end;
           byte('3'): begin
               Flag:=true;
                G := 0; R := 128; B := 0;
              end;
           byte('4'): begin
               Flag:=true;
                G := 255; R := 69; B := 0;
              end;
           byte('5'): begin
               Flag:=true;
                G := 199; R := 21; B := 133;
              end;
           byte('6'): begin
               Flag:=true;
                G := 0; R := 0; B := 0;
              end;
           byte('7'): begin
               Flag:=true;
                G := 143; R := 188; B := 143;
              end;
           byte('8'): begin
               Flag:=true;
                G := 0; R := 255; B := 255;
              end;
           byte('9'): begin
               Flag:=true;
                G := 0; R := 255; B := 0;
              end;
       end;

     if Flag then
      begin
       InvalidateRect(hwnd,nil,true); { Перерисовать окно сейчас же, не дожидаясь опустошения очереди }
       UpdateWindow(hwnd);
      end;
     end; { WM_KeyDown }

    WM_Destroy:
        PostQuitMessage(0);

  else
   result:=DefWindowProc(hwnd,msg,wparam,lparam);
  end; { case msg }
 end; { end WndProc }

begin
 { Заполнение описания оконного класса }
  wndClass.cbSize:=sizeof(wndClass);
  wndClass.style:=CS_hredraw or CS_vredraw;
  wndClass.lpfnWndProc:=@WndProc;
  wndClass.cbClsExtra:=0;
  wndClass.cbWndExtra:=0;
  wndClass.hInstance:=hPrevInst;
  wndClass.hInstance:=hInstance;
  wndClass.hIcon:=loadIcon(0, idi_Application);
  wndClass.hCursor:=loadCursor(0, idc_Arrow);
  wndClass.hbrBackground:=GetStockObject(white_Brush);
  wndClass.lpszMenuName:=nil;
  wndClass.lpszClassName:=szClassName;
  wndClass.hIconSm:=loadIcon(0, idi_Application);

 { Регистрация оконного класса }
  RegisterClassEx(wndClass);

 { Создание окна }
  hwnd:=CreateWindowEx(
         0,
         szClassName, { Имя класса окна }
         'Изменение цвета ',    { Заголовок окна }
         WS_overlappedWindow,     { Стиль окна }
         CW_useDefault,           { Left }
         CW_useDefault,           { Top }
         500,                     { Width }
         300,                     { Height }
         0,                       { Хэндл родительского окна }
         0,                       { Хэндл оконного меню }
         hInstance,               { Хэндл экземпляра приложения }
         nil);                    { Параметры создания окна }

 { Отобразить окно }
  ShowWindow(hwnd,SW_Show);
  UpdateWindow(hwnd);   { Послать WM_Paint оконной процедуре, прорисовав
                         окно минуя очередь сообщений (необязательно) }
  ElReg:=CreateEllipticRgn(50,50,100,100);
 { Получить очередное сообщение }
  while GetMessage(msg,0,0,0) do
   begin
    TranslateMessage(msg); { Windows транслирует сообщения от клавиатуры }
    DispatchMessage(msg);  { Windows вызовет оконную процедуру }
   end; { Выход по WM_Quit, на которое GetMessage вернет FALSE }

end.
