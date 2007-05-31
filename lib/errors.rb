module Validatable
  class Errors
    extend Forwardable
    include Enumerable

    def_delegators :errors, :clear, :each, :each_pair, :empty?, :length, :size

    # call-seq: on(attribute)
    # 
    # Returns nil, if no errors are associated with the specified attribute.
    # Returns the error message, if one error is associated with the specified attribute.
    def on(attribute)
      errors[attribute.to_sym]
    end

    def add(attribute, message) #:nodoc:
      errors[attribute.to_sym] = message
    end

    def merge!(errors) #:nodoc:
      errors.each_pair{|k, v| add(k,v)}
      self
    end

    def errors #:nodoc:
      @errors ||= {}
    end

    def count
      size
    end

    def full_messages
      full_messages = []

      errors.each_key do |attribute|
        errors[attribute].each do |msg|
          next if msg.nil?

          if attribute.to_s == "base"
            full_messages << msg
          else
            full_messages << humanize(attribute.to_s) + " " + msg
          end
        end
      end
      full_messages
    end
    
    def humanize(lower_case_and_underscored_word)
      lower_case_and_underscored_word.to_s.gsub(/_id$/, "").gsub(/_/, " ").capitalize
    end
  end
end