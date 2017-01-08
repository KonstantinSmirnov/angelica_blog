module ApplicationHelper
  def namespace?(namespace)
    namespace.include?(params[:controller].split('/').first)
  end

  def controller?(controller)
    controller.include?(params[:controller])
  end

  def action?(action)
    action.include?(params[:action])
  end
end
