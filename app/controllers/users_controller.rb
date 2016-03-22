class UsersController < ApplicationController
  require 'will_paginate/array'
  def index
    p "....../..."
    @list = [1,2,3,4,5,6,7,8,9,10]
    @per_page = params[:page_size] || 5
    @page = params[:page] || 1
    @result = @list.paginate(:per_page => @per_page, :page => @page)
    respond_to do |format|
      format.html
      format.js
    end
  end


  def show

  end

  def new
  end

  def edit
  end


  def create
  end


end
