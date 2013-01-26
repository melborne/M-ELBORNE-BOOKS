---
language: 'ja'
unique_identifier:
 - 'http://melborne.github.com/2012/04/09/to-newbie/'
 - 'BookID'
 - 'URL'
title: 'これからRubyを始める人たちへ'
subtitle: 'To Whom Start Ruby'
subject: 'programming, ruby, tutorial, 入門'
description: '本書は、ブログ「hp12c」(http://melborne.github.com/)における「これからRubyを始める人たちへ」(http://melborne.github.com/2012/04/09/to-newbie/)の電子書籍版であり、主としてプログラミング経験者向けに書かれたプログラミング言語「Ruby」の入門書です。'
creator: 'kyoendo'
date: '2012-12-01'
liquid: '../../template/plugins'
---

##１章　Rubyの特徴
Rubyは、まつもとゆきひろ氏（通称「Matz」）により設計されたオブジェクト指向プログラミング言語です。Rubyの特徴を一言で言うならば、それは「間口が広くて奥が深い言語」ということになります。

「間口が広い」というのは、インタフェースがシンプルで誰でもが簡単に使い始められることを意味します。「奥が深い」というのは、プロフェッショナルによる長期使用に耐えうる本物の言語であるということを意味します。「間口が広い」ということと「奥が深い」ということは本来競合する概念ではありませんが、その両方をバランスよく組み合わせるには、対象に対する深い知識と広い視野、加えて人並み外れたセンスが必要です。

Rubyはまつもと氏のその絶妙なバランス感覚によって生まれました。つまりRubyはプログラム言語における「スーパーマリオブラザーズ」であり、氏は言語界における「宮本茂」なのです。

