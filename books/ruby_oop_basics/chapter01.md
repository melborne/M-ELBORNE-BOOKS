---
language: 'ja'
unique_identifier:
 - 'http://melborne.github.com/'
 - 'BookID'
 - 'URL'
title: 'Rubyのオブジェクト指向をちゃんと理解する'
subtitle: ''
subject: 'programming, ruby, tutorial, 入門'
description: '本書は、ブログ「hp12c」( http://melborne.github.com/ )における「」の電子書籍版です。'
creator: 'kyoendo'
date: '2012-12-'
liquid: '../../template/plugins'
---



##オブジェクトの種類
Rubyはオブジェクト指向言語であり、Ruby空間に存在するオブジェクトをその操作対象とする。Ruby空間には3種類のオブジェクト、すなわちインスタンスオブジェクト、クラスオブジェクト、そしてモジュールオブジェクトが存在している。これらは通常単に、オブジェクト、クラス、モジュールと呼ばれているけど、ここではそれらのオブジェクトとしての側面を強調したいので、あえてその名称を使おう。

##クラスオブジェクト ～クラスとしての側面～
クラスオブジェクトは通常単にクラスと呼ばれ、主にRuby空間にインスタンスオブジェクトを生み出すために存在する。生み出されるインスタンスオブジェクトのデザインは、クラスオブジェクトに記述されており、しかもユーザがインスタンスオブジェクトにアクセスしてその機能を実現しようとするとき、インスタンスオブジェクトはクラスオブジェクトからその機能を借り出す。

Rubyにはその設計者により予め多数のクラスオブジェクトが用意されている。これらは組み込みクラスと呼ばれる。ユーザは組み込みクラスを自由に使うことができるけれど、class式を使って独自クラスを定義することもできる。
{% highlight ruby %}
  class Creature
    def initialize(name)
      @name = name
    end
  end
{% endhighlight %}
ユーザがclass式を使って既存クラスと同名のクラスオブジェクトを定義した場合、それは既存クラスの書き換えではなく拡張となる。その既存クラスが本来持っている機能は失われず、新たな機能がそこに付加される。
{% highlight ruby %}
  class String
    def speak(word)
     puts word
    end
  end
  my_name = "Charlie"
  my_name.speak('Hello') # => Hello
  my_name.length  # => 7
{% endhighlight %}

もっとも同名のメソッドを再定義すれば、それは基のメソッドの上書きになるので注意を要する。
{% highlight ruby %}
  class String
    def length
      "I don't wanna tell you."
    end
  end
  "Charlie".length  # => "I don't wanna tell you."
{% endhighlight %}

特定のクラスオブジェクトからインスタンスオブジェクトを生成するには、newメソッドを使う。
{% highlight ruby %}
  class Creature
    def initialize(name)
      @name = name
    end
  end
  # Creatureクラスのnewメソッドでオブジェクトを生成する
  my_pet = Creature.new('Doggie') 
{% endhighlight %}

ただ代表的な組み込みクラスではリテラル表記を使って、簡易にインスタンスオブジェクトを生成できる。
{% highlight ruby %}
  # 文字列オブジェクトの生成
  my_name = "Charlie"
  # 整数オブジェクトの生成
  my_age = 195
  # 配列オブジェクトの生成
  my_pets = [ 'Dog', 'Crocodile', 'Hippopotamus' ]
  # ハッシュオブジェクトの生成
  my_favorite = { :number => 3, :language => 'Ruby', :color => 'Blue' } 
  # 範囲オブジェクトの生成
  my_range = 9..21
  # 正規表現オブジェクトの生成
  my_regexp = /ruby/ 
{% endhighlight %}

オブジェクトの特性はそのクラスオブジェクトのメソッド定義でほぼ決まる。メソッドはdef式を使って定義できる。
{% highlight ruby %}
  class Creature
    def self.description
      "I'm a Creature Class for making creatures."
    end
    def initialize(name)
      @name = name
    end
    def name
      @name
    end
  end
{% endhighlight %}
クラスオブジェクトには、インスタンスオブジェクトのためのInstanceメソッドと、自身のためのselfメソッドとを定義できる。

