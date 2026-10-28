@echo off
setlocal EnableExtensions

title Auto-Editor - Premiere Pro XML


REM ============================================================
REM
REM     AUTO-EDITOR - PREMIERE PRO XML
REM     CONFIGURATION
REM
REM ============================================================
REM
REM     Edit the variables in this section to change how
REM     Auto-Editor detects and removes silence.
REM
REM ============================================================


REM ------------------------------------------------------------
REM GENERAL SETTINGS
REM ------------------------------------------------------------

REM Seconds before the window closes after successful processing.
REM Set to 0 if you do not want an automatic delay.
set "Auto_Close=1"


REM ------------------------------------------------------------
REM AUTO-EDITOR EDITING SETTINGS
REM ------------------------------------------------------------

REM Editing method.
REM Current Auto-Editor method for silence removal:
REM     audio
set "EDIT_METHOD=audio"


REM Audio loudness threshold.
REM Higher = more aggressive silence removal.
REM Lower  = keeps quieter speech.
REM Examples:
REM     4%
REM     6%
REM     8%
REM     -18dB
set "SILENCE_THRESHOLD=6%%"


REM Audio stream to analyze.
REM Current Auto-Editor supports:
REM     all
REM     0
REM     1
REM     etc.
set "AUDIO_STREAM=all"


REM Audio channel to analyze.
REM Examples:
REM     all
REM     left
REM     right
REM     center
set "AUDIO_CHANNEL=all"


REM ------------------------------------------------------------
REM MARGIN / PADDING
REM ------------------------------------------------------------

REM Amount of audio kept BEFORE an active/loud section.
set "MARGIN_BEFORE=0.2sec"


REM Amount of audio kept AFTER an active/loud section.
set "MARGIN_AFTER=0.2sec"


REM ------------------------------------------------------------
REM SMOOTHING
REM ------------------------------------------------------------

REM Minimum duration of a section that can be CUT.
set "MINCUT=0.2sec"


REM Minimum duration of a section that can be KEPT.
set "MINCLIP=0.1sec"


REM ------------------------------------------------------------
REM ACTIONS
REM ------------------------------------------------------------

REM What to do with active/loud sections.
REM Default:
REM     nil = keep unchanged
set "WHEN_ACTIVE=nil"


REM What to do with inactive/silent sections.
REM Default:
REM     cut = remove completely
set "WHEN_INACTIVE=cut"


REM ------------------------------------------------------------
REM EXPORT SETTINGS
REM ------------------------------------------------------------

REM Premiere Pro export format.
set "EXPORT_FORMAT=premiere"


REM Output filename suffix.
REM Example:
REM     Podcast.mp3
REM     Podcast_ALTERED.xml
set "OUTPUT_SUFFIX=_ALTERED"


REM ============================================================
REM
REM     END OF CONFIGURATION
REM
REM     Normally you should not need to edit anything below.
REM
REM ============================================================


REM ------------------------------------------------------------
REM CHECK INPUT FILE
REM ------------------------------------------------------------

if "%~1"=="" (
    echo.
    echo [!] No input file provided.
    echo.
    echo Please select an MP3 or WAV file and use:
    echo     Generate Premiere Pro XML
    echo.
    pause
    exit /b 1
)

set "InputFile=%~1"


REM ------------------------------------------------------------
REM CHECK INPUT FILE EXISTS
REM ------------------------------------------------------------

if not exist "%InputFile%" (
    echo.
    echo [!] ERROR: Input file was not found.
    echo.
    echo Input:
    echo "%InputFile%"
    echo.
    pause
    exit /b 1
)


REM ------------------------------------------------------------
REM CHECK FILE TYPE
REM ------------------------------------------------------------

set "InputExtension=%~x1"

if /I not "%InputExtension%"==".mp3" if /I not "%InputExtension%"==".wav" (
    echo.
    echo [!] ERROR: Unsupported input file type.
    echo.
    echo This workflow supports:
    echo     MP3
    echo     WAV
    echo.
    echo Input:
    echo "%InputFile%"
    echo.
    pause
    exit /b 1
)


REM ------------------------------------------------------------
REM LOCATE AUTO-EDITOR
REM ------------------------------------------------------------

REM Auto-Editor MUST be in the same directory as this BAT file.

set "AUTO_EDITOR=%~dp0auto-editor.exe"


if not exist "%AUTO_EDITOR%" (
    echo.
    echo ------------------------------------------
    echo     Auto-Editor - Premiere Pro XML
    echo ------------------------------------------
    echo.
    echo [!] ERROR: auto-editor.exe was not found.
    echo.
    echo Expected location:
    echo "%AUTO_EDITOR%"
    echo.
    echo Please place:
    echo.
    echo     auto-editor.exe
    echo.
    echo in the same folder as:
    echo.
    echo     handler.bat
    echo.
    pause
    exit /b 1
)


