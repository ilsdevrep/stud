program mylab7;

uses windows,  sysutils,messages; {интерфейсы к системным DLL}

{$R myres7.res} // Подключается файл ресурсов

procedure chengetext(h:thandle);
var   i,j:integer;
      buftmp,war: string;
      buffer: array[0..2000] of char;
      buffer2:PChar;


begin
    SendMessage(GetDlgItem(h,4),wm_gettext,sizeof(buffer),integer(@buffer));
    if buffer[1999] <> #0 then
     begin
      if  MessageBox(0,'Ты превысел 2000 симвало! Отчистить главное окно ввода?','Я вижу ты любишь набирать тексты!', MB_YESNO) = IDYES then
       begin
         SendMessage(GetDlgItem(h,4),wm_settext,0,0);
       end;
       war:='Ты набирай, но поменьше!!!';
       SendMessage(GetDlgItem(h,5),wm_settext,0,longint(war));
     end

     else
       begin
         buffer2:=StrAlloc(2000);
         i:=0; StrCopy(buffer2,'');
         while buffer[i]<>#0 do
           begin
              case buffer[i] of
                    'й' : StrCat(buffer2,'io');'ц' : StrCat(buffer2,'z'); 'у' : StrCat(buffer2,'u');
                    'к' : StrCat(buffer2,'k');'е' : StrCat(buffer2,'e');  'н' : StrCat(buffer2,'n');
                    'г' : StrCat(buffer2,'g');'ш' : StrCat(buffer2,'sh'); 'щ' : StrCat(buffer2,'sch');
                    'з' : StrCat(buffer2,'z');'х' : StrCat(buffer2,'h');  'ф' : StrCat(buffer2,'f');
                    'ы' : StrCat(buffer2,'bl');'в' : StrCat(buffer2,'v'); 'а' : StrCat(buffer2,'a');
                    'п' : StrCat(buffer2,'p'); 'р' : StrCat(buffer2,'r'); 'о' : StrCat(buffer2,'o');
                    'л' : StrCat(buffer2,'l'); 'д' : StrCat(buffer2,'d'); 'ж' : StrCat(buffer2,'j');
                    'э' : StrCat(buffer2,'e'); 'я' : StrCat(buffer2,'ya');'ч' : StrCat(buffer2,'ch');
                    'с' : StrCat(buffer2,'s'); 'м' : StrCat(buffer2,'m'); 'и' : StrCat(buffer2,'i');
                    'т' : StrCat(buffer2,'t'); 'б' : StrCat(buffer2,'b'); 'ю' : StrCat(buffer2,'u');

                    'Й' : StrCat(buffer2,'IO');'Ц' : StrCat(buffer2,'Z');'У' : StrCat(buffer2,'U');
                    'К' : StrCat(buffer2,'K'); 'Е' : StrCat(buffer2,'E');'Н' : StrCat(buffer2,'N');
                    'Г' : StrCat(buffer2,'G'); 'Ш' : StrCat(buffer2,'SH');'Щ' : StrCat(buffer2,'SCH');
                    'З' : StrCat(buffer2,'Z'); 'Х' : StrCat(buffer2,'H'); 'Ф' : StrCat(buffer2,'F');
                    'Ы' : StrCat(buffer2,'bl');'В' : StrCat(buffer2,'V'); 'А' : StrCat(buffer2,'A');
                    'П' : StrCat(buffer2,'P'); 'Р' : StrCat(buffer2,'R'); 'О' : StrCat(buffer2,'O');
                    'Л' : StrCat(buffer2,'L'); 'Д' : StrCat(buffer2,'D'); 'Ж' : StrCat(buffer2,'J');
                    'Э' : StrCat(buffer2,'E'); 'Я' : StrCat(buffer2,'YA');'Ч' : StrCat(buffer2,'CH');
                    'С' : StrCat(buffer2,'S'); 'М' : StrCat(buffer2,'M'); 'И' : StrCat(buffer2,'I');
                    'Т' : StrCat(buffer2,'T'); 'Б' : StrCat(buffer2,'B'); 'Ю' : StrCat(buffer2,'U');

                 else
                      begin
                        buftmp:='';
                        buftmp:=buffer[i];
                        StrCat(buffer2,PChar(buftmp));
                      end;
            end;//case
          inc(i);
       end;//while
     SendMessage(GetDlgItem(h,5),wm_settext,0,longint(buffer2))
  end;// if 2000
end;


procedure static(a,b:integer); stdcall; external 'mylib7.dll' name 'static';
  //Статическая загрузка функции

var dyn:procedure(a,b:integer) stdcall; //Переменная для динамической загрузки
    hLib7:hModule;