selfメソッドはメソッド名の前にselfあるいはクラス名を冠することで、Instanceメソッドと区別される。クラスオブジェクトにおけるselfメソッドは、普通クラスメソッドと呼ばれている。
{% highlight ruby %}
  Creature.description
       # =>  "I'm a Creature Class for making creatures."
{% endhighlight %}

Instanceメソッドはこのクラスオブジェクトから派生するインスタンスオブジェクトの挙動を決定付ける。つまり、クラスオブジェクトからインスタンスオブジェクトが生成されたとき、Instanceメソッドがあたかも、インスタンスオブジェクト自身が持つメソッドのように振る舞う。
{% highlight ruby %}
  my_pet = Creature.new('Doggie')
  my_pet.name   # => "Doggie"
{% endhighlight %}

##クラスオブジェクト ～オブジェクトとしての側面～
確かにクラスオブジェクトはインスタンスオブジェクトを生成するための雛形的なものだ。だけれども、同時にクラスオブジェクトは、それ自身もRuby空間に存在するオブジェクトである。

インスタンスオブジェクトにクラスオブジェクトという母があるように、すべてのクラスオブジェクトにもClassクラスオブジェクトという母がある。

つまりすべてのクラスの雛形となっているのはClassクラスオブジェクトであり、クラスオブジェクトはすべてここから生成されている。classメソッドでこの事実を知ることができる。
{% highlight ruby %}
  Object.class           # => Class
  Array.class            # => Class
  Binding.class          # => Class
  Continuation.class     # => Class
  Data.class             # => Class
  Exception.class        # => Class
  Dir.class              # => Class
  File::Stat.class       # => Class
  Hash.class             # => Class
  IO.class               # => Class
  File.class             # => Class
  MatchData.class        # => Class
  Method.class           # => Class
  Module.class           # => Class
  Numeric.class          # => Class
  Proc.class             # => Class
  Process::Status.class  # => Class
  Range.class            # => Class
  Regexp.class           # => Class
  String.class           # => Class
  Struct.class           # => Class
  Symbol.class           # => Class
  Thread.class           # => Class
  ThreadGroup.class      # => Class
  Time.class             # => Class
  UnboundMethod.class    # => Class
  TrueClass.class        # => Class
  FalseClass.class       # => Class
  NilClass.class         # => Class
{% endhighlight %}

驚くべきことに、Classクラスオブジェクトの母もClassクラスオブジェクト自身である！
{% highlight ruby %}
  Class.class            # => Class
{% endhighlight %}
あなたが後から作るクラスオブジェクトも、その母はあなたではなくClassクラスオブジェクトである。
{% highlight ruby %}
  Creature.class # => Class
{% endhighlight %}
またある特定のクラスのサブクラスもその母はスーパークラスではなく、Classクラスオブジェクトである。
{% highlight ruby %}
  class Person < Creature  # CreatureクラスのサブクラスPersonを定義
  end
  Person.class # => Class
{% endhighlight %}
兎にも角にも、あらゆるクラスオブジェクトは、一つのクラスオブジェクトClassから生成されているのだ！

つまりRuby空間には、最初にClassクラスオブジェクトから生成されたClassクラスオブジェクトがあり、そのClassクラスオブジェクトが次いで他のすべてのクラスオブジェクトを生成し、最後にこの生成された各種のクラスオブジェクトからインスタンスオブジェクトが生成される、という構図が描かれる。

クラスオブジェクトからインスタンスオブジェクトを生成するときはnewメソッドを使うが、クラスオブジェクトの生成にはその必要はない。規定のクラスオブジェクトについてはおそらく初期化時に、ユーザ定義のクラスオブジェクトについてはclass定義式の解析時にRubyが自動で生成する。生成されたクラスオブジェクトにはそのクラス名を冠した定数が付けられ、これによりユーザによるクラスオブジェクトへのアクセスが可能になる。

このことを確認するために、恣意的にClassクラスオブジェクトのnewクラスメソッドを使ってクラスオブジェクトを生成してみよう。
{% highlight ruby %}
  puts Creature = Class.new(Creature)
        # =>warning: already initialized constant Creature
        # => Creature
{% endhighlight %}
これによりCreature定数には既にCreatureクラスオブジェクトがセットされていることが確認できる。なお上記によりCreatureクラスオブジェクトのサブクラスが生成され、それがCreature定数に再設定される。

