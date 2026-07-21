

#include <limits.h>

#include "gtest/gtest.h"
namespace {

bool int2bool(int n) {
  return n;
}

// Tests positive input.
TEST(ExampleTest, Positive) {
  EXPECT_FALSE(int2bool(0));
  EXPECT_TRUE(int2bool(1));
  EXPECT_TRUE(int2bool(-1));
}
// Tests positive input.
TEST(ExampleTest, Negative) {
  EXPECT_FALSE(int2bool(6));
}
}  // namespace