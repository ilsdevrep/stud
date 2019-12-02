program Project1;

uses
  windows,
  messages,
  SysUtils;

{интерфейсы к системным DLL}

function WndProc(hWnd: THandle; Msg: integer;
                 wParam: longint; lParam: longint): longint;
                 stdcall; forward;

var CreationCounter:integer=0; // Счетчик созданных главных окон

procedure WinMain; {Основной цикл обработки сообщений}
  const szClassName='Controls demo';
  var   wndClass:TWndClassEx;
        msg:TMsg;
        hwnd1:THandle;

begin
  wndClass.cbSize:=sizeof(wndClass);
  wndClass.style:=0;
  wndClass.lpfnWndProc:=@WndProc;
  wndClass.cbClsExtra:=0;
  wndClass.cbWndExtra:=0;
  wndClass.hInstance:=hInstance;
  wndClass.hIcon:=loadIcon(0, idi_Application);
  wndClass.hCursor:=loadCursor(0, idc_Arrow);
  wndClass.hbrBackground:=GetStockObject(ltgray_Brush);
  wndClass.lpszMenuName:=nil;
  wndClass.lpszClassName:=szClassName;
  wndClass.hIconSm:=loadIcon(0, idi_Application);

  RegisterClassEx(wndClass);

  hwnd1:=CreateWindowEx(0,
         szClassName, {имя класса окна}
         'Заголовок окна',    {заголовок окна}
         ws_popupwindow or ws_sysmenu or ws_caption or ws_border or ws_visible,       {стиль окна}
         10,           {Left}
         10,           {Top}
         400,                     {Width}
         450,                     {Height}
         0,                       {хэндл родительского окна}
         0,                       {хэндл оконного меню}
         hInstance,               {хэндл экземпляра приложения}
         nil);                    {параметры создания окна}


  while GetMessage(msg,0,0,0) do begin {получить очередное сообщение}
    if not IsDialogMessage(hwnd1,msg)
           {Если Windows не распознает и не обрабатывает клавиатурные сообщения
            как команды переключения между оконными органами управления,
            тогда чообщение идет на стандартную обработку}
    then begin
      TranslateMessage(msg);   {Windows транслирует сообщения от клавиатуры}
      DispatchMessage(msg);    {Windows вызовет оконную процедуру}
    end;
  end; {выход по wm_quit, на которое GetMessage вернет FALSE}
end;

 procedure mov(hWnd: THandle; num: integer);
   var
      buffer: array[0..5] of char;
      str_empty,str_error:string;
 begin
      str_empty:='Значение не задано в поле ';
      str_error:='Неверное число в поле ';
    GetWindowText(GetDlgItem(hwnd,num),@buffer,5);
                    if (buffer)<>'' then
                      if ((StrToInt(buffer)>255) or (StrToInt(buffer)<0) ) then
                      begin
                           MessageBox(0,PChar(str_error+inttostr(num)), '', mb_OK);
                           if((StrToInt(buffer)>255)) then begin
                             SetScrollPos(GetDlgItem(hwnd,num+3),sb_ctl,255,true);
                             SetWindowText(GetDlgItem(hwnd,num),'255');
                           end
                           else begin
                             SetScrollPos(GetDlgItem(hwnd,num+3),sb_ctl,0,true);
                             SetWindowText(GetDlgItem(hwnd,num),'0');
                           end
                      end
                          else
                          SetScrollPos(GetDlgItem(hwnd,num+3),sb_ctl,StrToInt(buffer),true)
                      else begin
                           MessageBox(0,PChar(str_empty+inttostr(num)), '', mb_OK);
                           SetScrollPos(GetDlgItem(hwnd,num+3),sb_ctl,0,true);
                           SetWindowText(GetDlgItem(hwnd,num),'0');
                      end;
 end;

function WndProc(hWnd: THandle; Msg: integer; wParam: longint; lParam: longint): longint; stdcall;
  const
      Edit1 = 1; Edit2 = 2; Edit3 = 3;
      ScrollBar1 = 4; ScrollBar2 = 5; ScrollBar3 = 6;

      BtnExecute=10;

  var //i,j:integer;
      rect:TRect;
//      buffer: array[0..255] of char;
      ps:TPaintStruct;
      hBrush,hOldBrush,hdc:THandle;
