require 'colorize'
class SeattleTheaterController
   
   def initialize
      Scraper.scrape_the_5th('https://www.5thavenue.org/boxoffice#current')
      Scraper.scrape_childrens('https://www.sct.org/Shows/2017-2018-Season')
   end
   
   def call
    #   binding.pry
       #1. scrapes the websites
       #2. make objects from those websites
       #3. Class show has  :theaters, :dates  the show cannot change these
       #4. Class theater has :shows, :dates, :location
       #5. 
    #   binding.pry
       
      # asks if you would like shows by theater, date/time, genre
      puts "Would you like shows by theater, date?"
      input = gets.chomp
      #gets input and calls method mased on input

      case input
      when /theater/i
          choose_theater
      when /date/i
          shows_by_date
      else
          call
      end
      
      #ask for a specific show and then list the show, it's genre, the dates it is playing at for each theater.
      #also puts a description of the show
      
   end
    
    def choose_theater
      puts "Which theater would you like to see the shows for?"
      puts "Please enter the corresponding number"
      puts "1. 5th Avenue Theater"
      puts "2. Seattle Children's Theater"
      
      input = gets.chomp
      
      case input
      when "1"
        shows_by_theater("The 5th Avenue Theater")
      when "2"
        shows_by_theater("Seattle Children's Theater")
      when "back"
        call
      else
         choose_theater 
      end
    end
    
    #return shows playing at each theater
    def shows_by_theater(x)
      a = Show.all.select {|show| show.theater == x}
      puts "Shows at " + x 
      binding.pry
    #   puts a[0].theater.location  ##currently not an object have to refactor to fix this
      puts "\n\n"
      a.each do |i|
          puts i.name.colorize(:light_magenta)  ##red
          puts i.dates.colorize(:light_red)  ##light_red
          puts i.description.colorize(:red)
          puts "\n"
      end
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