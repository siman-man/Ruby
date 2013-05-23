class Hash
  def [] key
    p key
  end
end

hash = Hash.new(3)

hash[:hello]
