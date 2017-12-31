class Show
    
    attr_accessor :name, :theater, :dates, :description
    
    @@all = []
    
    def save
      @@all << self 
    end
        
    
end