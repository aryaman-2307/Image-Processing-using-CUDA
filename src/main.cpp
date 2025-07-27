#include "cli.hpp"
#include "img_utils.hpp"

#include <chrono>
#include <filesystem>
#include <iostream>

namespace fs = std::filesystem;
using Clock  = std::chrono::steady_clock;

int main(int argc, char** argv) {
    Options opt = ParseArgs(argc, argv);
    if (!fs::exists(opt.output_dir)) fs::create_directories(opt.output_dir);

    auto files = img::ListImageFiles(opt.input_dir);
    if (files.empty()) {
        std::cerr << "No images found in " << opt.input_dir << "\n";
        return 1;
    }

    auto t_total = Clock::now();
    size_t px = 0;

    for (const auto& f : files) {
        int w, h;
        auto src = img::ReadGray(f, &w, &h);
        std::vector<uint8_t> dst(src.size());

        auto t0 = Clock::now();
        img::MedianFilter(src.data(), dst.data(), w, h, opt.radius);
        auto t1 = Clock::now();

        fs::path out = fs::path(opt.output_dir) / fs::path(f).filename();
        img::WriteGray(out.string(), w, h, dst.data());

        double ms = std::chrono::duration<double, std::milli>(t1 - t0).count();
        std::cout << "Processed " << f << " (" << w << "x" << h
                  << ") in " << ms << " ms\n";
        px += w * h;
    }

    double ms_total = std::chrono::duration<double, std::milli>(
                          Clock::now() - t_total).count();
    std::cout << "=== Summary ===\nImages: " << files.size()
              << "  Pixels: " << px
              << "  Wall‑time: " << ms_total << " ms\n";
    return 0;
}
