
class CurtainCallSeattle::SeattleTheaterController
   
   def create_shows
      fifth = CurtainCallSeattle::Scraper.scrape_the_5th('https://www.5thavenue.org/boxoffice#current')
      CurtainCallSeattle::Show.create_shows_array(fifth)
      
      sct = CurtainCallSeattle::Scraper.scrape_childrens('http://www.sct.org/shows/')
      CurtainCallSeattle::Show.create_shows_array(sct)
      
      start
   end
   
  def start

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
    def shows_by_theater(x)
      theater = CurtainCallSeattle::Theater.find_by_name(x)
      puts "\n\n"
      puts "Shows at " + theater.name
      puts theater.location
      puts "\n\n"
      
      if theater.shows.size > 0
        theater.shows.each.with_index(1) do |show, index| 
          puts "#{index}. #{show.name.colorize(:light_magenta)}"
          puts (show.dates.first.to_s + " to " + show.dates.last.to_s).colorize(:light_blue)
          puts "\n"
        end
      else
          puts "No shows for #{theater}."
      end
        
        puts "Pick number to see description or go back."
        input = gets.chomp

        if input =~ /quit/i
            abort ("Goodbye.")
        elsif input.to_i > 0 && input.to_i <= theater.shows.size
            puts (theater.shows[input.to_i-1].description).colorize(:blue)
            puts ""
        end
        choose_theater
    end
    
    #return shows playing on a specific date (or maybe in order by soonest)
    def shows_by_date
        
        puts "1. Shows by month?"
        puts "2. Shows playing on a specific date?"
        
        input = gets.chomp
      
      case input
      when "1"
        shows_by_month
      when "2"
        shows_by_day
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
                shows.each.with_index(1) do |show, index|
                   puts show.theater.name.colorize(:cyan)
                   puts "#{index}. #{show.name}"
                   binding.pry
                   CurtainCallSeattle::Theater.get_shows_by_month(month)
                   print_show(show)
               end
            else
               puts "No shows for that month"
            end
        else
           puts "Sending you back to the previous choices."
           shows_by_date
        end
        
        shows_by_month
    end
    
    #return shows by a specific date or date range
    def shows_by_day
        
        date_array = []
        puts "Initial Date"
        date_array << create_date
        puts "Please enter end date (or the same date if only one day)"
        date_array << create_date
        
        date_array.sort!
        CurtainCallSeattle::Show.all.each do |show|
          if (show.dates.first <= date_array[1] && show.dates.first >= date_array[0]) || (show.dates.last >= date_array[0] && show.dates.last <= date_array[1]) || (show.dates.first < date_array[0] && show.dates.last > date_array[1])
              puts show.theater.name.colorize(:cyan)
              puts show.theater.location.colorize(:cyan)
              print_show(show)
          end
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
            shows_by_day
        end

    end
    
    def check_input(input)
        if input =~ /quit/i
            abort("Goodbye.")
        elsif input =~ /back/i
            shows_by_date
        end
    end
    
    #converts month user input to an integer
    def month_to_i(month)
        if Date::ABBR_MONTHNAMES.include?(month.capitalize) || Date::MONTHNAMES.include?(month.capitalize)
            month=Date.parse(month)
            month = month.mon
        else
            month = month.to_i
        end
    end
    
    #puts show information including description
    def print_show(show)
          puts show.name.colorize(:light_magenta)
          puts (show.dates.first.to_s + " to " + show.dates.last.to_s).colorize(:light_blue)
          puts show.description.colorize(:blue)
          puts "\n"
    end

end