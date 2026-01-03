ECHO *** CALL init-pdi-server in framework\bin ***
CALL init-pdi-server.bat
ECHO *** CALL start-pentaho.bat in "%KETTLE_CLIENT_DIR%" ***
CALL %KETTLE_CLIENT_DIR%\start-pentaho.bat %OPT% %*