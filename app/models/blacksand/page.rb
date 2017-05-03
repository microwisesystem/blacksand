require 'uri'

module Blacksand
  class Page < ActiveRecord::Base
    belongs_to :parent, class_name: Page, foreign_key: 'parent_id'
    has_many :children, class_name: Page, foreign_key: 'parent_id', :dependent => :destroy
    has_one :navigation, :dependent => :destroy

    belongs_to :template
    belongs_to :prototype

    has_many :properties, :dependent => :destroy
    has_many_kindeditor_assets :attachments, :dependent => :destroy

    accepts_nested_attributes_for :properties

    has_many :positioned_children, -> { order(:position) }, class_name: 'Page', foreign_key: 'parent_id'

    # validates :title, :template, presence: true

    # 在新建页面的时候，上传的图片没有 owner_id 和 owner_type
    # TODO: 还有一种情况是在新建页面的时候，图片上传上来后又被删除了。这时候图片就变成没有人认领的孤儿了。
    after_commit :set_owner_for_kindeditor_assets, on: :create

    # 在编辑的过程中可能从内容中删除了部分图片, 但是 Kinkeditor::Assets 还没有被删除
    after_commit :clean_unsued_kindeditor_assets, on: :update

    # page.props.name
    # page.props[:name]
    def props
      if @attrs.blank?
        properties = self.properties.includes(:field).map { |p| [p.field.name, p.content] }
        @attrs = OpenStruct.new(Hash[properties])
      end

      @attrs
    end

    # 推荐使用 props 方法 @gaohui 2015.11.26
    def values
      if @values.blank?
        @values = ActiveSupport::HashWithIndifferentAccess.new
        self.properties.each do |p|
          @values[p.field.name] = p.content
        end
      end

      @values
    end

    def ancestors
      if self.parent.present?
        self.parent.ancestors + [self.parent]
      else
        []
      end
    end

    def descendents
      self.positioned_children.reduce([]) do |all, child|
        all << child
        all.concat(child.descendents)
        all
      end
    end
    
    def child(title)
      self.children.where(title: title).first
    end

    def child_with(conditions)
      self.children.find_by(conditions)
    end

    def content_first_image
      image_assets = image_assets_of_content

      return if image_assets.empty?

      asset_name = image_assets.first
      Kindeditor::Asset.where(asset: asset_name).first
    end

    def all_image_srcs_of_content
      html_doc = Nokogiri::HTML(self.content)
      images = html_doc.xpath("//img")
      images.map{|img| img['src'] }
    end

    def preferred_child_template_name
      preferred_option('preferred_child_template_name')
    end

    def preferred_child_prototype_name
      preferred_option('preferred_child_prototype_name')
    end

    def tree_node
      href = Blacksand::Engine.routes.url_helpers.children_partial_pages_path(parent_id: self.id)

      return {text: self.title, href: href, page_id: self.id} if self.children.count == 0

      # children 多余 15 个且都是叶子节点, 那么子节点不显示
      if self.children.count >= 15 && self.children.limit(15).all? { |p| p.children.empty? }
        {
        text: self.title,
        href: href,
        page_id: self.id
        }
      else
        {
        text: self.title,
        href: href,
        page_id: self.id,
        nodes: self.children.order(:position).map { |p| p.tree_node },
        }
      end

    end

    def build_properties
      self.prototype.fields.each do |field|
        Property.build_property(self, field)
      end
    end

    def self.tree_nodes(page_ids = nil)
      if page_ids
        Page.where(id: page_ids).order(:position).map { |p| p.tree_node }
      else
        Page.where('parent_id is null').order(:position).map { |p| p.tree_node }
      end
    end

    def self.selectNode(nodes, page_id)
      nodes.each do |node|
        if node[:page_id] == page_id
          node.merge!(state: {selected: true})
          return
        end

        selectNode(node[:nodes], page_id) if node[:nodes].present?
      end
    end


    def self.query_value(name, value)
      joins(properties: :field).where(fields: {name: name}, properties: {value: value})
    end

    protected

    def set_owner_for_kindeditor_assets
      image_assets = image_assets_of_content

      image_assets.each do |asset_name|
        asset = Kindeditor::Asset.where(asset: asset_name, owner_id: 0).first
        asset.update(owner_id: self.id, owner_type: self.class.name) if asset.present?
      end
    end

    def clean_unsued_kindeditor_assets
      image_assets = image_assets_of_content
      exists_image_assets = self.attachments.to_a.select { |asset| asset.asset_type == 'image' }.map { |a| File.basename(a.asset.path) }

      redundant_image_assets = exists_image_assets - image_assets
      Kindeditor::Asset.where('asset in (?)', redundant_image_assets).destroy_all
    end

    # 返回内容中所有上传的图片
    def image_assets_of_content
      srcs = all_image_srcs_of_content.select do |src|
        # 本地上传的文件
        if src.start_with? "/#{RailsKindeditor.upload_store_dir}"
          true
        # 有可能是与存储
        elsif src.start_with?("http") && URI(src).path.start_with?("/#{RailsKindeditor.upload_store_dir}")
          true
        else
          false
        end
      end
      srcs.map { |src| File.basename(src) }
    end

    def preferred_option(key)
      if self.template && self.template.options.present? && self.template.options[key]
        self.template.options[key]
      elsif self.prototype && self.prototype.options.present? && self.prototype.options[key]
        self.prototype.options[key]
      end
    end
  end
end