begin
  result:=0;
  case Msg of
    wm_create: {Органы управления создаются при создании главного окна}
      begin
        inc(CreationCounter);
        GetClientRect(hwnd,rect); //размеры клиентской области
      ///
        CreateWindowEx(WS_EX_OVERLAPPEDWINDOW , // Утопленная рамка
                   'edit',
                   '0',// пустой текст в поле ввода
                   ws_visible or ws_child or ws_border or ws_tabstop,//Группа закончена, отсюда начинается следующая
                   10,10,50,20,
                   hwnd,
                   Edit1,
                   hInstance,
                   nil);

        CreateWindowEx(WS_EX_CLIENTEDGE, // Утопленная рамка
                   'edit',
                   '0',// пустой текст в поле ввода
                   ws_visible or ws_child or ws_border or ws_tabstop, //Группа закончена, отсюда начинается следующая
                   10,40,50,20,
                   hwnd,
                   Edit2,
                   hInstance,
                   nil);
        CreateWindowEx(WS_EX_CLIENTEDGE, // Утопленная рамка
                   'edit',
                   '0',// пустой текст в поле ввода
                   ws_visible or ws_child or ws_border or ws_tabstop ,//Группа закончена, отсюда начинается следующая
                   10,70,50,20,
                   hwnd,
                   Edit3,
                   hInstance,
                   nil);
        CreateWindow('scrollbar',
                   nil,
                   ws_visible or ws_child or sbs_horz,
                   130,10,255,20,
                   hwnd,
                   ScrollBar1,
                   hInstance,
                   nil);
        SetScrollRange(GetDlgItem(hwnd,ScrollBar1),sb_ctl,0,255,true);
        CreateWindow('scrollbar',
                   nil,
                   ws_visible or ws_child or sbs_horz,
                   130,40,255,20,
                   hwnd,
                   ScrollBar2,
                   hInstance,
                   nil);
        SetScrollRange(GetDlgItem(hwnd,ScrollBar2),sb_ctl,0,255,true);
        CreateWindow('scrollbar',
                   nil,
                   ws_visible or ws_child or sbs_horz,
                   130,70,255,20,
                   hwnd,
                   ScrollBar3,
                   hInstance,
                   nil);
        SetScrollRange(GetDlgItem(hwnd,ScrollBar3),sb_ctl,0,255,true);

        CreateWindow('static',
                   'Red',//текст в поле ввода
                   ws_visible or ws_child,
                   70,10,50,20,
                   hwnd,
                   ScrollBar3,
                   50,
                   nil);
        CreateWindow('static',
                   'Green',
                   ws_visible or ws_child,
                   70,40,50,20,
                   hwnd,
                   50,
                   hInstance,
                   nil);
        CreateWindow('static',
                   'Blue',
                   ws_visible or ws_child,
                   70,70,50,20,
                   hwnd,
                   50,
                   hInstance,
                   nil);
        CreateWindow('button',
                   'Set Color',
                   ws_visible or ws_child or bs_defpushbutton or ws_tabstop,
                   10,100,110,20,
                   hwnd,
                   BtnExecute,
                   hInstance,
                   nil);
      end;

    wm_command: // Обработка команд от всех органов управления
      case hiword(wParam) of
         BN_DBLCLK:
          begin
            SendMessage(hwnd,wm_command,bn_clicked shl 16 or BtnExecute,GetDlgItem(hwnd,BtnExecute));
          end;
         BN_Clicked:
          begin
            if loword(wParam)=BtnExecute then
             begin
                mov(hwnd,Edit1);
                mov(hwnd,Edit2);
                mov(hwnd,Edit3);
                InvalidateRect(hwnd,nil,true);
                SendMessage(hwnd, wm_setfocus,GetDlgItem(hwnd,Edit2),0)
             end;
          end;
      end;

    wm_destroy:
      begin // Органы управления уничтожаются автоматически
        PostQuitMessage(0);
      end;

      WM_Paint:
     begin
      hdc:=BeginPaint(hwnd,ps);
      GetClientRect(hwnd,rect);
      hBrush:=CreateSolidBrush(
                               rgb(
                                   GetScrollPos(GetDlgItem(hwnd,ScrollBar1),SB_CTL)
                                   , GetScrollPos(GetDlgItem(hwnd,ScrollBar2),SB_CTL)
                                   , GetScrollPos(GetDlgItem(hwnd,ScrollBar3),SB_CTL)
                               )
      );
      hOldBrush:=SelectObject(hdc,hBrush);
      GetClientRect(hwnd,rect);
      FillRect(hdc,rect,hBrush);
      DeleteObject(SelectObject(hdc,hOldBrush));
      EndPaint(hwnd,ps);
     end;


    else
      result:=DefWindowProc(hwnd,msg,wparam,lparam);
  end;
end;



begin
  WinMain;
end.

