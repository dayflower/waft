require 'openssl'
require 'securerandom'

module Waft
  module Util
    class << self
      def encrypt(password, data)
        salt = SecureRandom.random_bytes(8)

        cipher = OpenSSL::Cipher.new('aes-256-gcm')
        cipher.encrypt

        cipher.key, cipher.iv = generate_key_iv(cipher, password, salt)
        cipher.auth_data = ''

        binary = data.dup.force_encoding('ASCII-8BIT')
        encrypted = cipher.update(binary) + cipher.final
        tag = cipher.auth_tag

        salt + encrypted + tag
      end

      def decrypt(password, data)
        binary = data.dup.force_encoding('ASCII-8BIT')
        salt = binary[0, 8]
        tag = binary[-16, 16]
        encrypted = binary[8...-16]

        cipher = OpenSSL::Cipher.new('aes-256-gcm')
        cipher.decrypt

        cipher.key, cipher.iv = generate_key_iv(cipher, password, salt)
        cipher.auth_data = ''
        cipher.auth_tag = tag

        decrypted = cipher.update(encrypted) + cipher.final

        decrypted
      end

      private

      def generate_key_iv(cipher, password, salt)
        key_iv = OpenSSL::PKCS5.pbkdf2_hmac(password, salt, 1974, cipher.key_len + cipher.iv_len, 'sha256')
        key = key_iv[0, cipher.key_len]
        iv = key_iv[cipher.key_len, cipher.iv_len]
        return key, iv
      end
    end
  end
end
