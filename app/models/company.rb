class Company < ActiveRecord::Base
  has_attached_file :logo, :styles => { :medium => "300x300>", 
                                        :thumb => "100x100>",
                                        :original => "550x400>"}, 
                                        :default_url => "/images/:style_missing.png",
                                        path: ":rails_root/public/uploads/:class/:attachment/:id/:style/album_cover.:extension",
                                        url: "/uploads/:class/:attachment/:id/:style/album_cover.:extension"
  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/
  
  belongs_to :nature
  belongs_to :industry
  belongs_to :financing_stage
  has_many :company_members
  has_many :company_scenes
end
