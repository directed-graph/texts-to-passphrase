#!/usr/bin/env bash

# macOS compatibility
shuf=shuf
if ! (which shuf &>/dev/null); then
    shuf=gshuf
fi

if ! (type get_random &>/dev/null); then
    >&2 echo "===> using \$RANDOM as basis for get_random"
    get_random() {
        local upper=${1:-4294967295} # 2^32 - 1
        local lower=${2:-0}
        echo $(($RANDOM * ($upper - $lower + 1) / 32768 + $lower))
    }
fi

set -e -o pipefail

## input options
# minimum number of words for each random line used; we may wish to only pick
# words from lines that have more than a specific number of words
min_num_words=${MIN_NUM_WORDS:-10}
# paths to text files
texts="$@"
if [[ ! "$texts" || "${INCLUDE_TEXTS_VARIABLE:-yes}" == "yes" ]]; then
    texts+=" ${TEXTS:-$(dirname "$0")/texts/*}"
fi

## output options
# number of words to generate
word_count=${WORD_COUNT:-64}
# number of words per line in output; 0 for no limit
per_line=${PER_LINE:-10}

## execution options
# file to store temporary data
temp=${TEMP_FILE:-$(mktemp)}

# TODO: make more efficient by caching/reusing what we can

generated_count=0
printed=0
while (($generated_count < $word_count)); do
    word=
    while [[ ! "$word" ]]; do
        text=$(echo $texts | tr " " "\n" | $shuf | head -n 1)
        line=$(sed "$(get_random $(wc -l <$text) 1)q;d" <$text \
               | tr -cd " a-zA-Z0-9_-" \
               | sed -e 's/^[[:space:]]\{1,\}//' -e 's/[[:space:]]\{1,\}$//')
        num_words=$(echo $line | wc -w)
        if (($num_words >= $min_num_words)); then
            word=$(echo "$line" \
                   | tr -s "[:blank:]" "\n" \
                   | sed "$(get_random $num_words 1)q;d")
        fi
    done
    if (($printed >= $per_line && $per_line != 0)); then
        printf "\n"
        printed=0
    fi
    if (($printed != 0)); then
        printf " "
    fi
    printf -- "$word"
    printed=$(($printed + 1))
    generated_count=$(($generated_count + 1))
done
echo

