cmake_minimum_required(VERSION 3.31)
project(example)

enable_testing()
add_executable(example_test example_test.c)
add_test(NAME example_test COMMAND example_test)
