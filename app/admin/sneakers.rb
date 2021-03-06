ActiveAdmin.register Sneaker do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :description, :size, :price, :image, :category_names, :avialability, images: []
  filter :name
  filter :categories
  filter :price
  filter :created_at
  filter :updated_at

  scope 'Available', :avialability_true
  scope 'N/A', :avialability_false

  action_item :import, except: :import do
    link_to t('import'), admin_sneakers_import_path
  end

  controller do
    def import; end

    def import_file
      Sneaker.import(params[:file])
      redirect_to admin_sneakers_path
    end
  end
  index do
    selectable_column
    id_column
    column :name
    column :avialability
    column :price
    column :created_at
    column :updated_at
    actions
  end
  form do |f|
    f.inputs do
      f.input :name
      f.input :category_names
      f.input :description, as: :trix_editor
      f.input :size
      f.input :price
      f.input :avialability
      f.input :image, as: :file
      f.input :images, as: :file, input_html: {multiple: true}
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :description do
        div do
          sneaker.description
        end
      end
      row :size
      row :price
      row :avialability
      row :image do |object|
        image_tag object.image
      end
      row :images do |object|
        ul do
        object.images.each do |image|
          span image_tag image
    end
  end
  end
  row :category_names
end
panel 'Categories' do
  table_for sneaker.categories do
    column :id
    column { |c| link_to c.name, admin_category_path(c.id) }
  end
end
    active_admin_comments
  end
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :description, :size, :price]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
