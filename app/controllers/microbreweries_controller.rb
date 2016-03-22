class MicrobreweriesController < ApplicationController
  require 'will_paginate/array'
  require 'rest-client'
  ZOMATO_API_KEY = "8c61abd70d564d6fb45081b32de5ac9b"

  def rest_call(type, path, query, payload=nil)
    headers = {
        :content_type => 'application/json',
        :accept => 'application/json',
        'X-Zomato-API-Key' => ZOMATO_API_KEY
    }
    headers[:params] = query
    url = URI.escape("https://developers.zomato.com/api/v2.1"+ path)
    p url
    begin
      response = RestClient::Request.execute(:method => type, :url => url, :headers => headers, :payload => payload)
    rescue => e
      p e.response
    end
    JSON.parse(response)
  end

  def index
    city_id = rest_call(:get, "/cities", {'q' => 'ncr'})["location_suggestions"][0]["id"]
    collection_id = rest_call(:get, "/collections", {'city_id' => city_id})["collections"].select{|collection| collection["collection"]["title"] == "Microbreweries"}[0]["collection"]["collection_id"]
    microbreweries = rest_call(:get, "/search", {'entity_id' => city_id, 'entity_type' => 'city', 'collection_id' => collection_id})
    @restaurants =  microbreweries["restaurants"]
    microbrewery_restaurant = []
    @restaurants.each do |restaurant|
      arr = [restaurant["restaurant"]["thumb"],restaurant["restaurant"]["name"]]
      microbrewery_restaurant.push(arr)
    end
    per_page = params[:page_size] || 5
    page = params[:page] || 1
    @result = microbrewery_restaurant.paginate(:per_page => per_page, :page => page)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    city_id = rest_call(:get, "/cities", {'q' => 'ncr'})["location_suggestions"][0]["id"]
    collection_id = rest_call(:get, "/collections", {'city_id' => city_id})["collections"].select{|collection| collection["collection"]["title"] == "Microbreweries"}[0]["collection"]["collection_id"]
    search_microbreweries = rest_call(:get, "/search", {'entity_id' => city_id, 'entity_type' => 'city', 'collection_id' => collection_id})["restaurants"].select{|r| r["restaurant"]["name"] == params["id"]}[0]
    res_id = search_microbreweries["restaurant"]["R"]["res_id"]
    p res_id
    @restaurant = rest_call(:get, "/restaurant", {'res_id' => res_id})
    respond_to do |format|
      format.html
      format.js
    end
  end

end
