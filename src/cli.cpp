#include "cli.hpp"

#include <cstdlib>
#include <iostream>

Options ParseArgs(int argc, char** argv) {
    Options opt;
    for (int i = 1; i < argc; ++i) {
        std::string a = argv[i];
        if (a == "--input"  && i + 1 < argc) opt.input_dir  = argv[++i];
        else if (a == "--output" && i + 1 < argc) opt.output_dir = argv[++i];
        else if (a == "--filter" && i + 1 < argc) opt.filter     = argv[++i];
        else if (a == "--radius" && i + 1 < argc) opt.radius     = std::atoi(argv[++i]);
        else {
            std::cerr << "Unknown / bad arg: " << a << "\n";
            std::exit(1);
        }
    }
    return opt;
}
