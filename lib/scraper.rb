# choose some of these to start  add the rest later. Find the smaller theaters and add those to the list
# https://www.5thavenue.org/
# https://www.seattlerep.org/
# http://www.acttheatre.org
# https://www.sct.org/
# https://www.stgpresents.org/   includes moore, paramount, neptune
# https://www.villagetheatre.org/   everett and issaquah locations

class CurtainCallSeattle::Scraper

    def self.scrape_urls
    # begin
    #   fifth = self.scrape_the_5th('https://www.5thavenue.org/boxoffice#current')
    #   CurtainCallSeattle::Show.create_shows_array(fifth)
    # rescue
    #   puts "5th Ave is broken. Please open issue at https://github.com/Rygel-XVI/curtain-call-seattle-cli-gem/issues"
    # end
    #
    # begin
    #   sct = self.scrape_childrens('http://www.sct.org/onstage/')
    #   CurtainCallSeattle::Show.create_shows_array(sct)
    #
    # rescue
    #   puts "Childrens Theater is broken. Please open issue at https://github.com/Rygel-XVI/curtain-call-seattle-cli-gem/issues"
    # end

    begin
      # paramount = self.scrape_paramount('https://seattle.broadway.com/shows/tickets/')
      paramount = self.scrape_paramount('https://www.broadway.org/theatres/details/paramount-theatre,433')
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
        doc = Nokogiri::HTML(open(url))
        a = doc.css("ul#menu-main-navigation li a")[0]["href"]
        shows_sct('http://www.sct.org/' + a)
      rescue
        puts "scrape childrens not executing"
      end
    end

    def self.shows_sct(url)
      begin
        doc = Nokogiri::HTML(open(url))
        a = doc.css("div.season-production-listing div.row-production-listing")

        sct = CurtainCallSeattle::Theater.new
        sct.location = "201 Thomas St, Seattle, WA 98109"
        sct.name = "Seattle Children's Theater"

        a.map{|i|
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
        a = doc.css("div.tour-date-info")
        # binding.pry
        paramount = CurtainCallSeattle::Theater.new
        paramount.location = "911 Pine St, Seattle, WA 98101"
        paramount.name = "The Paramount Theater"

        a.map{|i|
          binding.pry
          # name: i.children[1].children.text
          # description url == i.children[1].values[0]
          # dates: i.children[3].text.scan(/[a-zA-Z]{3,}\s[0-9]+/)  
          # theater: paramount
        }

        # a.map {|i| {:name => i.css("img").attr("alt").text,
        #     :dates => create_dates_paramount(i),
        #     :theater => paramount,
        #     :description => get_description_paramount("https://seattle.broadway.com" + i.css("a")[1]['href'])}
        # }
      rescue
        puts "scrape_paramount broken"
      end
    end

    # takes in an opened url to traverse to the dates. converts the date into a Date object
    def self.create_dates_paramount(i)
      begin
        b = i.css("p.dates")
        b.at_css("span").remove if b.at_css("span")
        b = b.text
        c = b.split(/\s|,\s|–/)  ##this is a special '–' it is not a hyphen do not delete this

        if c.size == 4  ##format is JAN 2–14, 2018
            dates = [c[0] + " " + c[1] + ", " + c[-1], c[0] + " " + c[2] + ", " + c[-1]]
        elsif c.size == 5 ##format is FEB 6–MAR 18, 2018
            dates = [c[0] + " " + c[1] + ", " + c[-1], c[2] + " " + c[3] + ", " + c[-1]]
        elsif c.size == 6  ##format is DEC 13, 2018–JAN 6, 2019
            dates = [c[0] + " " + c[1] + ", " + c[2], c[3] + " " + c[4] + ", " + c[5]]
        else ##what is a better way? redirecting to the website?
            dates = ["jan 1, #{Date.today.year}", "dec 31, #{Date.today.year}"]
        end

        y = dates.map {|x| Date.parse(x)}
        (y[0]...y[1])
      rescue
        puts "dates_paramount not working"
      end
    end

    def self.get_description_paramount(url)
      begin
        doc = Nokogiri::HTML(open(url))
        doc.css("div.mod-story p").text
      rescue
        puts "description_paramount not working"
      end
    end
end
