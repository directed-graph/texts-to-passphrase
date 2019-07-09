#!/usr/bin/env bash

set -x

export WORD_COUNT=32
export TEXTS=test-texts/*
files=(
    LICENSE
    README.md
    generate.bash
)

./generate.bash
./generate.bash ${files[@]}
INCLUDE_TEXTS_VARIABLE=no ./generate.bash ${files[@]}

