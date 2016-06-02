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

编辑模板和原型

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
```


