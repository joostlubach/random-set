require 'random_set/gaussian'

module RandomSet

  # Generates a Gaussian trend. For each sample, a Gaussian random number is generated using
  # {Gaussian}, and its value is taken as the mean value for the next value. This produces
  # a natural trend.
  class GaussianTrend

    # Initializes the generator.
    #
    # @param [Float] start
    #   The first mean value.
    # @param [Float] volatility
    #   This number is multiplied with the mean to provide the standard deviation. The higher
    #   the number, the 'wilder' the trend will become. A value of 0.2 (default) produces a
    #   natural trend.
    # @param [Proc] rand_helper
    #   See {Gaussian#initialize}.
    def initialize(start, volatility = 0.2, rand_helper = lambda { Kernel.rand })
      @prev = start
      @volatility = volatility
      @rand_helper = rand_helper
    end

    def next
      @prev = Gaussian.new(@prev, @prev * @volatility, @rand_helper).next
    end

  end

end