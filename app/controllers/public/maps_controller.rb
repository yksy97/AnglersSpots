class Public::MapsController < ApplicationController
  def index
    @spots = Spot.all
  end
end
