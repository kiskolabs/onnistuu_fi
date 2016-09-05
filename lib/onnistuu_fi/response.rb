require "json"

module OnnistuuFi
  class Response
    attr_reader :signer

    def initialize(encrypted, iv, signer)
      @encrypted = encrypted
      @iv = iv
      @signer = signer
    end

    def data
      signer.decrypt(@encrypted, @iv)
    end
  end
end
