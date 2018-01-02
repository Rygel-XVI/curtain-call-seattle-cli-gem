class Theater

    attr_accessor :location, :shows, :name
    
    @@all = []
    
    def initialize
        self.shows = []
    end
    
    def save
      @@all << self 
    end
    
    def self.all
       @@all
    end
    
    def add_show(show)
        shows << show if !shows.include?(show)
    end
    
    def get_songs_by_name
        shows.map {|show| show.name}
    end
    
end