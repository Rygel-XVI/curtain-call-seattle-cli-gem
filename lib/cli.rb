require 'colorize'
require 'time'
class SeattleTheaterController
   
   def initialize
      Scraper.scrape_the_5th('https://www.5thavenue.org/boxoffice#current')
      Scraper.scrape_childrens('https://www.sct.org/Shows/2017-2018-Season')
   end
   
   
   ##for testing purposes
   def test_call
      shows_by_day
   end
   
#   def call
#       #1. scrapes the websites
#       #2. make objects from those websites
#       #3. Class show has  :theaters, :dates, :description
#       #4. Class theater has :shows, :dates, :location
#       #5. 
       
#       # asks if you would like shows by theater, date/time
#       puts "Would you like shows by theater, date?"
#       input = gets.chomp
#       #gets input and calls method mased on input

#       case input
#       when /theater/i
#           choose_theater
#       when /date/i
#           shows_by_date
#       else
#           call
#       end
      
#       #ask for a specific show and then list the show, it's genre, the dates it is playing at for each theater.
#       #also puts a description of the show
      
#   end
    
    def choose_theater
      puts "Which theater would you like to see the shows for?"
      puts "Please enter the corresponding number"
      puts "1. 5th Avenue Theater"
      puts "2. Seattle Children's Theater"
      puts "3. Go back"
      
      input = gets.chomp
      
      case input
      when "1"
        shows_by_theater("The 5th Avenue Theater")
      when "2"
        shows_by_theater("Seattle Children's Theater")
      when /back|3/i
          test_call
        # call
      else
         choose_theater 
      end
    end
    
    #return shows playing at a specific theater
    def shows_by_theater(x)
      a=Theater.all.detect {|i| i.name == x}

      puts "\n\n"
      puts "Shows at " + x 
      puts a.location
      puts "\n\n"
      
      a.shows.each {|i| print_show(i)}
    end
    
    #return shows playing on a specific date (or maybe in order by soonest)
    def shows_by_date
        
        puts "1. Shows by month?"
        puts "2. Shows playing on a specific date?"
        puts "3. Go back"
        
        input = gets.chomp
      
      case input
      when "1"
        shows_by_month
      when "2"
        shows_by_date_range
      when /back|3/i
        test_call
        # call
      else
         shows_by_date
      end

        ##collect all shows and sort them by start date or end date
        
        #showing all will be too long of a list for a cli
        #do shows by dates the user enters. can be single days or range
        #maybe shows by month
    end
    
    #return shows by month
    def shows_by_month
       puts "Choose month by it's corresponding number (ie Jan = 1, Feb = 2)." 
       
       input = gets.chomp
       if input.to_i == 0
           d=Date.parse(input)
           d.mon ## results 1-12
           Show.get_shows_by_month(d.mon).each do |show|
               puts show.theater.name
               print_show(show)
           end
       elsif input.to_i > 0 && input.to_i < 13
            Show.get_shows_by_month(input.to_i).each do |show| 
                puts show.theater.name
                print_show(show)
            end
       else
           puts "That is not a valid month. Please enter 1-12 or the month"
           shows_by_month
       end
    end
    
    #return shows by a specific date or date range
    def shows_by_day
        date_array = []
        puts "Initial Date"
        date_array << create_date
        puts "Please enter end date (or the same date if only one day)"
        date_array << create_date
        binding.pry
        
        
    end
    
    #helper method to get date input from user
    def create_date

        puts "Please enter month"
        month = gets.chomp
        
        puts "Please enter day"
        day = gets.chomp.to_i
        
        puts "Please enter year"
        year = gets.chomp.to_i
        

        if Date::ABBR_MONTHNAMES.include?(month.capitalize) || Date::MONTHNAMES.include?(month.capitalize)
            binding.pry
            month=Date.parse(month.capitalize)
            month = month.mon
            binding.pry
        else
            month.to_i
        end
        
        if Date.valid_date?(year, month.to_i, day)
            date_string = "#{day}-#{month}-#{year}"
            Date.new(date_string) 
        else
            puts "Not a valid date: Month #{month}, Day #{day}, Year #{year}."
            shows_by_day
        end

        Date.new(date_string)
    end
    
    
    def print_show(show)
          puts show.name.colorize(:light_magenta)  ##red
          puts show.dates.first.to_s.colorize(:light_red) + " to " + show.dates.last.to_s.colorize(:light_red) ##light_red
          puts show.description.colorize(:red)
          puts "\n"
    end

end