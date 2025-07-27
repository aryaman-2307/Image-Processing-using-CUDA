#include "img_utils.hpp"

#include <chrono>
#include <cstdlib>
#include <filesystem>
#include <iostream>

namespace fs = std::filesystem;
using Clock  = std::chrono::steady_clock;

struct Options {
    std::string input_dir  = "data/sample_images";
    std::string output_dir = "out";
    std::string filter     = "median";
    int         radius     = 3;
};

Options ParseArgs(int argc, char** argv) {
    Options opt;
    for (int i = 1; i < argc; ++i) {
        std::string a = argv[i];
        if (a == "--input" && i + 1 < argc)  opt.input_dir  = argv[++i];
        else if (a == "--output" && i + 1 < argc) opt.output_dir = argv[++i];
        else if (a == "--filter" && i + 1 < argc) opt.filter = argv[++i];
        else if (a == "--radius" && i + 1 < argc) opt.radius = std::atoi(argv[++i]);
        else {
            std::cerr << "Unknown/invalid arg: " << a << '\n';
            std::exit(1);
        }
    }
    return opt;
}

int main(int argc, char** argv) {
    Options opt = ParseArgs(argc, argv);

    if (!fs::exists(opt.output_dir)) fs::create_directories(opt.output_dir);

    auto files = img::ListImageFiles(opt.input_dir);
    if (files.empty()) {
        std::cerr << "No images found in " << opt.input_dir << '\n';
        return 1;
    }

    auto start_total = Clock::now();
    size_t total_px  = 0;

    for (const auto& path : files) {
        int w, h;
        auto src = img::ReadGray(path, &w, &h);
        std::vector<uint8_t> dst(src.size());

        auto t0 = Clock::now();
        if (opt.filter == "median") {
            img::MedianFilter(src.data(), dst.data(), w, h, opt.radius);
        } else {
            std::cerr << "Unsupported filter\n"; return 1;
        }
        auto t1 = Clock::now();

        fs::path out_path = fs::path(opt.output_dir) / fs::path(path).filename();
        img::WriteGray(out_path.string(), w, h, dst.data());

        double ms = std::chrono::duration<double, std::milli>(t1 - t0).count();
        std::cout << "Processed " << path << " (" << w << "x" << h
                  << ") in " << ms << " ms\n";
        total_px += w * h;
    }

    double ms_total = std::chrono::duration<double, std::milli>(
                          Clock::now() - start_total)
                          .count();
    std::cout << "=== Summary ===\n"
              << "Images   : " << files.size() << "\n"
              << "Pixels   : " << total_px << "\n"
              << "Wall‑time: " << ms_total << " ms\n";
    return 0;
}
