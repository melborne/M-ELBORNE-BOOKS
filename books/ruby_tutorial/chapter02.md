# Rubyチュートリアル ～英文小説の最頻出ワードを見つけよう！
# １章　Rubyの特徴
忙しい読者の皆様が求めているものは、表題「英文小説の最頻出ワードを見つけよう！」に対するRubyのサンプルプログラムであることは熟知しています。しかしそれを速やかに理解するためには、Rubyに関する前提知識が必要です。少し時間をいただいて、最初にRubyの特徴的な事柄について説明させてください。

なおRubyは1993年に日本で生まれてから、複数回のヴァージョンアップを繰り返し、現在もなお進化の過程にあります。現行安定ヴァージョンはRuby4.8.10ですが、以下で説明する内容はレガシーヴァージョンでも動作します。またJRuby, PRuby, MRuby, SRubyあるいはLittleRuby, MicroRuby, uby, byでも動作するでしょう。ただ, Cuby, roobee, RubybuR, λRuby, ComeOn!RubyおよびLavieRubis, Ruby&#54861;（rubyインタプリタのハングルによる実装）, Rubykak&#257;（rubyインタプリタのマオリ語による実装）では動作しないでしょう（これらは2023年の未来予想を元に書かれています(^_^;)）。

さあ説明を始めましょう。

これから説明するのは次の4つの項目です

1. Rubyはオブジェクト指向です
1. Rubyのブロックは仮装オブジェクトです
1. クラスはオブジェクトの母であってクラスの子であるオブジェクトです
1. Rubyはユーザフレンドリです


<<<------>>>


{% csssig h2 id='ruby_object' %}
## Rubyはオブジェクト指向です
{% endcsssig %}

依然として現在主流のプログラミング言語は手続き型です。手続き型言語では手続きは関数などのかたちでモジュール化されていますが、データ構造はそれとは別に管理されています。

でもRubyではデータ構造も手続きと一緒にパッケージ化されており、それはオブジェクトと呼ばれています。つまりRubyではプログラムを組成する最小単位はオブジェクトです。そのためRubyプログラマのやるべきことは、「メモリ空間に必要なオブジェクトを生成し、それにメッセージを送ってその結果としてのオブジェクトを得る」というかたちでプログラムを組成することになります。

例えば、次の例はメモリ空間に文字列オブジェクトを生成し、それにlengthというメッセージを送っています。
{% highlight ruby %}
 'hippopotamus'.length # => 12
{% endhighlight %}
文字列をクォートすれば文字列オブジェクトが生成されます。生成された文字列オブジェクト'hippopotamus'は、内部に多数のメソッドを持っており、lengthメッセージが送られるとこれに対応するメソッドを検索し、あればそれを起動し結果を返します。

通常反応するメソッドは、送られるメッセージ名と同じ名前を持っています。ですからこれからはメッセージとメソッドを区別しないで用います。メッセージを受けるオブジェクトのことを、レシーバと言うことがあります。

注目して頂きたいのは、オブジェクトがメッセージを受けて返す値は、オブジェクトであるということです。つまり上で返された整数12は単なる整数ではなく、整数オブジェクト（正確には固定長整数オブジェクト）なのです。従ってこの返された値もメッセージを受け取ることができます。ですからRubyではこんな記述が許されます。
{% highlight ruby %}
 'hippopotamus'.length.even? # => true
{% endhighlight %}
これはメソッドチェーンと呼ばれることがあります。

別の例を示します。
{% highlight ruby %}
 ['donkey', 'alligator', 'hippopotamus'].at(0) # => "donkey"
{% endhighlight %}
これはメモリ空間に3つの文字列オブジェクトを要素として含んだ、１つの配列オブジェクトを生成し、それにatメソッドを0整数オブジェクトを引数に付けて送っているコードです。任意のオブジェクトを\[ \]で括ると配列オブジェクトが生成されます

このようにメッセージには引数を付けることができます。ただしRubyはオブジェクトしか相手にしませんから、この引数はオブジェクトでなければなりません。返される結果は配列の先頭要素の'donkey'文字列オブジェクトです。確認のためこの結果にもメソッドチェーンを試みてみましょう。
{% highlight ruby %}
 ['donkey', 'alligator', 'hippopotamus'].at(0) # => "donkey"
 ['donkey', 'alligator', 'hippopotamus'].at(0).length # => 6
 ['donkey', 'alligator', 'hippopotamus'].at(0).length.even? # => true
{% endhighlight %}

メソッドチェーンの個数に制限はありません。暇つぶしをしたいのなら次のようにしてもかまいません。
{% highlight bash %}
 1.next.next.next.next.next.next.next.next.next \
  .next.next.next.next.next.next.next.next.next \
  .next.next.next.next.next.next.next.next.next \
  .next.next.next.next.next.next.next.next.next \
  .next.next.next.next.next.next.next.next.next \
  .next.next.next.next.next.next.next.next.next \
  .next.next.next.next.next.next.next.next.next \
  .next.next.next.next.next.next.next.next.next \
  .next.next.next.next.next.next.next.next.next \
  .next.next.next.next.next.next.next.next.next \
  .next.next.next.next.next.next.next.next.next # => 100
{% endhighlight %}

