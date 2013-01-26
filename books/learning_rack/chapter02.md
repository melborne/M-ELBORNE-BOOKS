#２章　Rack Middlewareの魔法


噂によるとRackにはMiddlewareなる魔法があるそうです。そしてRack古文書にはMiddlewareについて次のようにあります。

> `use`の呪文を唱えよ。さすれば扉は開かれん

{% csssig h2 id='pre' %}
## 準備
{% endcsssig %}

前回作った、なんちゃってWebフレームワーク「draque」を継続して使います。`config.ru`が少し長くなったので、Webアプリの本体を別ファイル`draque.rb`に移します。

{% highlight ruby %}
#draque.rb
module Draque
  @@routes = { get:{} }

  def draque(env)
    path = env['PATH_INFO']
    if res = @@routes[:get][path]
      res.call(env)
    else
      [ 404, headers, not_found ]
    end
  end

  def get(path, &blk)
    @@routes[:get][path] = blk
  end
end

Object.send(:include, Draque)

get '/draque' do
  [ 200, headers, draque_body ]
end

get '/' do |env|
  [ 200, headers, top_body(env) ]
end

def headers
  {'Content-Type' => 'text/html'}
end

def top_body(env)
  ["<h1>Welcome to the World of Draque!!</h1>"] +
  env.map { |k,v| "<p>%s => %s</p>" % [k, v] }
end

def draque_body
  ["<img src='http://farm1.staticflickr.com/1/79151_ed9b9d37a9.jpg'>"]
end

def not_found
  ["<img src='https://a248.e.akamai.net/assets.github.com/images/modules/404/parallax_errortext.png?1329921026'>"]
end
{% endhighlight %}

`config.ru`は次のようになります。

{% highlight ruby %}
# config.ru
require "./draque"

run method(:draque)
{% endhighlight %}

{% csssig h2 id='use' %}
## useの呪文
{% endcsssig %}

さて早速、`use`の呪文を試してみます。`config.ru`にuseを追加します。

{% highlight ruby %}
# config.ru
require "./draque"

use

run method(:draque)
{% endhighlight %}

`rackup`します。
{% highlight bash %}
% rackup
~/.rbenv/.../rack/builder.rb:77:in `use': wrong number of arguments (0 for 1) (ArgumentError)
        from config.ru:4:in `block in <main>'
{% endhighlight %}

引数が足りないと言われました。おそらくmiddlewareを渡すものと思われます。しかしmiddlewareが何なのかわからないので、例によってまずは`1`を渡してrackupしてみます。

{% highlight ruby %}
# config.ru
require "./draque"

use 1

run method(:draque)
{% endhighlight %}

どうでしょうか。

{% highlight bash %}
% rackup
~/.rbenv/.../rack/builder.rb:82:in `block in use': undefined method `new' for 1:Fixnum (NoMethodError)
{% endhighlight %}

1にはnewメソッドが無いと言われました。これでクラスが期待されている、つまり**middlewareはクラスである**ということが分かりました（#newが定義されていれば、もしかしたらクラスでなくてもいいのかもしれません）。それでは、差し当たりUpDownというクラスを作って渡してみます。

{% highlight ruby %}
# config.ru
require "./draque"

class UpDown
  
end

use UpDown

run method(:draque)
{% endhighlight %}

どうでしょうか。

{% highlight bash %}
% rackup
~/.rbenv/.../rack/builder.rb:82:in `initialize': wrong number of arguments(1 for 0) (ArgumentError)
{% endhighlight %}

今度はinitializeの引数が足りないと言われました。では１引数のinitializeを定義します。

{% highlight ruby %}
# config.ru
require "./draque"

class UpDown
  def initialize(arg)
    
  end
end

use UpDown

run method(:draque)
{% endhighlight %}

どうでしょうか。
{% highlight bash %}
% rackup
>> Thin web server (v1.3.1 codename Triple Espresso)
>> Maximum connections set to 1024
>> Listening on 0.0.0.0:9292, CTRL+C to stop
{% endhighlight %}

ポート9292でThin Webサーバが立ち上がりました。

Browserでhttp://localhost:9292 にアクセスしてみます。
{% highlight bash %}
>> Listening on 0.0.0.0:9292, CTRL+C to stop
NoMethodError: undefined method `call' for #<UpDown:0x00000101053fc8>
{% endhighlight %}


