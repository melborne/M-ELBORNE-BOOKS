{% csssig h2 id='version25' class='version' %}
##バージョン25（クラスの拡張）
{% endcsssig %}

さてGUIで出力も魅力的なものになりました。もうやり残すことはなさそうです。当初単なる制御構造であったスクリプトが、WordDictionaryという立派なクラスになりました。これで将来このクラスを拡張したり、このクラスをベースにしたアプリケーションを作れます。

で、将来っていつ？

...

そうです。DogYearのこの時代に、いつ来るか分からない将来を待っているゆとりなんて私たちにはないのです！自分たちから未来に向かって進むのです！何らかの形ある結果を残すのです！！

...

ということで...

なんか息巻いている人がいるので、もう少し進みましょう。
まずはもう少し機能拡張しましょう。WordDictionaryクラスから生成した複数の単語辞書オブジェクトを、相互作用させるような機能があったら楽しそうです。

まずは2つのオブジェクトを結合する +メソッドを定義しましょう。
{% highlight ruby %}
 class WordDictionary
   attr_reader :words
   def +(other)
     result = (@words + other.words).join(" ")
     WordDictionary.new(result)
   end
   protected :words
 end
{% endhighlight %}

**+**メソッドは他の単語辞書オブジェクトを引数に取って、自身と引数の単語を結合した単語辞書オブジェクトを返します。つまりAオブジェクトにrubyという単語が32個あり、Bオブジェクトに18個あった場合、これらを結合したCオブジェクトにはrubyは50個あることになります。

attr_reader :wordsは、**+**メソッドの実装において他のオブジェクトの@wordsインスタンス変数にアクセスできるようにします。protected :wordsにおいてその可視性を、同系のオブジェクトからのアクセスに限定します。

**+**メソッドのresultには2つの単語オブジェクトの単語をスペースで結合してなる文字列が入り、その文字列でWordDictionaryクラスのオブジェクトを作って返り値とします。@wordsは配列を指していますから、実装においては配列の+メソッドが使えます。

これによって通常の算術演算のような記法で、2つの単語辞書オブジェクトを結合できるようになりました。
{% highlight ruby %}
 alice = WordDictionary.new('public/alice.txt')
 romeo_juliet = WordDictionary.new('public/romeo_juliet.txt')
 p alice.top_by_length(10) { |val| val > 10 }
 p romeo_juliet.top_by_length(10) { |val| val > 10 }
 p (alice + romeo_juliet).top_by_length(10) { |val| val > 10 }
 #> [["caterpillar", 28, 11], ["everything", 14, 10], ["adventures", 12, 10], ["foundation", 25, 10], ["electronic", 27, 10], ["paragraph", 11, 9], ["anxiously", 14, 9], ["beautiful", 13, 9], ["agreement", 18, 9], ["trademark", 11, 9]]
 #> [["distributed", 18, 11], ["shakespeare", 17, 11], ["electronic", 19, 10], ["therefore", 23, 9], ["gentleman", 14, 9], ["gutenberg", 24, 9], ["gentlemen", 11, 9], ["copyright", 16, 9], ["benvolio", 17, 8], ["daughter", 17, 8]]
Argument has assumed as a text string
 #> [["distribution", 16, 12], ["shakespeare", 18, 11], ["caterpillar", 28, 11], ["opportunity", 11, 11], ["information", 13, 11], ["distributed", 22, 11], ["everything", 15, 10], ["adventures", 12, 10], ["foundation", 25, 10], ["permission", 16, 10]]
{% endhighlight %}

<<<------>>>

{% csssig h2 id='version26' class='version' %}
##バージョン26（他の演算メソッドの定義）
{% endcsssig %}
じゃあ次に**-**メソッドを定義しましょう。ついでに**&**メソッドと**|**メソッドも定義しましょう。 **-**メソッドは2つのオブジェクトの差分を、**&**メソッドと**|**メソッドはそれぞれそれらの積と和を出力します。なお先のrubyの例を**-**メソッドに適用した場合、Cオブジェクトのrubyの個数は14でなく0になります。
{% highlight ruby %}
 class WordDictionary
   attr_reader :words
   def +(other)
     result = (@words + other.words).join(" ")
     WordDictionary.new(result)
   end
   protected :words
   def -(other)
     result = (@words - other.words).join(" ")
     WordDictionary.new(result)
   end
 
   def &(other)
     result = (@words & other.words).join(" ")
     WordDictionary.new(result)
   end
 
   def |(other)
     result = (@words | other.words).join(" ")
     WordDictionary.new(result)
   end
 end
{% endhighlight %}


<<<------>>>

{% csssig h2 id='version27' class='version' %}
##バージョン27（DRY四度）
{% endcsssig %}

さて次にやるべきことは分かってますね？そう、Don't Repeat Yourself!です。

上の4つの演算はその中の演算子が異なるだけです。先の例のようにこれをブロックやオブジェクト化して渡す方法がありますが、ここではもっとスマートにシンボルを使って渡してみましょう。
{% highlight ruby %}
 class WordDictionary
   attr_reader :words
   def +(other)
     arithmetics(:+, other)
   end
 
   def -(other)
     arithmetics(:-, other)
   end
 
   def &(other)
     arithmetics(:&, other)
   end
 
   def |(other)
     arithmetics(:|, other)
   end
 
   private
   def arithmetics(op, other)
     result = (@words.send op, other.words).join(" ")
     WordDictionary.new(result)
   end
 end
{% endhighlight %}

arithmeticsメソッド内でsendメソッドを使っている点がポイントです。sendメソッドは、シンボルで表現されたメソッドを実行できるようにします。これでコードがすっきりしました。

