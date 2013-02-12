# Usage

It is just an executable ruby program:

    bin/nosy_git README.md

But you do need to be within a git repository.

## Options

* `-f, --format`. Defaults to `pretty`, other option is `csv`

## Running the tests -- missing rubygems

If you run the tests and you get an error from bundler like: 

```
no such file to load -- rubygems`, 
```

it means your default ruby installation is missing rubygems.

The shell call made during the tests does not run under the same rvm context.

Install rubygems for your default ruby `which -a ruby`.

```
$ sudo apt-get install rubygems
```

# Notes 
## R Usage

R can be invoked from its cli using something like:

    # R --vanilla --args "csv/sample_data.csv" "out/xxx.png" < example.R

read in a `.R` file, and supply data and output as args, R will connect it all together.

## Analyzing a git repository

As inspired by Kent Beck's Closure of Code (can't find earl).

to find all the files in a repo:

   $ git ls-tree -r --name-only HEAD | wc -l

to collect all modifications:

  $ git log --name-status | grep -Ei "^[MA]\s+" | sort | uniq -c | sort -h | sed 's/^ *//g' | grep -Eo ^[0-9]+
