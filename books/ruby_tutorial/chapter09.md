{% csssig h2 id='version07' class='version' %}
##バージョン07（Enumerable#take_byの定義）
{% endcsssig %}
更に欲が出てきました。このtake_byというメソッドを配列でも使いたくなりました。

実は先のsort_byというメソッドはHashクラスにもArrayクラスにも定義されていません。それが定義されているのはEnumerableというモジュールです。モジュールというのはクラスの亜種です。オブジェクトを生成できないクラスです。飛べない鳥ニワトリのようなものです（説明のためモジュールおよびニワトリに対するこのような差別的発言をお許しください）。

EnumerableモジュールをHashおよびArrayクラスにインクルードすることで、sort_byの夢のコラボが実現しています。

我らtake_byにも夢を実現させましょう。
{% highlight ruby %}
 module Enumerable
   def take_by(nth)
     sort_by { |elem| yield elem }.take(nth)
   end
 end
 
 WORDS = ARGF.read.downcase.scan(/[a-z]+/)
 DICTIONARY = WORDS.inject(Hash.new(0)) { |dic, word| dic[word] += 1 ; dic }
 p DICTIONARY.take_by(30) { |key, val| -val }
 p WORDS.take_by(30) { |word| -word.length }
 
 #> [["the", 16077], ["of", 9823], ["and", 7482], ["to", 7098], ["in", 4456], ["a", 3841], ["that", 3161], ["was", 3040], ["it", 2919], ["i", 2881], ["her", 2550], ["she", 2313], ["as", 2134], ["you", 2071], ["not", 2057], ["be", 2044], ["is", 2033], ["his", 2009], ["he", 1940], ["for", 1927], ["with", 1875], ["on", 1638], ["had", 1567], ["but", 1519], ["s", 1495], ["all", 1363], ["at", 1344], ["by", 1308], ["this", 1249], ["have", 1201]]
 #> ["communicativeness", "congregationalist", "indestructibility", "disinterestedness", "misrepresentation", "superciliousness", "unenforceability", "unenforceability", "incomprehensible", "inextinguishable", "discontentedness", "internationalism", "incomprehensible", "unenforceability", "congratulations", "acknowledgments", "accomplishments", "unrighteousness", "condescendingly", "congratulations", "transformations", "merchantibility", "notwithstanding", "congratulations", "recommendations", "appropriateness", "congratulations", "contemporaneous", "comprehensively", "thoughtlessness"]
{% endhighlight %}

すばらしい！

配列オブジェクトを指すWORDSに対して、ワード長降順の条件でtake_byメソッドを呼んでいます。

実はわたくし最頻出ワードよりも最長ワードに興味があったのですよ。'incomprehensibleなcongregationalist'になりたい！そんな今日この頃です...

さて...

もう終わりでしょうか？気になる人には気になるところは、もうないでしょうか。

<<<------>>>

{% csssig h2 id='version08' class='version' %}
##バージョン08（top_by_valueの定義）
{% endcsssig %}
take_byでよく使いそうなのは、やっぱり最大値最小値でソートしてtakeでしょう。take_byとは別にHashクラスにこれらtop_by_value, bottom_by_valueを定義するというのはどうでしょうか。
{% highlight ruby %}
 module Enumerable
   def take_by(nth)
     sort_by { |elem| yield elem }.take(nth)
   end
 end
 
 class Hash
   def top_by_value(nth)
     take_by(nth) { |key, val| -val }
   end
 
   def bottom_by_value(nth)
     take_by(nth) { |key, val| val }
   end
 end
 
 WORDS = ARGF.read.downcase.scan(/[a-z]+/)
 DICTIONARY = WORDS.inject(Hash.new(0)) { |dic, word| dic[word] += 1 ; dic }
 p DICTIONARY.top_by_value(30)
 p DICTIONARY.bottom_by_value(30)
{% endhighlight %}

DICTIONARYに対するメソッド呼び出しがすっきりしました。