UpDownオブジェクトに`call`メソッドがないと言われました。では、UpDown#callを定義してみます。

{% highlight ruby %}
# config.ru
require "./draque"

class UpDown
  def initialize(arg)
    
  end

  def call
    
  end
end

use UpDown

run method(:draque)
{% endhighlight %}


今度はどうでしょう。
{% highlight bash %}
ArgumentError: wrong number of arguments (1 for 0)
        config.ru:10:in `call'
{% endhighlight %}

引数がないと言われました。ん？

では引数を付けてみます。

{% highlight ruby %}
# config.ru
require "./draque"

class UpDown
  def initialize(arg)
    
  end

  def call(arg)
    
  end
end

use UpDown

run method(:draque)
{% endhighlight %}

どうでしょうか。

{% highlight bash %}
Rack::Lint::LintError: Status must be >=100 seen as integer
{% endhighlight %}

Statusは100以上の数でなければならないとのRack::Lint::LintErrorが吐かれました。これって...

いつかきた道..ですよね？

{% highlight ruby %}
# config.ru
require "./draque"

class UpDown
  def initialize(arg)
    
  end

  def call(arg)
    200
  end
end

use UpDown

run method(:draque)
{% endhighlight %}

{% highlight bash %}
Rack::Lint::LintError: headers object should respond to #each, but doesn't (got NilClass as headers)
{% endhighlight %}

{% highlight ruby %}
# config.ru
require "./draque"

class UpDown
  def initialize(arg)
    
  end

  def call(arg)
    return 200, {'one' => '1'}
  end
end

use UpDown

run method(:draque)
{% endhighlight %}

{% highlight bash %}
Rack::Lint::LintError: No Content-Type header found
{% endhighlight %}

{% highlight ruby %}
# config.ru
require "./draque"

class UpDown
  def initialize(arg)
    
  end

  def call(arg)
    return 200, {'Content-Type' => 'text/html'}
  end
end

use UpDown

run method(:draque)
{% endhighlight %}

{% highlight bash %}
!! Unexpected error while processing request: Response body must respond to each
127.0.0.1 - - [05/Aug/2012 18:03:10] "GET / HTTP/1.1" 200 - 0.0010
{% endhighlight %}

ほら！

第３返り値に#eachできるボディでしたね。

{% highlight ruby %}
# config.ru
require "./draque"

class UpDown
  def initialize(arg)
    
  end

  def call(arg)
    return 200, {'Content-Type' => 'text/html'}, "Hello, from UpDown".chars
  end
end

use UpDown

run method(:draque)
{% endhighlight %}

![draque6](images/draque6.png)
<br clear='all' />


いいですね！

  ・ ・ ・

って、良くないです。runした`draque`がレンダリングされないじゃないですか...


{% csssig h2 id='draque' %}
## draqueを探す
{% endcsssig %}

さて、どうしますか。

そう言えばinitializeに渡した引数、あれは何でしょうね。`p`してみましょうか。

{% highlight ruby %}
# config.ru
require "./draque"

class UpDown
  def initialize(arg)
    p arg
  end

  def call(arg)
    return 200, {'Content-Type' => 'text/html'}, "Hello, from UpDown".chars
  end
end

use UpDown

run method(:draque)
{% endhighlight %}

どうでしょうか。
{% highlight bash %}
% rackup
#<Method: Rack::Builder(Draque)#draque>
>> Thin web server (v1.3.1 codename Triple Espresso)
>> Maximum connections set to 1024
>> Listening on 0.0.0.0:9292, CTRL+C to stop
127.0.0.1 - - [05/Aug/2012 18:14:13] "GET / HTTP/1.1" 200 - 0.0012
127.0.0.1 - - [05/Aug/2012 18:14:14] "GET /favicon.ico HTTP/1.1" 200 - 0.0009
{% endhighlight %}

なんとinitializeには`draque`が渡っていました。驚愕の事実。

そうすると、UpDown#callの中でdraqueをcallすれば、draqueがレンダリングされますか？やってみます。

{% highlight ruby %}
# config.ru
require "./draque"

class UpDown
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  end
end

use UpDown

run method(:draque)
{% endhighlight %}

どうでしょうか。

![draque7](images/draque7.png)
<br clear='all' />


うまくいきました。

{% csssig h2 id='mid' %}
## middlewareを書く
{% endcsssig %}

現状middleware `UpDown`は、何もしないダメウェアですが、callのところでゴニョゴニョすれば何かできると想像できます。やってみます。

{% highlight ruby %}
# config.ru
require "./draque"

class UpDown
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    [status, headers, body.reverse]
  end
end

use UpDown

run method(:draque)
{% endhighlight %}

どうでしょうか。

![draque8](images/draque8.png)
<br clear='all' />


天地反転の呪文が適用されました。

{% csssig h2 id='wrap' %}
##ここまでのまとめ
{% endcsssig %}

以上のことをまとめます。

> 1. middlewareは#callメソッドを持ったクラスである。
> 1. middleware#initializeにはrunに渡したWebアプリオブジェクトが渡される。
> 1. middlewareの#callでWebアプリの#callを呼んで、ゴニョゴニョする。

従って、リクエストーレスポンスの流れは次のようになります。
> 1. Rack(Webサーバ)はBrowserからリクエストが来ると、useされたmiddleware(UpDwon)の#callを呼ぶ。
> 1. middlewareの#callはWebアプリ(draque)の#callを呼ぶ。
> 1. Webアプリは#call呼び出しに対してリクエストに応じた、[status, headers, body]を返す。
> 1. middlewareは#callでゴニョゴニョして、[status, headers, body]を返す。
> 1. Rack(Webサーバ)はBrowserにHTTPレスポンスを返す。

{% csssig h2 id='mid2' %}
## ２つ目のmiddlewareを書く
{% endcsssig %}

さて、もう一つmiddlewareを書いてみます。名前をFireとします。

{% highlight ruby %}
# config.ru
require "./draque"

class UpDown
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    [status, headers, body.reverse]
  end
end

class Fire
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    new_body = ["<div style='background-color:red'>"] + body + ["</div>"]
    [status, headers, new_body]
  end
end

use Fire

use UpDown

run method(:draque)
{% endhighlight %}

\#callの中でゴニョゴニョしてるの分かりますか？

レスポンスを見てみます。

![draque9](images/draque9.png)
<br clear='all' />


天地反転の呪文と炎の呪文が適用されました。

さて、ここで気になることが一つあります。Fireに渡されたappはWebアプリなのでしょうか、それとも...。`p`で見てみます。

{% highlight ruby %}
# config.ru
require "./draque"

class UpDown
  def initialize(app)
    p "#{app} in UpDown"
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    [status, headers, body.reverse]
  end
end

class Fire
  def initialize(app)
    p "#{app} in Fire"
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    new_body = ["<div style='background-color:red'>"] + body + ["</div>"]
    [status, headers, new_body]
  end
end

use Fire

use UpDown

run method(:draque)
{% endhighlight %}

どうでしょうか。
{% highlight bash %}
% rackup
"#<Method: Rack::Builder(Draque)#draque> in UpDown"
"#<UpDown:0x000001008ee738> in Fire"
>> Thin web server (v1.3.1 codename Triple Espresso)
>> Maximum connections set to 1024
>> Listening on 0.0.0.0:9292, CTRL+C to stop
{% endhighlight %}

UpDownにdraqueが渡されていることが分かります。そして、果たしてFireにはUpDownが渡されていました。

つまりこういうことです。

> 1. 最初にuseされたmiddleware(Fire)のinitializeには、次にuseされたmiddleware(UpDown)のオブジェクトが渡される。つまりUpDownオブジェクトはFireオブジェクトでラップされる。
> 1. 最後にuseされたmiddleware(UpDown)には、Webアプリオブジェクト(draque)が渡される。つまりdraqueオブジェクトはUpDownオブジェクトでラップされる。
> 1. つまりRackというのは、棚ではなくて、マトリョーシカである。

従って、リクエストーレスポンスの流れは次のようになります。

> 1. Rack(Webサーバ)はBrowserからリクエストが来ると、最初にuseされたFireの#callを呼ぶ。
> 1. Fireの#callは次にuseされたUpDownの#callを呼ぶ。
> 1. UpDownの#callはWebアプリ(draque)の#callを呼ぶ。
> 1. Webアプリは#call呼び出しに対してリクエストに応じた、[status, headers, body]を返す。
> 1. UpDownは#callでゴニョゴニョして、[status, headers, body]を返す。
> 1. Fireは#callでゴニョゴニョして、[status, headers, body]を返す。
> 1. Rack(Webサーバ)はBrowserにHTTPレスポンスを返す。

{% csssig h2 id='fire' %}
## Fireを改良する
{% endcsssig %}

さてFireの呪文は強力過ぎます。これを一部の文字列にだけ適用するよう改良します。

対象文字列を指定する方法が必要になります。ところがFireオブジェクトはRackが生成するので、そのチャンスは一見なさそうです。仕方がないので、試しにuseに渡して、initializeで受けるようにしてみます。`p`で出力を見ます。

{% highlight ruby %}
class Fire
  def initialize(app, pattern)
    @app = app
    p pattern
  end

  def call(env)
    status, headers, body = @app.call(env)
    new_body = ["<div style='background-color:red'>"] + body + ["</div>"]
    [status, headers, new_body]
  end
end

use Fire, "hello"

run method(:draque)
{% endhighlight %}

どうでしょうか。
{% highlight bash %}
% rackup
"hello"
>> Thin web server (v1.3.1 codename Triple Espresso)
>> Maximum connections set to 1024
>> Listening on 0.0.0.0:9292, CTRL+C to stop
{% endhighlight %}

受け渡しができているようです。ついでにブロックもイケるか見てみます。

{% highlight ruby %}
class Fire
  def initialize(app, pattern)
    @app = app
    p pattern
    yield
  end

  def call(env)
    status, headers, body = @app.call(env)
    new_body = ["<div style='background-color:red'>"] + body + ["</div>"]
    [status, headers, new_body]
  end
end

use Fire, "hello" do
  p "hello from a block!"
end

use UpDown

run method(:draque)
{% endhighlight %}

{% highlight bash %}
% rackup
"hello"
"hello from a block!"
>> Thin web server (v1.3.1 codename Triple Espresso)
>> Maximum connections set to 1024
>> Listening on 0.0.0.0:9292, CTRL+C to stop
{% endhighlight %}

ブロックも受けてくれるようです。

では、新しいFireを実装します。

{% highlight ruby %}
# config.ru
require "./draque"

class UpDown
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    [status, headers, body.reverse]
  end
end

class Fire
  def initialize(app, pattern)
    @app = app
    @pattern = pattern
  end

  def call(env)
    status, headers, body = @app.call(env)

    replace = ->pat{ "<em style='background-color:red'>#{pat}</em>" }
    new_body = body.inject([]) { |m, part| m << part.gsub(@pattern) { replace[$&] } }
    
    [status, headers, new_body]
  end
end

use Fire, /rack|draque/i

use UpDown

run method(:draque)
{% endhighlight %}

出力を見てみます。

![draque10](images/draque10.png)
<br clear='all' />


いいですね！


Rack、次の一歩は踏み出せたでしょうか。


今回の結論：

> Rackは実はマトリョーシカだった！


