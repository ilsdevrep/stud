program lab7;

uses windows, messages, SysUtils; {интерфейсы к системным DLL}

{$R res7.res} // Подключается файл ресурсов


//procedure static(a,b:integer); stdcall; external 'lib7.dll' name 'static';
  //Статическая загрузка функции

procedure mov(hWnd: THandle; num: integer);
   var
      buffer: array[0..5] of char;
      str_empty,str_error:string;
 begin
      str_empty:='Значение не задано в поле ';
      str_error:='Неверное число в поле ';
	  
	  //ВСЕ РАБОТАЕТ КРОМЕ ИЗМЕНЕНИЯ ПОЛЗУНКА НА СКРОЛЛБАРАХ
	  
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

var dyn:procedure(a,b:pChar) stdcall; //Переменная для динамической загрузки
    hLib7:hModule;


function dlgProc(hWnd: THandle; Msg: integer; wParam: longint; lParam: longint): longint; stdcall;
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
                mov(hWnd,Edit1);
                mov(hWnd,Edit2);
                mov(hWnd,Edit3);
                InvalidateRect(hwnd,nil,true);
                SendMessage(hwnd, wm_setfocus,GetDlgItem(hwnd,Edit2),0)
             end;
          end;
      end;
    wm_close: EndDialog(hwnd, 0);

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
	

    
  end;
end;

function wndProc(hWnd: THandle; Msg: integer; wParam: longint; lParam: longint): longint; stdcall;
var a,b:pChar;
begin
	b:='Кутузов';
	a:='Поздняков';
  result:=0;
  case Msg of
    wm_create:
      begin
        // А теперь -- загрузка вручную. На самом деле эта DLL уже загружена,
        // поэтому еще раз не загружается, увеличивается лишь счетчик ссылок на нее
        hLib7:=loadLibrary('lib7.dll');
        // Настройка переменной процедурного типа на индекс 100 в DLL
        @dyn:=GetProcAddress(hLib7,pointer(2));
      end;
    wm_command: // Обработка команд от всех органов управления
      if hiword(wparam)=0 then begin //В сообщениях меню нулевой код уведомления
        case loword(wparam) of
//          101: static(101,1);
          102: dyn(b,a);
          103: // Диалог из ресурса другого модуля -- hLib7 !
            DialogBox(hLib7,'lib7dlg',hwnd,@dlgproc);
          104: sendmessage(hwnd,wm_close,0,0);
        end;
      end;
    wm_close:
      begin // Органы управления уничтожаются автоматически
        FreeLibrary(hLib7);
        PostQuitMessage(0);
      end;
    else
      result:=DefWindowProc(hwnd,msg,wparam,lparam);
  end;
end;

procedure WinMain; {Основной цикл обработки сообщений}
  const szClassName='Controls demo';
  var   wndClass:TWndClassEx;
        msg:TMsg;
        hwnd1:THandle;
        sbuf:array[byte] of char;
begin
  loadString(hInstance,1,@sbuf,256);

  wndClass.cbSize:=sizeof(wndClass);
  wndClass.style:=0;
  wndClass.lpfnWndProc:=@WndProc;
  wndClass.cbClsExtra:=0;
  wndClass.cbWndExtra:=0;
  wndClass.hInstance:=hInstance;
  wndClass.hIcon:=loadIcon(hInstance, 'lab7');
  wndClass.hCursor:=loadCursor(hInstance, 'TRIANGLE');
  wndClass.hbrBackground:=GetStockObject(white_Brush);
  wndClass.lpszMenuName:='lab7menu';
  wndClass.lpszClassName:=szClassName;
  wndClass.hIconSm:=wndClass.hIcon;

  RegisterClassEx(wndClass);

  hwnd1:=CreateWindowEx(0,
         szClassName, {имя класса окна}
         @sbuf,    {заголовок окна}
         ws_overlappedwindow,       {стиль окна}
         10,           {Left}
         10,           {Top}
         500,                     {Width}
         300,                     {Height}
         0,                       {хэндл родительского окна}
         0,                       {хэндл оконного меню}
         hInstance,               {хэндл экземпляра приложения}
         nil);                    {параметры создания окна}

  ShowWindow(hwnd1,sw_show);

  while GetMessage(msg,0,0,0) do begin {получить очередное сообщение}
      TranslateMessage(msg);   {Windows транслирует сообщения от клавиатуры}
      DispatchMessage(msg);    {Windows вызовет оконную процедуру}
  end; {выход по wm_quit, на которое GetMessage вернет FALSE}
end;


begin
  WinMain;
end.