class Company < ActiveRecord::Base
  has_attached_file :logo, :processors => [:watermark], :styles => { :medium => "300x300>", 
                                              :thumb => "100x100>",
                                              :original => {:geometry => '550x400>',  
                                                            :watermark_path => "#{Rails.root}/public/watermark.png",#水印图片所在位置  
                                                            :position => 'SouthEast'
                                                          }
                                              }, 
                                              :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/
end
