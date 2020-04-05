del /Q qqwry.dat

curl.exe -o setup.zip http://update.cz88.net/soft/setup.zip
rem wget.exe -O setup.zip http://update.cz88.net/soft/setup.zip

unzip.exe -o setup.zip setup.exe -d files
innounp.exe  -dfiles -e -x -y files\setup.exe
move files\qqwry.dat .\qqwry.dat
move files\หตร๗.txt .\qqwry.txt
rmdir /S /Q files

del /Q setup.zip

pause
