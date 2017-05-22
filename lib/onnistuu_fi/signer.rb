require "base64"
require "openssl"

module OnnistuuFi
  class Signer
    attr_accessor :key

    def initialize(_key, keycode)
      self.key = Base64.decode64(keycode)
    end

    def encrypt(message)
      return nil if message.nil?

      iv = OpenSSL::Cipher::Cipher.new("AES-128-CBC").random_iv
      aes = OpenSSL::Cipher.new('AES-256-CBC')
      aes.encrypt
      aes.key = key
      aes.iv = iv
      encrypted_data = aes.update(JSON.dump(message)) + aes.final
      [Base64.encode64(iv), Base64.encode64(encrypted_data)]
    end

    def decrypt(encrypted_data, iv)
      return nil if encrypted_data.nil?
      encrypted_data = Base64.decode64(encrypted_data).strip
      iv = Base64.decode64(iv).strip
      aes = OpenSSL::Cipher.new('AES-256-CBC')
      aes.decrypt
      aes.key = key
      aes.iv = iv
      message = (aes.update(encrypted_data) + aes.final)
      JSON.load(message)
    end
  end
end
