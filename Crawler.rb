# AppStoreのデータ取得
require 'openssl'
require 'net/http'
require 'json'
require 'date'
require 'FileUtils'

TIMEOUT_SEC = 10

url = 'rss.itunes.apple.com'
https = Net::HTTP.new(url, 443)
https.open_timeout = TIMEOUT_SEC
https.read_timeout = TIMEOUT_SEC
https.use_ssl = true
https.verify_mode = OpenSSL::SSL::VERIFY_PEER
https.verify_depth = 5

begin

  # 新着オススメ、新着ゲームオススメ、トップセールス、トップセールスiPad、トップ有料、トップ有料ゲーム、トップ無料、トップ無料ゲーム、トップ無料iPad
  categories = Array[
    'new-apps-we-love',
    'new-games-we-love',
    'top-grossing',
    'top-grossing-ipad',
    'top-paid',
    'top-paid-games',
    'top-free',
    'top-free-games',
    'top-free-ipad'
  ]

  # 日本、米国、英国、台湾、中国、韓国、香港、タイ、ドイツ、インド、スペイン、フランス、イタリア、オランダ、
  # フィリピン、南アフリカ、インドネシア、オーストラリア、シンガポール
  countries = Array[
    'jp', 'en','gb','tw','cn','kr','hk','th','de','in','es','fr','it','nl',
    'ph','za','id','au','sg'
  ]

  categories.each { |category|
    countries.each { |country|
      response = nil
      path = "/api/v1/#{country}/ios-apps/#{category}/100/explicit/json"
      https.start do
        response = https.get(path)
      end
      date = Date.today
      dir = "./output/ranking/#{category}"
      FileUtils.mkdir_p(dir) unless FileTest.exist?(dir)
      File.open("#{dir}/#{category}-#{country}-#{date}.json", "a") do |file|
        file.puts response.body
      end
    }
  }

  # ファイルからJSONオブジェクトの読み込み
  # File.open('.\Sample.json') do |file|
  #   hash = JSON.load(file)
  #   puts hash['total_count']
  # end
end
