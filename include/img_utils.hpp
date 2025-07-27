#ifndef IMG_UTILS_HPP_
#define IMG_UTILS_HPP_

#include <cstdint>
#include <string>
#include <vector>

namespace img {

std::vector<uint8_t> ReadGray(const std::string& path, int* w, int* h);
void WriteGray(const std::string& path, int w, int h, const uint8_t* data);

void MedianFilter(const uint8_t* src, uint8_t* dst,
                  int width, int height, int radius);

std::vector<std::string> ListImageFiles(const std::string& dir_path);

}  // namespace img
#endif  // IMG_UTILS_HPP_
