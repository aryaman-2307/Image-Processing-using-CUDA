#include "img_utils.hpp"

#include <cuda_runtime.h>
#include <nppi_filtering_functions.h>
#include <sys/stat.h>

#define STB_IMAGE_IMPLEMENTATION
#include "../third_party/stb_image.h"
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "../third_party/stb_image_write.h"

#include <algorithm>
#include <filesystem>
#include <iostream>

namespace fs = std::filesystem;
namespace img {


auto ReadGray(const std::string& path, int* w, int* h) -> std::vector<uint8_t> {
    int channels;
    uint8_t* data = stbi_load(path.c_str(), w, h, &channels, 1);
    if (!data) { throw std::runtime_error("Failed to read " + path); }
    std::vector<uint8_t> v(data, data + (*w) * (*h));
    stbi_image_free(data);
    return v;
}

void WriteGray(const std::string& path,
               int w,
               int h,
               const uint8_t* data) {
    if (!stbi_write_png(path.c_str(), w, h, 1, data, w)) {
        throw std::runtime_error("Failed to write " + path);
    }
}


void MedianFilter(const uint8_t* src,
                  uint8_t*       dst,
                  int            width,
                  int            height,
                  int            radius) {
    size_t pitch;
    uint8_t* d_src;
    uint8_t* d_dst;
    cudaMallocPitch(&d_src, &pitch, width, height);
    cudaMallocPitch(&d_dst, &pitch, width, height);
    cudaMemcpy2D(d_src, pitch, src, width, width, height, cudaMemcpyHostToDevice);

    NppiSize oSize{width, height};
    NppiSize oMask{2 * radius + 1, 2 * radius + 1};
    NppiPoint oAnchor{radius, radius};

    NppiSize oRoi{width - 2 * radius, height - 2 * radius};

    Npp8u* pTmp;
    size_t tmp_bytes;
    nppiFilterMedianGetBufferHostSize_8u_C1R(oRoi, oMask, &tmp_bytes);
    cudaMalloc(&pTmp, tmp_bytes);

    NppStatus st = nppiFilterMedian_8u_C1R(
        d_src + pitch * radius + radius, pitch,
        d_dst + pitch * radius + radius, pitch,
        oRoi, oMask, oAnchor, pTmp);
    if (st != NPP_SUCCESS) throw std::runtime_error("NPP failure");

    cudaMemcpy2D(dst, width, d_dst, pitch, width, height, cudaMemcpyDeviceToHost);
    cudaFree(pTmp);
    cudaFree(d_src);
    cudaFree(d_dst);
}

std::vector<std::string> ListImageFiles(const std::string& dir_path) {
    std::vector<std::string> files;
    for (const auto& e : fs::directory_iterator(dir_path)) {
        if (!e.is_regular_file()) continue;
        std::string ext = e.path().extension().string();
        std::transform(ext.begin(), ext.end(), ext.begin(), ::tolower);
        if (ext == ".png" || ext == ".jpg" || ext == ".jpeg") {
            files.push_back(e.path().string());
        }
    }
    std::sort(files.begin(), files.end());
    return files;
}

} 
