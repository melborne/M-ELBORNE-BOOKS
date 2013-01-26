---
language: 'ja'
unique_identifier:
 - 'http://melborne.github.com/books/20130121wfpm_by_ruby.html'
 - 'BookID'
 - 'URL'
title: 'Rubyを使って「なぜ関数プログラミングは重要か」を読み解く（前編）但し後編の予定なし'
subtitle: ''
subject: 'programming, ruby, 関数型, tutorial'
description: '本書は、ブログ「hp12c」( http://melborne.github.com/ )における「Rubyを使って「なぜ関数プログラミングは重要か」を解読しよう！」の電子書籍版です。'
creator: 'kyoendo'
date: '2012-12-29'
liquid: '../template/plugins'
---

##はじめに

「Why Functional Programming Matters:なぜ関数プログラミングは重要か」(原著者：John Huges 邦訳：山下伸夫)という有名な論文があります。

> [なぜ関数プログラミングは重要か](http://www.sampou.org/haskell/article/whyfp.html)

これはMirandaという関数型言語を使って、プログラマにとって関数プログラミングがいかに重要であるかを論証したものです。これが書かれてからの年数（1984年公表）と被ブックマーク数から見て、「関数型プログラミングを学ぶ人の必読の書」であることは明らかでしょう。しかし内容は幾分高度であり自分はこれを読み解くのに苦労しています。

以下は、この論文における「4.1. ニュートン-ラプソン法による平方根」の章までについて、Rubyの関数プログラミングの機能を使ってこの論文におけるコードに対応するものを記述し、自分の解釈でその骨子を説明したものとなっています。したがってこの記事の目的は、Rubyを使うことで関数プログラミングの妙味をより分かりやすく伝えると同時に、Rubyにおける関数プログラミングのパワーを知ってもらうことにあります。

なお、オリジナルの論文は「5. 人工知能からの例」までありますが、自分の力不足により上記以降を読み解くことができていません。したがって今のところ、本記事の後編が書かれる予定は無いことを予めご了承下さいm(__)m


<<<------>>>


##１章　関数プログラミングにおける重要な要素
モジュール化設計がプログラミングを成功させる鍵です。見過ごされがちですがプログラミング言語においてコードを自由にモジュール化するためには、それらを結合する糊が極めて重要な役割を担います。プログラマの目標は小さく、簡潔で、汎用的なモジュールを貼り合せてプログラムを構成することにあります。関数プログラミングには二種類の強力な糊、つまり関数の貼り合せをする糊（高階関数）と、プログラムの貼り合せをする糊（遅延評価）があります。

<<<------>>>

##２章　関数の貼り合せ ─ リストにおける張り合せ ─
最初に単純な関数を貼り合わせてより複雑な関数が作れるということを見ていきます。このことをリストにおける簡単なリスト処理の問題で説明します。

リストというのは、要素のない空リストであるか、または空リストを含む任意の要素のリストに任意の要素を結合（cons）したものである、という風に理解できます。Rubyにはリスト処理のためのArrayクラスがあるので、ここでは各関数をArrayクラスのメソッドとして定義していきます。

上記定義に従って最初に**cons**をArrayのメソッドとして定義します。またリスト処理を容易にするために、関数言語風にhead（リストの先頭要素）と、tail（リストの先頭要素を除いた残り）を定義します。

{% highlight ruby %}
class Array
  def cons(a)
    [a] + self
  end

  alias :head :first
  def tail
    drop 1
  end
end

[].cons(1) # => [1]
[].cons(2).cons(1) # => [1, 2]
[].cons(3).cons(2).cons(1) # => [1, 2, 3]

[1, 2, 3].head # => 1
[1, 2, 3].tail # => [2, 3]
{% endhighlight %}


最初に、リストの要素を足し合わせる**sum0**を定義します。これは再帰を使って以下のように書くことができます。
{% highlight ruby %}
class Array
  def sum0
    return 0 if empty?
    head + tail.sum0
  end
end

ls = [1,2,3,4,5]
ls.sum0 # => 15
{% endhighlight %}

つまり空リストに対しては0を返すようにし、それ以外ではリストの最初の要素を残りの要素の和に足していくことで結果を得ます。

ここで、この定義における加算に固有の要素つまり「0」と「+」を一般化すると、リスト処理の汎用メソッドreduceができ上がります（Rubyには既に同じ機能を持ったEnumerable#reduceが存在します）。
{% highlight ruby %}
class Array
  def reduce(f, a)
    return a if empty?
    f[head, tail.reduce(f, a)]
  end
end
{% endhighlight %}

Rubyではメソッドはそのままでは引数として渡すことができないので、ここではfとしてProcオブジェクトを受けるようにし`Proc#[]`で実行するようにしています（Proc#.callまたはProc#.()という呼びだし方法もあります）。

今度はreduceとaddメソッドを使って**sum**を再定義してみます。
{% highlight ruby %}
class Array
  def sum
    reduce add, 0
  end

  def add
    ->a,b{ a + b } # lambda{ |a,b| a + b } と同じ
  end
end

ls = [1,2,3,4,5]
ls.sum # => 15
{% endhighlight %}

addメソッドはa,bを引数に取るProcオブジェクト、つまり手続きを返す高階関数です。

同様にしてreduceとmultiplyメソッドを使って、要素を掛け合わせる**product**を定義します（RubyのArrayには別の目的のために同名のメソッドがあるので警告がでます）。
{% highlight ruby %}
class Array
  def product
    reduce multiply, 1
  end

  def multiply
    ->a,b{ a * b }
  end
end

ls = [1,2,3,4,5]
ls.product # => 120
{% endhighlight %}

またreduceを使って、真理値リストの要素のうち何れかが真かを検査する**any_true**と、すべての要素が真であることを検査する**all_true**を同様に定義できます。
{% highlight ruby %}
class Array
  def any_true
    reduce send(:or), false
  end

  def all_true
    reduce send(:and), true
  end

  def or
    ->a,b{ a or b }
  end

  def and
    ->a,b{ a and b }
  end
end

tf1 = [false, true, false]
tf2 = [true, true, true]

tf1.any_true # => true
tf2.any_true # => true
tf1.all_true # => false
tf2.all_true # => true
{% endhighlight %}

Rubyにおいて**or**と**and**は予約語なのでそのままの形では引数として渡すことができません。ここではこの問題を回避するため、`Kernel#send`を使っています（Kernel#methodを使う方法もあります）。

さてここで`reduce(f, a)`をcons(a)との対比で理解してみましょう。リスト[1,2,3]はconsを使って以下のように作ることができます。
{% highlight ruby %}
[].cons(3).cons(2).cons(1) # => [1, 2, 3]
{% endhighlight %}

reduce(f,a)は上の式のconsをすべてfに置き換え、\[ \]をaに置き換えたものとみなすことができます。
{% highlight ruby %}
a.f(3).f(2).f(1)
{% endhighlight %}

その結果、先のsumのreduce add, 0とproductのreduce multiply, 1は、それぞれ以下のように理解できます。
{% highlight ruby %}
0.add(3).add(2).add(1)
1.multiply(3).multiply(2).multiply(1)
{% endhighlight %}

そうするとreduce cons, \[ \]はリストを複写するものであることが理解できるでしょう。consをreduceに渡せるように少し改良して複写メソッドdupを定義します。
{% highlight ruby %}
class Array
  def cons
    ->a,ls=self{ [a] + ls }
  end

  def reduce(f, a)
    return a if empty?
    f[head, tail.reduce(f, a)]
  end

  def dup
    reduce cons, []
  end
end

[1,2,3].dup # => [1, 2, 3]
{% endhighlight %}
consは他の補助メソッドと同様に２つの引数を取るようにし、かつ[]メソッドで実行されるようProcオブジェクト化します。

ここでdupにおけるreduceの第二引数にリストを渡せるようにすれば、リストを結合するappendが定義できます。
{% highlight ruby %}
class Array
  def append(ls)
    reduce cons, ls
  end
end

[1,2,3].append [4,5,6] # => [1, 2, 3, 4, 5, 6]
{% endhighlight %}

続いてリストの要素を２倍するメソッド**double_all**を定義します。double_allはreduceとdouble_and_consを使って次のように書くことができます。double_and_consは要素を倍にして結果をリストに結合するものです。
{% highlight ruby %}
class Array
  def double_all
    reduce double_and_cons, []
  end

  def double_and_cons
    ->num,ls{ cons[2*num, ls] }
  end
end

ls = [1,2,3,4,5]
ls.double_all # => [2, 4, 6, 8, 10]
{% endhighlight %}

ここで**double_and_cons**はさらにdoubleとf_and_consにモジュール化することができます。
{% highlight ruby %}
class Array
  def double_all
    reduce f_and_cons[double], []
  end
  
  def double
    ->num{ 2 * num }
  end
  
  def f_and_cons
    ->f,el,ls{ cons[f[el], ls] }.curry
  end
end

ls = [1,2,3,4,5]
ls.double_all # => [2, 4, 6, 8, 10]
{% endhighlight %}

double_allにおいてreduceはその第１引数としてProcオブジェクトを受け取る必要があります。ここではf_and_consをカリー化することにより、それがdoubleのみを取ってProcオブジェクトを返せるよう工夫しています。このような方法を関数の部分適用といいます。

また2つの関数を合成する**compose**メソッドを定義することにより、consとdoubleを合成する方法もあります。
{% highlight ruby %}
class Array
  def double_all
    reduce compose(cons, double), []
  end

  def double
    ->num{ 2 * num }
  end
  
  def compose(f,g)
    ->x,y{ f[g[x],y] }
  end
end

ls = [1,2,3,4,5]
ls.double_all # => [2, 4, 6, 8, 10]
{% endhighlight %}
（このcomposeは受け取る引数の個数が固定的であり、汎用的なものではありません）

double_allはconsと合成する関数を一般化することによって、更にモジュール化を進めることができます。
{% highlight ruby %}
class Array
  def double_all
    map double
  end

  def map(f)
    reduce compose(cons, f), []
  end
end

ls = [1,2,3,4,5]
ls.double_all # => [2, 4, 6, 8, 10]
{% endhighlight %}

**map**は任意のメソッドfをリストのすべての要素に適用します。mapはreduceと並ぶもう一つの汎用的なメソッドです（Rubyには同じ目的のArray#mapが存在するので警告がでます）。

{% highlight ruby %}
[1,2,3,4,5].map ->x{ x ** 2 } # => [1, 4, 9, 16, 25]
%w(ruby haskell scheme).map ->s{ s.upcase } # => ["RUBY", "HASKELL", "SCHEME"]
{% endhighlight %}

このようにしてメソッドを高階関数と、いくつかの単純なメソッドの合成としてモジュール化することにより、リストのための多数のメソッドを効果的に定義することができました。

