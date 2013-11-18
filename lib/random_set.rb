module RandomSet

  class UnsupportedTemplate < RuntimeError; end
  class CannotInferCount < RuntimeError; end

  class << self

    # @!method generate([count], template)
    #
    # Generates a series of data based on the given template. This template may be a hash
    # or an array. If a hash is given, the output of this function is an array of hashes.
    # Conversely, if an array is given, the output is an array of arrays.
    #
    # @param [Fixnum] count          A count. Leave this out if the count can be inferred.
    # @param [Hash|Array] template   The generator template.
    # @return [Array]                The generated data.
    #
    # @raise [UnsupportedTemplated]  If any of the provided templates was not supported.
    # @raise [CannotInferCount]      If no count was specified, and no count could be inferred.
    def generate(*args)
      raise ArgumentError, "template required" if args.empty?
      raise ArgumentError, "too many arguments (1..2 expected)" if args.length > 2
      Template.new(args.pop).generate *args
    end

  end
end

require 'random_set/template'
require 'random_set/gaussian_trend'