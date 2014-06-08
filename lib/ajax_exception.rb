class AjaxException < Exception
  attr_accessor :hash_message
  
  def initialize(msg)
    self.hash_message = msg
  end
  
  def message
    self.hash_message
  end
end