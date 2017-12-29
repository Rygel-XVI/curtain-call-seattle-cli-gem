class SeattleTheaterController
   
   def call
      # asks if you would like shows by theater, date/time, genre
      puts "Would you like shows by theater, genre, or date?"
      input = gets.chomp
      #gets input and calls method mased on input
      
      case input
      when input =~ /theater/i
          shows_by_theater
      when input =~ /genre/i
          shows_by_genre
      when input =~ /date/i
          shows_by_date
      end
      
      #ask for a speific show and then list the show, it's genre, the dates it is play for each theater it is playing at.
      
   end

    def shows_by_theater
        
    end
    
    def shows_by_date
        
    end
    
    def shows_by_genre
        
    end
    
end