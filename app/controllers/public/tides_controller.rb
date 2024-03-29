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
    # 潮汐情報の表示に必要なパラメーターが１つでもない場合、indexにリダイレクトする
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
    # @eddと@floodはそれぞれの値をそのままビューに表示＝mapメゾットは不要
    @edd = response_body['tide']['chart'][params[:date]]['edd']
    @flood = response_body['tide']['chart'][params[:date]]['flood']
    
    render 'index'
  end

# AJAXリクエストを受け取り、指定された都道府県コードに一致する港名と港コードのリストをJSON形式で返す
  def get_port_name
    render json: Tide.where(prefecture_code: params[:prefecture_code]).pluck(:port_name, :port_code)
  end
end



# 勉強メモ
# indexアクションでは、Tideモデルから都道府県名と都道府県コードの一意的なリストを取得し、ビューに表示するための準備をする。

# grafアクションでは、ユーザーからのリクエストに基づいて外部APIから潮汐情報を取得する。
# ① まず「ユーザーパラメータ」として、ユーザーがフォームを通じて送信したデータ（都道府県コード、港コード、日付）を受け取る。
# ② 受け取ったパラメータを基に、外部潮汐情報APIへのリクエストURLを組み立てるために加工する。この「リクエストパラメータ」は、APIが要求する特定の形式に合わせて構築される。
# ③ 加工したパラメータを使って外部APIにHTTPリクエストを送信し、潮汐情報を含むJSON形式のレスポンスデータを受け取る。
# ④ 受け取ったJSONデータから必要な情報（潮汐、潮の状態、日出日没時刻、港の位置情報など）を抽出し、ビューで表示するためにインスタンス変数に格納する。
# ⑤ 最終的に、加工されたデータを含むインスタンス変数をビューに渡し、ユーザーに潮汐情報を視覚的に表示する。
# ここでは、「ユーザーパラメータ」の受け取り、「リクエストパラメータ」の加工、外部APIからの「レスポンスデータ」の取得と加工、そしてビューにデータを渡す。



# 「uniq!」はRubyのメソッドで、配列内の要素から重複を取り除き、配列を一意的な要素のみにする。「！」は配列自体を破滅的に変更するメソッドの末尾につく。



# 「and return」を使用することで、リダイレクト後のコード実行を即座に停止。これによって早期にレスポンスを返すこと（今回は必要なパラメータが欠けている場合のリダイレクト）ができる。



# 42行目の「raise」はRubyのメゾットで、APIからのレスポンスをプログラムが正しく処理できなかった場合に、開発者やアプリケーションのログにその事実を記録し、デバッグの手がかりを提供する。
# なので、ユーザー向けのエラーメッセージではないことに注意する。



# eachとmapメソッドの違いは、各要素に繰り返し処理をした結果を元の配列をそのまま返すか、新しい配列として返すかの違い。
# numbers = [1, 2, 3]
# result = numbers.〇〇〇 { |number| number * 10 }
# -eachメゾットだと〇〇〇は、 [1, 2, 3]
# -mapメゾットだと 〇〇〇は、[10, 20, 30]



# 46行目からは外部APIからレスポンス（response_body）内の特定のデータを階層から抽出して、それをビューに返すためにインスタンス変数に格納している。
# このデータをrender index でビューに渡して潮汐情報を表示する。

