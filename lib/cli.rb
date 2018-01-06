require 'colorize'
require 'time'
class SeattleTheaterController
   
   def initialize
      Scraper.scrape_the_5th('https://www.5thavenue.org/boxoffice#current')
      Scraper.scrape_childrens('https://www.sct.org/Shows/2017-2018-Season')
   end
   
   
   ##for testing purposes
#   def test_call
#       shows_by_day
#   end
   
  def call

      puts "Would you like shows by 1.theater or 2.date?"
      input = gets.chomp

      case input
      when /theater|1/i
          choose_theater
      when /date|2/i
          shows_by_date
      when /quit/i
          abort ("Goodbye.")
      else
          call
      end

  end
    
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
        #   test_call
        call
      when /quit/i
        abort ("Goodbye.")
      else
         choose_theater 
      end
      call
    end
    
    #return shows playing at a specific theater
    def shows_by_theater(x)
      theater = Theater.find_by_name(x)
      a = theater.get_shows_by_name
      puts "\n\n"
      puts "Shows at " + theater.name
      puts theater.location
      puts "\n\n"
      
      theater.shows.each.with_index(1) do |show, index| 
          puts "#{index}. #{show.name.colorize(:light_magenta)}"  #red
          puts show.dates.first.to_s.colorize(:light_red) + " to " + show.dates.last.to_s.colorize(:light_red)
          puts "\n"
        end
        
        puts "Pick number to see description or go back."
        input = gets.chomp
        
        if input == /quit/i
            abort ("Goodbye.")
        elsif input.to_i > 0 && input.to_i <= theater.shows.size
            puts theater.shows[input.to_i-1].description
            puts ""
        else
            choose_theater
        end
            
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
        shows_by_day
      when /back|3/i
        call
      when /quit/i
         abort ("Goodbye.")
      else
         shows_by_date
      end
      call
    end
    
    #return shows by month
    def shows_by_month
       puts "Choose month by it's corresponding number (ie Jan = 1, Feb = 2)." 
       
       month = gets.chomp
       
       if month == /quit/i
           abort ("Goodbye.")
       elsif Date::ABBR_MONTHNAMES.include?(month.capitalize) || Date::MONTHNAMES.include?(month.capitalize)
            month=Date.parse(month)
            month = month.mon
        else
            month = month.to_i
        end
        
        if Date.valid_date?(1999, month, 1)
            Show.get_shows_by_month(month).each do |show|
               puts show.theater.name
               print_show(show)
           end
       else
           puts "That didn't work. Sending you back to the previous choices."
           shows_by_date
       end

    end
    
    #return shows by a specific date or date range
    def shows_by_day
        
        date_array = []
        puts "Initial Date"
        date_array << create_date
        puts "Please enter end date (or the same date if only one day)"
        date_array << create_date
        
        date_array.sort!
        
        Show.all.each do |show|
           print_show(show) if show.dates.first <= date_array[1] || show.dates.last >= date_array[0]
        end

    end
    
    #helper method to get date input from user and returns Date class
    def create_date

        puts "Please enter month"
        month = gets.chomp
        
        puts "Please enter day"
        day = gets.chomp.to_i
        
        puts "Please enter year"
        year = gets.chomp.to_i
        
        if Date::ABBR_MONTHNAMES.include?(month.capitalize) || Date::MONTHNAMES.include?(month.capitalize)
            month=Date.parse(month)
            month = month.mon
        else
            month = month.to_i
        end
        
        if Date.valid_date?(year, month, day)
            Date.new(year, month, day) 
        else
            puts "Not a valid date: Month #{month}, Day #{day}, Year #{year}."
            shows_by_day
        end

    end
    
    
    def print_show(show)
          puts show.name.colorize(:light_magenta)  ##red
          puts show.dates.first.to_s.colorize(:light_red) + " to " + show.dates.last.to_s.colorize(:light_red) ##light_red
          puts show.description.colorize(:red)
          puts "\n"
    end

end