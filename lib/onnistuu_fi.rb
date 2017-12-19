require "onnistuu_fi/version"
require "onnistuu_fi/signer"
require "onnistuu_fi/form"
require "onnistuu_fi/response"

module OnnistuuFi
  API_ENDPOINT = "https://www.onnistuu.fi/external/entry/"

  def self.generate_form(options = {})
    @client_identifier = options.fetch(:client_identifier) {
      raise(ArgumentError, "missing client_identifier from the passed arguments")
    }
    @encryption_key = options.fetch(:encryption_key) {
      raise(ArgumentError, "missing encryption_key from the passed arguments")
    }

    signer = OnnistuuFi::Signer.new(@client_identifier, @encryption_key)
    fields = options.fetch(:fields)
    fields = fields.merge(customer: @client_identifier)

    if block_given?
      fields[:button] = yield
    else
      fields[:button] = "<button type='submit'>#{fields.fetch(:button_text, 'Sign')}</button>"
    end

    OnnistuuFi::Form.new(signer, fields).generate_html
  end

  def self.decode_response(options = {})
    @client_identifier = options.fetch(:client_identifier) {
      raise(ArgumentError, "missing client_identifier from the passed arguments")
    }
    @encryption_key = options.fetch(:encryption_key) {
      raise(ArgumentError, "missing encryption_key from the passed arguments")
    }

    signer = OnnistuuFi::Signer.new(@client_identifier, @encryption_key)

    OnnistuuFi::Response.new(
      options.fetch(:encrypted_data),
      options.fetch(:iv),
      signer
    ).data
  end
end
