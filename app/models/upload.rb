class Upload < ApplicationRecord

  def initialize(title, data)
    @title = title
    @data = data
  end

end
