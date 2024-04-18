set PATH=%PATH%;"C:\Program Files\CodeGear\RAD Studio\5.0\bin";"C:\Program Files (x86)\CodeGear\RAD Studio\5.0\bin"

del QQWry.rc

del QQWry.res

echo QQWry RCDATA QQWry.dat > QQWry.rc

brcc32.exe QQWry.rc

rename QQWry.res QQWry.res

del QQWry.rc

pause
