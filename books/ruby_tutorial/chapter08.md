{% csssig h2 id='version04' class='version' %}
##バージョン04（sort_byメソッド）
{% endcsssig %}

先のスクリプトにわたしは何の不満もありません。でもリファクタリングはクセになります。3行目のsortのブロックが気になる人には気になります。

{% highlight ruby %}
 p DICTIONARY.sort { |a, b| b[1] <=> a[1] }[0...30]
{% endhighlight %}


少し直しましょう。
{% highlight ruby %}
 WORDS = ARGF.read.downcase.scan(/[a-z]+/)
 DICTIONARY = WORDS.inject(Hash.new(0)) { |dic, word| dic[word] += 1 ; dic }
 p DICTIONARY.sort_by { |key, val| val }.slice(-30..-1)
{% endhighlight %}

sortに代えてsort_byを使いました。辞書の要素数が多ければこちらのほうが速度的に有利です。これは好みの問題かもしれませんが。\[\]に代えてsliceを使いました。sort_byが昇順ソートになっているので、sliceの範囲オブジェクトは最後尾(-1)から指定しています。

<<<------>>>

{% csssig h2 id='version05' class='version' %}
##バージョン05（takeメソッド）
{% endcsssig %}
でも次の方がもっとすっきりします。
{% highlight ruby %}
 WORDS = ARGF.read.downcase.scan(/[a-z]+/)
 DICTIONARY = WORDS.inject(Hash.new(0)) { |dic, word| dic[word] += 1 ; dic }
 p DICTIONARY.sort_by { |key, val| -val }.take(30)
{% endhighlight %}

valを負数にすれば降順ソートになります。takeメソッドは先頭から30要素を取ります。

###TMTOWTDI
「同じことをやるのに複数のやり方があっていい」というのがPerlの流れを汲むRubyの流儀です。ですからRubyではこのように同じ処理を複数の方法で実現できます。

この「同じことをやるのに複数のやり方があっていい」という考え方は、英語では -TMTOWTDI- といいます。

> There's More Than One Way To Do It

だそうです。最初に見たとき、

> TiMe TO WheTher Die or Ill

かと思いました。

でもいま、本当の答えに気が付きました。 -TMTOWTDI- は正規表現だったんです。

> /Today's (Mon|Tue) Or (Wed|Thu) Day/I

<<<------>>>

{% csssig h2 id='version06' class='version' %}
##バージョン06（take_byメソッドの定義）
{% endcsssig %}
やり方が複数あることに最初は戸惑うかもしれません。でもジブンノカタチニコダワル派には麻薬になります。

ではもう少しコダワッテ...

この「ハッシュをソートして端からいくつか取る」というのは、汎用性がありそうです。標準メソッドに似たようなtake_whileというのはあるのですが、目的のものはありません。

では、これをtake_byメソッドとしてHashクラスに作りましょう。
{% highlight ruby %}
 class Hash
   def take_by(nth)
     sort_by { |elem| yield elem }.take(nth)
   end
 end
 
 WORDS = ARGF.read.downcase.scan(/[a-z]+/)
 DICTIONARY = WORDS.inject(Hash.new(0)) { |dic, word| dic[word] += 1 ; dic }
 p DICTIONARY.take_by(30) { |key, val| -val }
 p DICTIONARY.take_by(30) { |key, val| val }
 
 # >[["the", 16077], ["of", 9823], ["and", 7482], ["to", 7098], ["in", 4456], ["a", 3841], ["that", 3161], ["was", 3040], ["it", 2919], ["i", 2881], ["her", 2550], ["she", 2313], ["as", 2134], ["you", 2071], ["not", 2057], ["be", 2044], ["is", 2033], ["his", 2009], ["he", 1940], ["for", 1927], ["with", 1875], ["on", 1638], ["had", 1567], ["but", 1519], ["s", 1495], ["all", 1363], ["at", 1344], ["by", 1308], ["this", 1249], ["have", 1201]]
 [["rained", 1], ["grows", 1], ["pearly", 1], ["hinder", 1], ["overturn", 1], ["interpose", 1], ["infuse", 1], ["prescribes", 1], ["escaping", 1], ["guinness", 1], ["belch", 1], ["humbling", 1], ["appropriately", 1], ["luminous", 1], ["frailty", 1], ["rightful", 1], ["nods", 1], ["purple", 1], ["sepulcher", 1], ["hollow", 1], ["rivaled", 1], ["pearls", 1], ["eyed", 1], ["judaizing", 1], ["fulton", 1], ["taylor", 1], ["coincidence", 1], ["apocalypticae", 1], ["clime", 1], ["atoning", 1]]
{% endhighlight %}

あまり好まれるやり方ではありませんが、このようにRubyでは組み込みのクラスを開いてそこにメソッドを追加することも簡単にできるのです。

これでDICTIONARYに対するメソッド呼び出しが１つで済むようになりました。

ちょっと分かりづらいかもしれませんが、キモはメソッド定義中のyieldです。yieldがあるとメソッド呼び出しの際に、ブロックを取れるようになります。メソッドが呼び出されて実行がyieldに達すると、ブロックが実行されます。

上の例ではsort_byのブロック引数elemに、ハッシュの最初の要素つまりkey, valueの組が渡されると、yieldがtake_byに付けられたブロックの中身-valになります。

