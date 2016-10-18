# Blacksand - 黑石是由黑沙组成的

这是一个独立 Rails engine, 提供了门户核心的功能, 管理页面和页面显示.

管理页面在 `/dashboard` 下面.


### 安装

Gemfile

    gem 'blacksand', git: 'git@gitlab.com/microwise/blacksand.git'

执行

    rails g blacksand:install
    rake db:migrate
    
routes.rb

    mount Blacksand::Engine => '/cms'
    blacksand

### 示例

    # 创建一个新的站点
    rails g blacksand:new_site demo

会生成 `app/themes/demo/` 文件夹。

还有站点对应的模板和原型文件, `db/sites/demo.yml`。

#### 编辑模板和原型

```yml
templates:
- name: 列表
  path: list/awesome

prototypes:
- name: 新闻
  fields_attributes:
  - name: date
    field_type: date
    description: 发布时间
    required: true
  - name: type
    field_type: select
    description: 发布时间
    options: ['行业新闻', '企业新闻']
    required: true
```

`field_type` 目前支持 

- date 
- number 
- string 
- textarea 
- rich_text 
- image 
- gallery 多张图片
- slide 大图片
- select

编辑完模型和原型后可以执行命令导入到数据库。

`rake "blacksand:seed[demo]"`

#### 模板页面

出过首页详情页都会有 `@page` 变量, 变量有这些属性。

- @page.title     # 页面标题
- @page.content   # 页面内容
- @page.props     # 页面自定义属性
- @page.props.xxx # 获取页面 xxx 属性

如果字段的属性是 gallery 可以通过 file 获取对应图片. 如下

```
@page.props.my_gallery.each do |picture| 
  picutre.file   # image_tag(picutre.file), image_path(picutre.file)
end
```

也可以通过页面标识('en_name')来获取 page, `page('museums')` .

如何获取子页面

```
# 产品:
#   - 产品列表
#   - 产品目录
```

```
@page # 产品
@page.positioned_children # 返回排好序的子页面
@page.child('产品列表')    # 返回特定标题的子页面
```

__页面参数__

模板有时候需要给 layout 或者  partial 传递一些参数, 就可以通过 `set_page_options title: 'IamTitle'`, 然后可以通过 `page_options(:title)` 获取。

#### 导航

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

#### 图片样式

文件上传使用的是 carrierwave, 目前集成了两种处理方式一直种是 carrierwave 自带的图片处理，另一种是借助七牛的图片处理。

使用方法如下：

文件存储, 使用自带的图片处理方式(如果是七牛存储自带的图片处理也能正常工作)。
```ruby
Blacksand.carrierwave_storage = :file

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

```ruby
Blacksand.carrierwave_storage = :qiniu

Blacksand::ImageUploader.class_eval do
  qiniu_styles({
    :'300xMIN' => 'imageMogr2/thumbnail/!300x300r/gravity/Center/crop/300x300/interlace/1',
    :'500xMIN' => 'imageMogr2/thumbnail/!500x500r/gravity/Center/crop/500x500/interlace/1'
  })
end
```

