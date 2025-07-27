#ifndef CLI_HPP_
#define CLI_HPP_

#include <string>

struct Options {
    std::string input_dir  = "data/sample_images";
    std::string output_dir = "out";
    std::string filter     = "median";
    int         radius     = 3;
};

Options ParseArgs(int argc, char** argv);

#endif  // CLI_HPP_
