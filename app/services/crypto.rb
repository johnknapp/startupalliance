class Crypto

  def initialize(args)
    @aes          = OpenSSL::Cipher::AES128.new(:CBC)
    @sk           = args[:sk] ||= 'decae6b1999d75bd'
    @str          = args[:str]
    @enc          = args[:enc]
    @pk           = args[:pk]
  end

  # expects utf-8, returns hash with hex of encrypted message and public key
  def encrypt
    @aes.encrypt
    @aes.key      = @sk
    pk            = @aes.random_iv.unpack('H*')
    enc           = (@aes.update(@str) + @aes.final).unpack('H*')
    {enc: enc, pk: pk}
  end

  # accepts hex, returns utf-8
  def decrypt
    @aes.decrypt
    @aes.key      = @sk
    @aes.iv       = @pk.pack('H*')
    (@aes.update(@enc.pack('H*')) + @aes.final).force_encoding('utf-8')
  end

end

