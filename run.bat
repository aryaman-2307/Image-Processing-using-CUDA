@echo off
REM ============================================================
REM  Builds (Release) with MSVC + NVCC and runs the demo batch
REM ============================================================

echo === Configuring & building ===
cmake -S . -B build ^
      -G "Visual Studio 17 2022" -A x64 ^
      -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release

echo.
echo === Running demo on sample dataset ===
IF NOT EXIST docs\execution-artifacts\before_after (
    mkdir docs\execution-artifacts\before_after
)

build\bin\batch_processor.exe ^
    --input  data\sample_images ^
    --output docs\execution-artifacts\before_after ^
    --filter median --radius 3 ^
    | powershell -NoLogo -Command ^
        "Tee-Object -FilePath docs\execution-artifacts\log.txt"

echo.
echo ✅  Output images + log written to docs\execution-artifacts\
pause