既に書いたがクラスオブジェクトには自身のためのselfメソッド(クラスメソッド)を定義できる。クラスオブジェクトに対しクラスメソッドを直接呼び出すことによって、クラスオブジェクト自身にアクセスできる。クラスメソッドはそこから派生したインスタンスオブジェクト全体を管理するためなどに使うことができる。
{% highlight ruby %}
  class Creature
    @@counter = 0
    def initialize(name)
      @name = name
      @@counter += 1
    end
    def self.count
      "You have #{@@counter} creatures."
    end
  end
  dog = Creature.new('hot')
  alligator = Creature.new('thanks')
  hippopotamus = Creature.new('idiot')
  Creature.count  # => "You have 3 creatures."
{% endhighlight %}

##継承(Inheritance)
継承とはクラスオブジェクト間の相互依存関係のことである。Rubyではあるクラスオブジェクトが定義したメソッドを、あたかも自分に定義されたもののように他のクラスオブジェクトが利用できる。利用される側をスーパークラス、利用する側をサブクラスと呼ぶ。

他のクラスオブジェクトを利用してクラスを定義する場合、自分の名前にスーパークラス名を接ぎ木する。
{% highlight ruby %}
  class Person < Creature  # CreatureクラスのサブクラスPersonを定義
    def initialize(name,age)
      super(name)
      @age = age
    end
    def age
     @age
    end
  end
  me = Person.new('Charlie', 8)
  me.name   # => "Charlie"
  me.age      # => 8
{% endhighlight %}
こうすればサブクラスPersonのインスタンスであるmeオブジェクトでも、自ら定義することなくメソッドnameが使える。つまり、me.nameが実行されたとき、このメッセージは最初Personクラスオブジェクトに送られて、そこで対応するnameメソッドが存在しないことが分かると、次いでそのスーパークラスに渡され実行される(Moduleクラスオブジェクトの話はここでは割愛する)。

一般的に言えば、Rubyはメッセージに対応するメソッドが見つかるまでクラスツリーを遡り、最後にはObjectクラスオブジェクトに至る。

一つのクラスオブジェクトは同時並行的に複数のクラスオブジェクトと継承関係になれない。つまり複数のスーパークラスを同時に持てない。このような制限を、制限のない多重継承に対して単純継承という。

しかし他のクラスオブジェクトのサブクラスをスーパークラスにすることはできる。この数つまり経時直線的な段数に制限はない。
{% highlight ruby %}
  class PersonInEarth < Person
    def initialize(name, age, country)
      super(name, age)
      @country = country
    end
    def country
      @country
    end
  end
  a_friend = PersonInEarth.new('Fernando', 34, "Spain")
  a_friend.name    # >> "Fernando"
  a_friend.country # >> "Spain"
{% endhighlight %}

誰がスーパークラスかはsuperclassメソッドで調べられる。
{% highlight ruby %}
  PersonInEarh.superclass # >> Person
{% endhighlight %}

Rubyでは継承関係にない独立したクラスオブジェクトというのは作れない。クラス定義においてスーパークラスを指定しないとき、Rubyは勝手にObjectクラスオブジェクトをそのスーパークラスにセットする。つまりすべてのクラスオブジェクトはObjectクラスオブジェクトのサブクラスである。組み込みクラスも例外ではない。

何も定義しないクラスでmethodsメソッドを呼べば、それが既にObjectクラスオブジェクトのサブクラスになっていることが確認できる(このメソッドを呼べること自体が証拠ですが)。
{% highlight ruby %}
  class Nothing
  
  end
  n = Nothing.new
  p n.methods 
  # >> ["inspect", "tap", "clone", "public_methods", "object_id",  "__send__", "instance_variable_defined?", "equal?", "freeze",  "extend", "send", "methods", "hash", "dup", "to_enum",  "instance_variables", "eql?", "instance_eval", "id",  "singleton_methods", "taint", "frozen?", "instance_variable_get",  "enum_for", "instance_of?", "display", "to_a", "method", "type",  "instance_exec", "protected_methods", "==", "===",  "instance_variable_set", "kind_of?", "respond_to?", "to_s",  "class", "__id__", "tainted?", "=~", "private_methods",  "untaint", "nil?", "is_a?"]
{% endhighlight %}
NothingクラスオブジェクトはObjectクラスオブジェクトが持っているすべてのメソッドを継承する。

