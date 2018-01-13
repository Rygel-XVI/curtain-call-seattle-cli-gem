
class CurtainCallSeattle::CLI
   
    def call
        puts "Welcome to Curtain Call Seattle!"
        puts "To quit at anytime type quit."
        puts ""
        CurtainCallSeattle::Scraper.scrape_urls
        start
    end
 
   
    def start
      puts "To quit type 'quit'"
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
          start
      end
      
    end
    
    
    def choose_theater
      puts "To quit type 'quit'"
      puts "Which theater would you like to see the shows for?"
      puts "Please enter the corresponding number"
      
      theaters = CurtainCallSeattle::Theater.all
      theaters.each.with_index(1) {|theater, index| puts "#{index}. #{theater.name}"}
      
      input = gets.chomp

      if input.to_i > 0 && input.to_i <= theaters.size
          shows_by_theater(theaters[input.to_i-1].name)
      else
          
          case input
          when /back/i
            start
          when /quit/i
            abort ("Goodbye.")
          end
          
      end
      
      start
    end
    
    #return shows playing at a specific theater
    def shows_by_theater(theater_input)
      theater = CurtainCallSeattle::Theater.find_by_name(theater_input)
      puts "\n\n"
      puts "Shows at " + theater.name
      puts theater.location
      puts "\n\n"
      
      #puts each show name next to an index number + 1
      shows = theater.shows
      if shows.size > 0
        puts_shows_with_index(shows)
      else
          puts "No shows for #{theater}.".colorize(:yellow)
      end
        
        #prompts user to choose a show and then displays all of that shows information
        puts "Pick number to see description or go back."
        input = gets.chomp

        if input =~ /quit/i
            abort ("Goodbye.")
        elsif input.to_i > 0 && input.to_i <= theater.shows.size
            puts ""
            print_show(theater.shows[input.to_i-1])
        end
        
        choose_theater
    end
    
    #return shows playing on a specific date (or maybe in order by soonest)
    def shows_by_date
        
        puts "1. Shows by month?"
        puts "2. Shows playing in a date range?"
        
        input = gets.chomp
      
        case input
        when "1"
        shows_by_month
        when "2"
        shows_by_date_range
        when /quit/i
         abort ("Goodbye.")
        else
         start
        end

    end
    
    #return shows by month
    def shows_by_month
       puts "Choose month by number, abbreviation, or name (1 = jan = january)." 
       
       month = gets.chomp
       month =~ /quit/i ? abort("Goodbye.") : month = month_to_i(month)
        
        if Date.valid_date?(1999, month, 1)
            shows = CurtainCallSeattle::Show.get_shows_by_month(month)
            if shows.size > 0
                puts_shows_with_index(shows)
            
                puts "Pick number to see description or go back."
                input = gets.chomp
    
                if input =~ /quit/i
                    abort ("Goodbye.")
                elsif input.to_i > 0 && input.to_i <= shows.size
                    puts ""
                    print_show(shows[input.to_i-1])
                end
            
            else
               puts "No shows for that month".colorize(:yellow)
            end
            
        else
           puts "Sending you back to the previous choices."
           shows_by_date
        end
        
        shows_by_month
    end
    
    #return shows by a specific date or date range
    def shows_by_date_range
        
        date_array = []
        puts "Initial Date"
        date_array << create_date
        puts "Please enter end date (or the same date if only one day)"
        date_array << create_date
        
        date_array.sort!
        
        shows = CurtainCallSeattle::Show.get_shows_by_date_range(date_array)
        if shows.size > 0
            puts_shows_with_index(shows)
            
            puts "Pick number to see description or go back."
            input = gets.chomp
            
            if input =~ /quit/i
                abort ("Goodbye.")
            elsif input.to_i > 0 && input.to_i <= shows.size
                puts ""
                print_show(shows[input.to_i-1])
            end
            
        else
            puts "No shows between those dates".colorize(:yellow)
        end
          
        shows_by_date
    end
    
    #helper method to get date input from user and returns Date class
    def create_date

        puts "Please enter month if different than current"
        month = gets.chomp
        check_input(month)

        month == "" ? month = Date.today.month : month = month_to_i(month)
        
        puts "Please enter day if different than today"
        day = gets.chomp
        check_input(day)
        
        day == ""  ? day = Date.today.day : day = day.to_i
        
        puts "Please enter year if different then current"
        year = gets.chomp
        check_input(year)
        
        year == ""  ? year = Date.today.year : year = year.to_i
        
        if Date.valid_date?(year, month, day)
            Date.new(year, month, day) 
        else
            puts "Not a valid date: Month #{month}, Day #{day}, Year #{year}."
            shows_by_date_range
        end

    end
    
    #checks user input to see if they want to go back or quit the program
    def check_input(input)
        if input =~ /quit/i
            abort("Goodbye.")
        elsif input =~ /back/i
            shows_by_date
        end
    end
    
    #converts user input for month into an integer
    def month_to_i(month)
        if Date::ABBR_MONTHNAMES.include?(month.capitalize) || Date::MONTHNAMES.include?(month.capitalize)
            month=Date.parse(month)
            month = month.mon
        else
            month = month.to_i
        end
    end


#####This section handles displaying information for the shows#####

    def puts_shows_with_index(shows)
       shows.each.with_index(1) do |show, index| 
          print "#{index}. "
          puts_show_name(show)
          puts_show_dates(show)
          puts "\n"
        end 
    end

    def print_show(show)
          puts_show_name(show)
          puts_show_dates(show)
          puts_show_description(show)
          puts "\n"
    end
    
    #puts theater name and location/address
    def print_theater_from_show(show)
          puts_theater_name(show)
          puts_theater_location(show)
    end
    
    def puts_theater_name(show)
        puts show.theater.name
    end
    
    def puts_theater_location(show)
        puts show.theater.location 
    end

    def puts_show_name(show)
        puts show.name.colorize(:light_magenta).underline
    end
    
    def puts_show_dates(show)
        puts (show.dates.first.to_s + " to " + show.dates.last.to_s).colorize(:magenta)
    end
    
    def puts_show_description(show)
        puts show.description.colorize(:light_blue)
    end

end