procedure DrawBitmap(hdc, hBitmap: THandle; xs,yS: integer;rect:TRect);
  var bm: TBitmap;
      hdcMem: THandle;
begin
  hdcMem:=CreateCompatibleDC(hdc);
  SelectObject(hdcMem, hBitmap);
  GetObject(hBitmap, sizeof(TBitmap),@bm);
  BitBlt(hdc, xs, ys, bm.bmWidth, bm.bmHeight, hdcMem,0,0,SRCCOPY);
  DeleteDC(hdcMem);
end;



function dlgProc(hdlg: THandle; Msg: integer; wParam: longint; lParam: longint): LRESULT; stdcall;
begin
  result:=1;
  case Msg of

     wm_command:  // Обработка команд от всех органов управления
      if SendMessage(1, BM_GETCHECK,0,0)=1 then
       begin
         if hiword(wParam)= EN_CHANGE then
            begin
              //SendMessage(GetDlgItem(hwnd1,edit),wm_gettext,sizeof(buffer),integer(@buffer));
              //SendDlgItemMessage(hwnd1,edit2,wm_settext,sizeof(buffer),integer(@buffer));
              chengetext(hdlg);
            end;
       end

     else
      if hiword(wParam)= BN_Clicked then
        begin
           if loword(wParam)=3 then
              begin
                chengetext(hdlg);
              end;//if
        end; //if



    wm_close:
      begin
        EndDialog(hdlg,idCancel);
      end;
    else
      result:=0;
      // Никаких DefDlgProc!
  end;
end;

function abProc(habdlg: THandle; Msg: integer; wParam: longint; lParam: longint): longint; stdcall;
var ps:TPaintStruct;
      hend,hdc:THandle;
      rect:TRect;
begin
  result:=0;
  case Msg of
   wm_paint:
      begin
        SetWindowRgn(habdlg,CreateRoundRectRgn(3,23,161,240,80,80),true);
        hdc:=BeginPaint(habdlg,ps);
         GetClientRect(habdlg,rect);
         hend:=loadbitmap(hInstance,'im1');
         DrawBitmap(hdc,hend,0,0,rect );
        endPaint(habdlg,ps);
      end;

    wm_lbuttondown :
      EndDialog(habdlg,idCancel);

    wm_close:
      EndDialog(habdlg,idCancel);
    else
      result:=0;
  end;
end;

function wndProc(hWnd: THandle; Msg: integer; wParam: longint; lParam: longint): longint; stdcall;
begin
  result:=0;
  case Msg of
    wm_create:
      begin
        //А теперь -- загрузка вручную. На самом деле эта DLL уже загружена,
        // поэтому еще раз не загружается, увеличивается лишь счетчик ссылок на нее
        hLib7:=loadLibrary('mylib7.dll');
        // Настройка переменной процедурного типа на индекс 100 в DLL
        @dyn:=GetProcAddress(hLib7,pointer(100));
      end;
    wm_command: // Обработка команд от всех органов управления
      if hiword(wparam)=0 then begin //В сообщениях меню нулевой код уведомления
        case loword(wparam) of
          101: static(101,1);
          102: dyn(102,1);
          103:DialogBox(hlib7,'mydlg',0,@dlgproc);
          // Диалог из ресурса другого модуля -- hLib7 !

          104: sendmessage(hwnd,wm_close,0,0);
          105: DialogBox(hInstance,'ab',hwnd,@abproc);
          106:MessageBox(0,'Это просто так! Для прикола!','Team#17', MB_OK or MB_ICONINFORMATION);
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
        hwnd1,hwnd2:THandle;
        sbuf:array[byte] of char;
begin
  loadString(hInstance,1,@sbuf,256);

  wndClass.cbSize:=sizeof(wndClass);
  wndClass.style:=0;
  wndClass.lpfnWndProc:=@WndProc;
  wndClass.cbClsExtra:=0;
  wndClass.cbWndExtra:=0;
  wndClass.hInstance:=hInstance;
  wndClass.hIcon:=loadIcon(hInstance, 'tox');
  wndClass.hCursor:=loadCursor(hInstance, 'cur');
  wndClass.hbrBackground:=GetStockObject(gray_Brush);
  wndClass.lpszMenuName:='lab7menu';
  wndClass.lpszClassName:=szClassName;
  wndClass.hIconSm:=wndClass.hIcon;

  RegisterClassEx(wndClass);

  hwnd1:=CreateWindowEx(0,
         szClassName, {имя класса окна}
         @sbuf,    {заголовок окна}
         ws_overlappedwindow,       {стиль окна}
         100,           {Left}
         100,           {Top}
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