継承はクラスオブジェクト間の師弟制度のようなものである。とりわけ、Rubyの継承は一子相伝、一人がそのすべてを引き継ぐという特徴を有する。この特徴のため、継承関係が成熟しクラス階層が限りなきものになったとしても、Rubyは迷うことなくその末端から頂点、つまりObjectクラスオブジェクトまでを遡ることができる。

基本的にサブクラスはスーパークラスの特性をすべて引き継ぐが、サブクラスにおいてその一部を拒否したり再定義することは許される。
{% highlight ruby %}
  class PersonInEarth < Person
    undef :age  # ageメソッドを未定義にする
    alias :name_old :name  #nameメソッドをname_oldに変える
    def initialize(name,age,country)
      super(name,age)
      @country = country
    end
    def country
      @country
    end
    def name   # nameメソッドを再定義する
      "my name is #{name_old}."
    end
  end
  a_friend = PersonInEarth.new('Fernand', 34, "Spain")
  p a_friend.name　# >> "my name is Fernand."
  p a_friend.age
  # ~> -:39: undefined method `age' for #<PersonInEarth:0x23550> (NoMethodError)
{% endhighlight %}

##モジュールオブジェクト
単純継承はメソッド探索の複雑さを排除する。一方で継承の本来的意義を低下させうる。仮に異なる系譜の継承クラス群があり、その両方の系譜の特性を持ったクラスオブジェクトを生成したい場合、単純継承ではそれを一方の系譜のサブクラスとし、そこに他方の系譜の特性すべてを一から書き足す必要が生じる。これは継承の目的に反し極めて非生産的だ。

Rubyではモジュールオブジェクトがこの問題を最小化する。モジュールオブジェクトは通常単にモジュールと呼ばれる。

モジュールオブジェクトは、継承関係に立つことができない独立したクラスオブジェクトである。そこからインスタンスオブジェクトを生成することもできない。モジュールオブジェクトはその中に特定の機能のまとまりを持って、クラスオブジェクトにMix-inつまり挿し木される。モジュールオブジェクトをMix-inしたクラスオブジェクトは追加的にその機能を獲得することになる。
{% highlight ruby %}
  module Behavior
    def self.description  # モジュールメソッドの定義
      "I'm a Behavior Module."
    end
    def sleep  # Instanceメソッドの定義
      "I'm sleeping."
    end
    def eat
      "I'm eating."
    end
  end
  class PersonInEarth < Person
    include Behavior  # Behaviorモジュールを読み込む
    def initialize(name,age,country)
      super(name,age)
      @country = country
    end
    def country
      @country
    end
  end
  a_friend = PersonInEarth.new('Fernand', 34, "Spain")
  a_friend.eat  # >> "I'm eating."
  a_friend.sleep  # >> "I'm sleeping."
  Behavior.description  # >> "I'm a Behavior Module."
{% endhighlight %}
モジュールの定義はmodule式で行う。クラスオブジェクトと同様モジュールオブジェクトには、インスタンスオブジェクトのためのInstanceメソッドと、自身のためのselfメソッドとを定義できる。モジュールのselfメソッドは一般にモジュールメソッドと称される。

クラスオブジェクトにモジュールオブジェクトをMix-inするにはincludeメソッドを使う。これによりあたかも、モジュールオブジェクトで定義したメソッドがクラスオブジェクトにあるかのように働く。よって、クラスオブジェクトから生成されたインスタンスオブジェクトは、それらのInstanceメソッドを自由に使える。

もっとも、モジュールのselfメソッドがMix-in先クラスのselfメソッドとして働くことはない。つまりモジュールメソッドはクラスメソッドにはならない。この点が継承の場合とは異なっている。

モジュールオブジェクトのMix-inによって継承におけるメソッド探索のルートが変わる。モジュールオブジェクトをMix-inしたクラスオブジェクト内が探索されると、そのスーパークラスに先立ってモジュールオブジェクト内が探索される。多重継承におけるようなあいまいさはない。ancestorsメソッドでその順位を確認できる。
{% highlight ruby %}
  PersonInEarth.ancestors 
   #  >> [PersonInEarth, Behavior, Person, Creature, Object, Kernel, BasicObject]
{% endhighlight %}

