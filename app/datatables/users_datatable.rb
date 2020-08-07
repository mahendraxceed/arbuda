class UsersDatatable < TrkDatatables::ActiveRecord
  def columns
    {
      'users.id': {},
      'users.email': {},
      'users.admin': {},
      'users.name': {},
      'users.mobile': {},
    }
  end

  def all_items
    # you can use @view.params kkm                       tv
    User.all
  end

  def rows(filtered)
    # you can use @view.link_to and other helpers

    filtered.map do |user|
      admin = @view.enabled_disabled_label user.admin?, enabled_text: 'Admin', disabled_text: 'Employee'
      [
        @view.link_to(user.id, user),
        @view.link_to(user.email, user),
        admin,
        user.name.titleize,
        user.mobile,
      ]
    end
  end
end
