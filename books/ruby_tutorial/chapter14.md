{% csssig h2 id='version20' class='version' %}
##バージョン20（ネットアクセス）
{% endcsssig %}
ここまで来たらもう一歩。

小説データは元々ネットにあるんですから、いちいちファイルにダウンロードしないで、直接ネットから取れたらうれしいです。

open-uriライブラリというのを使うと、httpに簡単にアクセスできるようになります。
{% highlight ruby %}
  require "open-uri"
  class WordDictionary
	private
    def input_to_string(input)
     case input
     when /^http/
       begin
         open(input) { |f| return f.read }
       rescue Exception => e
         puts e
         exit
       end
     when String
       begin
         File.open(input, "r:utf-8") { |f| return f.read }
       rescue
         puts "Argument has assumed as a text string" 
         input
       end
     when ARGF.class
       input.read
     else
       raise "Wrong argument. ARGF, file or string are acceptable."
     end
    end
  end
  wdic = WordDictionary.new('http://www.gutenberg.org/files/245/245.txt')
  p wdic.top_by_length(30)
#> [["inconsequentialities", 1, 20], ["straightforwardly", 1, 17], ["unenforceability", 1, 16], ["acquaintanceship", 3, 16], ["reproachlessness", 1, 16], ["misunderstanding", 1, 16], ["stenographically", 1, 16], ["preposterousness", 1, 16], ["responsibilities", 1, 16], ["incomprehensible", 1, 16], ["charlottesville", 1, 15], ["acknowledgments", 1, 15], ["unrighteousness", 2, 15], ["multitudinously", 1, 15], ["unphilosophical", 1, 15], ["impossibilities", 2, 15], ["inconspicuously", 1, 15], ["inconsequential", 2, 15], ["conscientiously", 1, 15], ["notwithstanding", 3, 15], ["merchantibility", 1, 15], ["architecturally", 2, 15], ["daguerreotypist", 1, 15], ["representations", 1, 15], ["unhandkerchiefs", 1, 15], ["correspondingly", 3, 15], ["picturesqueness", 2, 15], ["proportionately", 1, 15], ["unconsciousness", 1, 15], ["exemplification", 1, 15]]
{% endhighlight %}

open-uriライブラリをrequireして、input_to_stringに新しい分岐条件を加えます。ネットアクセスがうまくいかない場合は、エラーメッセージを表示してスクリプトの実行を終了します。

これで一層便利になりました。

<<<------>>>

{% csssig h2 id='version21' class='version' %}
##バージョン21（メソッドの追加）
{% endcsssig %}
もう少し実用的なメソッドも追加しましょう。

オブジェクトを読みやすいかたちで出力するto_sメソッドと、オブジェクトの部分オブジェクトを返すselectメソッドを定義します。
{% highlight ruby %}
 class WordDictionary
   def to_s
     @freq_dic.to_s
   end
   def select(regexp)
     text = @words.select { |key, val| key =~ regexp }.join(" ")
     WordDictionary.new(text)
   end
 end
{% endhighlight %}

次の例はselectメソッドにより、先頭がxyzの何れかで始まる語の集合からなる新しいWordDictionaryオブジェクトを生成し、これをto_sメソッドで出力しています。
{% highlight ruby %}
 wdic = WordDictionary.new(ARGF)
 puts xyz_dic = wdic.select(/^[xyz]/)
 p xyz_dic.top_by_length(5)
#> {"you"=>2071, "yes"=>90, "zealand"=>1, "your"=>597, "yourself"=>60, "yesterday"=>18, "yet"=>163, "young"=>144, "yer"=>4, "ye"=>90, "yelp"=>1, "youth"=>17, "yawned"=>3, "zigzag"=>1, "yours"=>26, "yards"=>2, "year"=>124, "yawning"=>3, "x"=>2, "yelled"=>1, "xi"=>1, "xii"=>3, "yard"=>1, "years"=>226, "zip"=>3, "youngest"=>15, "younger"=>30, "yielding"=>4, "yield"=>8, "yawn"=>2, "york"=>13, "yourselves"=>5, "younge"=>4, "youths"=>1, "yielded"=>5, "yale"=>4, "zeph"=>3, "zephaniah"=>1, "zech"=>2, "zion"=>4, "zealots"=>3, "zinzendorf"=>6, "xxxiii"=>1, "xxv"=>3, "xxvi"=>1, "y"=>8, "zama"=>1, "zealous"=>2, "xiii"=>8, "yea"=>6, "zinzendorfs"=>1, "xenophon"=>3, "youthful"=>1, "yearly"=>2, "xxix"=>1, "xh"=>1, "zoroaster"=>2, "xciii"=>1, "zeal"=>2, "zambezi"=>1, "xerxes"=>11, "xv"=>1, "yellow"=>1, "xxiii"=>1}

