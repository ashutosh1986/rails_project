class ScrapsController < ApplicationController
  require 'nokogiri'
  require 'open-uri'
  require 'rest-client'
  def index
    restaurant_details
    #render json: {:restaurant_details =>@doc}
    respond_to do |format|
      format.html
      format.json { render json: {:restaurant_details =>@doc}}
    end
  end

  def show
    p params["id"]
    @res = restaurant_details.select{|res| res[:name] == params["id"]}.first
    respond_to do |format|
      format.html
      format.json { render json: @res}
    end
  end

  private

  def restaurant_details
    url = 'https://www.zomato.com/ncr/microbreweries'
    doc = Nokogiri::HTML(open(url))
    @doc = doc.css(".top-res-box").map do |cl|

      {
          :name => cl.at_css(".top-res-box-overlay a")[:href].split("/").last,
          :cusines => cl.at_css(".top-res-box-cuisine2").text,
          :price => cl.at_css(".top-res-box-cft").text,
          :rating => cl.css(".top-res-box-rating").text.strip
      }
    end
  end


end