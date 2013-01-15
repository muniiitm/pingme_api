class Associate < ActiveRecord::Base 
  has_many :locations, :through => :associate_location
  has_many :associate_logins
  
  def log(ip)
    self.associate_logins.build(:login_ip=>ip)
    self.save
  end
    
end