#> [["zinzendorfs", 1, 11], ["zinzendorf", 6, 10], ["yourselves", 5, 10], ["zoroaster", 2, 9], ["zephaniah", 1, 9]]
{% endhighlight %}

+++++++++++++++++++

さてずいぶんと長い道のりを来ました。スクリプトは一時僅か3行にまで短くできたのに、現在80行を超えるまでに肥大化しました。ワードエコではありません。

ここで最初のコードと3行のコードと、現在のコードとを見比べてみましょうか。

（バージョン01）
{% highlight ruby %}
 dic = Hash.new(0)
 while line = ARGF.gets
   line.downcase!
   while line.sub!(/[a-z]+/, "")
     word = $&
     dic[word] += 1
   end
 end
 p dic.sort { |a, b| b[1] <=> a[1] }[0...30]
{% endhighlight %}

（バージョン03）
{% highlight ruby %}
 WORDS = ARGF.read.downcase.scan(/[a-z]+/)
 DICTIONARY = WORDS.inject(Hash.new(0)) { |dic, word| dic[word] += 1 ; dic }
 p DICTIONARY.sort { |a, b| b[1] <=> a[1] }[0...30]
{% endhighlight %}

（バージョン21）
{% highlight ruby %}
 require 'open-uri'
 module Enumerable
   def take_by(nth)
     sort_by { |elem| yield elem }.take(nth)
   end
 end
 
 class WordDictionary
   include Enumerable
 
   def initialize(input)
     input = input_to_string(input)
     @words = input.downcase.scan(/[a-z]+/)
     @freq_dic = @words.inject(Hash.new(0)) { |dic, word| dic[word] += 1 ; dic }
   end
 
   def each
     @freq_dic.each { |elem| yield elem }
   end
 
   def top_by_frequency(nth, &blk)
     take_by_value(nth, lambda { |v| -v }, &blk)
   end
 
   def bottom_by_frequency(nth, &blk)
     take_by_value(nth, lambda { |v| v }, &blk)
   end
 
   def top_by_length(nth, &blk)
     list = take_by_key(nth, lambda { |key| -key.length }, &blk)
     list.map { |word, freq| [word, freq, word.length] }
   end
 
   def to_s
     @freq_dic.to_s
   end
 
   def select(regexp)
     text = @words.select { |key, val| key =~ regexp }.join(" ")
     WordDictionary.new(text)
   end
 
   private
  def input_to_string(input)
   case input
   when /^http/
     begin
       open(input) { |f| return f.read }
     rescue Exception => e
       puts e
       exit
     end
   when String
     begin
       File.open(input, "r:utf-8") { |f| return f.read }
     rescue
       puts "Argument has assumed as a text string." 
       input
     end
   when ARGF.class
     input.read
   else
     raise "Wrong argument. ARGF, file or string are acceptable."
   end
  end
 
   def take_by_value(nth, sort_opt, &blk)
     val = lambda { |key, val| val }
     take_by_key_or_val(nth, sort_opt, val, &blk)
   end
 
   def take_by_key(nth, sort_opt, &blk)
     key = lambda { |key, val| key }
     take_by_key_or_val(nth, sort_opt, key, &blk)
   end
 
   def take_by_key_or_val(nth, sort_opt, by)
     @freq_dic.select { |key, val| block_given? ? yield(val) : val }.take_by(nth) { |key, val| sort_opt[by[key, val]] }
   end
 end
 wdic = WordDictionary.new(ARGF)
 p wdic.top_by_frequency(20)
{% endhighlight %}

確かにスクリプトは肥大化しています。果たして今までの労力は無駄だったんでしょうか。ワードエコでなくなった分、よくなったことがあるんでしょうか。

はい、あります。それは単語辞書が、単なる制御構造からオブジェクトになったことです。

オブジェクトになった利点の１つは、コードがポータブルになるということです。つまりそれが持つデータを維持しながら、他のオブジェクトに送って相互作用させたり、データベースに保存したりできます。同時に内容の異なる複数の辞書オブジェクトを生成し、これらを相互に連携して結果を得る(内容の比較とか)といったこともできるようになります。これらはネットワーク越しであってもかまいません。

他の利点は機能の追加が容易になる点です。クラスにメソッドを追加することで、単語辞書を対象にした新たな機能が容易に追加できます。既にいくつかの機能追加を見てきました。

最初のヴァージョンのスクリプトに機能を追加することを想像頂ければ、この利点は明らかでしょう。このようにオブジェクトは機能追加のフレームワークになっているのです。

今までの苦労も、未来に対する投資というかたちで報われそうです。そろそろ幕を閉じるときが来たようです。

