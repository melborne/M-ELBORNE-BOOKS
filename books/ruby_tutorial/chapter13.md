{% csssig h2 id='version17' class='version' %}
##バージョン17（top_by_lengthの定義）
{% endcsssig %}
次にバージョン07で示したような、最長ワードトップ30を出力するメソッドtop_by_lengthも定義しましょう。
{% highlight ruby %}
 class WordDictionary
   def top_by_length(nth, &blk)
     list = take_by_key(nth, lambda { |key| -key.length }, &blk)
     list.map { |word, freq| [word, freq, word.length] }
   end
 
   private
   def take_by_value(nth, sort_opt)
     @freq_dic.select { |key, val| block_given? ? yield(val) : val }.take_by(nth) { |key, val| sort_opt[val] }
   end
 
   def take_by_key(nth, sort_opt)
     @freq_dic.select { |key, val| block_given? ? yield(val) : val }.take_by(nth) { |key, val| sort_opt[key] }
   end
 end
 wdic = WordDictionary.new(ARGF)
 p wdic.top_by_length(30) { |val| val > 100 }
{% endhighlight %}

ここでは将来に備えて、take_by_valueと同じようにtake_by_keyを定義して、top_by_lengthはこれを使うようにします。

top_by_lengthはその語と出現数に加えて、語長を返すようにしています。Arrayクラスのmapメソッドをここでは使っています。mapメソッドはinjectメソッド同様とても便利なメソッドです。配列の各要素の内容をブロックの処理結果で置き換えます。上の例は list.map { |item| item << item[0].length } でもいいです。

出力はこんな感じです。
{% highlight ruby %}
#> [["illustration", 160, 12], ["therefore", 127, 9], ["catherine", 126, 9], ["jerusalem", 120, 9], ["gutenberg", 285, 9], ["elizabeth", 636, 9], ["prophecy", 322, 8], ["together", 105, 8], ["anything", 117, 8], ["pleasure", 103, 8], ["judgment", 134, 8], ["believe", 110, 7], ["collins", 180, 7], ["between", 114, 7], ["wickham", 194, 7], ["bingley", 306, 7], ["replied", 136, 7], ["history", 189, 7], ["himself", 178, 7], ["against", 164, 7], ["because", 116, 7], ["however", 179, 7], ["through", 185, 7], ["nothing", 235, 7], ["sabbath", 215, 7], ["herself", 312, 7], ["another", 144, 7], ["project", 262, 7], ["without", 263, 7], ["thought", 215, 7]]
{% endhighlight %}

<<<------>>>

{% csssig h2 id='version18' class='version' %}
##バージョン18（DRY三度）
{% endcsssig %}
またも問題発生！DRY違反です！
{% highlight ruby %}
   def take_by_value(nth, sort_opt)
     @freq_dic.select { |key, val| block_given? ? yield(val) : val }.take_by(nth) { |key, val| sort_opt[val] }
   end
 
   def take_by_key(nth, sort_opt)
     @freq_dic.select { |key, val| block_given? ? yield(val) : val }.take_by(nth) { |key, val| sort_opt[key] }
   end
{% endhighlight %}

take_by_key_or_valメソッドを定義して、これを回避します。
{% highlight ruby %}
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
{% endhighlight %}
ふぅ

<<<------>>>

{% csssig h2 id='version19' class='version' %}
##バージョン19（入力の拡張）
{% endcsssig %}
さて次は何ですか？そうですね...

せっかくクラスを作ったのに、コマンド引数しか取れないっていうのは寂しいです。では次はWordDictionaryクラスがファイル名か文字列を直接受け取れるようにしましょう。

そのためにinput_to_stringメソッドを定義し、initializeメソッドで入力を適切に変換するようにします。
{% highlight ruby %}
 class WordDictionary
   def initialize(input)
     input = input_to_string(input)
     @words = input.downcase.scan(/[a-z]+/)
     @freq_dic = @words.inject(Hash.new(0)) { |dic, word| dic[word] += 1 ; dic }
   end
   
   private
   def input_to_string(input)
    case input
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
 wdic1 = WordDictionary.new(ARGF)
 wdic2 = WordDictionary.new('11.txt')
 wdic3 = WordDictionary.new(<<-EOS)
 It was all very well to say 'Drink me,' but the wise little Alice was not going to do THAT in a hurry. 'No, I'll look first,' she said, 'and see whether it's marked "poison" or not'; for she had read several nice little histories about children who had got burnt, and eaten up by wild beasts and other unpleasant things, all because they WOULD not remember
 the simple rules their friends had taught them: such as, that a red-hot poker will burn you if you hold it too long; and that if you cut your finger VERY deeply with a knife, it usually bleeds; and she had never forgotten that, if you drink much from a bottle marked 'poison,' it is almost certain to disagree with you, sooner or later.
EOS
 p wdic1.top_by_frequency(10)
 p wdic2.top_by_frequency(10)
 p wdic3.top_by_frequency(10)
 
 #> [["the", 4507], ["to", 4243], ["of", 3728], ["and", 3658], ["her", 2225], ["i", 2069], ["a", 2012], ["in", 1936], ["was", 1848], ["she", 1710]]
 #> [["the", 1818], ["and", 940], ["to", 809], ["a", 690], ["of", 631], ["it", 610], ["she", 553], ["i", 545], ["you", 481], ["said", 462]]
 #> [["it", 5], ["you", 5], ["and", 5], ["that", 4], ["had", 4], ["a", 4], ["if", 3], ["she", 3], ["to", 3], ["not", 3]]
{% endhighlight %}

input_to_stringにおいて、case式を使って入力の種類を切り分けました。when Stringでは最初ファイル名として処理できるか試み、できない場合は文字列として処理できるようにしました。うまくいっているようです。

WordDictionary.new(<<-EOS)...は、ヒアドキュメントという記法を使っています。任意記号EOSで挟まれた行が文字列として解釈されます。

