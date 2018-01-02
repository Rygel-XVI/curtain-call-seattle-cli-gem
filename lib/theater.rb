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
        self.shows << show if !self.shows.include?(show)
    end
    
end