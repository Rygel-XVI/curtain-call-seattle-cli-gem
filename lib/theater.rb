class Theater

    attr_accessor :location, :shows
    
    @@all = []
    
    def save
      @@all << self 
    end
    
    def self.all
       @@all 
    end
    
end