インスタンスオブジェクトにとって、その母がクラスオブジェクトであるならば、モジュールオブジェクトは、彼のベビーシッターのような存在だ。母に代わって子をヘルプする。ベビーシッターがそうであるように、モジュールオブジェクトは、複数のクラスオブジェクトにおいて掛け持ちされうる。

この点に鑑みればモジュールオブジェクトに、特定のインスタンスオブジェクトの属性情報を保持させる、つまりインスタンス変数を持たせることは危険だということが分かる。

なお、モジュールオブジェクトは継承関係には立てないが、モジュールオブジェクトに他のモジュールオブジェクトをMix-inすることはできる。しかし最終的にモジュールオブジェクトはクラスオブジェクトにMix-inされ、その継承関係に割り込まなければ機能しない(ただモジュールメソッドは直接呼ぶことができる)。

##インスタンスオブジェクト
インスタンスオブジェクトは普通単にオブジェクトあるいはインスタンスと呼ばれ、先に書いたようにクラスオブジェクトをnewすることでRuby空間に生み出される。

Ruby空間では、各種のクラスオブジェクトから生み出された多数のインスタンスオブジェクトが、順次・分岐・繰り返しの制御構造の中で相互に働き掛けあうことによって、ユーザの所望する意味のある結果が返される。

Rubyではインスタンスオブジェクトが主役である。

ところがその存在の重みとは裏腹に、インスタンスオブジェクトの中身はほとんど空である。基本的にインスタンスオブジェクトは自分の属性情報のみを保持する。他のオブジェクトとの相互作用のためのメソッド群を基本的に保持しない。つまりインスタンスオブジェクトは、自分が何者で誰が親なのかということは知っているけれども、ユーザから送られてくるメッセージの処理方法を知らない。

一方インスタンスオブジェクトへのアクセスはそれにメッセージを送ることで達成される。より正確には、メッセージを送る以外にインスタンスオブジェクトにアクセスする手段はない。

結局、メッセージを受け取ったインスタンスオブジェクトは、それを自分の生成元のクラスオブジェクトに投げ、彼女がインスタンスオブジェクトに代わって答えを用意する。そのクラスオブジェクト自身が対応するメソッドを備えていない場合、先に書いたように、モジュールオブジェクトを含むクラスツリーを辿ってメソッドが探索される。
{% highlight ruby %}
  # a_friendでラベル付けされたオブジェクトにメッセージnameを送る
  a_friend.name
{% endhighlight %}

この例でa_friendでラベル付けされたインスタンスオブジェクトは、メッセージnameを受け取るとこれをその生成元であるPersonInEarthクラスオブジェクトへ送る(後で述べるSingletonメソッドがある場合はまずそれを探索する)。PersonInEarthでは対応するnameメソッドを呼び出すために、まず自分自身がそれを持っているかが調べられる。次いで、そこにincludeしたBehaviorモジュールオブジェクト内が探索される。PersonInEarthおよびBehaviorモジュールはnameメソッドを持っていないので、メッセージは今度はそのスーパークラスであるPersonに渡される。

ところがPersonクラスオブジェクトもnameメソッドを備えていないので、メッセージは更にそのスーパークラスであるCreatureクラスに渡される。そしてここに定義されたnameメソッドが実行され、その結果が順次逆のルートを辿って、a_friendでラベル付けされたインスタンスオブジェクトからユーザに返される。

##Singletonメソッド(抽象メソッド)
インスタンスオブジェクトの中身はほとんど空であるということを書いた。しかしインスタンスオブジェクトはクラスオブジェクトやモジュールオブジェクトと同様に、その内部にselfメソッドを持つことができる。インスタンスオブジェクトにおけるselfメソッドは、Singletonメソッドまたは抽象メソッドと呼ばれる。

Singletonメソッドは、そのインスタンスオブジェクト固有のメソッドを定義するために使われる。
{% highlight ruby %}
  a_friend = PersonInEarth.new('Fernand', 34, "Spain")
  def a_friend.name
    "My friend, #{@name}"
  end
  p a_friend.name   # >> "My friend, Fernand"
{% endhighlight %}
メソッド定義におけるメソッド名の前にインスタンスオブジェクトを置くことによって、そのインスタンスオブジェクトのSingletonメソッドが定義される。Singletonメソッドはクラスツリーの最下層に位置し、メソッド探索において最優先の探索先となる。

