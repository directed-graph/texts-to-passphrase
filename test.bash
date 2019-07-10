#!/usr/bin/env bash

set -x

export TEXTS=test-texts/*
export VERBOSE=yes
export WORD_COUNT=32

files=(
    LICENSE
    README.md
    generate.bash
)

./generate.bash
./generate.bash ${files[@]}
INCLUDE_TEXTS_VARIABLE=no ./generate.bash ${files[@]}

