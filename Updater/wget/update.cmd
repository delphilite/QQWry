del /Q qqwry.dat

wget.exe -O setup.zip https://www.cz88.net/soft/KG0NrjiB-2024-04-17.zip

unzip.exe -o setup.zip setup.exe -d files
innounp.exe  -dfiles -e -x -y files\setup.exe
move files\qqwry.dat .\qqwry.dat
move files\หตร๗.txt .\qqwry.txt
rmdir /S /Q files

del /Q setup.zip

pause
