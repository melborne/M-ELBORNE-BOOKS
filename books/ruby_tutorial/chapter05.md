{% csssig h2 id='user_friendly' %}
##Rubyはユーザフレンドリです
{% endcsssig %}

Rubyにおいてオブジェクト指向はその基本的設計思想です。Ruby設計者まつもとゆきひろさん(愛称Matz)はその思想を頑なに守りながら、一方でプログラマーの負担を最小化するために、ユーザインタフェースをよりフレンドリなものにしました。そのいくつかを紹介します。

###メソッド呼び出しのシンタックスシュガー
オブジェクト指向の基本ルールに従えば、簡単な算術演算も整数オブジェクトに対するメソッド呼び出しのかたちを取ります。
{% highlight ruby %}
 6.+(2) # => 8
 6.-(2) # => 4
 6.*(2) # => 12
 6./(2) # => 3
{% endhighlight %}

しかしRubyでは慣れ親しんだ数学式の書き方ができます。
{% highlight ruby %}
 6 + 2 # => 8
 6 - 2 # => 4
 6 * 2 # => 12
 6 / 2 # => 3
{% endhighlight %}

オブジェクトの状態変数（Rubyではインスタンス変数と呼びます）への代入も次のように自然に書けます。
{% highlight ruby %}
 charlie = Person.new('Charlie', 12, :male)
 charlie.age = 18
{% endhighlight %}

この実際の定義は以下のようになっています。

{% highlight ruby %}
class Person
  def initialize(name, age, sex)
    @name, @age, @sex = name, age, sex
  end

  def age
    @age
  end
  
  def age=(age)
    @age = age
  end
end

charlie = Person.new('Charlie', 12, :male)
charlie.age = 18
charlie.age # => 18
{% endhighlight %}

つまり変数への代入に見える先の式は、実際は引数を伴ったメソッド呼び出しで、**charlie.age=(18)**と等価です。

このようなメソッド呼び出しのシンタックスシュガー(簡略表記)がRubyではできます。

###クラス定義およびレシーバの省略
Rubyではクラス定義をすることなく、コードを手続き型言語のように書くこともできます。
{% highlight ruby %}
 def fact(n)
   if n == 1
     1
   else
     n * fact(n-1)
   end
 end
 puts fact(10)
# >> 3628800
{% endhighlight %}

このようにいきなりメソッドfactを定義したり、レシーバを指定せずにputsメソッド呼んだりできます。

でもここでもオブジェクト指向設計は崩れていません。Matzはオブジェクト内でのメソッド呼び出しをそのレシーバを省略できるようにすると共に、クラスの外で書かれたコードがObjectクラスという基本クラスに自動設定されるようにし、これによって設計の一貫性を維持しつつ、手続き型記述を許せるようにしたのです。

Rubyの手続き型記述をよく使う方も、このことは頭の片隅にあって良いと思います。Rubyではクラスの外をトップレベルと呼ぶことがあります。

###変数・定数
以下の構文は変数carに対する値の代入ですが、Rubyではそれは正確な表現ではありません。
{% highlight ruby %}
 car = 'mini cooper'
{% endhighlight %}

「変数carで'mini cooper'文字列オブジェクトを参照できるようにする」と言ったほうがより正確です。つまり変数carは単なる参照ラベルに過ぎません。ですから、１つのオブジェクトに複数の変数を付けてもコピーは起きません。型といった概念もないので型宣言は不要です。Rubyでは次のコードは問題ありません。
{% highlight ruby %}
 a = 3
 b = 6
 c = a + b
 puts c
 a = 'mississippi'
 b = '-hippopotamus'
 c = a + b
 puts c
 # >> 9
 # >> mississippi-hippopotamus
{% endhighlight %}

’+’が算術演算子ではなくてメソッドであると前に書きました。前者のa + bは3整数オブジェクトに対して、6整数オブジェクトを引数に+メソッドを呼び出しています。その後a, bの参照先が変わって、後者のa + bは'mississippi'文字列オブジェクトに対して、'-hippopotamus'文字列オブジェクトを引数に +メソッドを呼び出しています。つまり+メソッドは、異なるタイプのオブジェクトに送られているのです。

そして整数オブジェクトでは+メソッドは、自身と引数を加算した整数オブジェクトを返すように、文字列オブジェクトでは、自身と引数を連結した文字列オブジェクトを返すようにそれぞれ定義されています。

定数に対する考え方も同じです。定数は大文字で始まり貼り替えの必要のない、つまり内容が変化しないオブジェクトを指す目的で使います。なおクラス定義は大文字で始まりますが(String, Array)、これらはクラスオブジェクトを指し示す定数です。

###括弧の省略
Rubyでは解釈に曖昧さが生じない限り、括弧を省略できます。
{% highlight ruby %}
 def say word
   "#{word} " * 3
 end
 puts say "Hello!"
 puts say say "Hi!"
 # >> Hello!　Hello!　Hello!　
 # >> Hi!　Hi!　Hi!　　Hi!　Hi!　Hi!　　Hi!　Hi!　Hi!　　
{% endhighlight %}

このオブジェクト原理主義的な書き方はこうです。
{% highlight ruby %}
 def say(word)
   "#{word} ".*(3)
 end
 puts(say("Hello!"))
 puts(say(say("Hi!")))
 # >> Hello!　Hello!　Hello!　
 # >> Hi!　Hi!　Hi!　　Hi!　Hi!　Hi!　　Hi!　Hi!　Hi!　　
{% endhighlight %}

括弧の省略はこのようにコードの見た目を改善し読みやすくします。しかし行き過ぎはむしろコードを読み難くします。文章の句読点を使うように適度に括弧を使うのが常識人です。

###多重代入と*(アスタリスク)
Rubyでは関連する複数の変数に対して同時に代入ができます。
{% highlight ruby %}
 a, b, c = 0, 1, 2
{% endhighlight %}

これを多重代入といいます。もちろん関連がなくてもできますが推奨されません。
{% highlight ruby %}
 SIZE, name, switch = {:L => 'large', :M => 'medium', :S => 'small' }, 'Ruby',  [0, 1]
{% endhighlight %}

メソッドは複数の返り値を返せるので、これを多重代入で受けることもできます。
{% highlight ruby %}
 class Fixnum
   def plus_multi(other)
     return self + other, self * other
   end
 end
 
 a, b = 3.plus_multi(4)
 a # => 7
 b # => 12
{% endhighlight %}

変数に*(アスタリスク)を付けるとマルチラベルになって、受けたオブジェクトを配列に入れてそれを指します。
{% highlight ruby %}
 *a = 1, 2, 3
 a # => [1, 2, 3]
{% endhighlight %}

Rubyではこれをメソッドの引数にも使えるのです。
{% highlight ruby %}
 def hello(*a)
   a.each { |name| puts "Hello, #{name}!" }
 end
 
 hello 'donkey', 'alligator', 'hippopotamus'
 # >> Hello, donkey!
 # >> Hello, alligator!
 # >> Hello, hippopotamus!
{% endhighlight %}

このようにRubyは純粋なオブジェクト指向言語でありながら、とてもユーザフレンドリな作りになっています。

呆れるほど長い前置きが続きました。でもこれで最初に掲げた4つの項目の説明は終わりです。もちろん説明はし尽くされていませんが、最初の目的を失しそうなのでここまでとします。

そろそろ本題に入りましょう。

