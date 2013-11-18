module RandomSet

  # Generates a Gaussian (normally distributed) random number, using the given mean and standard
  # deviation.
  #
  # Source: http://stackoverflow.com/questions/5825680/code-to-generate-gaussian-normally-distributed-random-numbers-in-ruby
  class Gaussian

    # Initializes the generator.
    #
    # @param [Float] mean    The mean.
    # @param [Float] stddev  The standard deviation.
    # @param [Proc] rand_helper
    #   A proc used to generate the random number. This is Ruby's +rand+ function by default.
    def initialize(mean, stddev, rand_helper = lambda { Kernel.rand })
      @rand_helper = rand_helper
      @mean = mean
      @stddev = stddev
      @valid = false
      @next = 0
    end

    def next
      if @valid then
        @valid = false
        return @next
      else
        @valid = true
        x, y = self.class.gaussian(@mean, @stddev, @rand_helper)
        @next = y
        return x
      end
    end

    private

    def self.gaussian(mean, stddev, rand)
      theta = 2 * Math::PI * rand.call
      rho = Math.sqrt(-2 * Math.log(1 - rand.call))
      scale = stddev * rho
      x = mean + scale * Math.cos(theta)
      y = mean + scale * Math.sin(theta)
      return x, y
    end

  end

end