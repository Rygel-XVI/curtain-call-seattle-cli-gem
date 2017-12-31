class SeattleTheaterController
   
   def call
       #1. scrapes the websites
       #2. make objects from those websites
       #3. Class show has  :theaters, :dates  the show cannot change these
       #4. Class theater has :shows, :dates, :location
       #5. 
    #   binding.pry
      Scraper.scrape_the_5th('https://www.5thavenue.org/boxoffice#current')
      Scraper.scrape_childrens('https://www.sct.org/Shows/2017-2018-Season')
       
      # asks if you would like shows by theater, date/time, genre
      puts "Would you like shows by theater, genre, or date?"
      input = gets.chomp
      #gets input and calls method mased on input

      case input
      when /theater/i
          shows_by_theater
      when /genre/i
          shows_by_genre
      when /date/i
          shows_by_date
      end
      
      #ask for a specific show and then list the show, it's genre, the dates it is playing at for each theater.
      #also puts a description of the show
      
   end

    #return shows playing at each theater
    def shows_by_theater
        puts "shows_by_theater"
    end
    
    #return shows playing on a specific date (or maybe in order by soonest)
    def shows_by_date
        puts "shows_by_date"
    end
    
    #return shows by genre (kids, musical, play, classic, monologue, other)
    def shows_by_genre
        puts "shows_by_genre"
    end
    
    
end