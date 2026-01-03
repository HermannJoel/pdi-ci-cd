ECHO *** CALL init.bat in framework\bin ***
CALL init.bat
ECHO *** CALL Spoon.bat in %KETTLE_CLIENT_DIR% ***
CALL %KETTLE_CLIENT_DIR%\Spoon.bat %OPT% %*