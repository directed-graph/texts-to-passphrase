
There are many ways to generate a password. If we use a password manager, we can
usually generate a random string with different characters, numbers, and
symbols. Then, we simply copy and paste those passwords to login.

However, sometimes, we may wish to manually type out the password. For example,
we may want to login on a machine that is not ours (and so we do not wish to set
up our password manager on that machine). Or, we may wish to enter our password
on the phone, but do not wish to put the password manager on the phone itself.

In these situations, what we need is a password generator that generates
passwords that are easy to type. Some password managers provide this ability
(e.g. diceware passwords, or similar). Here, we implement a slightly different
system. We take a set of books, or any arbitrary text. Then, we randomly select
words from those texts (this is almost equivalent to generating a "page number",
a "line number", and a "word number"). The selected words are then our password.


## Implementation

We give each "book" an equal probability of being selected. Note that this is
different from giving each word an equal probability. This is intentional, as
the probability of each "page", "line", and "word" will vary significantly
depending on which "books" you choose. We want to take advantage of that fact.

The main inputs are the text files (or "books") and the number of words to
generate. We will select a random "book", and from that random "book", we will
select a line number in that book (here the line number will account for both
the "page number" and the "line number" in the book anology). Then, we will
select a word number in that line to be our word for this book. This will
repeat until we have generated the number of words we want to generate.

When getting the line we want, we can apply some filtering. For example, we may
wish to ignore all non-alphanumeric characters. Or, we may want to avoid all
lines that have less than a certain amount of words.


## Custom Random Number Generator

You may use a custom random number generator to increase security. By default,
we will use the `bash` built-in `$RANDOM` as a basis to generate the number. If
you want to use a custom generator, export `get_random` as a function or a
program. The `get_random` must take two arguments:

1. the `upper` bound of the randomly generated number
2. the `lower` bound of the randomly generated number

Without exporting `get_random`, we will do the equivalent of the following,
based on [this](https://stackoverflow.com/a/49216005) answer:

    get_random() {
        local upper=${1:-4294967295} # 2^32 - 1
        local lower=${2:-0}
        echo $(($RANDOM * ($upper - $lower + 1) / 32768 + $lower))
    }


## Dependencies

The programs we need include the following:

- `bash`
- `dirname`
- `mktemp`
- `sed`
- `shuf`
- `tr`
- `wc`

On Linux and WSL, these should all be installed by default. On MacOS, you need
to install `coreutils` to get `shuf`. It will be installed as `gshuf`, but
`generate.bash` will automatically find it.

