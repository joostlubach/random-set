# RandomSet

Generates a series of data based on a template. This template may be a hash
or an array. If a hash is given, the output of this function is an array of hashes.
Conversely, if an array is given, the output is an array of arrays.

Each item in the given template corresponds to an attribute of each item in the result
set, and specifies how its data should be generated.

## Installation

Add this line to your application's Gemfile:

    gem 'random-set'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install random-set

## Examples

Generate an array of tuples, where the second argument is a random number between 0 and 1:

    RandomSet.generate [ (1..3), ->{ rand } ]
    => [ [1, 0.156], [2, 0.782], [3, 0.249] ]

Generate some randomized trend over the last week:

    RandomSet.generate :date => (Date.current - 7.days), :value => ->{ rand }

## Counting

If at least one of the attribute templates is 'fixed-size', e.g. a range or an array,
a count is heuristically found by taking the maximum size. The value `nil` is provided
where an attribute value cannot be inferred:

    RandomSet.generate [ (1..2), (1..4) ]
    => [ [1,1], [1,2], [nil,3], [nil,4] ]

If you have only infinitely sized templates, you need to specify a count:

    RandomSet.generate [ ->{ rand } ]
    => raises CannotInferCount

    RandomSet.generate 3, [ ->{ rand } ]
    => [ [0.562], [0.168], [0.476] ]

## Supported templates

The following templates are supported:

* Anything with an `each` method that returns an Enumerator.
* Procs or lambdas. One (optional) argument is passed: the number of the current iteration.
* An instance of any class that has a `next` method. If this class also has a `count` method,
  it is considered a fixed-size template.

## Built-in generators

The following built-in generators are available as templates:

* Gaussian - a Gaussian (normal distribution) random number generator.
* GaussianTrend - a trend generator using a Gaussian distribution. Each value is taken as the
  mean of the next value.

To use a built-in generator, create an instance in your template:

    RandomSet.generate 5, [ RandomSet::GaussianTrend.new(1000) ]
    => [ [1307.878], [1397.881], [1296.988], [1929.835], [2118.800] ]

## Integration with Faker and others

Using procs, you can easily integrate Faker-like libraries:

    RandomSet.generate 3, [ ->{ Faker::Name.name } ]
    => [ ["Mr. Zita Cruickshank"], ["Godfrey Grady"], ["Mrs. Simone Nikolaus"] ]

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request