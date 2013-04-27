{% csssig h2 id='version16' class='version' %}
##バージョン16（スクリプトのクラス化）
{% endcsssig %}
でも待ってください。そこまで汎用性がある汎用性があるって言うのなら...

クラスにでもしたらどうですか？

それならArrayクラスなどの組み込みクラスにも迷惑は掛かりませんし、なるほどいい考えかもしれません。

では、テキストファイルを受け取ると、英単語頻度辞書を生成するWordDictionaryクラスを作りましょう。まず現在のスクリプト全体を掲載します。
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
 
 class << ARGF
   def take_words(regexp)
     read.downcase.scan(regexp)
   end
 end
 
 class Array
   def make_freq_dic
     inject(Hash.new(0)) { |dic, word| dic[word] += 1; dic }
   end
 end
 
 WORDS = ARGF.take_words(/[a-z]+/)
 DICTIONARY = WORDS.make_freq_dic
 p DICTIONARY.top_by_value(30)
{% endhighlight %}

これらのコードにおける各メソッドをWordDictionaryクラスに実装します。このクラスはARGFオブジェクトを引数に取って、そこからワード辞書オブジェクトを生成します。Enumerableのtake_byはWordDictionary以外でも使えそうなのでこのまま残します。

上のスクリプトは次のように生まれ変わりました。
{% highlight ruby %}
 module Enumerable
   def take_by(nth)
     sort_by { |elem| yield elem }.take(nth)
   end
 end
 
 class WordDictionary
   include Enumerable
 
   def initialize(argf)
     @words = argf.read.downcase.scan(/[a-z]+/)
     @freq_dic = @words.inject(Hash.new(0)) { |dic, word| dic[word] += 1; dic }
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
 
   private
   def take_by_value(nth, sort_opt)
     @freq_dic.select { |key, val| block_given? ? yield(val) : val }
              .take_by(nth) { |key, val| sort_opt[val] }
   end
 end
 
 wdic = WordDictionary.new(ARGF)
 p wdic.top_by_frequency(30)
 p wdic.bottom_by_frequency(30) { |val| val > 100 }
{% endhighlight %}

ざっと眺めてみると先のコードが大体そのまま移管されているのが分かると思います。top_by_valueとbottom_by_valueは、目的を分かりやすくするために名前をそれぞれ、top_by_frequencyとbottom_by_frequencyに変えました。
 
変わったところを列挙してみます。

1. WordDictionaryクラス
1. include Enumerable
1. initializeメソッド
1. eachメソッド
 
クラス定義はキーワードclassに続き、大文字で始まるクラス名を指定して行います。スクリプトが実行されたとき、このクラス定義からそのクラス名で参照可能なクラスオブジェクトが生成されます。

include EnumerableによってEnumerableモジュールに追加したtake_byメソッドが使えるようになります。

initializeメソッドは、WordDictionaryクラスを生成するnewメソッドが呼ばれたときに自動で実行されるメソッドです。通常ここにオブジェクトの初期化処理を書きます。

WordDictionaryでは単語を切り出してその結果の配列を@wordsというインスタンス変数で参照できるようにします。次いで頻出ワード辞書を作り出しその結果のハッシュを、@freq_dicインスタンス変数で参照できるようにしています。

eachメソッドにはちょっとしたマジックがあります。Enumerableモジュールには繰り返し処理のための便利なメソッドが多数存在しますが、eachメソッドをうまく定義すればWordDictionaryで生成されるオブジェクトでも、これらの便利なメソッドが使えるようになるのです。例をあとで示します。

スクリプトの最後の3行でこのWordDictionaryクラスの使い方が分かると思います。

ARGFを引数に取ったnewメソッドをWordDictionaryクラスに送り、これによって単語辞書オブジェクトを生成します。

「newメソッドなんて定義してないのに何故呼べるの？」と考えた人は鋭いです。理由はこうです。

すべてのクラスは何らかのクラスの継承クラスです。明示的に継承元クラスを指定する場合はclass WordDictionary < Hash のようにします。明示的な指定がない場合Rubyは自動でObjectクラスをその継承元クラスとして指定します。ですからWordDictionaryクラスはObjectクラスの被継承者です。そして被継承者は継承元のメソッドすべてを自由に使えるのです。

さて、eachメソッドのマジックを１つ見せます。
{% highlight ruby %}
 wdic = WordDictionary.new(ARGF)
 wdic.group_by { |word, freq| word.length }
     .select { |len, word| len > 14 }
     .sort
     .each { |len, word| print "#{len} => #{word.transpose.first}\n"}

 #> 15 => ["representations", "merchantibility", "accomplishments", "acknowledgments", "inconsistencies", "conscientiously", "superintendence", "congratulations", "thoughtlessness", "recommendations", "uncompanionable", "disappointments", "condescendingly", "transformations", "transfiguration", "ecclesiasticism", "notwithstanding", "representatives", "appropriateness", "characteristics", "contemporaneous", "unrighteousness", "remorselessness", "comprehensively"]
 #> 16 => ["unenforceability", "superciliousness", "incomprehensible", "discontentedness", "inextinguishable", "internationalism"]
 #> 17 => ["disinterestedness", "misrepresentation", "communicativeness", "congregationalist", "indestructibility"]
{% endhighlight %}

Enumerableモジュールに定義されているgroup_byメソッドを、WordDictionaryクラスのオブジェクトで使った例です。ワード長が15以上のものをグループ別に表示させています。自作のクラスがこれでずっと高級になりました。Enumerableモジュールが持っているメソッドは以下で調べられます。

[module Enumerable](http://doc.ruby-lang.org/ja/1.9.3/class/Enumerable.html "module Enumerable")
