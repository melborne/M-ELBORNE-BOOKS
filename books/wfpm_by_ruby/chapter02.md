##３章　関数の貼り合せ ─ツリーにおける張り合せ ─

貼り合せの能力はリスト上の関数にとどまりません。ラベル付き順序ツリーの例でこれを示しましょう。

Rubyにはリストに都合の良いArrayクラスが組込みでありましたが、ツリーに都合の良いものはないので自分でクラスを定義する必要があります。ツリーはラベルを持ったノードを連結したものとして表現できるので、この連結の機能をもったNodeクラスを定義することでツリーを表現します。
{% highlight ruby %}
class Node
  attr_reader :label, :subtrees

  def initialize(label, *subtrees)
    @label = label
    @subtrees = subtrees
  end
end

def node
  ->label,*subtrees{ Node.new(label, *subtrees) }
end
{% endhighlight %}

ノードオブジェクトは**label**とサブノードのリスト**subtrees**をもつことができます。ここではノードオブジェクトを関数言語風に生成するために、**node関数**(Objectクラスのメソッド)を用意しています。

例えば、
{% highlight bash %}
           1 o
            ／ ＼
          ／     ＼
        ／         ＼
     2 o             o 3
                     |
                     |
                     |
                     o  4
{% endhighlight %}

というツリーはこのNodeクラスを使って以下のように表現できます。

{% highlight ruby %}
tree = node[1, 
            node[2],
            node[3, node[4]]
            ]

# >> #<Node:0x0a431c @label=1, @subtrees=[#<Node:0x0a4420 @label=2, @subtrees=[]>, #<Node:0x0a4358 @label=3, @subtrees=[#<Node:0x0a4394 @label=4, @subtrees=[]>]>]>
{% endhighlight %}

つまりノード１は２つのノード２，３をサブノードとしてもち、ノード３はノード４をサブノードとしてもっていることが表現されています。nodeの第２引数は省略でき、この場合subtreesの値は\[ \]になります。

さてここで、リストで用意したreduceメソッドと同じ目的をツリーで果たす**red_tree**メソッドを定義してみます。

リストのところの説明でreduceがリストを生成するconsとの比較で、consと\[ \]をfとaに置き換えたものとみなせると言いました。同じ発想でツリーがリストを含むノードで生成される、つまりnodeとconsと\[ \]で生成できることから、red_treeはこれらをfとgとaに置き換えたものとみなせます。

ここでツリーとリストは別のクラスなので、それぞれのクラスの上にred_treeを定義する必要があります。
{% highlight ruby %}
class Node
  def red_tree(f, g, a)
    f[label, subtrees.red_tree(f, g, a)]
  end
end

class Array
  def red_tree(f, g, a)
    return a if empty?
    g[head.red_tree(f, g, a), tail.red_tree(f, g, a)]
  end
end
{% endhighlight %}

ここで最初の引数である関数fはノードオブジェクトの要素に適用され、第２の引数である関数gはリストの要素に適用されます。red_treeと他の関数を貼り合せることで興味深い関数がいくつも定義できるようになります。

次の段階に進む前に、Arrayクラスに定義した有用なメソッド群をNodeクラスにも定義します。ここではNodeクラスに同じものを用意するのではなく、Arrayクラスのそれらのメソッドをモジュールに抽出してNodeクラスでも使えるようにしてみます。
{% highlight ruby %}
module Functional
  def cons
    ->x,ls=self{ [x] + ls }
  end

  def append
    ->se=self,ls{ se.reduce cons, ls }
  end

  def add
    ->x,y{ x + y }
  end

  def double
    ->num{ 2 * num }
  end
  
  def compose(f,g)
    ->x,y{ f[g[x],y] }
  end
end

class Array
  include Functional
end

class Node
  include Functional
end
{% endhighlight %}
ここでappendは他の補助メソッドと同様に２つの引数を取るようにし、かつ[]メソッドで実行されるようProcオブジェクト化しています。

準備ができたので、まずツリーのラベルの数値をすべて足す**sum_tree**を定義します。
{% highlight ruby %}
class Node
  def sum_tree
    red_tree add, add, 0
  end
end

tree = node[1,
            node[2],
            node[3, node[4]]
           ]
tree.sum_tree # => 10
{% endhighlight %}


ツリーのlabel全体のリストは以下のように定義できます。
{% highlight ruby %}
class Node
  def labels
    red_tree cons, append, []
  end
end

tree.labels # => [1, 2, 3, 4]
{% endhighlight %}

最後にリストのmapと類似したメソッドつまり関数fをツリーのすべてのラベルに適用するメソッド**map_tree**を定義します。

{% highlight ruby %}
class Node
  def map_tree(f)
    red_tree compose(node, f), cons, []
  end
end
{% endhighlight %}

map_treeを使えば、たとえばラベルの数値を倍にするメソッドを定義できます。
{% highlight ruby %}
class Node
  def double_all
    map_tree double
  end
end

tree.double_all.labels # => [2, 4, 6, 8]
{% endhighlight %}



