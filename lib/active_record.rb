module ActiveRecord
  class Base
  
    #修改默认to_s方法
    def to_s
      return self.name if self.has_attribute?(:name)
      super
    end
  end
end