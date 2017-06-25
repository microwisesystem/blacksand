# Blacksand - 黑石是由黑沙组成的

这是一个独立 Rails engine, 提供了门户核心的功能, 管理页面和页面显示.


![screenshot](https://raw.githubusercontent.com/microwisesystem/blacksand/master/screenshot.gif)

## 安装

Gemfile

    source "https://rails-assets.org"
    ...
    gem 'blacksand'

执行

    rails g blacksand:install
    rake db:migrate

routes.rb 添加下面两行

```ruby
# 管理后台地址 /cms
mount Blacksand::Engine => '/cms'

blacksand
```

更新数据库迁移脚本

    rake blacksand:install:migrations
    
## 示例

0. 创建站点


    rails g blacksand:new_site demo

会生成 `app/themes/demo/` 和 `db/sites/demo.yml`, 目录结构如下。

```
app/
  themes/
    demo/
      assets/
      locals/
      views/

db/
  sites/
    demo.yml
```

同时修改 `config/initializers/blacksand.rb`

```
Blacksand.site_id = 'deomo'
```
      

1. 编辑模板和原型

打开 db/sites/demo.yml, 编辑模板和原型，添加两个模板 "新闻列表" 和 "新闻详情"，还有一个 "新闻原型"。

```yml
templates:
- name: 新闻列表
  path: news/index
  options:
    preferred_child_template_name: 新闻详情
    preferred_child_prototype_name: 新闻
- name: 新闻详情
  path: news/show

prototypes:
- name: 新闻
  fields_attributes:
  - name: published_at
    field_type: date
    description: 发布时间
    required: true
  - name: editor
    field_type: string
    description: 编辑
    required: true
```

2. 导入模板和原型

```
rake "blacksand:seed[demo]"
```

将模板和原型导入到数据库, 模板和原型有任何修改后可重复执行导入。如果 yml 中模板和原型被删除，数据库中多出的模板和原型也会被删除。

3. 添加模板页面


添加新闻列表 `app/themes/demo/views/news/index.html.erb`

```erb
<h1>新闻列表</h1>
<ul>
  <% @page.children.each do |child_page| %>
    <li>
      <%= link_to child_page.title, page_path(child_page) %>
    </li>
  <% end %>
</ul>
```

添加新闻详情 `app/themes/demo/views/news/show.html.erb`

```erb
<h1><%= @page.title %></h1>
<p>
  发布时间: <%= @page.props.published_at %> 
  编辑: <%= @page.props.editor %>
</p>


<!-- 新闻内容 -->
<p>
  <%= @page.content.html_safe %>
</p>
```

4. 进入管理后台添加内容

进入 http://127.0.0.1:3000/cms , 点击"添加页面" 就可以添加新闻，然后预览看效果了。

5. 添加首页

blacksand 后台可以添加各式各样的页面，唯独首页需要单独开发。

生成 WelcomeController

```
rails g controller welcome index
```

编辑 welcome_controller.rb, 添加 `blacksand`

```ruby
class WelcomeController < ApplicationController
  blacksand

  def index
  end
end

```

编辑路由 routes.rb，添加下面这行

```
root 'welcome#index'
```

最后编辑 welcome/index.html.erb。

```erb
<h1><%= page("news").title %></h1>
<ul>
  <% page("news").children.each do |child_page| %>
    <li>
      <%= link_to child_page.title, page_path(child_page) %>
    </li>
  <% end %>
</ul>
```

上面模板中 "news" 是新闻列表页面的 "标识" 必须是全局唯一的，
这样可以通过 `page("news")` 模板函数来获取 Page 实例，从而获取页面相关的属性，例如标题和子页面等。

## 文档

### templates 参数


| key        | 描述           |  类型 | 必填  |
| ------------- |---------------|---| ------|
| name      | 模板名称 |string| true |
| path      | 模板路径      |string|   true |
| options   | 选项。      | hash |  false |
| options.`preferred_child_template_name`  | 子页面默认模板. 如果页面的模板和原型都有配置，模板的优先机高于原型, 其他一样。 | string |  false |
| options.`preferred_child_prototype_name`  | 子页面默认原型. | string |  false |

### prototypes 参数

| key        | 描述           |  类型 | 必填  |
| -----------|---------------|-------|------|
| name      | 原型名称 |string| true |
| options   | 选项      | hash |  false |
| options.`preferred_child_template_name`  | 子页面默认模板. 如果页面的模板和原型都有配置，模板的优先机高于原型, 其他一样。 | string |  false |
| options.`preferred_child_prototype_name`  | 子页面默认原型   | string |  false |
| fields_attributes      | 原型字段 |array. 元素为 field | true |
| fields_attributes[i].name      | 字段名称, 全英文，用于获取属性值。 |string| true |
| fields_attributes[i].field_type      | 字段类型 |string| true |
| fields_attributes[i].description      | 字段描述 |string| true |
| fields_attributes[i].required      | 是否必填，默认 false |string| false |


`field_type` 目前支持

- date
- number
- string
- textarea
- rich_text
- image
- gallery 多张图片
- slide 大图片, **推荐使用 image**
- file 文件
- select
- page 关联页面(Page)
- array 数组

编辑完模型和原型后可以执行命令导入到数据库。

`rake "blacksand:seed[demo]"`

### 模板页面

除过首页，详情页都会有 `@page` 变量, 其实是 Page 实例， 他有这些属性。

- page.title     # 页面标题
- page.content   # 页面内容
- page.props     # 页面自定义属性
- page.props.xxx # 获取页面 xxx 属性
- page.children  # 获取子页面集合
- page.positioned_children # 获取排序好的子页面集合
- page.child('page title') # 根据子页面标题获取子页面，返回 Page 实例
- page.child_with(key: value) # 根据条件查询某个字页面，返回 Page 实例
- page.ancestors  # 返回所有父级页面数组, 自上向下。
- page.descendents # 返回所有下级页面数据，深度优先遍历。
- page.all_image_srcs_of_content # 返回 content 中所有图片的链接地址

如果字段的属性是 gallery 可以通过 file 获取对应图片. 如下

```ruby
@page.props.my_gallery.each do |picture|
  picutre.file   # image_tag(picutre.file), image_path(picutre.file)
end
```

模板 helper 方法

- page('en_name')                   # 也可以通过页面标识('en_name')来获取 page, `page('museums')` .
- set_page_options(some_key: value) # 设置页面参数，一般通过模板给layout传递参数
- page_options[:some_key]           # 获取页面参数
- textarea2html(text)               # 将文本中的空格转换为换行


__页面参数__

模板有时候需要给 layout 或者  partial 传递一些参数, 就可以通过 `set_page_options title: 'IamTitle'`, 然后可以通过 `page_options[:title]` 获取。

### 导航

除过首页, page 页面 __默认__ 都会有 `@navigations` 变量可以在页面访问。`@navigations` 包括当前所有的导航,并且是排好序的。

如果想让页面有 `@navigations` 可以给 controller 加 `load_navigatoins`, 例如

```ruby
class WelcomeController < ApplicationController
  blacksand

end
```

Navigation 有这些属性

* name    名称
* url     地址,一般是外部链接
* page    Page 对象
* options 选项, Hash
    * 'hover_submenus'
    * 'link_sub_page'

### 图片样式

文件上传使用的是 carrierwave, 目前集成了两种处理方式一直种是 carrierwave 自带的图片处理，另一种是借助七牛的图片处理。

carrierwave 配置需要手动在项目 config/initializers/ 添加配置文件，具体看 [carrierwave 配置](https://github.com/carrierwaveuploader/carrierwave#configuring-carrierwave)

使用方法如下：

文件存储, 使用自带的图片处理方式(如果是七牛存储自带的图片处理也能正常工作)。
```ruby
Blacksand.carrierwave_storage = :file
Blacksand.carrierwave_store_dir_prefix = 'uploads'

Blacksand::ImageUploader.class_eval do
    version :thumb do
      process :resize_to_fill => [200, 200]
    end

    version :thumb_resize_and_pad do
      process :resize_and_pad => [200, 200]
    end

    version :small do
      process :resize_to_fill => [280, 150]
    end
end

```

七牛存储，使用七牛的图片处理(参考 http://developer.qiniu.com/code/v6/api/kodo-api/image/index.html)。

Gemfile 文件添加 `gem "carrierwave-qiniu"`, 然后具体配置看 [carrierwave-qiniu](https://github.com/huobazi/carrierwave-qiniu) 官方文档

```ruby
Blacksand.carrierwave_storage = :qiniu
Blacksand.carrierwave_store_dir_prefix = 'another_path'

Blacksand::ImageUploader.class_eval do
  qiniu_styles({
    :'300xMIN' => 'imageMogr2/thumbnail/!300x300r/gravity/Center/crop/300x300/interlace/1',
    :'500xMIN' => 'imageMogr2/thumbnail/!500x500r/gravity/Center/crop/500x500/interlace/1'
  })
end

image.url('300xMIN')
```

如果 carrierwave 的 storage 由 file 改为 qiniu, 图片迁移脚本

```
rake "carrierwave:from_file_to_qiniu[Blacksand::Property,image]"
rake "carrierwave:from_file_to_qiniu[Blacksand::Picture,file]"

# kindeditor 不能使用此命令, kindeditor 动态生成文件名, 建议使用 qshell 进行批量迁移
# ~~rake "carrierwave:from_file_to_qiniu[Kindeditor::Asset,asset]"~~
```

注意：2.0 版本以后 Kindeditor 的 storage 和 Blacksand 是一直的，但是 'carrierwave_store_dir_prefix' 只针对 Blacksand。
Kindeditor 需要单独配置 `upload_dir` 详见 Kindeditor 的[配置](https://github.com/Macrow/rails_kindeditor#上传图片及文件配置),
如果 `upload_dir` 变化那么 Blacksand::Page 的 content 内容里的 img src 也需要替换。


## 认证和权限


### 认证

认证可以使用 Devise 或者自定义。


`initializers/blacksand.rb`
```ruby
# block 会在 controller 里执行
Blacksand.authenticate_with do
  # Devise
  authenticate_user!

  # HTTP basic auth
  # authenticate_or_request_with_http_basic do |u, p|
  #   u == 'admin' && p == 'password'
  # end
end
```

### 授权

授权目前只支持 cancancan.

initializers/blacksand.rb
```ruby
Blacksand.authorize_with :cancancan
# 用时要定义 current_user
Blacksand.current_user_method do
  # Devise
  current_user
end
```
