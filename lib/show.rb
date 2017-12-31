class Show
    
    attr_accessor :name, :theater, :dates, :description
    
    @@all = []
    
# add mass assignment initialization later
# when i initialize i should add it to the theater class if it doesn't exist
# maybe add a find or create method for theater and song **module**

    def save
      @@all << self 
    end
    
    def self.all
       @@all 
    end
      
#   if show is found check that the theater is in it's list of theaters else create new song
   def find_or_create(show_hash)
       @@all.each do |show|
        if show_hash[:name] == show.name
            find_or_add_theater(show_hash)
        else
            Show.new(show_hash)
        end
    end
   end
   
#   take in a hash of a show and if the theater is already included in the show's data then ignore else add the theater to the shows theater array and add the show to the theater object
# for now leave :theater as a single item not an array maybe add that later if i end up finding multiple listings or just have multiple songs may ok
   def find_or_add_theater(show_hash)
       if show_hash[:theater] == get_songs_by_name(show_hash[:name]).theater
       
       end
       
   end
   
   def self.get_songs_by_name
      @@all.map {|i| i.name} 
   end
    
end