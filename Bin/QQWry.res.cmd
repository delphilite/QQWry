del QQWry.rc

del QQWry.res

echo QQWry RCDATA QQWry.dat > QQWry.rc

"%bds%\bin\brcc32.exe" QQWry.rc

rename QQWry.res QQWry.res

del QQWry.rc

pause