繰り返しになりますが、組み込みクラスやモジュールに汎用性のないメソッドを追加することは褒められたことではありません。ここではRubyを学ぶために多少の無茶をしている点、ご了承下さい。

実行結果は次のようになります。
{% highlight ruby %}
#> [["the", 16077], ["of", 9823], ["and", 7482], ["to", 7098], ["in", 4456], ["a", 3841], ["that", 3161], ["was", 3040], ["it", 2919], ["i", 2881], ["her", 2550], ["she", 2313], ["as", 2134], ["you", 2071], ["not", 2057], ["be", 2044], ["is", 2033], ["his", 2009], ["he", 1940], ["for", 1927], ["with", 1875], ["on", 1638], ["had", 1567], ["but", 1519], ["s", 1495], ["all", 1363], ["at", 1344], ["by", 1308], ["this", 1249], ["have", 1201]]
#> [["rained", 1], ["grows", 1], ["pearly", 1], ["hinder", 1], ["overturn", 1], ["interpose", 1], ["infuse", 1], ["prescribes", 1], ["escaping", 1], ["guinness", 1], ["belch", 1], ["humbling", 1], ["appropriately", 1], ["luminous", 1], ["frailty", 1], ["rightful", 1], ["nods", 1], ["purple", 1], ["sepulcher", 1], ["hollow", 1], ["rivaled", 1], ["pearls", 1], ["eyed", 1], ["judaizing", 1], ["fulton", 1], ["taylor", 1], ["coincidence", 1], ["apocalypticae", 1], ["clime", 1], ["atoning", 1]]
{% endhighlight %}

ん～

これじゃbottom_by_valueはあまり意味がありませんね。

<<<------>>>

{% csssig h2 id='version09' class='version' %}
##バージョン09（top_by_valueの改良）
{% endcsssig %}
ブロックを取って範囲を限定できるようにしたら、もう少しマシになるかもしれません。
{% highlight ruby %}
 module Enumerable
   def take_by(nth)
     sort_by { |elem| yield elem }.take(nth)
   end
 end
 
 class Hash
    def top_by_value(nth)
     select { |key, val| yield val }.take_by(nth) { |key, val| -val }
    end
 
    def bottom_by_value(nth)
     select { |key, val| yield val }.take_by(nth) { |key, val| val }
    end
 end
 
 WORDS = ARGF.read.downcase.scan(/[a-z]+/)
 DICTIONARY = WORDS.inject(Hash.new(0)) { |dic, word| dic[word] += 1 ; dic }
 p DICTIONARY.top_by_value(30) { |val| val < 400 }
 p DICTIONARY.bottom_by_value(30) { |val| val > 100 }
{% endhighlight %}

top_by_value, bottom_by_valueではselectメソッドを使って、対象範囲を限定できるようにしました。結果に少し意味がでました。
{% highlight ruby %}
 #> [["know", 386], ["up", 383], ["into", 382], ["its", 380], ["did", 378], ["am", 377], ["than", 377], ["little", 376], ["can", 372], ["may", 370], ["how", 365], ["every", 365], ["only", 361], ["man", 361], ["now", 361], ["first", 358], ["other", 358], ["christ", 358], ["should", 353], ["mrs", 352], ["after", 346], ["again", 346], ["come", 344], ["see", 338], ["some", 338], ["well", 329], ["world", 326], ["bennet", 323], ["prophecy", 322], ["never", 317]]
 #> [["gave", 101], ["forth", 101], ["course", 101], ["thy", 102], ["speak", 102], ["get", 102], ["head", 102], ["home", 103], ["bible", 103], ["pleasure", 103], ["seemed", 104], ["together", 105], ["why", 105], ["high", 106], ["thou", 106], ["myself", 106], ["daniel", 108], ["hand", 109], ["near", 109], ["often", 110], ["better", 110], ["hear", 110], ["left", 110], ["believe", 110], ["moment", 111], ["find", 111], ["half", 113], ["really", 114], ["prophet", 114], ["book", 114]]
{% endhighlight %}

