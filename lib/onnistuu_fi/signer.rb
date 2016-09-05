require "mcrypt"
require "base64"
require "openssl"

module OnnistuuFi
  class Signer
    def initialize(client_identifier, encryption_key)
      @client_identifier = client_identifier
      @encryption_key = Base64.decode64(encryption_key)
    end

    # Returns [base64_iv, base64_encrypted_data]
    def encrypt(data)
      iv = OpenSSL::Cipher::Cipher.new("AES-256-CBC").random_iv.unpack("H*").first
      mcrypt = Mcrypt.new(:rijndael_256, :cbc, @encryption_key, iv, :pkcs)

      [Base64.encode64(iv), Base64.encode64(mcrypt.encrypt(JSON.dump(data)))]
    end

    # Parameters:
    # - encrypted data in base64
    # - iv in base64
    #
    # Returns decrypted data
    def decrypt(encrypted, iv)
      mcrypt = Mcrypt.new(:rijndael_256, :cbc, @encryption_key, Base64.decode64(iv), :pkcs)

      JSON.load(mcrypt.decrypt(Base64.decode64(encrypted)))
    end
  end
end
