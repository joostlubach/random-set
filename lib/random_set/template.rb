module RandomSet

  # A template for the random set.
  # @api internal
  class Template

    def initialize(templates)
      @hash       = templates.is_a?(Hash)
      @generators = resolve_generators(templates)
    end

    def hash?
      @hash
    end

    def resolve_generators(templates)
      hash = {}

      process = proc do |key, template|
        hash[key] = create_generator(template)
      end

      if hash?
        templates.each &process
      else
        templates.each_with_index { |template, index| process[index, template] }
      end

      hash
    end

    def create_generator(template)
      case template
      when nil then nil
      when ->(t){ t.respond_to?(:next) } then template
      when ->(t){ t.respond_to?(:each) } then template.each
      when Proc then CustomGenerator.new(template)
      else raise UnsupportedTemplate, "cannot create a generator for a template of class #{template.class}"
      end
    end

    attr_reader :generators

    # Gives a count for the items in this template. If no count can be inferred, +nil+ is returned.
    def count
      max = nil
      generators.each do |_key, generator|
        next unless generator && generator.respond_to?(:count)
        max = [ max.to_i, generator.count ].max
      end
      max
    end

    def generate(count = self.count)
      raise CannotInferCount, "no count was specified or could be inferred" unless count

      data = []
      count.times.each { data << generate_next(data) }
      data
    end

    def generate_next(data)
      item = hash? ? {} : []
      generators.each do |key, generator|
        begin
          item[key] = generator.try(:next)
        rescue StopIteration
          # If some enumerator came to the end, we just leave the rest of the keys blank.
          item[key] = nil
        end
      end
      item
    end

    class CustomGenerator

      def initialize(block)
        @block = block
        @iteration = 0
      end

      attr_reader :block

      def next
        if block.arity == 1
          block.call @iteration
        else
          block.call
        end
      ensure
        @iteration += 1
      end

    end

  end

end