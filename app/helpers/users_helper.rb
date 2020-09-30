module UsersHelper
  def avatar_image(user, size: 200, **opts)
    image_tag user.avatar.variant(resize_to_fill: [size, size]), **opts if user.avatar.attached?
  end

  def rounded_avatar(user, size: 200, **opts)
    avatar_image(user, size: size, **opts.merge(class: 'rounded-circle'))
  end
end
