require 'digest'

module DataIntegrity
  class Checksum
    def self.generate(data, bitlength = 256)
      digest = Digest::SHA2.new(bitlength)
      digest.update(data.to_s)
      digest.hexdigest
    end

    def self.verify(data, original_checksum)
      current_checksum = generate(data)
      current_checksum == original_checksum
    end
  end
  class Validator
    def self.validate_type(data, expected_type)
      data.is_a?(expected_type)
    end

    def self.validate_format(data, format_regex)
      !!(data.to_s =~ format_regex)
    end

    def self.validate_range(data, range)
      range.cover?(data)
    end

    def self.validate(data, expected_type, format_regex, range)
      validate_type(data, expected_type) && validate_format(data, format_regex) && validate_range(data, range)
    end

    def castable?(variable, target_type)
      variable.respond_to?("to_#{target_type}")
    end
  end
end