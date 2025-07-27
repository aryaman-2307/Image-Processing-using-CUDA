#ifndef IMG_UTILS_HPP_
#define IMG_UTILS_HPP_

#include <cstdint>
#include <string>
#include <vector>

namespace img {

/**
 * Reads an 8‑bit grayscale image using stb_image.
 * Returns width, height, and pixel data (row-major).
 */
auto ReadGray(const std::string& path, int* w, int* h) -> std::vector<uint8_t>;

/**
 * Writes an 8‑bit grayscale PNG using stb_image_write.
 */
void WriteGray(const std::string& path,
               int                     w,
               int                     h,
               const uint8_t*          data);

/**
 * Applies a median filter (`radius` pixels) using NVIDIA NPP.
 * Input and output buffers are host‑resident; the function handles GPU copies.
 */
void MedianFilter(const uint8_t* src,
                  uint8_t*       dst,
                  int            width,
                  int            height,
                  int            radius);

/**
 * Returns list of regular files (non‑recursive) in `dir_path`
 * whose extension is .png / .jpg / .jpeg.
 */
std::vector<std::string> ListImageFiles(const std::string& dir_path);

}  // namespace img
#endif  // IMG_UTILS_HPP_
