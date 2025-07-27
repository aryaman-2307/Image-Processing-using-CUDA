# Image-Processing-using-CUDA

GPU‑accelerated **median filter** that batch‑processes a directory of PNG/JPG
images using NVIDIA NPP.

## Quick start (Windows 10/11)

1. **Install prerequisites**
   * Visual Studio 2022 Community – *Desktop development with C++*
   * CUDA Toolkit 12.x (tick *Performance Primitives (NPP)*)
   * CMake ≥ 3.25, Git

2. **Open** *x64 Native Tools Command Prompt for VS 2022*

3. **Clone & fetch data**

```bat
git clone https://github.com/your‑handle/cuda-batch-processor.git
cd cuda-batch-processor
powershell -ExecutionPolicy Bypass -File scripts\fetch_data.ps1
