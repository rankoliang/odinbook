module UsersHelper
  def avatar_link(user, size)
    if user.avatar.attached?
      user.avatar.variant resize_to_fill: [size, size]
    else
      'odin-logo.svg'
    end
  end

  def avatar_tag(user, size: 200, **opts)
    image_tag avatar_link(user, size), width: size, height: size, **opts
  end

  def round_avatar_tag(user, size: 200, **opts)
    avatar_tag user, size: size, **opts
  end
end
