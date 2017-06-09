module ApplicationHelper
  FLASH_CSS_MAP = {
      success: "alert alert-dismissible alert-success",
      error:   "alert alert-dismissible alert-danger",
      alert:   "alert alert-dismissible alert-warning",
      notice:  "alert alert-dismissible alert-success",
  }

  def flash_css(flash_type)
    FLASH_CSS_MAP[flash_type.to_sym] || flash_type.to_s
  end

  def title_tag(str)
    content_for( :title) { raw("#{str}") }
  end

  def head_tag
    content_for (:head){ stylesheet_link_tag 'sign', media: 'all', 'data-turbolinks-track': 'reload' }
  end

  def panel_tag(str)
    content_for :panel, raw("#{str}")
  end

  def panel_container(&block)
    content_tag(:div, content_tag(:div, capture(&block), class: 'panel-body'), class: 'panel panel-default')
  end

  def main_container(block)
    content_for?(:panel) ? panel_container { block } : block
  end

  def current_page?(*pages)
    pages.flatten.compact.any?{ |page| page == request.fullpath }
  end

  def current_controller?(*ctrls)
    ctrls.flatten.compact.any?{ |ctrl| ctrl.to_s.underscore == (controller_path || controller_path.pluralize)  }
  end

  def current_action?(*acts)
    acts.flatten.compact.any?{ |act| act.to_s == action_name }
  end

  def active_tag?(opts={})
    ctrls = opts.delete :controller
    acts = opts.delete :action
    if ctrls && acts
      current_controller?(ctrls) && current_action?(acts)
    else
      current_controller?(ctrls) || current_action?(acts)
    end
  end

  def nav_tag(opts={}, &block)
    html_options = opts.delete(:html) || {}
    html_options[:class] ||= ''
    html_options[:class] << 'active' if active_tag?(opts)
    content_tag :li, capture(&block), html_options
  end
end