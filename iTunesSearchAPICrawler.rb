# AppStoreのデータ取得
require 'openssl'
require 'net/http'
require 'json'
require 'FileUtils'

TIMEOUT_SEC = 10

url = 'itunes.apple.com'
https = Net::HTTP.new(url, 443)
https.open_timeout = TIMEOUT_SEC
https.read_timeout = TIMEOUT_SEC
https.use_ssl = true
https.verify_mode = OpenSSL::SSL::VERIFY_PEER
https.verify_depth = 5

begin

  # categories = Array[
  #   'games','education','kids',
  #   'photo','video','entertainment',
  #   'productivity','shopping','lifestyle',
  #   'social','networking','health','fitness',
  #   'travel','news','weather',
  #   'navigation','buisiness','finance',
  #   'food','drink','music',
  #   'sports','books','reference',
  #   'medical','utilities','magazines',
  #   'catalogs']

  categories = Array[
    'ゲーム','教育','キッズ','写真',
    '動画','エンターテイメント','ショッピング',
    'ライフスタイル','ソーシャルネットワーキング',
    '健康','フィットネス','天気','ナビゲーション',
    '旅行','ニュース','食事','ミュージック',
    'スポーツ','医療','ユーティリティ','マガジン','カタログ']

  # categories = Array['フリマ','fintech','Matching',
  #   'マッチング','fitness','フィットネス',
  #   'music','音楽','動画','tv','チャット',
  #   'chat','写真','投資','料理','レシピ','シェア']

  categories.each { |category|
    sleep(1)
    response = nil
    path = "/search?term=#{category}&media=software&entity=software&country=jp&lang=ja_jp&limit=200"
    p path
    https.start do
      response = https.get(path)
    end

    json = JSON.parse(response.body)
    json["results"].each { |result|
      name = result["trackId"]
      File.open("./output/applications/#{name}.json", "w") { |file|
        file.puts result
      }
    }
  }

  # ファイルからJSONオブジェクトの読み込み
  # File.open('.\Sample.json') do |file|
  #   hash = JSON.load(file)
  #   puts hash['total_count']
  # end
end
