del /Q qqwry.dat

wget.exe -O setup.zip https://www.cz88.net/soft/setup.zip

unzip.exe -o setup.zip setup.exe -d files
innounp.exe  -dfiles -e -x -y files\setup.exe
move files\qqwry.dat .\qqwry.dat
move files\˵��.txt .\qqwry.txt
rmdir /S /Q files

del /Q setup.zip

pause
