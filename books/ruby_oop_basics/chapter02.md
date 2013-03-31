##付録１　RubyのObjectクラスは過去を再定義するタイムマシンだ！

Objectクラスはすべてのクラスのスーパークラスです。よってObjectクラスに定義されたインスタンスメソッドoは、すべてのクラスで定義されたインスタンスメソッドoになります。
{% highlight ruby %}
class Object
  def o
    'o'
  end
end

class MyClass

end

Object.new.o # => "o"
Array.new.o # => "o"
Hash.new.o # => "o"
MyClass.new.o # => "o"
{% endhighlight %}
ClassクラスもObjectクラスのサブクラスなので、このインスタンスメソッドoは当然、Classクラスのインスタンスメソッドoにもなります。
{% highlight ruby %}
Class.new.o # => "o"
{% endhighlight %}

一方、Classクラスはすべてのクラスの生成クラスです。よってClassクラスのインスタンスメソッドとなったoは、すべてのクラスのクラスメソッドself.oになります。
{% highlight ruby %}
Array.o # => "o"
Hash.o # => "o"
MyClass.o # => "o"
{% endhighlight %}
この中には当然Objectクラスが含まれているので、Classクラスのインスタンスメソッドoは、Objectクラスのクラスメソッドself.oにもなります。
{% highlight ruby %}
Object.o # => "o"
{% endhighlight %}

ところが、ObjectクラスはClassクラスのスーパークラスなので、Objectクラスのクラスメソッドになったself.oはClassクラスのクラスメソッドself.oにもなります。
{% highlight ruby %}
Class.o # => "o"
{% endhighlight %}

整理しましょう。

Objectクラスが１つのインスタンスメソッドoを持つと、それがClassクラスを含むすべてのクラスのインスタンスメソッドoとなり、Objectを含むすべてのクラスのクラスメソッドself.oとなり、Classクラスのクラスメソッドself.oとなります。こうしてRuby実行空間に存在するすべてのクラスには、インスタンスメソッドoとクラスメソッドself.oが生まれることとなるのです。

ClassクラスはObjectクラスを含むすべてのクラスの母です。従って、すべてのクラスはClassクラスの特性に依存します。一方でClassクラスはその子であるObjectクラスの弟子（サブクラス）です。従って、ClassクラスはObjectクラスの特性を受け継ぎます。

このような多層的循環構造によってObjectクラスが変わると、Classクラスが変わり、その変化はすべてのクラスを変えるのです。つまりObjectクラスへのオペレーションは、過去の事実（Classクラス）を再定義し、延いては今の世界（すべてのクラス）を再構築するのです！

そうRubyのObjectクラスは...

「時空を超えて過去を再定義し、世界を再構築するタイムマシン」なのです！

ところでObjectクラスにはKernelモジュールがincludeされています。モジュールに定義されたインスタンスメソッドはそれをincludeしたクラスのものになるので、KernelモジュールのインスタンスメソッドはObjectクラスのものになります。

つまりKernelモジュールはObjectクラスに過去を変えるためのメソッドを補給します。Kernelモジュールから補給されたメソッドは、Objectクラスに定義されたメソッドとして同様に、過去を再定義し今の世界を再構築します。

そうRubyのKernelモジュールは...

「タイムマシン補助燃料タンク」だったのです！

