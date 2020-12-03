FROM mcr.microsoft.com/windows:1903

WORKDIR /usr/src/app

RUN powershell.exe -Command "Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted"

COPY write.exe .

COPY generate-specimens-windows.ps1 .

# RUN powershell.exe -File generate-specimens-windows.ps1

