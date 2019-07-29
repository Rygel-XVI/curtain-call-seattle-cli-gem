# choose some of these to start  add the rest later. Find the smaller theaters and add those to the list
# https://www.5thavenue.org/
# https://www.seattlerep.org/
# http://www.acttheatre.org
# https://www.sct.org/
# https://www.stgpresents.org/   includes moore, paramount, neptune
# https://www.villagetheatre.org/   everett and issaquah locations

class CurtainCallSeattle::Scraper

    def self.scrape_urls
    begin
      fifth = self.scrape_the_5th('https://www.5thavenue.org/boxoffice#current')
      CurtainCallSeattle::Show.create_shows_array(fifth)
    rescue
      puts "5th Ave is broken. Please open issue at https://github.com/Rygel-XVI/curtain-call-seattle-cli-gem/issues"
    end

    begin
      sct = self.scrape_childrens('http://www.sct.org/onstage/')
      CurtainCallSeattle::Show.create_shows_array(sct)

    rescue
      puts "Childrens Theater is broken. Please open issue at https://github.com/Rygel-XVI/curtain-call-seattle-cli-gem/issues"
    end

    begin
      paramount = self.scrape_paramount('https://seattle.broadway.com/')
      CurtainCallSeattle::Show.create_shows_array(paramount)
    rescue
      puts "Paramount Theater is broken. Please open issue at https://github.com/Rygel-XVI/curtain-call-seattle-cli-gem/issues"
    end
    end

### Scraper for The 5th Avenue Theater ###
    def self.scrape_the_5th(url)
        doc = Nokogiri::HTML(open(url))
        a = doc.css("td .zero, td .guts div")
        the5th = CurtainCallSeattle::Theater.new
        the5th.location = "1308 5th Ave, Seattle, WA 98101"
        the5th.name = "The 5th Avenue Theater"

        a.map {|i| i.text !~ /\w/ ? next : {:name => i.css("h2 a").text,
                                            :dates => create_dates_5th(i),
                                            :theater => the5th,
                                            :description => parse_description_5th(i)}
        }

    end

    def self.parse_description_5th(i)
        desc = i.css("p")[1].text
        desc.gsub! /\t/, ''
    end


    # takes in an opened url to traverse to the dates. converts the date into a Date object
    def self.create_dates_5th(i)
        d = i.css(".date").text
        d = d.split(/\W{2,}/)
        dates = [d[0] + " " + d[2], d[1] + " " + d[2]]
        y = dates.map {|x| Date.parse(x)}
        (y[0]...y[1])
    end

###Scraper for Seattle Children's Theater###

## add other info from website in the future (ie shows with interpreters, age recommendations)
    def self.scrape_childrens(url)
      begin
        binding.pry
        doc = Nokogiri::HTML(open(url))
        a = doc.css("ul#menu-main-navigation li a")[0]["href"]
        shows_sct('http://www.sct.org/' + a)
      rescue
        puts "scrape childrens not executing"
      end
    end

    def self.shows_sct(url)
      begin
        binding.pry
        doc = Nokogiri::HTML(open(url))
        a = doc.css("div.season-production-listing div.row-production-listing")

        sct = CurtainCallSeattle::Theater.new
        sct.location = "201 Thomas St, Seattle, WA 98109"
        sct.name = "Seattle Children's Theater"

        a.map{|i|
          binding.pry
          {
          name: i.css("div.col-text a")[0].text,
          dates: create_dates_childrens(i),
          theater: sct,
          description: parse_description_childrens(i.css("div.col-text a")[0]["href"])
        }
      }
      rescue
        puts "shows_sct not functioning"
      end
    end

    def self.parse_description_childrens(url)
      begin
        doc = Nokogiri::HTML(open(url))
        desc = doc.css("meta[name='twitter:description']")[0].attributes["content"].value
      rescue
        puts "sct descriptions not functioning"
      end
    end


# takes in an opened url to traverse to the dates. converts the date into a Date object
    def self.create_dates_childrens(i)
      begin
        d = i.css("div.col-text div.dates").text
        d = d.split (/-|,\s/)
        dates = [d[0] + " " + d[2], d[1] + " " + d[2]]
        y = dates.map {|x| Date.parse(x)}
        (y[0]...y[1])
      rescue
        puts "sct date creation not funcitoning"
      end
    end


###Scraper for Paramount Theater ###
    def self.scrape_paramount(url)
      begin
        doc = Nokogiri::HTML(open(url))
        a = doc.css(".engagement-card__title")
        paramount = CurtainCallSeattle::Theater.new
        paramount.location = "911 Pine St, Seattle, WA 98101"
        paramount.name = "The Paramount Theater"

        a.map do |i|
          show_url = i.children[0].values[0]
          scrape_paramount_show(show_url, paramount)
        end
      rescue
        puts "scrape_paramount broken"
      end
    end

    def self.scrape_paramount_show(url, paramount)
      doc = Nokogiri::HTML(open(url))

      {
      name: doc.css(".engagement-card__content .engagement-card__title").text,
      dates: create_dates_paramount(doc.css(".engagement-card__content .engagement-card__performance-dates").text),
      description: doc.css(".accordion__panel p").text,
      theater: paramount
    }
    end

    # takes in an opened url to traverse to the dates. converts the date into a Date object
    def self.create_dates_paramount(i)
      begin

        dates = i.scan(/\w+/)

        if (dates.length === 4)
          d1 = Date.parse(dates[0] + " " + dates[1] + " " + dates[3])
          d2 = Date.parse(dates[0] + " " + dates[2] + " " + dates[3])
        elsif (dates.length === 5)
          d1 = Date.parse(dates[0] + " " + dates[1] + " " + dates[4])
          d2 = Date.parse(dates[2] + " " + dates[3] + " " + dates[4])
        elsif (dates.length === 6)
          d1 = Date.parse(dates[0] + " " + dates[1] + " " + dates[2])
          d2 = Date.parse(dates[3] + " " + dates[4] + " " + dates[5])
        end

        return (d1...d2)

      rescue
        puts "dates_paramount not working"

      end
    end

end
