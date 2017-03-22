# desc "Explaining what the task does"
# task :blacksand do
#   # Task goes here
# end

namespace :blacksand do
  desc "Clean unsued kindeditor assets"
  task :clean_kindeditor_assets => :environment do ||
    puts "Delete unsued kindeditor assets 1 day ago"
    assets = Kindeditor::Asset.where(owner_id: 0).where("created_at <= ?", 1.day.ago)
    puts "Assets: #{assets.count}"
    assets.destroy_all
  end

  desc "Seed templates and prototypes and clean unused of them"
  task :seed, [:site_id] => :environment do |t, args|
    site_id = args.site_id

    data = YAML.load_file(Rails.root.join("db/sites/#{site_id}.yml")).deep_symbolize_keys

    data[:templates].each do |template|
      t = Blacksand::Template.where(name: template[:name]).first_or_initialize(path: template[:path], options: template[:options])
      if t.new_record?
        puts "Create Template #{t.name}"
        t.save!
      else
        t.update_attributes!(path: template[:path], options: template[:options])
      end
    end

    # 删除遗留的模板
    Blacksand::Template.where('name not in (?)', data[:templates].map { |t| t[:name] }).each do |t|
      puts "Delete template: #{t.name}"
      t.destroy!
    end

    data[:prototypes].each do |prototype|
      params = ActionController::Parameters.new(prototype: prototype)
      prototype_params = params.require(:prototype).permit! #(:name, fields_attributes: [:name, :field_type, :description, :required, :options => []])

      p = Blacksand::Prototype.where(name: prototype[:name]).first_or_initialize(prototype_params)
      if p.new_record?
        puts "Create Prototype #{p.name}"
        p.save!
      else
        p.update!(options: prototype_params[:options])
        # seed 一次换一次 fields, 但是之前关联 field 的地方都需要变
        prototype[:fields_attributes].each do |field|
          field_attributes = field.slice(:field_type, :description, :required, :options)
          f = p.fields.where(name: field[:name]).first_or_initialize(field_attributes)
          if f.new_record?
            puts "Create Field #{p.name} / #{f.name}"
            f.save!
          else
            f.update_attributes!(field_attributes)
          end
        end

        # 删除多余的 field
        to_deleted_fields = p.fields.map(&:name) - prototype[:fields_attributes].map { |f| f[:name] }
        puts "Delete Fields #{p.name} / #{to_deleted_fields}" if to_deleted_fields.any?
        p.fields.where(name: to_deleted_fields).destroy_all
      end
    end

    # 删除遗留的原型
    Blacksand::Prototype.where('name not in (?)', data[:prototypes].map { |p| p[:name] }).each do |p|
      puts "Delete prototype: #{p.name}"
      p.destroy!
    end
  end
end
