#!/bin/bash
set -e

flutter test --coverage $1
# lcov --remove coverage/lcov.info 'lib/Api/third-party/*' -o coverage/lcov.info
genhtml coverage/lcov.info -o coverage/html