##付録２　RubyのModuleクラスはすべてのモジュールの母であり同時にすべてのクラスの父である！

Moduleクラスはすべてのモジュールの生成クラスです。よってModuleクラスに定義されたインスタンスメソッドmは、すべてのモジュールで定義されたモジュールメソッドself.mになります。
{% highlight ruby %}
class Module
  def m
    'm'
  end
end

Module.new.m # => "m"
Kernel.m # => "m"
Enumerable.m # => "m"
Math.m # => "m"
{% endhighlight %}
またModuleクラスはClassクラスのスーパークラスでもあります。よってModuleクラスに定義されたインスタンスメソッドmは、Classクラスで定義されたインスタンスメソッドmになります。
{% highlight ruby %}
Class.new.m # => "m"
{% endhighlight %}
ここで、Classクラスはすべてのクラスの生成クラスです。よってClassクラスのインスタンスメソッドとなったmは、すべてのクラスのクラスメソッドself.mになります。
{% highlight ruby %}
Object.m # => "m"
Array.m # => "m"
class MyClass
end
MyClass.m # => "m"
{% endhighlight %}
この中には当然Moduleクラスも含まれているので、Classクラスのインスタンスメソッドmは、Moduleクラスのクラスメソッドself.mにもなります。
{% highlight ruby %}
Module.m # => "m"
{% endhighlight %}
ところが、ModuleクラスはClassクラスのスーパークラスなので、Moduleクラスのクラスメソッドになったself.mは、Classクラスのクラスメソッドself.mにもなります。
{% highlight ruby %}
Class.m # => "m"
{% endhighlight %}

整理しましょう。

Moduleクラスが１つのインスタンスメソッドmを持つと、それがすべてのモジュールのモジュールメソッドself.mとなり、Classクラスのインスタンスメソッドmとなり、ModuleクラスおよびClassクラスを含む、すべてのクラスのクラスメソッドself.mとなります。

Moduleクラスはモジュールの生成クラスです。よって、Classクラスがすべてのクラスを生み出すように、Moduleクラスはすべてのモジュールを生み出します。そして生み出されたすべてのモジュールは、Moduleクラスの特性に依存します。

そう、Classクラスがすべてのクラスの母であるなら...

「Moduleクラスはすべてのモジュールの母」なのです！

加えて、ModuleクラスはClassクラスのスーパークラスでもあります。そのためModuleクラスに定義されたすべてのメソッドはClassクラスで使えます。すべてのクラスはその生成クラスであるClassクラスの影響を受けるので、結果すべてのクラスはModuleクラスの影響を受けることになります。つまり、ModuleクラスはClassクラスによるクラス生成において、それを支援する極めて重要な役割を担っているのです。

要するにModuleクラスは、すべてのクラスの母であるClassクラスを支える...

「すべてのクラスの父」なのです！

そうModuleクラスは、一方で各モジュールの母として彼らを生み出し、他方で各クラスの父としてClassクラスを支えるという、父と母の２つの顔を持った実体だったのです！


<<<------>>>

## 謝辞

本書は、ブログ「[hp12c](http://melborne.github.com/ 'hp12c')」における以下の記事の電子書籍版です。

> [オブジェクトの理解から始めるRuby](http://melborne.github.com/2013/02/07/understand-ruby-object/ 'オブジェクトの理解から始めるRuby')


メディア向けの調整を行って電子書籍化しました。EPUBデータの生成には、Rubyで作られた[melborne/maliq](https://github.com/melborne/maliq 'melborne/maliq')を使っています。

## 著者について

**kyoendo(a.k.a melborne)**

Rubyを愛するブログ「[hp12c](http://melborne.github.com/ 'hp12c')」の管理者。東京在住。妻と二人暮らし。

> github: [melborne (kyoendo)](https://github.com/melborne 'melborne (kyoendo)')

> twitter: [kyoendo (merborne) on Twitter](https://twitter.com/merborne 'kyoendo (merborne) on Twitter')

----

2013年2月7日　初版発行

