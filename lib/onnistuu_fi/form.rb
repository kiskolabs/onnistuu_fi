module OnnistuuFi
  class Form
    attr_reader :options

    def initialize(signer, options = {})
      @signer = signer
      @options = options

      data = {
        stamp: @options.delete(:stamp) || Time.now,
        return_success: @options.delete(:return_success) || raise(ArgumentError, "missing required parameter: return_success"),
        document: @options.delete(:document) || raise(ArgumentError, "missing required parameter: document"),
        requirements: @options.delete(:requirements) || raise(ArgumentError, "missing required parameter: requirements")
      }
      iv, signed_data = signer.encrypt(data)

      options[:iv] = iv
      options[:data] = signed_data
      validate_options!
    end

    def generate_html
      "<form action='#{API_ENDPOINT}' method='post'>
        #{fields.compact.join("\n")}
        <input type='hidden' name='padding' value='pkcs5' />
        <input type='hidden' name='cipher' value='rijndael-128' />
        #{@options[:button]}
      </form>"
    end

    private

    def validate_options!
      [:customer, :return_failure, :data, :iv].map do |field_name|
        unless options[field_name]
          raise ArgumentError, "missing required parameter: #{field_name}"
        end
      end
    end

    def fields
      [:customer, :return_failure, :return_success, :data, :iv].map {|field_name|
        if options[field_name]
          hidden_field(field_name, options[field_name])
        end
      }
    end

    def hidden_field(name, value)
      "<input type='hidden' name='#{name.to_s}' value='#{value.to_s}' />"
    end
  end
end
