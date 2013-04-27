{% csssig h2 id='version14' class='version' %}
##バージョン14（ARGF.take_wordsの定義）
{% endcsssig %}
さてもう改良点はないでしょうか。スクリプト全体をもう一度みてみましょう。

{% highlight ruby %}
 module Enumerable
   def take_by(nth)
     sort_by { |elem| yield elem }.take(nth)
   end
 end
 
 class Hash
   def top_by_value(nth, &blk)
     take_by_value(nth, lambda { |v| -v }, &blk)
   end
 
   def bottom_by_value(nth,&blk)
     take_by_value(nth, lambda { |v| v }, &blk)
   end
 
   private
   def take_by_value(nth, sort_opt)
     select { |key, val| block_given? ? yield(val) : val }
     .take_by(nth) { |key, val| sort_opt[val] }
   end
 end
 
 WORDS = ARGF.read.downcase.scan(/[a-z]+/)
 DICTIONARY = WORDS.inject(Hash.new(0)) { |dic, word| dic[word] += 1; dic }
 p DICTIONARY.top_by_value(30)
{% endhighlight %}

3行目が思いの外すっきりしたので、1行目のメソッドチェーンが気になりだしました。ちょっと病的な感覚かもしれません。でも楽しいRubyの学習のために先に進みます。

「添付ファイルから単語を取って配列に入れる」という操作は汎用性がありそうです。今度はこれをいじりましょう。ARGFに対するtake_wordsメソッドを定義します。

オブジェクトに対するメソッドの追加は、今まで見てきたようにそのオブジェクトが属するクラスにメソッドを定義することで実現するのが普通です。しかしここではARGFオブジェクトに直接メソッドを追加してみたいと思います。


これはそのオブジェクト専用の名無しクラスにメソッドを定義することで実現できます。
{% highlight ruby %}
 class << ARGF
   def take_words(regexp)
     read.downcase.scan(regexp)
   end
 end
 
 WORDS = ARGF.take_words(/[a-z]+/)
 DICTIONARY = WORDS.inject(Hash.new(0)) { |dic, word| dic[word] += 1; dic }
 p DICTIONARY.top_by_value(30)
{% endhighlight %}

この場合クラスに名前を与えずに、オブジェクトを<<で接ぎ木します。この無名クラスはSingletonクラスまたは特異クラスなどと呼ばれます。

クラスを定義しない別の書き方もあります。
{% highlight ruby %}
 def ARGF.take_words(regexp)
   read.downcase.scan(regexp)
 end
{% endhighlight %}
こう書いたときSingletonメソッドまたは特異メソッドなどと呼ばれます。

take_wordsには正規表現を渡せるようにしてます。先頭がx,y,zで始まる単語のみを対象に最頻出ワード30をリストしてみましょう。
{% highlight ruby %}
 WORDS = ARGF.take_words(/[xyz][a-z]+/)
 DICTIONARY = WORDS.inject(Hash.new(0)) { |dic, word| dic[word] += 1; dic }
 p DICTIONARY.top_by_value(30)
 
 #> [["you", 2071], ["zabeth", 636], ["your", 597], ["ys", 556], ["ying", 322], ["years", 226], ["yes", 214], ["ything", 176], ["ydia", 172], ["yet", 163], ["young", 144], ["xt", 143], ["ye", 137], ["year", 124], ["yself", 108], ["zzy", 97], ["yed", 82], ["ybody", 77], ["ylon", 75], ["zed", 67], ["ze", 64], ["yourself", 60], ["xpected", 58], ["yton", 58], ["yphon", 55], ["xactly", 54], ["yond", 54], ["xed", 52], ["yright", 48], ["yone", 45]]
{% endhighlight %}

Singletonメソッドについては以下が参考になるかもしれません。

[Rubyを始めたけど今ひとつRubyのオブジェクト指向というものが掴めないという人、ここに来て見て触って！](http://melborne.github.io/2013/02/07/understand-ruby-object/ "Rubyを始めたけど今ひとつRubyのオブジェクト指向というものが掴めないという人、ここに来て見て触って！")

<<<------>>>

{% csssig h2 id='version15' class='version' %}
##バージョン15（make_freq_dicの定義）
{% endcsssig %}

ここまで来るともう止まりません。はっきり言って2行目も気になります。
{% highlight ruby %}
 DICTIONARY = WORDS.inject(Hash.new(0)) { |dic, word| dic[word] += 1; dic }
{% endhighlight %}

しかも頻出ワード辞書というのは汎用性がありそうです。make_freq_dicメソッドとしてArrayに定義しましょう。ええこれは明らかに行き過ぎです（いや、もうとっくに行き過ぎです..）。Arrayに定義されるべきメソッドは、あらゆる種類の配列で使われうるメソッドのみを定義すべきです。でも、もうわたしにも止められないのです！
{% highlight ruby %}
 class Array
   def make_freq_dic
     inject(Hash.new(0)) { |dic, word| dic[word] += 1; dic }
   end
 end
 
 WORDS = ARGF.take_words(/[a-z]+/)
 DICTIONARY = WORDS.make_freq_dic
 p DICTIONARY.top_by_value(30)
{% endhighlight %}

すっきりです。ARGFから単語を取り出しWORDSで参照する、WORDSから頻出ワードを作ってDICTIONARYで参照する、DICTIONARYから頻出トップ30を取って出力する、１つのオブジェクトに１つのメソッド。さすがにもう気が済みました。わたしの暴走を許してくださりありがとうございます。

