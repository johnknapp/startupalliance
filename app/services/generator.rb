class Generator

  def self.uid
    rand(36**36).to_s(36) + '@skillbank.io'
  end

  def self.pid(object)
    klass = object.class
    ary_of_pids = klass.all.pluck(:pid)
    pid = make_pid
    while ary_of_pids.include?(pid) # verified unique before returning
      pid = make_pid
    end
    pid
  end

  # See https://github.com/genericsteele/token_phrase for inspiration on uniqueness strategy
  # def self.upid
  #   begin
  #     pid = make_pid
  #   end while self.class.exists?(pid: pid)
  # end

  def self.code(length)
      array = %w[b c e f g h i j k n o p r s t v x y 1 2 3 4 5 6 7 8 9 0]
      array.sample(length).join
  end

  private

    # 13,585,136 unique pids, add 6 to length array for 340,278,128 unique pids
    def self.make_pid
      length  = %w[3 4 5].sample
      type    = %w[letters numbers both].sample
      case type
        when 'letters'
          pid = %w[b c e f g h i j k n o p r s t v x y].sample(length.to_i).join
        when 'numbers'
          pid = %w[1 2 3 4 5 6 7 8 9 0].sample(length.to_i).join
        else
          pid = %w[b c e f g h i j k n o p r s t v x y 1 2 3 4 5 6 7 8 9 0].sample(length.to_i).join
      end
      pid
    end

end

# 10^3 + 10^4 + 10^5 + 16^3 + 16^4 + 16^5 + 26^3 + 26^4 + 26^5                      =  13,585,136
# 10^3 + 10^4 + 10^5 + 16^3 + 16^4 + 16^5 + 26^3 + 26^4 + 26^5 + 10^6 + 16^6 + 26^6 = 340,278,128