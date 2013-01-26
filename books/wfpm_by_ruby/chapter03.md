##４章　プログラムの貼り合せ - 遅延評価 -

次に、関数プログラミングの２つ目の強力な糊、つまりプログラムを貼り合せる糊について説明します。

いま２つのプログラムｆとｇがあって、入力inputをこれらに適用する場合を考ます。
{% highlight ruby %}
g (f input)
{% endhighlight %}

プログラムｆは入力inputを受け取ってその出力を計算し、その出力はプログラムｇの入力として使われます。

一般的なプログラム言語ではｆからの出力を一時的にメモリーに蓄えることでその実装を可能としますが、ケースによってはメモリー占有量が膨大になり得ます。

関数プログラミングではプログラムｆとｇは厳密な同期の上で走ります。つまりプログラムｆはプログラムｇが必要とする分だけ実行されて残りは破棄されます。このことからプログラムｆは無限に出力を生成し続けるものであってもよいということになります。これによってプログラムの停止条件は、ループ本体と切り離すことができ、強力なモジュール化が可能になります。

このようなプログラムの評価方式は「遅延評価」と呼ばれています。

##ニュートンーラプソン法による平方根
遅延評価の力を使って、ニュートンーラプソン法による平方根のアルゴリズムを求めてみます。この方法でnの平方根を求めるとき任意の近似値xを選び、xとn/xの平均を取っていくことでより良い近似値xを得ます。これを繰り返し十分に良い近似値が得られたら処理を終えるようにします。良い近似値かの判断は隣接する近似値の差が許容誤差eps以下であるかにより判断します。

Rubyにおける一般的な実装は以下のようになるでしょう。
{% highlight ruby %}
 EPS = 0.0001    # 許容誤差
 A0 = 1.0        # 初期近似値
 def sqrt(n, x=A0, eps = EPS)
   loop do
     y = x
     x = (x + n/x) / 2.0           # 次の近似値
     return x if (x-y).abs < eps
   end
 end

 sqrt 2 # => 1.4142135623746899
 sqrt 5 # => 2.236067977499978
 sqrt 8 # => 2.8284271250498643
{% endhighlight %}

この実装ではループの停止条件は、ループに組み込まれてしまって分離が容易ではありません。遅延評価を使うことによって実装のモジュール化を行い、その部品が他の場面でも使えることを示します。

基本的にRubyの関数（メソッド）は正格評価であり遅延評価されません。しかし関数をProcやEnumeratorオブジェクトとすることによって、その評価のタイミングを遅らせる、つまり遅延評価させることができます。

まず次の近似値を計算する**next_val**を定義します。
{% highlight ruby %}
 def next_val
   ->n,x{ (x + n/x) / 2.0 }.curry
 end
{% endhighlight %}

next_valは、求める平方根の数値nと近似値xを取って次の近似値を返しますが、これをcurry化されたProcオブジェクトを返すように実装します。これによって、２つの引数を渡すタイミングをコントロールできるようになります。つまり数値nだけを先に渡すことによってnext_valは、１つの引数xを受ける関数に変わります。

例を示します。
{% highlight ruby %}
 next_for_five = next_val[5]

 nx = next_for_five[1.0] # => 3.0
 nx = next_for_five[nx] # => 2.3333333333333335
 nx = next_for_five[nx] # => 2.238095238095238
 nx = next_for_five[nx] # => 2.2360688956433634
{% endhighlight %}

次に、初期値に任意の関数を繰り返し適用して、その結果のリストを返す汎用関数**repeat**を定義します。
{% highlight ruby %}
 def repeat(f, x)
   Enumerator.new { |y| loop { y << x; x = f[x] } }
 end
{% endhighlight %}

repeat関数は１つの引数を取って１つの結果を返す関数ｆと、ｆの初期値となるxを取りEnumeratorオブジェクトを返します。Enumeratorのブロックの中ではloopによってxを関数ｆに適用した結果が、繰り返しｙつまりEnumerator::Yielderオブジェクトに渡されますが、これはEnumeratorオブジェクトが呼び出されるまで実行されず、そのため無限ループにはなりません。

このrepeat関数に先のnext_val関数を渡すことによって、平方根nの近似値のリストが得られるようになります。
{% highlight ruby %}
 approxs = repeat next_val[5], 1.0 # => #<Enumerator: #<Enumerator::Generator:0x0a4aec>:each>

 ls = []
 5.times { ls << approxs.next }
 ls # => [1.0, 3.0, 2.3333333333333335, 2.238095238095238, 2.2360688956433634]
{% endhighlight %}

