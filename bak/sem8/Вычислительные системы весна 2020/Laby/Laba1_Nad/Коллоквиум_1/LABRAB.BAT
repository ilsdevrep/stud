Echo off
if %1.==. goto Err1
if %1 == 1 goto 1
if %1 == 2 goto 2
if %1 == 3 goto 3
goto Err1
:1
   Kolok %1
   If ErrorLevel==2  goto Err2
   Most
goto End
:2
   Kolok %1
   If ErrorLevel==2  goto Err2
   Miv
goto End
:3
   Kolok %1
   If ErrorLevel==2  goto Err2
   Stalg
goto End
:Err1
Echo       Неправильно заданы параметры (запуск : labrab Номер_работы)
goto End
:Err2
Echo       П Р И Х О Д И Т Е    В    С Л Е Д У Ю Щ И Й     Р А З
pause
:End
echo off