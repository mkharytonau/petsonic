class ProductVariant

  attr_reader :name, :price, :image

  def initialize(name, price, image)
    @name = name
    @price = price
    @image = image
  end

  def to_s
    "ProductVariant(#{name}, #{price}, #{image}"
  end

end