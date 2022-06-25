# flwrap

Wrapper similar to [rlwrap](https://github.com/hanslub42/rlwrap) but using
Crystal library [fancyline](https://github.com/Papierkorb/fancyline) instead
of readline. Allows you to get history, some keyboard shortcuts for editing,
and auto-completion in any program.


## Installation

```console
$ shards install
$ shards build --release
$ ./bin/flwrap --help
```

## Usage

```console
$ flwrap tclsh  # without completions
$ flwrap -f completions.txt tclsh  # with completions from file (one per line)
```

## Contributing

1. Fork it (<https://github.com/andriamanitra/flwrap/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Andriamanitra](https://github.com/andriamanitra) - creator and maintainer
