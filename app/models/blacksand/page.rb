module Blacksand
  class Page < ActiveRecord::Base
    belongs_to :parent, class_name: Page, foreign_key: 'parent_id'
    has_many :children, class_name: Page, foreign_key: 'parent_id', :dependent => :destroy
    has_one :navigation, :dependent => :destroy

    belongs_to :template
    belongs_to :prototype

    has_many :properties, :dependent => :destroy
    # has_many_kindeditor_assets :attachments, :dependent => :destroy

    accepts_nested_attributes_for :properties

    has_many :positioned_children, -> { order(:position) }, class_name: 'Page', foreign_key: 'parent_id'

    # validates :title, :template, presence: true

    # after_save :normalize_kindeditor_assets

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
    
    def child(title)
      self.children.where(title: title).first
    end

    def content_first_image
      image_assets = image_assets_of_content

      return if image_assets.empty?

      asset_name = image_assets.first
      Kindeditor::Asset.where(asset: asset_name).first
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

    # 1. set owner for assets
    # 2. remove assets not exists
    # 3. TODO uploaded assets were be deleted before submit new page
    def normalize_kindeditor_assets

      return unless self.content_changed?

      image_assets = image_assets_of_content

      image_assets.each do |asset_name|
        asset = Kindeditor::Asset.where(asset: asset_name).first
        asset.update(owner_id: self.id) if asset.owner_id.blank?
      end

      exists_image_assets = self.attachments.to_a.select { |asset| asset.asset_type == 'image' }.map { |a| a.asset.file.filename }
      redundant_image_assets = exists_image_assets - image_assets

      Kindeditor::Asset.where('asset in (?)', redundant_image_assets).destroy_all
    end

    # 返回内容中所有上传的图片
    def image_assets_of_content
      html_doc = Nokogiri::HTML(self.content)
      images = html_doc.xpath("//img")
      image_assets = images.map do |img|
        match = Regexp.new('^/uploads/image/.+/(.+)$').match img['src']
        match[1] if match
      end.compact
    end
  end
end
