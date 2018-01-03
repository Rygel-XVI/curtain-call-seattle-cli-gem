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
      
#   if show is found check that the theater is in it's list of theaters else create new song
   def self.exists?(show_name)
       @@all.detect {|x| x.name == show_name}
   end
   
#   take in a hash of a show and if the theater is already included in the show's data then ignore else add the theater to the shows theater array and add the show to the theater object
# for now leave :theater as a single item not an array maybe add that later if i end up finding multiple listings or just have multiple songs may ok
   def find_or_add_theater(show_hash)
       if show_hash[:theater] == get_songs_by_name(show_hash[:name]).theater
       
       end
       
   end
   
   def self.get_dates
      self.dates.map do |i|  
        #   binding.pry
         i.dates
      end
   end
   
   def self.get_shows_by_month(month)
      a=Show.all.select do |i| 
        #   binding.pry
          i.dates.first.mon == month
        #  binding.pry
     end
   end
   
   def self.get_shows_by_name
      @@all.map {|i| i.name} 
   end
    
end