正確に記せばSingletonメソッドは、そのインスタンスオブジェクト自身に定義されているのではなく、そのインスタンスオブジェクトとそのクラスオブジェクトとの間に生成される、無名のクラスに定義される。だからこの無名クラスにSingletonメソッドを定義しても同様の結果が得られる。
{% highlight ruby %}
  class << a_friend
    def name
      "My friend, #{@name}"
    end
  end
  p a_friend.name  # >> "My friend, Fernand"
{% endhighlight %}
class名を無名とし、インスタンスオブジェクト名を二重の接ぎ木記号で繋ぐ(感情的には接ぎ木の向きは逆ですが)。複数のSingletonメソッドをまとめて定義する場合、この書式が有用だ。この無名クラスはSingletonクラスとも呼ばれる。

Singletonクラスはクラスメソッドやモジュールメソッドを定義する場合にも使える。

##extend
なおSingletonクラスはクラスに他ならないので、当然そこにモジュールオブジェクトをMix-inできる。
{% highlight ruby %}
  module Business
    def job
      "Programmer"
    end
  end
  class << a_friend
    include Business
  end
  p a_friend.job  # >> "Programmer"
{% endhighlight %}
SingletonクラスにMix-inされた
モジュールBusinessのメソッドjobは、インスタンスオブジェクトa_friendのSingletonメソッドになる。

でもRubyではもっと簡単に、モジュールメソッドをSingletonメソッドとしてMix-inする方法がある。それがextendだ。

SingletonメソッドがSingletonクラスのメソッドを直接インスタンスオブジェクトに追加できるようにするのと同様、extendはモジュールのメソッドを直接インスタンスオブジェクトに追加できるようにする。
{% highlight ruby %}
  a_friend.extend Business
  p a_friend.job  # >> "Programmer"
{% endhighlight %}
これによりモジュール内メソッドは特定のインスタンスオブジェクトの機能になる。

##まとめ
最後にクラス、モジュールおよびオブジェクトの特性を整理しておこう。

1. すべてのクラスオブジェクトは、Classクラスオブジェクトから生成される。
1. クラスオブジェクトは、インスタンスオブジェクトの雛形となり、それを生み出す母のような存在である。
1. それと共にそれ自身もオブジェクトである。
1. クラスオブジェクトは、インスタンスオブジェクトのためのInstanceメソッドと自身のためのクラスメソッドを持てる。
1. クラスオブジェクトは、継承によって他のクラスオブジェクトのメソッドを利用できる。
1. すべてのクラスオブジェクトは継承に係わっていて、その頂点にはObjectクラスオブジェクトがいる。
1. Rubyの継承は、スーパークラスを唯一つしか持たない単純継承である。
1. しかし継承の経時直線的な段数には制限はない。
1. モジュールオブジェクトは、クラスオブジェクトに代わってインスタンスオブジェクトを支援する、ベビーシッターのような存在である。
1. モジュールオブジェクトは継承関係に係われず、インスタンスオブジェクトを生成することもできない。
1. モジュールオブジェクト自身もオブジェクトであり、Instanceメソッドの他に自身のためのモジュールメソッドを持てる。
1. インスタンスオブジェクトは、クラスオブジェクトから生成される。
1. インスタンスオブジェクトがRuby空間における主役である。
1. インスタンスオブジェクトには、メッセージ送信以外にアクセス方法がない。
1. インスタンスオブジェクトに送られたメッセージは、クラスツリーに従って順次クラスオブジェクトに渡される。
1. インスタンスオブジェクト自身も固有のメソッドを持てる。

関連記事：

[Rubyのシンボルは文字列の皮を被った整数だ！]({{ site.url }}/2008/08/02/Ruby/)

[Rubyのブロックはメソッドに対するメソッドのMix-inだ！]({{ site.url }}/2008/08/09/Ruby-Mix-in/)

[Rubyのyieldは羊の皮を被ったevalだ！]({{ site.url }}/2008/08/12/Ruby-yield-eval/)


(追記:2008/8/17) メソッド探索の順位について誤りがあったので訂正しました
(追記:2008/8/27) extendの項目を追加しました
