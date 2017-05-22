module OnnistuuFi
  class Form
    attr_reader :options

    def initialize(signer, options = {})
      @signer = signer
      @options = options

      data = {
        stamp: @options.delete(:stamp) || Time.now,
        return_success: @options.delete(:return_success),
        document: @options.delete(:document),
        requirements: @options.delete(:requirements)
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
      # TODO
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
