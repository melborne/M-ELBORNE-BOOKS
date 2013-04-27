{% csssig h2 id='ruby_block' %}
##Rubyのブロックは仮装オブジェクトです
{% endcsssig %}

次にRubyのブロックを説明します。

手続き型言語同様、Rubyもifやwhileなどの制御構造をサポートしており、メソッド定義式の中でこれらを使うことができます（メソッド定義の外でも使えます）。
{% highlight ruby %}
 def hello(name)
   if name.length > 10
     name.squeeze!
   else
     name += name.reverse
   end
   "Hello, #{name}."
 end
 
 hello('mississippi-hippopotamus') # => "Hello, misisipi-hipopotamus."
 hello('donkey') # => "Hello, donkeyyeknod."
{% endhighlight %}

case式というユニークな制御構造もあります。
{% highlight ruby %}
 def good_bye(name)
   new_name =
     case name.length
     when 1..8
       name.next.capitalize
     when 9..15
       name.upcase.chop
     else
       name.replace("too-long-name")
     end
   "Good-bye, #{new_name}!!"
 end
 
 good_bye('donkey') # => "Good-bye, Donkez!!"
 good_bye('alligator') # => "Good-bye, ALLIGATO!!"
 good_bye('mississppi-hippopotamus') # => "Good-bye, too-long-name!!"
{% endhighlight %}
コードをよく見て頂ければわかると思いますが、caseはcase式であり値を返します。Rubyでは多くの制御構造や構文が式であり値を返します。つまりRubyでは制御構造もオブジェクト的なのです。

しかし、これらの制御構造は真のオブジェクトではありません。したがってこのような制御構造をメソッドの引数として渡すことはできません。LispやSchemeなどの異次元言語では、これらの制御構造を何の苦もなく関数の引数として渡せるそうです。このような関数は高階関数などとブルジョワジーに呼ばれます。

しかしハンカチを噛む必要はありません。Rubyにはブロックがあります。制御構造をdo endまたは{ }のブロックに入れると、メソッドに引数のように渡せるようになります。
{% highlight ruby %}
 ['donkey', 'alligator', 'hippopotamus'].each do |name|
   salute =
     if name.start_with?('hip')
       'ばか！'
     else
       'やあ！'
     end
   puts salute + name
 end
 # >> やあ！donkey
 # >> やあ！alligator
 # >> ばか！hippopotamus
{% endhighlight %}
例では配列オブジェクトにeachメソッドを送る際にブロックを渡しています。これを受け取った配列オブジェクトは、各要素をブロック引数nameに順番に渡して、ブロックの制御構造を起動するのです。eachに渡すブロックの中身を変えれば、eachメソッドの働きは大幅に変更できます。

この項の表題における「仮装」はtypoではありません。そう制御構造はブロックでオブジェクトに仮装して、他のオブジェクトに入り込むのです！

制御構造をメソッドに付けてオブジェクトに渡せるようにする方法はまだあります。勘のいい人は気が付いたかもしれません。そう制御構造をオブジェクト化すればいいのです。手続きオブジェクト、メソッドオブジェクトなどがこれを可能にします。先を急がれるでしょうからこの話題はこれで終わりにします。

興味のある方は以下が参考になるかもしれません。
[Rubyのブロックはメソッドに対するメソッドのMix-inだ！](http://melborne.github.io/2008/08/09/Ruby-Mix-in/)

