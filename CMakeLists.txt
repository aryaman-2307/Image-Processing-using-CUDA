cmake_minimum_required(VERSION 3.20)
project(cuda_batch_processor LANGUAGES CXX CUDA)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CUDA_STANDARD 17)
set(CUDA_SEPARABLE_COMPILATION ON)

add_compile_options($<$<COMPILE_LANGUAGE:CUDA>:--use_fast_math>)
add_compile_options($<$<COMPILE_LANGUAGE:CXX>:-Wall -Wextra -pedantic -O3>)

include_directories(include third_party)

add_executable(batch_processor
    src/main.cpp
    src/img_utils.cu
)

find_package(CUDAToolkit REQUIRED COMPONENTS nppif nppc)

target_link_libraries(batch_processor
    PRIVATE
        CUDA::cudart
        CUDA::nppif
        CUDA::nppc)

set_target_properties(batch_processor PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
)
