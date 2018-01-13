class CurtainCallSeattle::Theater

    attr_accessor :location, :shows, :name
    
    
    @@all = []
    
    def initialize
        self.shows = []
        save
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
    
    def get_shows_by_name
        shows.map {|show| show.name}
    end
    
   def self.find_by_name(name)
      @@all.detect {|theater| theater.name == name}
   end
   
   def get_shows_by_month(month)
      self.shows.map {|show| array << show if show.show_month_includes?(month)}
   end
    
end