require 'base64'
require 'json'
require 'net/https'

class Public::TidesController < ApplicationController
  def index
    @areas = Tide.all.pluck(:prefecture_name, :prefecture_code).uniq!
  end
  
  def graf
    @areas = Tide.all.pluck(:prefecture_name, :prefecture_code).uniq!
    
    # APIのURL作成
    api_url = "https://tide736.net/api/get_tide.php"

    # APIリクエスト用のパラメータ
    parameter = [
        "pc=#{params[:prefecture_code]}",
        "hc=#{params[:port_code]}",
        "yr=#{params[:date].to_date.strftime('%Y')}",
        "mn=#{params[:date].to_date.strftime('%m')}",
        "dy=#{params[:date].to_date.strftime('%d')}",
        "rg=day"
      ].join('&')

    # Google Cloud Vision APIにリクエスト
    uri = URI.parse("#{api_url}?#{parameter}")
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    response = https.request(request)
    @response_body = JSON.parse(response.body)
    # APIレスポンス出力
    if @response_body['status'] != 1
      raise @response_body['message']
    end
    
    render 'index'
  end
  
  def get_port_name
    render json: Tide.where(prefecture_code: params[:prefecture_code]).pluck(:port_name, :port_code)
  end
end