##Rubyのインストール
まずRubyをinstallする必要がありますが、もしあなたがWindowsユーザなら[RubyInstaller for Windows](http://rubyinstaller.org/ 'RubyInstaller for Windows')というツールがあります。以下などを参考に最新版をインストールしてください。

> [Windows で Ruby バージョン 1.8.7 あるいは 1.9.2 のインストール (RubyInstaller を使用)](http://www.kkaneko.com/rinkou/ruby/rubyinstaller.html 'Windows で Ruby バージョン 1.8.7 あるいは 1.9.2 のインストール (RubyInstaller を使用)')

もしあなたがMacユーザならRubyが最初から入っていますがversionがちょっと古いです。Terminalを開いて、次のようにしてversionを確認して下さい。

{% highlight ruby %}
% ruby -v
{% endhighlight %}

1.8.7が返ってきたなら1.9.2以降が必要です。

Xcodeがあるとして、まずは[Homebrew](http://mxcl.github.com/homebrew/ 'Homebrew')という、UNIXツールパッケージマネージャをinstallしてください。次にhomebrewで[rbenv](https://github.com/sstephenson/rbenv 'rbenv')という、RubyのVersionマネージャをinstallします。readlineもinstallします。

{% highlight ruby %}
% brew update
% brew install rbenv
% brew install ruby-build
% brew install readline
% brew link readline
{% endhighlight %}

.bashrcなどに以下を追記します。

{% highlight bash %}
% export PATH="$HOME/.rbenv/bin:$PATH"
% eval "$(rbenv init -)"
{% endhighlight %}

そしてRubyをinstallします。最初にrbenv installでinstall候補を表示して、1.9.3-p327辺りをinstallします。

{% highlight bash %}
% rbenv install
% CONFIGURE_OPTS="--with-readline-dir=/usr/local" rbenv install 1.9.3-p327
% rbenv rehash
% rbenv global 1.9.3-p327
{% endhighlight %}

`ruby -v`してversionを確認してください。

##開発環境
Rubyistはもっぱらエディタを使います。IDEを使っている人は少ないです。Vim、Emacs、[TextMate](http://macromates.com/ 'TextMate')が広く使われていますが、最近では[Sublime Text](http://www.sublimetext.com/ 'Sublime Text: The text editor you'll fall in love with')の人気が急上昇中です。


<<<--- chapter02 --->>>

##２章　最初のRubyのコード
Rubyはすぐ始めることができます。早速何か作ってみましょう。パスワード生成器を作りましょう。

###パスワード生成器
もしあなたが他のプログラミング言語を知っているなら、まずそれで考えてみてください。英数字8文字からなるパスワードを10個作ります。

Rubyでは次のようになります。

{% gist 2332989 password_gen.rb %}

どうですか？Rubyを知らなくても何となくコードが読めると思います。Rubyのコードは簡潔で可読性が高いです。

プログラムの実行はTerminalで次のようにします。

{% highlight bash %}
% ruby password_gen.rb
{% endhighlight %}

出力は次のようになります。

{% highlight bash %}
HIa09itR
k6GgIFLc
ZKGwo1q7
DXVYKpnZ
F2uXCza7
EJRiQyvV
THJ6thBE
4mTBscNK
y6kEzx1Q
vz5PLiKT
{% endhighlight %}

コードについて少し解説します。

Rubyはオブジェクト指向言語ですから、プログラムはオブジェクトに対するメソッド呼び出しの形を取ります。`def end`はメソッド定義で、その引数にはdefault値をセットできます。メソッド定義の中では\[ \](角括弧)で配列を作って、`sample`というメソッドを呼んでsizeの数だけ配列の要素をサンプリングしています。更にその返り値に`join`というメソッドを呼んで、サンプリングした配列の要素を結合しています。配列の中の`0..9`はRangeオブジェクトで、先頭の`*`(splat)演算子で配列に展開しています。メソッドは常に結果を返します。何処かで明示的にreturnしなければ最後の式の結果が返り値になります。

`10.times`は10オブジェクトに対してtimesメソッドを呼んでいます。そう数字もオブジェクトです。RubyにはPrimitive型のようなものはなく、すべてがクラスから生成されるオブジェクトです。ちなみにRubyでは`true`も`nil`もそれからクラス自身もオブジェクトです。`10.times`は0から9の繰り返しを表現する`Enumerator`というオブジェクトを返します。

`map`メソッドは渡したブロック（{}またはdo endで表現される）内の手続きを使って、Enumeratorの要素である0から9を置換します。ここで、定義した`password_gen`メソッドを呼んでいます。引数が不要の場合はメソッド呼び出しの括弧は省略できます。結果は配列の形で返ります。Rubyではmapのようなブロックを取るメソッドが多数登場します。ブロック内には自由に手続きを書けますから、つまりこれは高階関数（関数を引数に取る関数）の簡易版です。

最初の`def end`のところでこれはメソッド定義だと説明しました。そう、これは関数ではありません。Rubyには関数はありません。すべてがオブジェクトに対するメソッド呼び出しです。先のコードのようにクラス定義の外側（これをトップレベルと呼びます）で定義されるメソッドは、クラスツリーの最上位に位置する`Object`クラスに定義されたものとして扱われます。そして外からは呼び出せない内部メソッドとなるようprivate指定されます。Rubyではprivate指定されたメソッドはオブジェクトを指定しない暗黙の呼び出しでしか呼べないよう設計されています。putsも同様です。このようにしてRubyでは、オブジェクト指向における設計の一貫性を維持しつつ、使い勝手の良い手続き的プログラミングができるようになっています。これがRubyの素晴らしい点です。

###irbを使う
Rubyには`irb`という対話型実行環境が付属しています。Terminalでirbしてみます。

{% highlight bash %}
% irb
{% endhighlight %}

そしてコードを打ち込んでreturnしてください。

{% highlight bash %}
>> char_set = [*0..9, *'a'..'z', *'A'..'Z']
=> [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
>> char_set.sample(8)
=> ["q", "d", 0, "S", "R", "K", "r", "Q"]
>> char_set.sample(8).join
=> "PI1EOBJg"
{% endhighlight %}

returnのたびにその式が評価されるのが分かると思います。こうしてRubyistはirbでちょっと試してその動作を確認しつつプログラムするのです。

Rubyの格言の一つに「RubyのことはRubyに聞け」というのがあります。例えば、先の配列オブジェクトchar_setがどのようなメソッドを受け付けるのか知りたいとします。そんなときはirbでこうします。

{% highlight bash %}
>> char_set.methods
=> [:inspect, :to_s, :to_a, :to_ary, :frozen?, :==, :eql?, :hash, :[], :[]=, :at, :fetch, :first, :last, :concat, :<<, :push, :pop, :shift, :unshift, :insert, :each, :each_index, :reverse_each, :length, :size, :empty?, :find_index, :index, :rindex, :join, :reverse, :reverse!, :rotate, :rotate!, :sort, :sort!, :sort_by!, :collect, :collect!, :map, :map!, :select, :select!, :keep_if, :values_at, :delete, :delete_at, :delete_if, :reject, :reject!, :zip, :transpose, :replace, :clear, :fill, :include?, :<=>, :slice, :slice!, :assoc, :rassoc, :+, :*, :-, :&, :|, :uniq, :uniq!, :compact, :compact!, :flatten, :flatten!, :count, :shuffle!, :shuffle, :sample, :cycle, :permutation, :combination, :repeated_permutation, :repeated_combination, :product, :take, :take_while, :drop, :drop_while, :pack, :entries, :sort_by, :grep, :find, :detect, :find_all, :flat_map, :collect_concat, :inject, :reduce, :partition, :group_by, :all?, :any?, :one?, :none?, :min, :max, :minmax, :min_by, :max_by, :minmax_by, :member?, :each_with_index, :each_entry, :each_slice, :each_cons, :each_with_object, :chunk, :slice_before, :nil?, :===, :=~, :!~, :class, :singleton_class, :clone, :dup, :initialize_dup, :initialize_clone, :taint, :tainted?, :untaint, :untrust, :untrusted?, :trust, :freeze, :methods, :singleton_methods, :protected_methods, :private_methods, :public_methods, :instance_variables, :instance_variable_get, :instance_variable_set, :instance_variable_defined?, :instance_of?, :kind_of?, :is_a?, :tap, :send, :public_send, :respond_to?, :respond_to_missing?, :extend, :display, :method, :public_method, :define_singleton_method, :__id__, :object_id, :to_enum, :enum_for, :equal?, :!, :!=, :instance_eval, :instance_exec, :__send__]
{% endhighlight %}

そこに`sample`というメソッドを見つけました。irbで`help`と打ってreturnします。

{% highlight bash %}
>> help
{% endhighlight %}

promptが変わりますから、そこでsampleと打ちます。

{% highlight bash %}
>> sample
.sample

(from ruby core)
Implementation from Array
----------------------------------------------
  ary.sample        -> obj
  ary.sample(n)     -> new_ary
----------------------------------------------

Choose a random element or n random elements from the array. The elements are chosen by using random and unique indices into the array in order to ensure that an element doesn't repeat itself unless the array already contained duplicate elements. If the array is empty the first form returns nil and the second form returns an empty array.
{% endhighlight %}

Array#sampleに対するヘルプが表示されました。空returnでhelpを抜けます。

ネットに日本語の[Rubyリファレンスマニュアル](http://doc.ruby-lang.org/ja/1.9.3/doc/index.html 'Rubyリファレンスマニュアル')があります。全メソッドを一覧したいという欲張りな人には、拙作[Ruby Reference Index](http://rbref.heroku.com/ 'Ruby Reference Index')があります。

<<<--- chapter03 --->>>

##３章　２つ目のRubyのコード
次に、UNIXコマンドを一つ作ってみます。ディレクトリ内のファイルの情報一覧を表示する、つまり次のUNIXコマンドのRuby版です。

{% highlight bash %}
% ls -l
{% endhighlight %}

Rubyにはシェルコマンドをそのまま呼べる`system`というメソッドがあるので、コードは次のようになります。

{% highlight ruby %}
puts system 'ls -l'
{% endhighlight %}

これではRubyの紹介になりません。systemを使わないで書いてみます。

{% gist 2332989 ls_l.rb %}

実行すると次の結果が得られます。

{% highlight bash %}
% ruby ls_l.rb

mode  nlink  uid  gid  size  mtime
16877  3  501  20  102  2012-04-05 22:50:12 +0900  lib
33188  1  501  20  450  2012-04-07 13:50:34 +0900  ls_l.rb
33188  1  501  20  366  2012-04-05 08:29:55 +0900  myfirst_webapp.rb
33188  1  501  20  276  2012-04-06 08:00:31 +0900  password_gen.rb
16877  3  501  20  102  2012-04-05 22:49:54 +0900  test
{% endhighlight %}


今度のコードは読むのがちょっと難しいですね。解説します。

`%w( … )`は文字列を要素とする配列の簡略記法です。簡略しない書き方はこうです。

{% highlight ruby %}
long_format = ['mode', 'nlink', 'uid', 'gid', 'size', 'mtime']
{% endhighlight %}

この配列を`long_format`という変数に代入しています。Rubyの変数には型という概念がありません。Rubyの変数はオブジェクトへの参照です。つまり名札です。

`Dir[path]`は一見、配列参照のように見えますが、これはDirオブジェクトに対するメソッド呼び出しです。irbで次のようにしてください。

{% highlight bash %}
>> Dir['*']
=> ["lib", "ls_l.rb", "myfirst_webapp.rb", "password_gen.rb", "test"]
{% endhighlight %}

次にこうしてください。

{% highlight bash %}
>> Dir.[]('*')
=> ["lib", "ls_l.rb", "myfirst_webapp.rb", "password_gen.rb", "test"]
{% endhighlight %}

同じ結果が得られました。つまり`Dir[arg]`は`Dir.[](arg)`の簡略記法(syntax sugar)です。ちょっといたずらをします。irbで次のようにしてください。

{% highlight bash %}
>> def Dir.[](arg)
>>   arg * 10
>> end
=> nil
{% endhighlight %}

もう一度`Dir['*']`を実行します。

{% highlight bash %}
>> Dir['*']
=> "**********"
>> Dir['/bin']
=> "/bin/bin/bin/bin/bin/bin/bin/bin/bin/bin"
{% endhighlight %}

挙動が変わりました。つまりメソッドがoverrideされました。

Rubyにはこのような見た目を良くするためのメソッド呼び出しの簡略記法がいろいろあります。以下もそうです。

{% highlight bash %}
>> 1 + 2
=> 3
>> [1,2,3] << 4
=> [1, 2, 3, 4]
>> hash = {}
>> hash[:job] = 'rubyist'
=> "rubyist"
{% endhighlight %}

これらは演算子に見えますが、メソッド呼び出しです。originalはこうです。

{% highlight bash %}
>> 1.+(2)
=> 3
>> [1,2,3].<<(4)
=> [1, 2, 3, 4]
>> hash.[]=(:job, 'rubyist')
=> "rubyist"
{% endhighlight %}

Rubyで演算子に見える記号の多くはメソッド呼び出しです。したがってoverrideしたり、オブジェクトの種類に応じてその挙動を変えることができます。ポリモーフィズムですね。

ls_lの解説に戻ります。コードを再掲します。

{% gist 2332989 ls_l.rb %}

`map`はpassword_genのところで説明しました。`Dir[path]`で得られたfilenameは`|fname|`でブロック内の手続きに順番に渡されます。`File.stat(fname)`はfnameを引数にFileオブジェクトの`stat`メソッドを呼んでいます。これでそのファイル属性をパッケージ化したオブジェクトが得られます。そしてまた`map`です。今度はlong_formatの要素（ファイル属性名）を順番にブロックに渡します。ここで、`send`メソッドでstatにファイル属性名を渡して、各属性名を属性値に置換します。通常、属性値の取得は次のようにします。

{% highlight bash %}
>> stat = File.stat('password_gen.rb')
>> stat.mode
=> 33188
>> stat.nlink
=> 1
>> stat.uid
=> 501
>> stat.gid
=> 20
>> stat.size
=> 276
>> stat.mtime
=> 2012-04-06 08:00:31 +0900
{% endhighlight %}

`send`メソッドはその文字列で各メソッドの呼び出しを可能にします。`<<`は上で見ました。`long_format.map`で返された配列にfnameを追加するメソッドです。

最後に`path = ARGV[0] || '*'`の説明です。`ARGV`はcommand line引数を表す配列オブジェクトです。つまりこういうことです。

{% highlight bash %}
% ruby ls_l.rb '/usr/local/*'
{% endhighlight %}

この場合`ARGV[0]`には'/usr/local/\*'が格納され、変数pathはこれを指すことになります。引数なしで`$ ruby ls_l.rb`とした場合、nilが入ります。その場合pathは代わりに'\*'を参照します。つまり`path = ARGV[0] || '*'`は

{% highlight ruby %}
path = ARGV[0] ? ARGV[0] : '*'
{% endhighlight %}
あるいは
{% highlight ruby %}
path =
  if ARGV[0]
    ARGV[0]
  else
    '*'
  end
{% endhighlight %}

と等価です。ちなみにRubyでは`if`を含む制御構造の多くが式です。つまり結果を返します。上の例では結果はpathに代入されます。

<<<--- chapter04 --->>>

##４章　Rubyのクラス階層
さてRubyのクラスの説明を少しします。RubyのクラスシステムはUNIXのファイルシステムと同じ木構造です。クラスツリーのrootは`Object`クラスです。Objectクラスの持っている特性（つまりメソッド）は、そこにぶら下がっているクラス（つまりすべてのクラス）に継承されます。そしてぶら下がっているクラスで別の特性が追加されたなら、その追加の特性を含めてそこにぶら下がっているクラスに継承します。ここで言っている「継承」とは、下流から上流のメソッドを参照できるという意味です。

ここでRubyが標準で持っているクラスシステムを見てみます。1.9系で少しクラスシステムが複雑になりました。ここでは1.8.7のものを見ます。

{% highlight bash %}
Object
 |--Module
 |  └-Class
 |--Numeric
 |  └-Float
 |  └-Integer
 |     └-Bignum
 |     └-Fixnum
 |--String
 |--Symbol
 |--Array
 |--Hash
 |--Range
 |--Regexp
 |--MatchData
 |--IO
 |  └-File
 |--File::Stat
 |--Dir
 |--Time
 |--Struct
 |  └-Struct::Tms
 |--Enumerable::Enumerator
 |--Proc
 |--Method
 |--UnboundMethod
 |--Thread
 |--ThreadGroup
 |--FalseClass
 |--TrueClass
 |--NilClass
 |--Exception
 |--Continuation
 |--Process::Status
 |--Binding
 `--Data
    └-NameError::message
{% endhighlight %}

これらはRubyに最初から組み込まれたクラスです。重要なもの・よく使うものを上の方に配置しました。Rubyを起動すると最初にこれらのクラスがメモリ空間に構築されて呼べるようになります。Rubyではクラスもメモリ空間に常駐するオブジェクトです。最重要クラスは`Object`、`Module`、`Class`です。これらがRubyの世界の基礎を構築しています。

Rubyには別途[標準添付のクラス群](http://doc.ruby-lang.org/ja/1.9.3/library/index.html' ライブラリ一覧')があります。標準添付ライブラリと言います。これらは明示的にメモリに読み出す必要があります。読み出しには`require`を使います。

{% highlight ruby %}
require 'date'

puts Date.today
# >> 2012-04-07
{% endhighlight %}

読み出しによりこれらもクラスツリーのどこかにぶら下がることになります。あなたが作るoriginalのクラスも他の誰かが公開したクラスも、標準添付ライブラリと全く同様の扱いを受けます。

クラスの主たる仕事はオブジェクトをメモリ空間に生成することです。そしてその標準的な作法はクラスに対し`new`メソッドを呼ぶことです。

{% highlight ruby %}
string = String.new('hello') # => "hello"
array = Array.new(3, 'hello') # => ["hello", "hello", "hello"]
hash = Hash.new # => {}
range = Range.new(1,9) # => 1..9
regexp = Regexp.new(/r..y/) # => /r..y/
f = File.new('ls_l.rb') # => #<File:ls_l.rb>
{% endhighlight %}

もっとも、よく使われる組み込みクラスでは、結果を直接書けばオブジェクトが生成できるようになっています。そのようなものをリテラルといいます。

{% highlight ruby %}
string = 'hello' # => "hello"
array = ['hello', 'hello', 'hello'] # => ["hello", "hello", "hello"]
hash = {} # => {}
range = 1..9 # => 1..9
regexp = /r..y/ # => /r..y/
{% endhighlight %}

各オブジェクトに対してはその生成元クラスで定義したメソッドが呼べるようになります。各組み込みクラスには大量のメソッドが定義されています。[Ruby Reference Index](http://rbref.heroku.com/ 'Ruby Reference Index')における各クラスのpublic_instance_methodsの項を見てください。例えばArrayクラスには80を超えるメソッドが定義されています。これがRubyの便利さの源です。生成元クラスにメソッドが見つからなければ、Rubyはクラスツリーを逆にたどってメソッドを探しに行きます。これが継承の意味です。

##モジュール
Rubyにはクラスとそっくりな「モジュール」というオブジェクトがあります。クラス同様そこにはメソッドが定義できます。しかしモジュールは先のクラスツリーにぶら下がることができません。オブジェクトを生成することもできません。代わりに、クラスに挿し木されます。それによって対象のクラスにメソッドを補給します。これを「Mix-in」といいます。一つのモジュールを複数のクラスに挿し木することもできます。`Enumerable`という繰り返しに係る機能を提供するモジュールは`Array` `Hash` `Range` `IO`など多数のクラスにMix-inされています。最重要モジュールは、ObjectクラスにMix-inされた`Kernel`モジュールです。

##RubyGems
他の人が作ったクラスやモジュールは、もっぱら「RubyGems」という形式でパッケージされ公開・配布されています。それらは[RubyGems.org](https://rubygems.org/ 'RubyGems.org')でホスティングされています。Rubyにはそこからパッケージを取得するためのrubygemsというツールが付属しています。これを使って`gem search`して`gem install`します。

{% highlight ruby %}
% gem search rails --remote
% gem install rails
{% endhighlight %}

名前がはっきりしないような場合は[RubyGems.org](https://rubygems.org/ 'RubyGems.org')で検索します。機能別で比較しながら見つけたいなら[The Ruby Toolbox](https://www.ruby-toolbox.com/ 'The Ruby Toolbox')が便利です。RubyのWeb Application Frameworkにどんなものがあって、人気はどうなのか見てみます。

[The Ruby Toolbox - Web App Frameworks](https://www.ruby-toolbox.com/categories/web_app_frameworks 'The Ruby Toolbox - Web App Frameworks')

[Ruby on Rails](http://rubyonrails.org/ 'Ruby on Rails')の人気が図抜けているのがわかります。

<<<--- chapter05 --->>>

##５章　My First Web Application
ではgemを使って何か作ってみましょう。2番人気の[Sinatra](http://www.sinatrarb.com/ 'Sinatra')と[haml](http://haml-lang.com/ 'haml')というHTMLマークアップ言語でWebアプリを作ります。まずはこれらgemsをinstallします。

{% highlight ruby %}
% gem install sinatra
% gem install haml
{% endhighlight %}

そしてこれらのgemと最初に書いた`password_gen.rb`をrequireで読み込んで、それらを使ったコードを書きます。その前にpassword_gen.rbを少し直します。

{% highlight ruby %}
#!/usr/bin/env ruby
def password_gen(size=8)
  [*0..9, *'a'..'z', *'A'..'Z'].sample(size).join
end

if __FILE__ == $0
  puts 10.times.map { password_gen }
end
{% endhighlight %}

`puts 10.times...`を`if __FILE__ == $0 end`で囲います。このファイルを直接実行したときにだけ、if節が実行するようになります。

そうです、パスワード・ジェネレーターサービスを作ります。さあコードを書きましょう。

{% gist 2332989 myfirst_webapp.rb %}

この1ファイルで完成です。ええ、ほんとうに。

簡単に解説します。まず`get '/' do end`は括弧が省略されたRubyのメソッド呼び出しです。rootパスに対するHTTPメソッドGETリクエストを受けて、haml言語で書かれたindexをレンダリングします。`get '/:size' do end`はrootパスに渡されたパラメータを受けて、これをpassword_genメソッドに渡して結果を@pwdインスタンス変数に取得し、pwdのレンダリングのときにこれが出力されるようにします。何となく読めるでしょうか。このように一見その目的に特化した構文に見えるけれども、実はRubyの柔軟性を使ったその文法に従った構文を内部DSLと言います。Rubyistは内部DSLが得意です。

さあ、このコードを実行します。

{% highlight ruby %}
% ruby myfirst_webapp.rb
{% endhighlight %}

すると`WEBrick`というWeb Serverが起動します。`http://localhost:4567/`にアクセスします。

![Alt Browser Screen](images/webapp1.png)

<br clear='all' />

リンクをクリックして..

![Alt Browser Screen](images/webapp2.png)

![Alt Browser Screen](images/webapp3.png)

<br clear='all' />

希望の長さのパスワードが生成されてユーザに提供されます。

<<<--- chapter06 --->>>

##６章　メタプログラミング
次にRubyのメタプログラミングについても触れておきます。メタプログラミングとは、あなたに代わってランタイムつまり動的にプログラムにプログラムを書かせることです。`method_missing`というフックメソッドを使ったメタプログラミングをやってみます。まずは次のような仕掛けをしておきます。

{% gist 2332989 country.rb %}

ここには具体的なメソッド定義はありません。代わりにメソッド定義を動的に生成する`define_method`が定義されています。概要だけ説明すると、Countryおよびそのサブクラスが`def__`ではじまるメソッド呼び出しを受けたとき、def__以下のwordに係るsetterとgetterメソッドを自動生成します。次のように使います。

{% highlight ruby %}
class Japan < Country
  %w(capital language population).each { |m| send "def__#{m}" }
end

Japan.capital = 'Tokyo'
Japan.language = 'Japanese'
Japan.population = 127433494

puts <<EOS
Japan
  Capital:    #{Japan.capital}
  Language:   #{Japan.language}
  Population: #{Japan.population}
EOS

# >> Japan
# >>   Capital:    Tokyo
# >>   Language:   Japanese
# >>   Population: 127433494
{% endhighlight %}

CountryのサブクラスJapanで、def__ではじまるcapital以下のメソッドを呼び出します。しかしそのようなメソッドはJapanクラスにもCountryクラスにもさらにはその親であるObjectクラスにも定義されていないので、これらの呼び出しは結局、Countryのmethod_missingメソッドを呼び出すことになります。そしてそこに書かれたコードが実行されて、動的に`capital`, `capital=`, `language`, `language=`, `population`, `population=`の各メソッドが定義されることになります。一応確認してみましょう。

{% highlight ruby %}
Japan.methods(false) # => [:capital=, :capital, :language=, :language, :population=, :population, :currency=, :currency]
{% endhighlight %}
いいですね。

クラス定義のやり方も説明せずに、いきなりメタプログラミングもないものです。ただRubyの強力さを伝えたかったのです。

<<<--- chapter07 --->>>

##７章　本の紹介
最後にRubyの本をいくつか紹介します。

上に書いてあることが概ね理解できるなら、最初に読むRubyの本としては{{ 4873113679 | amazon_link }}をお薦めします。

{{ 4873113679 | amazon_medium_image }}


200頁ほどの比較的短い書籍ですが内容は濃いです。Rubyの言語解説だけでなく、言語を取り巻く環境についての説明がある点がいいです。言語仕様の理解だけではわからない、Rubyの世界観を掴むには最適の一冊だと思います。また文章が正確で読みやすい、という点もいいです。欠点を挙げるとするならば1.9の新機能に説明が傾斜している点ですが、それも1.9のリリースマネージャが書いたということに鑑みれば仕方なく、また貴重な解説ということができます。

プログラミングの経験があまり無いのなら、{{ 4873114691 | amazon_link }}と{{ 4797357401 | amazon_link }}をお薦めします。

{{ 4873114691 | amazon_medium_image }}


{{ 4873114691 | amazon_link }}は200頁ほどのチュートリアル的書籍で、手を動かしながらRubyを学ぶといった内容になっています。従ってRubyの言語仕様全体を知るには不向きですが、米国人特有のウィットに富んだ説明が、Rubyでプログラムを書く楽しさとマッチしていて好印象です。第１版ではRubyの外界とのやり取り、つまりファイルやネットワークを扱うものがなく物足りなさもありましたが、第２版では少し補われているようです。英語に抵抗が無いのなら$16.50のebookがお得です。また第１版はネットで日本語訳が無料公開されています。

[Learn to Program](http://pragprog.com/book/ltp2/learn-to-program 'Learn to Program')

[プログラミング入門　- Rubyを使って -, by Chris Pine, 日本語ver. by S. Nishiyama](http://www.ie.u-ryukyu.ac.jp/~kono/software/s04/tutorial/ 'プログラミング入門　- Rubyを使って -, by Chris Pine, 日本語ver. by S. Nishiyama')

{{ 4797357401 | amazon_medium_image }}


{{ 4797357401 | amazon_link }}は500頁ほどの非常に丁寧で網羅的なRubyの言語解説本になっています。言語の持っている機能を一つづつ順番に潰していき、最後に比較的大きな例題をこなすオーソドックスなスタイルです。説明も信頼できるものであり、安心して読み進めることができると思います。

{{ 4274068099 | amazon_medium_image }}


{{ 4274068099 | amazon_link }}はRuby解説本のDe-Facto Standardです。このシリーズに目を通したことがないRubyistはいないんじゃないかと思うほど人気の高い本です。ライブラリ編と２分冊になっていますが、価格を考えると購入は言語編だけでいいかと思われます。英語に抵抗が無いのなら$25.00のebookをお薦めします(もちろんライブラリ解説込み)。

[Programming Ruby 1.9](http://pragprog.com/book/ruby3/programming-ruby-1-9 'Programming Ruby 1.9')

{{ 4873113946 | amazon_medium_image }}


さて次に紹介する本は{{ 4873113946 | amazon_link }}です。この本は{{ 4274068099 | amazon_link }}が持つDe-Facto Standardの座を射程に入れています。しかしこの本には注意が必要です。少なくとも最初に読むべきではありません。Rubyが本来持っている楽しさというものを奪い取って、あなたのRubyに対する興味を消失させる可能性を持っています。つまりこの本はRubyの解説本ではなく、硬派なRuby言語仕様詳細解説本です。本が生まれた経緯から著者にまつもと氏が名を連ねていますが、これは実質Flanaganの本です。一方でRubyのことをそれなりに知っていて（例えば{{ 4873113946 | amazon_link }}は既に読んでいて）、Rubyに対するより詳細で正確な知識がほしい、もっとトリビアを知りたい、といった人には最高の一冊になります。にやにやしながらこの本を読むことになります。第一印象はよくありませんでしたが今はこの本がかなり好きです。こういった書籍は他にはありません。

Rubyの詳細は知りたいけれども、もっと遊び心がある本が良いといった人には{{ 4798115339 | amazon_link }}をお薦めします。

{{ 4798115339 | amazon_medium_image }}


650頁の大著です。1.8と1.9を跨いで出版されたのが良くなかったのか、今ひとつ人気がありません。だけど個人的にはこの本が好きです。著者のHal FultonはきっとRubyが大好きなんだと思います。exampleが豊富で著者がそこに時間を掛けているのがよく分かります。

Rubyを使ったプロの仕事を知りたいなら、この一冊で間違いありません。

{{ 4873114454 | amazon_medium_image }}
{{ 4873114454 | amazon_link }}


実践コードをベースにテスト技法、API設計、メタプログラミング、プロジェクト管理など、実践における正にベストプラクティスを解説する一冊になっています。高度な内容を取り扱っているにも拘らず、説明が丁寧かつ平易でその難しさを感じさせない良書だと思います。original英語版は無料公開されています。

[Ruby Best Practices- Full Book Now Available For Free!](http://blog.rubybestpractices.com/posts/gregory/022-rbp-now-open.html 'Ruby Best Practices- Full Book Now Available For Free!')

最後に紹介するのはRubyのメタプログラミングだけを扱った{{ 4048687158 | amazon_link }}です。

{{ 4048687158 | amazon_medium_image }}


この本は国外の評価は分かりませんが日本では大変に人気があります。特に他言語プログラマーの評価が高いように感じます。Rubyistが普段使っている各テクニックに名前を付けた、つまり共通言語としてカタログ化したことの役割が大きいです。Railsをやるなら目を通す必要があるのでしょう。

<<<--- chapter08 --->>>

##最後に

さて以上で「これからRubyを始める人たちへ」向けた、Rubyの紹介を終わります。Rubyを好きになれそうですか？もしこの記事でRubyを始めることを決意し、次に参考になる書籍以外の(つまりFreeの)読み物が必要なら、次の記事を読んで頂けるとうれしいです。

> [秋だ!Rubyを学ぼう! ～Rubyを知るための２６ポスト](http://melborne.github.com/2011/11/14/Ruby-Ruby/ '秋だ!Rubyを学ぼう! ～Rubyを知るための２６ポスト')

<<<--- chapter09 --->>>

## 謝辞

本書は、ブログ「[hp12c](http://melborne.github.com/ 'hp12c')」における以下の記事の電子書籍版です。

> [これからRubyを始める人たちへ](http://melborne.github.com/2012/04/09/to-newbie/ 'これからRubyを始める人たちへ')

ブログにおける不適切な記述（!）およびメディア向けの調整を行って電子書籍化しました。EPUBデータの生成には、Rubyで作られた[melborne/maliq](https://github.com/melborne/maliq 'melborne/maliq')を使っています。`maliq`ではEPUB変換に関し小嶋智氏の[skoji/gepub](https://github.com/skoji/gepub 'skoji/gepub')を利用しています。この場を借りて御礼申し上げます。素晴らしいツールをありがとうございます。

## 著者について

**kyoendo(a.k.a melborne)**

Rubyを愛するブログ「[hp12c](http://melborne.github.com/ 'hp12c')」の管理者。東京在住。妻と二人暮らし。

> github: [melborne (kyoendo)](https://github.com/melborne 'melborne (kyoendo)')

> twitter: [kyoendo (merborne) on Twitter](https://twitter.com/merborne 'kyoendo (merborne) on Twitter')

## 表紙について

表紙の絵は[Wordle](http://www.wordle.net/ 'Wordle - Beautiful Word Clouds')というツールを使って、Rubyのクラス群をそのメソッド数に応じて重み付けしビジュアル化したものです。詳細については以下を参照下さい。

> [Rubyのクラスの太った人たち](http://melborne.github.com/2012/07/19/ruby-methods-visualization/ 'Rubyのクラスの太った人たち')

----

2012年12月1日　初版発行


