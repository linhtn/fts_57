module ApplicationHelper
  def full_title page_title = ""
    base_title = t "static_pages.project_name"
    page_title.empty? ? base_title : page_title + " | " + base_title
  end

  def link_to_add_fields name, f, association
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for association, new_object, child_index:
      "new_#{association}" do |builder|
        render "admin/questions/" + association.to_s.singularize + "_fields", f: builder
      end

    link_to name, "javascript:void(0)", onclick:
      "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"
  end

  def link_to_remove_fields name, f
    f.hidden_field(:_destroy) + link_to(name, "javascript:void(0)",
      onclick: "remove_fields(this)", class: :remove_answer)
  end

  def spend_time exam
    time = if exam.time_end - exam.time_start < exam.duration * 60
      exam.time_end - exam.time_start
    else
      exam.duration * 60
    end
    Time.at(time).utc.strftime Settings.TIME_FORMAT
  end
end