REM ------------------------------------------------------------
REM CREATE OUTPUT PATH
REM ------------------------------------------------------------

set "OutputFile=%~dpn1%OUTPUT_SUFFIX%.xml"


REM ------------------------------------------------------------
REM BUILD AUTO-EDITOR EDIT EXPRESSION
REM ------------------------------------------------------------

REM Current Auto-Editor syntax:
REM
REM --edit audio:threshold=6%,stream=all,channel=all
REM
REM The values below are taken from the configuration section.

set "EDIT_EXPRESSION=%EDIT_METHOD%:threshold=%SILENCE_THRESHOLD%,stream=%AUDIO_STREAM%,channel=%AUDIO_CHANNEL%"


REM ------------------------------------------------------------
REM BUILD MARGIN EXPRESSION
REM ------------------------------------------------------------

set "MARGIN=%MARGIN_BEFORE%,%MARGIN_AFTER%"


REM ------------------------------------------------------------
REM BUILD SMOOTH EXPRESSION
REM ------------------------------------------------------------

set "SMOOTH=%MINCUT%,%MINCLIP%"


REM ------------------------------------------------------------
REM DISPLAY SETTINGS
REM ------------------------------------------------------------

echo.
echo ------------------------------------------
echo     Auto-Editor - Premiere Pro XML
echo ------------------------------------------
echo.
echo Input:          "%InputFile%"
echo Output:         "%OutputFile%"
echo Auto-Editor:    "%AUTO_EDITOR%"
echo.
echo -------- Silence Removal Settings --------
echo.
echo Edit method:    %EDIT_METHOD%
echo Threshold:      %SILENCE_THRESHOLD%
echo Audio stream:   %AUDIO_STREAM%
echo Audio channel:  %AUDIO_CHANNEL%
echo.
echo Minimum cut:    %MINCUT%
echo Minimum clip:   %MINCLIP%
echo Margin before:  %MARGIN_BEFORE%
echo Margin after:   %MARGIN_AFTER%
echo.
echo When active:    %WHEN_ACTIVE%
echo When inactive:  %WHEN_INACTIVE%
echo.
echo Export format:  %EXPORT_FORMAT%
echo Output suffix:  %OUTPUT_SUFFIX%
echo ------------------------------------------
echo.


REM ------------------------------------------------------------
REM SHOW COMMAND
REM ------------------------------------------------------------

echo Command:
echo.
echo "%AUTO_EDITOR%" "%InputFile%" --edit "%EDIT_EXPRESSION%" --margin "%MARGIN%" --smooth "%SMOOTH%" --when-active "%WHEN_ACTIVE%" --when-inactive "%WHEN_INACTIVE%" --export "%EXPORT_FORMAT%" --output "%OutputFile%"
echo.
echo ------------------------------------------
echo.


REM ------------------------------------------------------------
REM RUN AUTO-EDITOR
REM ------------------------------------------------------------

"%AUTO_EDITOR%" "%InputFile%" ^
    --edit "%EDIT_EXPRESSION%" ^
    --margin "%MARGIN%" ^
    --smooth "%SMOOTH%" ^
    --when-active "%WHEN_ACTIVE%" ^
    --when-inactive "%WHEN_INACTIVE%" ^
    --export "%EXPORT_FORMAT%" ^
    --output "%OutputFile%"


REM ------------------------------------------------------------
REM CHECK AUTO-EDITOR EXIT CODE
REM ------------------------------------------------------------

if errorlevel 1 (
    echo.
    echo ------------------------------------------
    echo [!] ERROR: Auto-Editor failed to generate
    echo     the Premiere Pro XML.
    echo ------------------------------------------
    echo.
    echo Input:
    echo "%InputFile%"
    echo.
    echo Expected output:
    echo "%OutputFile%"
    echo.
    pause
    exit /b 1
)


REM ------------------------------------------------------------
REM VERIFY OUTPUT FILE
REM ------------------------------------------------------------

if not exist "%OutputFile%" (
    echo.
    echo ------------------------------------------
    echo [!] ERROR: Auto-Editor reported success,
    echo     but the XML file was not found.
    echo ------------------------------------------
    echo.
    echo Expected output:
    echo "%OutputFile%"
    echo.
    pause
    exit /b 1
)


REM ------------------------------------------------------------
REM SUCCESS
REM ------------------------------------------------------------

echo.
echo ------------------------------------------
echo [OK] Premiere Pro XML generated
echo     successfully!
echo ------------------------------------------
echo.
echo Output:
echo "%OutputFile%"
echo.


REM ------------------------------------------------------------
REM AUTO CLOSE
REM ------------------------------------------------------------

if "%Auto_Close%"=="0" (
    echo Press any key to close...
    pause >nul
    exit /b 0
)

echo Closing in %Auto_Close% seconds...
timeout /t %Auto_Close% /nobreak >nul


exit /b 0