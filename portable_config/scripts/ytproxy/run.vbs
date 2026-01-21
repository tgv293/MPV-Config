Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "http-ytproxy.exe -c cert.pem -k key.pem -r 10485760 -p 12081", 0, True