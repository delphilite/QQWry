del /Q qqwry.dat

curl.exe -o setup.zip https://www.cz88.net/soft/Uz5X06QA-2024-07-03.zip

unzip.exe -o setup.zip setup.exe -d files
innounp.exe  -dfiles -e -x -y files\setup.exe
move files\qqwry.dat .\qqwry.dat
move files\หตร๗.txt .\qqwry.txt
rmdir /S /Q files

del /Q setup.zip

pause
