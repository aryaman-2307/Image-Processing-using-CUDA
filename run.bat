@echo off
rem -------------------- run.bat (VS 2019 edition) --------------------

:: Make sure you are inside **x64 Native Tools Command Prompt for VS 2019**

echo === Configuring ^& building ===
cmake -S . -B build ^
      -G "Visual Studio 16 2019" -A x64 ^
      -DCMAKE_BUILD_TYPE=Release
if errorlevel 1 (
    echo CMake configure failed.  Aborting.
    exit /b 1
)

cmake --build build --config Release
if errorlevel 1 (
    echo Build failed.  Aborting.
    exit /b 1
)

echo === Running demo on sample dataset ===
if not exist docs\execution-artifacts\before_after (
    mkdir docs\execution-artifacts\before_after
)

build\bin\batch_processor.exe ^
    --input  data\sample_images ^
    --output docs\execution-artifacts\before_after ^
    --filter median --radius 3 ^
    | powershell -NoLogo -Command ^
        "Tee-Object -FilePath docs\execution-artifacts\log.txt"

echo Done.
pause
