class Crypto

  def initialize(args)
    @aes          = OpenSSL::Cipher::AES128.new(:CBC)
    @bf           = OpenSSL::Cipher::BF.new(:CBC)
    @sk           = args[:sk] ||= 'f{\xE7\xFE\x81\x89S\xC3\xC4\xFB\xCC3k`\xD6\xD2'
    @str          = args[:str]
    @enc          = args[:enc]
    @pk           = args[:pk]
  end

  # expects utf-8, returns hash with hex of encrypted message and public key
  def encrypt_aes
    @aes.encrypt
    @aes.key      = @sk
    pk            = @aes.random_iv.unpack('H*')
    enc           = (@aes.update(@str) + @aes.final).unpack('H*')
    {enc: enc, pk: pk}
  end

  # accepts hex, returns utf-8
  def decrypt_aes
    @aes.decrypt
    @aes.key      = @sk
    @aes.iv       = @pk.pack('H*')
    (@aes.update(@enc.pack('H*')) + @aes.final).force_encoding('utf-8')
  end

  # expects utf-8, returns hex
  def encrypt_bf
    @bf.encrypt
    @bf.key       = @sk
    (@bf.update(@str) + @bf.final).unpack('H*')
  end

  # accepts hex, returns utf-8
  def decrypt_bf
    @bf.decrypt
    @bf.key       = @sk
    (@bf.update(@enc.pack('H*')) + @bf.final).force_encoding('utf-8')
  end

end

