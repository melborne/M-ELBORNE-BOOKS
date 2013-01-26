---
layout: post
title: RubyのModuleクラスはすべてのモジュールの母であり同時にすべてのクラスの父である！
date: 2008-09-30
comments: true
categories:
---

Moduleクラスはすべてのモジュールの生成クラスである。だからModuleクラスに定義されたinstanceメソッドmは、すべてのモジュールで定義されたモジュールメソッドself.mになる。
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
またModuleクラスはClassクラスのスーパークラスでもある。だからModuleクラスに定義されたinstanceメソッドmは、Classクラスで定義されたinstanceメソッドmになる。
{% highlight ruby %}
  Class.new.m # => "m"
{% endhighlight %}
ここで、Classクラスはすべてのクラスの生成クラスである。だからClassクラスのinstanceメソッドとなったmは、すべてのクラスのクラスメソッドself.mになる。
{% highlight ruby %}
  Object.m # => "m"
  Array.m # => "m"
  class MyClass
  end
  MyClass.m # => "m"
{% endhighlight %}
この中には当然Moduleクラスも含まれているから、Classクラスのinstanceメソッドmは、Moduleクラスのクラスメソッドself.mにもなる。
{% highlight ruby %}
  Module.m # => "m"
{% endhighlight %}
ところが、ModuleクラスはClassクラスのスーパークラスだから、Moduleクラスのクラスメソッドになったself.mは、Classクラスのクラスメソッドself.mにもなる。
{% highlight ruby %}
  Class.m # => "m"
{% endhighlight %}

整理しよう。

Moduleクラスが１つのinstanceメソッドmを持つと、それがすべてのモジュールのモジュールメソッドself.mとなり、Classクラスのinstanceメソッドmとなり、ModuleクラスおよびClassクラスを含む、すべてのクラスのクラスメソッドself.mとなる。

Moduleクラスはモジュールの生成クラスである。だから、Classクラスがすべてのクラスを生み出すように、Moduleクラスはすべてのモジュールを生み出す。そして生み出されたすべてのモジュールは、Moduleクラスの特性に依存する。

そう、Classクラスがすべてのクラスの母であるなら…

Moduleクラスはすべてのモジュールの母だ！

加えてModuleクラスはClassクラスのスーパークラスである。だからModuleクラスに定義されたすべてのメソッドはClassクラスで使える。すべてのクラスはその生成クラスであるClassクラスの影響を受けるので、結果すべてのクラスはModuleクラスの影響を受けることになる。つまり、ModuleクラスはClassクラスによるクラス生成において、それを支援する極めて重要な役割を担っている。

要するにModuleクラスは、すべてのクラスの母であるClassクラスを支える…

すべてのクラスの父なんだ！

そうModuleクラスは、一方で各モジュールの母として彼らを生み出し、他方で各クラスの父としてClassクラスを支えるという、父と母の２つの顔を持った実体だったんだ！


関連記事：[RubyのObjectクラスは過去を再定義するタイムマシンだ！]({{ site.url }}/2008/09/27/Ruby-Object/)

<<<------>>>

## 謝辞

本書は、ブログ「[hp12c](http://melborne.github.com/ 'hp12c')」における以下の記事の電子書籍版です。

> 

[Rubyのクラスはオブジェクトの母、モジュールはベビーシッター](http://melborne.github.com/2008/08/16/Ruby/ 'Rubyのクラスはオブジェクトの母、モジュールはベビーシッター')
[RubyのObjectクラスは過去を再定義するタイムマシンだ！](http://melborne.github.com/2008/09/27/Ruby-Object/ 'RubyのObjectクラスは過去を再定義するタイムマシンだ！')
[RubyのModuleクラスはすべてのモジュールの母であり同時にすべてのクラスの父である！](http://melborne.github.com/2008/09/30/Ruby-Module/ 'RubyのModuleクラスはすべてのモジュールの母であり同時にすべてのクラスの父である！')



ブログにおける誤記の修正およびメディア向けの調整を行って電子書籍化しました。EPUBデータの生成には、Rubyで作られた[melborne/maliq](https://github.com/melborne/maliq 'melborne/maliq')を使っています。

## 著者について

**kyoendo(a.k.a melborne)**

Rubyを愛するブログ「[hp12c](http://melborne.github.com/ 'hp12c')」の管理者。東京在住。妻と二人暮らし。

> github: [melborne (kyoendo)](https://github.com/melborne 'melborne (kyoendo)')

> twitter: [kyoendo (merborne) on Twitter](https://twitter.com/merborne 'kyoendo (merborne) on Twitter')

## 表紙について

----

2012年12月日　初版発行

