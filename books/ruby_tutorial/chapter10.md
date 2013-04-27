{% csssig h2 id='version10' class='version' %}
##バージョン10（DRY原則）
{% endcsssig %}

なかなかいいですね。さてこれでもう完成でしょうか...

いいえ！問題が発生しました！先のコードはDRY原則に反します！！

「DON'T REPEAT YOURSELF!」

達人プログラマは言いました。

「お前は二人も要らないよ！」

あるいは、

「愚鈍なる君の二度手間はダメ！」

そうです、同じコードの繰り返しは罪なのです！

もう一度コードを見てみましょう。
{% highlight ruby %}
 class Hash
    def top_by_value(nth)
     select { |key, val| yield val }.take_by(nth) { |key, val| -val }
    end
 
    def bottom_by_value(nth)
     select { |key, val| yield val }.take_by(nth) { |key, val| val }
    end
 end
{% endhighlight %}

「-」記号１つの差はありますが...確かに...そっくりです。Yes, I repeat myself...

Hashクラスにtake_by_valueというメソッドを作って、上のコードを1ヶ所に集約します。
{% highlight ruby %}
 class Hash
   def top_by_value(nth, &blk)
     take_by_value(nth, lambda { |v| -v }, &blk)
   end
 
   def bottom_by_value(nth,&blk)
     take_by_value(nth, lambda { |v| v }, &blk)
   end
 
   private
   def take_by_value(nth, sort_opt)
     select { |key, val| yield val }.take_by(nth) { |key, val| sort_opt[val] }
   end
 end
{% endhighlight %}
差し当たりtake_by_valueはクラスの中から呼ぶだけなので、その可視性をprivateにします。

take_by_valueはtop_by_valueおよびbottom_by_valueに渡される引数nthの他、手続きオブジェクトsort_optを引数に取ります。top_by_valueおよびbottom_by_value側では、{|v| -v}または{|v| v}をlambdaでオブジェクト化して渡します。take_by_valueのsort_opt[val]は受け取った手続きオブジェクトを実行します。これはsort_opt.call(val)でもいいです。

またtop_by_valueおよびbottom_by_valueでは、受け取るブロックをtake_by_valueに引き渡すために、&blkでブロックを一旦オブジェクト化する必要があります。

ちょっと込み入った話になりました。関連する話題はここにも書いているので、参考になるかもしれません。

[Rubyのブロックはメソッドに対するメソッドのMix-inだ！](http://melborne.github.io/2008/08/09/Ruby-Mix-in/)

兎に角、これでもう達人は怒らないでしょうか。

あっ！ちょっと問題を発見しました。top_by_valueにブロックを与えないで渡すとエラーがでます。
{% highlight ruby %}
 WORDS = ARGF.read.downcase.scan(/[a-z]+/)
 DICTIONARY = WORDS.inject(Hash.new(0)) { |dic, word| dic[word] += 1; dic }
 p DICTIONARY.top_by_value(30)
{% endhighlight %}
{% highlight ruby %}
 $ ruby topwords.rb 11.txt 1342.txt 18503.txt 
 topwords.rb:109:in `block in take_by_value': no block given (yield)
{% endhighlight %}

ブロックを渡さない場合は、範囲を限定しない結果を返すべきです。

<<<------>>>

{% csssig h2 id='version11' class='version' %}
##バージョン11（block_given?メソッド）
{% endcsssig %}
ブロックがあるか無いかを判定するメソッドとしてblock_given?があります。それを使ってブロックがない場合、代わりのブロックをtake_by_valueに渡してあげます。
{% highlight ruby %}
 class Hash
   def top_by_value(nth, &blk)
     blk = lambda { |v| v } unless block_given?
     take_by_value(nth, lambda { |v| -v }, &blk)
   end
   
   def bottom_by_value(nth, &blk)
     blk = lambda { |v| v } unless block_given?
     take_by_value(nth, lambda { |v| v }, &blk)
   end
   
   private
   def take_by_value(nth, sort_opt)
     select { |key, val| yield val }.take_by(nth) { |key, val| sort_opt[val] }
   end
 end
{% endhighlight %}

上の例ではblock_given?の代わりに引数blkを使ってもいいです。これで問題はなくなりました。

と　こ　ろ　が！

また恐ろしいことが起こりました。Hashクラスを見てください。
{% highlight ruby %}
 class Hash
   def top_by_value(nth, &blk)
     blk = lambda { |v| v } unless block_given?
     take_by_value(nth, lambda { |v| -v }, &blk)
   end
   
   def bottom_by_value(nth,&blk)
     blk = lambda { |v| v } unless block_given?
     take_by_value(nth, lambda { |v| v }, &blk)
   end
   
   private
   def take_by_value(nth, sort_opt)
     select { |key, val| yield val }.take_by(nth) { |key, val| sort_opt[val] }
   end
 end
{% endhighlight %}

lambda {|v| v }が4回も！
Don't Repeat Yourself! Yes, I repeat myself!!

達人...大至急直しますから...

<<<------>>>

{% csssig h2 id='version12' class='version' %}
##バージョン12（DRY再び）
{% endcsssig %}

lambda {|v| v }という手続きを返すoptというメソッドを定義しましょう。
{% highlight ruby %}
 class Hash
   def top_by_value(nth, &blk)
     blk = opt unless blk
     take_by_value(nth, opt(false), &blk)
   end
 
   def bottom_by_value(nth,&blk)
     blk = opt unless blk    
     take_by_value(nth, opt, &blk)
   end
 
   private
   def take_by_value(nth, sort_opt)
     select { |key, val| yield val }
     .take_by(nth) { |key, val| sort_opt[val] }
   end
 
   def opt(flag=true)
     lambda { |v| flag ? v : -v }
   end
 end
{% endhighlight %}

optメソッドのflag引数にデフォルトでtrueをセットしておきます。そうすればvalueがマイナスのときだけfalseを渡せばいいのです。

果たしてこれでコードが読みやすくなったのか、わたしにはわかりません。これはちょっとやり過ぎかもしれませんが、達人に怒られないということがここでは重要なのです。


<<<------>>>

{% csssig h2 id='version13' class='version' %}
##バージョン13（block_given?の移動）
{% endcsssig %}

と...ここまでやってミスに気が付きました。バージョン11のところでblock_given?の判定を、top_by_valueとbottom_by_valueのところでしました。でもこれをtake_by_valueのところでやればいいんです。そうすれば上のような手間は不要です。バージョン12はこんなやり方もあるんだという、ご理解でお願いします...

{% highlight ruby %}
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
{% endhighlight %}

take_by_value内で条件演算子(条件 ? 真 : 偽)を使って、ブロックの有無でyieldするかしないか分けています。

