class AppFormBuilder < ActionView::Helpers::FormBuilder
  def form_wrapper(form_field, method, options = {})
    title = options.delete(:title)
    options = options.merge({class: 'input'})

    @template.content_tag :div, class: 'field' do
      (@template.label_tag method, title || method.to_s.humanize, class: 'label') + 
      (@template.content_tag :div, class: 'control' do
        (@template.send(form_field, @object.class.to_s.underscore, method, options))
      end)
    end
  end
end
