@echo off
REM Set Environment
CD /d %~dp0\..\..
SET ROOT_DIR=%CD%
REM Set config-pdi-... e.g: config-pdi-local
IF "%PENTAHO_ENV%"=="" (SET PENTAHO_ENV=config-pdi-local)
ECHO Running with "%PENTAHO_ENV%" environment settings

ECHO *** Setting ROOT_DIR to "%ROOT_DIR%" ***
ECHO *** Setting PENTAHO_ENV to "%PENTAHO_ENV%" ***
ECHO *** Move to CONF_DIR : "%ROOT_DIR%\js_datamart-configuration\%PENTAHO_ENV%\env.windows.conf" ***

REM Load Environment Configuration
FOR /F "usebackq delims=" %%x IN ("%ROOT_DIR%\js_datamart-configuration\%PENTAHO_ENV%\env.windows.conf") DO (SET %%x)
REM Set Additional Variables
SET KETTLE_CLIENT_DIR=%PENTAHO_HOME%
SET KETTLE_HOME=%ROOT_DIR%\js_datamart-configuration\%PENTAHO_ENV%
SET KETTLE_META_HOME=%ROOT_DIR%\js_datamart-configuration\%PENTAHO_ENV%
SET OPT=%OPT% "-DPENTAHO_METASTORE_FOLDER=%KETTLE_META_HOME%"

ECHO *** Setting KETTLE_CLIENT_DIR to : %KETTLE_CLIENT_DIR% ***
ECHO *** Setting KETTLE_HOME to : %KETTLE_HOME% ***
ECHO *** Setting KETTLE_META_HOME to : %KETTLE_META_HOME% ***