Enumeratorオブジェクトはその呼び出し（ここではnext）の度にループを１つ回して結果を１つ返します。repeatはその出力を利用する関数と同期して、それが必要とされる分だけ評価されます。つまりrepeatそれ自体は繰り返し回数の制限を持ちません。

次に関数**with_in**を定義します。with_inは許容誤差と近似値のリスト（正確にはリストではなくEnumeratorオブジェクト）を引数に取り、許容誤差よりも小さい２つの連続する近似値を探します。

{% highlight ruby %}
 def with_in(eps, enum)
   a, b = enum.next, enum.peek
   return b if (a-b).abs <= eps
   with_in(eps, enum)
 end
{% endhighlight %}

最初の行でEnumeratorオブジェクトの返す最初の２つの値をnextとpeekでa, bに取ります。`Enumerator#peek`はカーソルを進めないで先頭要素を取ります。２行目の終了条件が満たされない限り、処理は再帰的に繰り返されることになります。

最後に、これらの部品を使って平方根を求める関数**sqrt**を定義します。
{% highlight ruby %}
 EPS = 0.0001    # 許容誤差
 A0 = 1.0        # 初期近似値
 def sqrt(n, a0=A0, eps=EPS)
   with_in eps, repeat(next_val[n], a0)
 end

 sqrt 2 # => 1.4142135623746899
 sqrt 3 # => 1.7320508100147274
 sqrt 5 # => 2.236067977499978
 sqrt 8 # => 2.8284271250498643
{% endhighlight %}

sqrt関数はこのようにしてモジュール化された３つの汎用部品**next_val**、**repeat**、**with_in**を貼り合せて作ることができました。

sqrt関数はモジュールを合成して構成されているので、プログラムの基本的な構造を変えることなく変更が容易に行えます。

今度は、２つの連続する近似値の差がゼロに近づくという条件の代わりに、２つの近似値の比が１に近づくという条件に変えてみます。これは非常に小さいまたは非常に大きい数に対してはより適切な結果を出します。

この目的を達成するには、関数with_inに代わる関数**relative**を定義するだけでいいのです。
{% highlight ruby %}
 def relative(eps, enum)
   a, b = enum.next, enum.peek
   return b if (a-b).abs <= eps*b.abs
   relative(eps, enum)
 end

 def sqrt(n, a0=A0, eps=EPS)
   relative eps, repeat(next_approx[n], a0)
 end

 sqrt 2 # => 1.4142135623746899
 sqrt 3 # => 1.7320508100147274
 sqrt 5 # => 2.236067977499978
 sqrt 8 # => 2.8284271250498643
{% endhighlight %}

他の部品を変えることなく新しいsqrt関数ができました。

##終わりに

以上、関数型プログラミングにおける強力な２つの糊、「高階関数」と「遅延評価」の例をいくつか見てきました。これらの糊によりプログラムは柔軟に、汎用的な多数のモジュールに分割できることが分かりました。Rubyにおける関数型プログラミングの支援機能は、純粋な関数型プログラミング言語におけるそれには及ばないものの、Rubyプログラマに大きな力を与え得るのではないでしょうか。


<<<------>>>

## 謝辞

本書は、「Why Functional Programming Matters:なぜ関数プログラミングは重要か」の邦訳版(http://www.sampou.org/haskell/article/whyfp.html)をベースに書かれたもので、この論文およびその邦訳版がなければ存在し得ないものです。したがって、原著者であるJohn Huges氏および翻訳者である山下伸夫氏に感謝します。

本書は、ブログ「[hp12c](http://melborne.github.com/ 'hp12c')」における以下の記事の電子書籍版です。

> [Rubyを使って「なぜ関数プログラミングは重要か」を読み解く（前編）但し後編の予定なし](http://melborne.github.com/2013/01/21/wfpm_by_ruby/)


ブログにおける誤記の修正およびメディア向けの調整を行って電子書籍化しました。EPUBデータの生成には、Rubyで作られた[melborne/maliq](https://github.com/melborne/maliq 'melborne/maliq')を使っています。

## 著者について

**kyoendo(a.k.a melborne)**

Rubyを愛するブログ「[hp12c](http://melborne.github.com/ 'hp12c')」の管理者。東京在住。妻と二人暮らし。

> github: [melborne (kyoendo)](https://github.com/melborne 'melborne (kyoendo)')

> twitter: [kyoendo (merborne) on Twitter](https://twitter.com/merborne 'kyoendo (merborne) on Twitter')

----

2013年1月21日　初版発行

