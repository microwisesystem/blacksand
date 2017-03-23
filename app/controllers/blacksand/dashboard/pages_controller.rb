module Blacksand
  class Dashboard::PagesController < Dashboard::BaseController
    before_action :set_page, only: [:show, :edit, :update, :destroy, :onchange_edit, :get_prototype_id]
    before_action :set_select, only: [:new, :edit, :onchange_new, :onchange_edit, :create, :update]

    def default
      redirect_to pages_url
    end

    def index
      @page = Page.where(id: params[:parent_id]).first
      @parent_id = params[:parent_id] || 0
      @all_children = Page.where(parent_id: nil).order(:position)
      @pages = @all_children.page(params[:page])

      # 编辑只能看到自己负责的板块
      tree_nodes = if false && current_user.role == 'editor'
                     Page.tree_nodes(current_user.page_ids)
                   else
                     Page.tree_nodes
                   end

      gon.pages = [{
                   text: '网站',
                   href: children_partial_pages_path(parent_id: nil),
                   page_id: 0,
                   nodes: tree_nodes,
                   }]

      # 选中父页面
      Page.selectNode(gon.pages, @parent_id.to_i)
    end

    def search
      # TODO: 查询排除自己
      @q = Page.ransack(params[:q])
      @pages = @q.result.page(params[:page])
    end

    def children_partial
      @page = Page.where(id: params[:parent_id]).first
      @parent_id = params[:parent_id]
      @parent_page = Page.find(params[:parent_id]) if params[:parent_id]
      @q = Page.includes(:template, :prototype).where(parent_id: params[:parent_id]).order(:position, created_at: :desc).ransack(params[:q])
      @all_children = @q.result
      @pages = @all_children.page(params[:page])
    end

    def show
    end

    def new
      @page = Page.new
      if params["parent_id"].present?
        @parent_id = params[:parent_id]
        parent_page = Page.find @parent_id
        @page.parent_id = params["parent_id"]

        # Set default template
        if parent_page.preferred_child_template_name
          @page.template = Template.find_by(name: parent_page.preferred_child_template_name)
        end

        # Set default prototype
        if parent_page.preferred_child_prototype_name
          prototype = Prototype.find_by(name: parent_page.preferred_child_prototype_name)
          @page.prototype = prototype
          prototype.fields.each do |field|
            Property.build_property(@page, field)
          end
        end
      end
    end

    def edit
      if !@page.properties.present? && @page.prototype.present?
        @page.build_properties
      end
    end

    def onchange_new
      @page = Page.new

      if params["parent_id"].present?
        @page.parent_id = params["parent_id"]
      end

      if params[:prototype_id].present?
        @page.prototype_id = params[:prototype_id]
        Prototype.find(params[:prototype_id]).fields.each do |field|
          Property.build_property(@page, field)
        end
      end
      render 'onchange_render'
    end

    def onchange_edit
      @page.properties.destroy_all
      if params[:prototype_id].present?
        @page.prototype_id = params[:prototype_id]
        @page.update_attributes(prototype_id: params[:prototype_id])
        @page.build_properties
        @page.save(validate: false)
      else
        @page.prototype_id = nil
        @page.update_attributes(prototype_id: nil)
      end
      render 'onchange_render'
    end

    def get_prototype_id
      respond_to do |format|
        format.json { render json: @page.prototype_id }
      end
    end

    def create
      @page = Page.new(page_params)

      respond_to do |format|
        if @page.save
          format.html { redirect_to pages_url(parent_id: @page.parent_id), notice: '页面创建成功.' }
          format.json { render :show, status: :created, location: @page }
        else
          puts @page.errors.full_messages
          format.html { render :new }
          format.json { render json: @page.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      respond_to do |format|
        if @page.update(page_params)
          format.html { redirect_to pages_url(parent_id: @page.parent_id), notice: '页面更新成功.' }
          format.json { render :show, status: :ok, location: @page }
        else
          format.html { render :edit }
          format.json { render json: @page.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @page.destroy
      respond_to do |format|
        format.html { redirect_to pages_url(parent_id: @page.parent_id), notice: '成功删除.' }
        format.json { head :no_content }
      end
    end

    def sort
      params[:page].each_with_index do |id, index|
        Page.update(id, {position: index+1})
      end
      render nothing: true
    end

    private
    def set_page
      @page = Page.find(params[:id])
    end

    def set_select
      @template_select = Template.all.map { |x| [x.name, x.id] }.sort_by {|x| x[0]}
      @prototype_select = Prototype.all.map { |x| [x.name, x.id] }
    end

    def page_params
      params.require(:page).permit(:title, :en_name, :parent_id, :template_id, :prototype_id, :content,
                                   :properties_attributes => [:id, :type, :field_id, :value, { values: [] }, :image, :file,
                                                              {:pictures_attributes => [:id, :name, :file, :_destroy]}])
    end

  end
end
