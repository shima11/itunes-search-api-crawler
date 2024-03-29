# AppStoreのデータ取得

require 'json'
require 'date'
require 'FileUtils'

categories = Array[
  'new-apps-we-love',
  'top-grossing',
  'top-paid',
  'top-free'
#  'top-grossing-ipad',
#  'top-paid-games',
#  'new-games-we-love',
#  'top-free-games',
#  'top-free-ipad'
]

# 新着オススメ、新着ゲームオススメ、トップセールス、トップセールスiPad、
# トップ有料、トップ有料ゲーム、トップ無料、トップ無料ゲーム、トップ無料iPad

countries = Array[
  "cl","hk","ml","th","gb","us","kr","cn","tw","jp","bs","bj","ca","td","de","gh","in",
  "ke","la","mo","mt","pw","pa","pe","ch","tr","ru","ao","ai","be","bz","bt","bo","bw",
  "br","bn","cy","eg","es","fj","fr","gm","gr","gd","gy","it","jo","kg","lv","lb","lr",
  "mw","mx","mn","na","nl","np","om","sn","sr","ug","qa","vn","ye","al","am","bh","bb",
  "by","bm","kh","co","cr","dk","dm","ec","ee","sv","gt","hr","il","jm","kw","lt","mk",
  "hu","my","ni","ne","no","pk","py","ph","pl","pt","ro","sc","sk","si","za","lk","tz",
  "tn","ua","uy","ve","zw","bg","dz","ar","cv","ky","cg","cz","gw","hn","is","id","ie",
  "kz","mg","mr","mu","ms","mz","ng","at","lc","sl","sg","sb","fi","se","sz","tj","au",
  "bf","lu","md","do","sa","uz","az","fm","nz","tm","ae","vg","pg","tc","st","tt","kn",
  "ag","vc"]

countriesHash = {
cl:"チリ",hk:"香港",ml:"マリ",th:"タイ",gb:"英国",us:"米国",kr:"韓国",cn:"中国",tw:"台湾",jp:"日本",bs:"バハマ",bj:"ベニン",ca:"カナダ",td:"チャド",de:"ドイツ",gh:"ガーナ",in:"インド",
ke:"ケニア",la:"ラオス",mo:"マカオ",mt:"マルタ",pw:"パラオ",pa:"パナマ",pe:"ペルー",ch:"スイス",tr:"トルコ",ru:"ロシア",ao:"アンゴラ",ai:"アンギラ",be:"ベルギー",bz:"ベリーズ",bt:"ブータン",bo:"ボリビア",bw:"ボツワナ",
br:"ブラジル",bn:"ブルネイ",cy:"キプロス",eg:"エジプト",es:"スペイン",fj:"フィジー",fr:"フランス",gm:"ガンビア",gr:"ギリシャ",gd:"グレナダ",gy:"ガイアナ",it:"イタリア",jo:"ヨルダン",kg:"キルギス",lv:"ラトビア",lb:"レバノン",lr:"リベリア",
mw:"マラウイ",mx:"メキシコ",mn:"モンゴル",na:"ナミビア",nl:"オランダ",np:"ネパール",om:"オマーン",sn:"セネガル",sr:"スリナム",ug:"ウガンダ",qa:"カタール",vn:"ベトナム",ye:"イエメン",al:"アルバニア",am:"アルメニア",bh:"バーレーン",bb:"バルバドス",
by:"ベラルーシ",bm:"バミューダ",kh:"カンボジア",co:"コロンビア",cr:"コスタリカ",dk:"デンマーク",dm:"ドミニカ国",ec:"エクアドル",ee:"エストニア",sv:"サルバドル",gt:"グアテマラ",hr:"クロアチア",il:"イスラエル",jm:"ジャマイカ",kw:"クウェート",lt:"リトアニマ",mk:"マケドニア",
hu:"ハンガリー",my:"マレーシア",ni:"ニカラグア",ne:"ニジェール",no:"ノルウェー",pk:"パキスタン",py:"パラグアイ",ph:"フィリピン",pl:"ポーランド",pt:"ポルトガル",ro:"ルーマニア",sc:"セルシェル",sk:"スロバキア",si:"スロベニア",za:"南アフリカ",lk:"スリランカ",tz:"タンザニア",
tn:"チュニジア",ua:"ウクライナ",uy:"ウルグアイ",ve:"ベネズエラ",zw:"ジンバブエ",bg:"ブルガリア",dz:"アルジェリア",ar:"アルゼンチン",cv:"カーボベルデ",ky:"ケイマン諸島",cg:"コンゴ共和国",cz:"チェコ共和国",gw:"ギニアビサウ",hn:"ホンジュラス",is:"アイスランド",id:"インドネシア",ie:"アイルランド",
kz:"カザフスタン",mg:"マダガスカル",mr:"モーリタニア",mu:"モーリシャス",ms:"モントセラト",mz:"モザンビーク",ng:"ナイジェリア",at:"オーストリア",lc:"セントルシア",sl:"シエラレオネ",sg:"シンガポール",sb:"ソロモン諸島",fi:"フィンランド",se:"スウェーデン",sz:"スワジランド",tj:"タジキスタン",au:"オーストラリア",
bf:"ブルキナファソ",lu:"ルクセンブルク",md:"モルドバ共和国",do:"ドミニカ共和国",sa:"サウジアラビア",uz:"ウズベキスタン",az:"アゼルバイジャン",fm:"ミクロネシア連邦",nz:"ニュージーランド",tm:"トルクメニスタン",ae:"アラブ首長国連邦",vg:"英領バージン諸島",pg:"パプアニューギニア",tc:"タークス・カイコス",st:"サントメ・プリンシペ",tt:"トリニダード・トバゴ",kn:"セントキッツ・ネイビス",
ag:"アンティグア・バーブーダ",vc:"セントビンセント・グレナディーン"
}

