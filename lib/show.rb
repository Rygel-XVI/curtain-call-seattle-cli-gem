class Show
    
    attr_accessor :name, :theater, :dates, :description
    
    @@all = []
    
# add mass assignment initialization later
# when i initialize i should add it to the theater class if it doesn't exist
# maybe add a find or create method for theater and song **module**

    # def initialize(show_hash)
    #     show_hash.each {|key, value| self.send(("#{key}="), value)}
    #     save
    # end
    
    def theater=(theater)
       @theater = theater
       theater.add_show(self)
    end
    
    def save
      @@all << self 
    end
    
    def self.all
       @@all 
    end
      
#   if show is exists check that the theater is in it's list of theaters else create new song
#   def self.exists?(show_name)
#       @@all.detect {|x| x.name == show_name}
#   end
   
#   def self.get_dates
#       self.dates.map do |i|  
#         #   binding.pry
#          i.dates
#       end
#   end
   
   def self.get_shows_by_month(month)
      self.all.select {|i| i.dates.first.mon == month}
   end
   
   def self.get_shows_by_name
      self.all.map {|i| i.name} 
   end
    
end