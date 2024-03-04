require 'base64'
require 'json'
require 'net/https'

class Public::TidesController < ApplicationController
  # エリアの一覧
  def index
    # 「Tide」モデルから都道府県名と都道府県コードの一意的なリストを取得し、@areaに格納する
    @areas = Tide.all.pluck(:prefecture_name, :prefecture_code).uniq!
  end
  
  def graf
    # パラメーターがない場合、indexにリダイレクト
    redirect_to tides_path and return if params[:prefecture_code].blank? || params[:port_code].blank? || params[:date].blank?
    
    # 再び、都道府県名と都道府県コードの一意的なリストを取得
    @areas = Tide.all.pluck(:prefecture_name, :prefecture_code).uniq! # エリアの一覧
    
    # APIのURL
    api_url = "https://tide736.net/api/get_tide.php"

    # APIリクエストに必要なパラメータを組み立て
    parameter = [
        "pc=#{params[:prefecture_code]}",
        "hc=#{params[:port_code]}",
        "yr=#{params[:date].to_date.strftime('%Y')}",
        "mn=#{params[:date].to_date.strftime('%m')}",
        "dy=#{params[:date].to_date.strftime('%d')}",
        "rg=day"
      ].join('&')

    # Google Cloud Vision APIにリクエストを送信
    uri = URI.parse("#{api_url}?#{parameter}")
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    response = https.request(request)
    response_body = JSON.parse(response.body)

    # APIからのレスポンスがエラーの場合、メッセージ
    if response_body['status'] != 1
      raise response_body['message']
    end
    
    # 潮汐、潮の状態、日出日没、港の位置情報をインスタンス変数に格納
    @tides = response_body['tide']['chart'][params[:date]]['tide'].map{|data| [data['time'], data['cm']]} # 潮位
    @tide = response_body['tide']['chart'][params[:date]]['moon']['title'] # 潮汐
    @astro_twilight = response_body['tide']['chart'][params[:date]]['sun']['astro_twilight'] # 日の出・日の入
    @location = [response_body['tide']['port']['latitude'], response_body['tide']['port']['longitude']]
    
    # 干潮と満潮
    @edd = response_body['tide']['chart'][params[:date]]['edd'].map{ |edd| edd }
    @flood = response_body['tide']['chart'][params[:date]]['flood'].map{ |flood| flood }
    
    render 'index'
  end

# AJAXリクエストを受け取り、指定された都道府県コードに一致する港名と港コードのリストをJSON形式で返す
  def get_port_name
    render json: Tide.where(prefecture_code: params[:prefecture_code]).pluck(:port_name, :port_code)
  end
end