begin

  # ファイルからJSONオブジェクトの読み込み

  output1 = []
  output2 = []

  # good = [] #ランキングが20以上上昇したもしくは圏外からランクインしたアプリ
  # bad = [] #ランキングが20以上下落したもしくは圏外になったアプリ

  File.open("./output/ranking/top-grossing/jp/2017-06-25.json") do |file|
      hash = JSON.load(file)
      results = hash['feed']['results']
      results.each_with_index { |result,index|
        if result['primaryGenreName'].to_s == 'ゲーム' then next end
        data  = result['id'].to_s + "\t" + index.to_s + "\t" + result['name'].to_s + "\t" + result['artistName'].to_s
        puts data
        output1.push(data)
      }
  end

  File.open("./output/ranking/top-grossing/jp/2017-06-26.json") do |file|
    hash = JSON.load(file)
    results = hash['feed']['results']
    results.each_with_index { |result,index|
      if result['primaryGenreName'].to_s == 'ゲーム' then next end
      data  = result['id'].to_s + "\t" + index.to_s + "\t" + result['name'].to_s + "\t" + result['artistName'].to_s
      puts data
      output2.push(data)
    }
  end

  # 必要なデータだけを抽出
  File.open("./output/ranking/top-grossing/jp/file1.txt", "w") { |file|
    output1.each { |data|
      file.puts(data)
    }
  }
  File.open("./output/ranking/top-grossing/jp/file2.txt", "w") { |file|
    output2.each { |data|
      file.puts(data)
    }
  }

  # ユーザリストを作成
  File.open("./output/ranking/top-grossing/jp/list1.txt", "w") { |file|
    output1.each { |data|
      file.puts(data.split(/\t/)[0])
    }
  }
  File.open("./output/ranking/top-grossing/jp/list2.txt", "w") { |file|
    output2.each { |data|
      file.puts(data.split(/\t/)[0])
    }
  }


rescue

end
